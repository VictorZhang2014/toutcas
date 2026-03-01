# Testify The RAG Performance

- Primary Framework: RAGAs: https://github.com/vibrantlabsai/ragas

# Four Metrics

- Faithfulness: checks is the answer drived from the context?
- Answer_Relevancy: checks does the answer actually address the questions?
- Context_Precision: checks is the useful information ranked high in the context?
- Context_Recall: checks does the context contain the info in the ground_truth?

# Simple RAGAs test

```python
python3 simple_test.py
```
The output would be 
```text
{'faithfulness': 0.7500, 'answer_relevancy': nan, 'context_precision': 1.0000, 'context_recall': 1.0000}
```

# Production-like Reproducible Steps
- 1. On Toutcas client app, upload the sample PDF file, and write one question about the file
- 2. Wait until the Toutcas client finishing, there will be an embedding json file generated and saved inside `PROJECT_ROOT/server/pdf/` folder on the `PROJECT_ROOT/server/` directory
- 3. Copy the sample json file `Guide_for_applicants_MSCA_Postdoctoral.pdf.embeddings.json` in this project
- 4. Generate 50 rows of the Ground_Truth as the test set, run command `python3 step1_groundtruth_generator.py`, and the ground_truth set has saved to `./Guide_for_applicants_MSCA_Postdoctoral.rag.testset.csv`
- 5. Final step is to run command `python3 step2_evalute.py`, the output would be 

```text
{'faithfulness': 0.7500, 'answer_relevancy': nan, 'context_precision': 1.0000, 'context_recall': 1.0000}
```


