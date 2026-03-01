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
- 4. Generate 10 rows of the Ground_Truth as the test set, run command `python3 step1_groundtruth_generator.py`, and the ground_truth set has saved to `./Guide_for_applicants_MSCA_Postdoctoral.rag.testset.csv`
- 5. Final step is to run command `python3 step2_evalute.py`, the output would be 

Evaluation Summary
```
{'faithfulness': 0.5486, 'answer_relevancy': 0.8122, 'context_recall': 0.4556}
```

Pandas Describe
```
|       faithfulness | answer_relevancy | context_recall |
|--------------------|------------------|----------------|
|count  |    4.000000    |     12.000000    |   12.000000
|mean   |    0.548579    |      0.812217    |    0.455556
|std    |    0.216621    |      0.118089    |    0.401596
|min    |    0.241935    |      0.534869    |    0.000000
|25%    |    0.497984    |      0.759610    |    0.000000
|50%    |    0.601190    |      0.834552    |    0.450000
|75%    |    0.651786    |      0.857521    |    0.750000
|max    |    0.750000    |      0.986943    |    1.000000
```

```
user_input                                 retrieved_contexts  ... answer_relevancy context_recall
7   What are the eligibility criteria for research...  [ ...  ...         0.805993       0.000000
8   What are the eligibility criteria for research...  [ ...  ...         0.534869       0.400000
10  Wht are the eligibility conditions for a non-a...  [ ...  ...         0.840006       0.666667
9   What are the eligibility criteria for research...  [ ...  ...         0.836831       0.500000
0   What is the purpose of the Marie Skłodowska-Cu...  [ ...  ...         0.904683       1.000000
```


