import os
import psycopg2
from psycopg2.extras import RealDictCursor

class SQLBase:
    VECTOR_DIM = 1536  

    def __init__(self):
      self.db_config = {
          "host": os.getenv("SUPABASE_DB_HOST"),
          "port": os.getenv("SUPABASE_DB_PORT", 5432),
          "dbname": os.getenv("SUPABASE_DB_NAME", "postgres"),
          "user": os.getenv("SUPABASE_DB_USER"),
          "password": os.getenv("SUPABASE_DB_PASSWORD"),
          "sslmode": "require"
      } 
    
    def get_connection(self):
        return psycopg2.connect(**self.db_config)

    def insert_document(self, content: str, embedding: list[float]):
        if len(embedding) != self.VECTOR_DIM:
            raise ValueError("Embedding dimension mismatch")

        sql = """
            INSERT INTO documents (content, embedding)
            VALUES (%s, %s::vector)
            RETURNING id;
        """

        with self.get_connection() as conn:
            with conn.cursor() as cur:
                cur.execute(sql, (content, embedding))
                doc_id = cur.fetchone()[0]
                conn.commit()

        return doc_id

    def query_by_embedding(self, embedding: list[float], limit: int = 5):
        if len(embedding) != self.VECTOR_DIM:
            raise ValueError("Embedding dimension mismatch")

        sql = """
            SELECT
                id,
                content,
                1 - (embedding <=> %s::vector) AS similarity
            FROM documents
            ORDER BY embedding <=> %s::vector
            LIMIT %s;
        """

        with self.get_connection() as conn:
            with conn.cursor(cursor_factory=RealDictCursor) as cur:
                cur.execute(sql, (embedding, embedding, limit))
                results = cur.fetchall()

        return results

