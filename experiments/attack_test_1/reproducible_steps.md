### Title
Compromised Vector-Store Credential Attack

#### Description
The attack simulates a realistic scenario where database administrator credentials are leaked or the password is weak. 

#### Steps
- 1. Create a vector database in the popular platform - supabase
  - Head to https://supabase.com/
- 2. Set a admin password, for example: `Abc123.,`; 
- 3. Create a table and import the csv with its embedding data into the postgresql vector database
  - File path: `./toutcas/server/db/text_to_embedding.py`
  - File CSV data path: `./toutcas/experiments/PseudoData_RD-Dept.csv`
- 4. Run the Flutter client application, and run the server side Python application
  - Server file path: `./toutcas/server/routes/vector_db_chat.py`, POST request to `http://127.0.0.1:20250/vector_db_chat`
  - Need to fill in SUPABASE_DB configuration at path ``./toutcas/.env`
- 5. Chat with the data in any one of the Research Development Department, Finance Department or Human Resources Department
  - When you chat with the departmental embedding data, it supports of cosine similarity, but you can choose from:
    - `Cosine distance`, the operator is `<=>`
    - `Euclidean (L2) distance`, the operator is `<->`
- 6. After 35 times of tests, we got two errors: 
  - Weak Password (Online dictionary of MD5 matched this password)
  - Credential Compromised (Accidently send it to the another)

#### Results
- 35 times of trials, 2 failures, the rest are succeeded.

