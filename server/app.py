from flask import Flask
from routes import text_analyser, webpage_content, pdf_analyser, burn_after_use, vector_db_chat
import logging
from dotenv import load_dotenv

load_dotenv() 

logging.basicConfig(
    filename='app.log', # Log file at the root of the project
    level=logging.INFO, 
    format='%(asctime)s [%(levelname)s] %(name)s - %(message)s',
    datefmt='%Y-%m-%d %H:%M:%S'
)

app = Flask(__name__) 

@app.route("/")
def home():
    return "I'm ToutCas, your personal AI assistant."

for bp in (webpage_content.webpage_content_bp,
           text_analyser.text_analyser_bp, 
           pdf_analyser.pdf_analyzer_bp,
           burn_after_use.bau_bp,
           vector_db_chat.vector_db_chat_bp
           ):
    app.register_blueprint(bp, url_prefix="/")

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=20250, debug=True)
