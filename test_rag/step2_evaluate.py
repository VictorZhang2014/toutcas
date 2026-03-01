from dotenv import load_dotenv
import pandas as pd
import ast 
from datasets import Dataset
from ragas import evaluate
from ragas.metrics import faithfulness, answer_relevancy, context_recall
from langchain_openai import ChatOpenAI
from ragas.llms import LangchainLLMWrapper
from langchain_openai import ChatOpenAI, OpenAIEmbeddings
import requests

load_dotenv() 

# ==========================================
# 1. DATA LOADING & PREPARATION
# ==========================================
print("Loading and cleaning test set...")
test_df = pd.read_csv("Guide_for_applicants_MSCA_Postdoctoral.rag.testset.csv")

test_df = test_df.rename(columns={
    "user_input": "question", 
    "reference": "ground_truth"
})

# Fix the Pydantic/String-to-List error
def safe_eval(val):
    if isinstance(val, list): return val
    try: return ast.literal_eval(val)
    except: return []

test_df['reference_contexts'] = test_df['reference_contexts'].apply(safe_eval)

# ==========================================
# 2. THE EVALUATION LOOP
# ========================================== 
answers = []
retrieved_contexts = []

for i, row in test_df.iterrows():
    query = row['question']

    payload = {
        "embedding_filename": "Guide_for_applicants_MSCA_Postdoctoral.pdf.embeddings.json",
        "messages": [{"content": "You are helpful assistant","role": "system"}],
        "model": "openai/gpt-oss-120b:novita",
        "text": query
    }

    response = requests.post(
        "http://localhost:20250/pdf_analyzer/getchunks",
        json=payload
    )

    if response.status_code != 200:
        print("Error:", response.status_code, response.text) 
        answers.append("")
        retrieved_contexts.append([])
        continue

    llm_resp = response.json()

    chunks = llm_resp["context"]
    ans = llm_resp["llm_response"]

    answers.append(ans)
    retrieved_contexts.append(chunks)

# Append results to dataframe
test_df['answer'] = answers
test_df['contexts'] = retrieved_contexts

# ==========================================
# 3. RAGAS SCORING
#    Initialize the LLM with a much higher max_tokens limit
#    2048 or 4096 is usually safe for complex RAG evaluations
# ==========================================
eval_llm = ChatOpenAI(
    model="gpt-4o", 
    max_tokens=4096, 
    temperature=0
) 
eval_embeddings = OpenAIEmbeddings(
    model="text-embedding-3-small"
) 

print("Calculating Ragas metrics...")
eval_dataset = Dataset.from_pandas(
    test_df[['question','answer','contexts','ground_truth']],
    preserve_index=False
)

result = evaluate(
    eval_dataset,
    metrics=[
        faithfulness,       # Checks if Answer matches Contexts
        answer_relevancy,   # Checks if Answer matches Question
        context_recall      # Checks if Contexts matches Ground Truth
    ],
    llm=eval_llm,
    embeddings=eval_embeddings
)

# ==========================================
# FINAL OUTPUT
# ==========================================
print("\n--- Evaluation Summary ---")
print(result)

scores_df = result.to_pandas()
print(scores_df.describe())

low_faith = scores_df.nsmallest(5, "faithfulness")
print(low_faith)

