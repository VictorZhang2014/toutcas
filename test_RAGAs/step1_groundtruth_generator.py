# utf-8
# Synthetic Test Set (Ground Truth Test Set)

import json
from dotenv import load_dotenv
from langchain_core.documents import Document
from langchain_openai import ChatOpenAI, OpenAIEmbeddings
from ragas.testset import TestsetGenerator
from ragas.llms import LangchainLLMWrapper
from ragas.embeddings import LangchainEmbeddingsWrapper


load_dotenv() 

# 1. Load your local JSON file
with open('Guide_for_applicants_MSCA_Postdoctoral.pdf.embeddings.json', 'r', encoding='utf-8') as f:
    local_data = json.load(f)

# 2. Convert JSON chunks to LangChain Document objects
langchain_docs = []
for item in local_data:
    # item is your dict: {"id": 0, "chunk": "...", "embedding": [...]}
    doc = Document(
        page_content=item["chunk"],
        metadata={
            "id": item["id"], 
            "filename": "source_pdf_name.pdf"  # Required for Ragas grouping
        }
    )
    langchain_docs.append(doc)


# 3. Wrap Models
generator_llm = LangchainLLMWrapper(ChatOpenAI(model="gpt-4o"))
generator_embeddings = LangchainEmbeddingsWrapper(OpenAIEmbeddings())

# 4. Initialize Generator (Flat import)
generator = TestsetGenerator(
    llm=generator_llm, 
    embedding_model=generator_embeddings
)

# 5. Generate Testset
# Distributions are now handled by 'query_distribution' internally or passed as synthesizers
dataset = generator.generate_with_langchain_docs(
    documents=langchain_docs,
    testset_size=10
)

# 6. Result
df = dataset.to_pandas()
print(df.head())

# 2. Save locally
df.to_csv("Guide_for_applicants_MSCA_Postdoctoral.rag.testset.csv", index=False)
df.to_json("Guide_for_applicants_MSCA_Postdoctoral.rag.testset.json", orient="records", force_ascii=False, indent=4)

print("Test set saved successfully!")
