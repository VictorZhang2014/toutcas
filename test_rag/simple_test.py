from datasets import Dataset
from dotenv import load_dotenv
from ragas import evaluate
from ragas.metrics import (
    faithfulness,
    answer_relevancy,
    context_precision,
    context_recall,
)

load_dotenv() 

# 1. Define your Test Dataset
# In a real scenario, these come from your RAG pipeline's logs
data_samples = {
    'question': [
        'When was the Great Wall of China built?', 
        'What is the capital of France?'
    ],
    'answer': [
        'The majority of the existing wall is from the Ming Dynasty (1368–1644).', 
        'The capital is Paris.'
    ],
    'contexts': [
        ['The Great Wall was built across historical northern borders of China. Most of the current wall dates to the Ming Dynasty.'],
        ['Paris is the capital and most populous city of France.']
    ],
    'ground_truth': [
        'The Great Wall was built over many centuries, but the Ming Dynasty (1368–1644) built the most famous parts.',
        'Paris is the capital of France.'
    ]
}

# 2. Convert dictionary to a Dataset object
dataset = Dataset.from_dict(data_samples)

# 3. Run the Evaluation
results = evaluate(
    dataset,
    metrics=[
        faithfulness,        # Checks: Is the answer derived ONLY from the context?
        answer_relevancy,    # Checks: Does the answer actually address the question?
        context_precision,   # Checks: Is the useful information ranked high in the context?
        context_recall       # Checks: Does the context contain the info in the ground_truth?
    ]
)

# 4. Export and Print Results
df = dataset.to_pandas().join(results.to_pandas())
print("--- Ragas Evaluation Results ---")
print(df[['question', 'faithfulness', 'answer_relevancy']])
print("\n--- Summary Scores ---")
print(results)

# 5. The results summary
# --- Ragas Evaluation Results ---
#                                   question  faithfulness  answer_relevancy
# 0  When was the Great Wall of China built?           0.5               NaN
# 1           What is the capital of France?           1.0               NaN

# --- Summary Scores ---
# {'faithfulness': 0.7500, 'answer_relevancy': nan, 'context_precision': 1.0000, 'context_recall': 1.0000}

