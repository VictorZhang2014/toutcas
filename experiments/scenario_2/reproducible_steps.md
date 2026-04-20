### Title
Log-Pipeline Leakage Across Tenants

#### Description
Note: We must admit that many server programs running on AWS, Google Cloud, or Azure, who enabled remote logging service and caching. AWS utilises CloudWatch Logs to centralize the logs from all of the system instances, applications, and AWS services that you use, in a single, and highly scalable service. The CloudWatch caches logs several days, weeks, or months. So this service should be deeply considerable in production environment.

#### Steps
- 1. Run this Flutter application
- 2. Run Python+Flask server side by typing the command `python3 app.py` in the root directory of server
- 3. Choose a PDF file to chat with from client side, every chat or text will go through the logging service
- 4. Repeat 20 times on the Step 3 

#### Results
We simulate this experiment, chat with the PDF data 20 times, and log 2 snippets of data, the logged file will save at the root directory of the server project, it is viewable to all. It turns out that 18/20 were non-logging chats.
- Log service at path location: `./toutcas/server/routes/pdf_analyser.py` (Line 143).
