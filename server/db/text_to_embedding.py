import pandas as pd  
from sentence_transformers import SentenceTransformer
from db.sql_base import SQLBase

class TextToEmbed:

    def __init__(self):
        # As an alternative, all-MiniLM-L6-v2 is also good 
        self.model = SentenceTransformer("all-MiniLM-L6-v2") 

    # text-embedding-3-small may be better than all-MiniLM-L6-v2
    # def encode2embedding(self, text):
    #       from openai import OpenAI
    #       client = OpenAI(api_key=os.getenv("OPENAI_API_KEY"))
    #     return client.embeddings.create(
    #         model="text-embedding-3-small",
    #         input=text
    #     ).data[0].embedding

    def encode2embedding(self, text: str) -> list[float]:
        return self.model.encode(text).tolist()

    def row_to_text(self, row) -> str:
        return (
            f"Employee name: {row['Name']}. "
            f"Age: {row['Age']}. "
            f"Phone: {row['Phone']}."
            f"Hire date: {row['Hire Date']}. "
            f"Salary: {row['Salary']}."
            f"Position: {row['Position']}. "
            f"Performance rating: {row['Performance']}. "
            f"Years in company: {row['Years in Company']}. "
            f"Specialization: {row['Specialization']}. "
        )

    def csv_to_embeddings(self, csv_path):
        df = pd.read_csv(csv_path) 
        for _, row in df.iterrows():
            text = self.row_to_text(row) 
            embedding = self.encode2embedding(text)
            SQLBase().insert_document(text, embedding)   


if __name__ == "__main__":
    path = "../../experiments/PseudoData_RD-Dept.csv"
    # path = "../../experiments/PseudoData_HumanResources-Dept.csv"
    # path = "../../experiments/PseudoData_Finance-Dept.csv"
    TextToEmbed().csv_to_embeddings(path)
