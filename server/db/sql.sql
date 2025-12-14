create extension if not exists vector;

create table embedding_table (
  id uuid primary key default gen_random_uuid(),
  content text not null,
  embedding vector(1536)
);

create index on embedding_table
using ivfflat (embedding vector_cosine_ops)
with (lists = 100);


