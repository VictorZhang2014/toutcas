from flask import Flask
from routes import text_analyser, webpage_content, pdf_analyser, burn_after_use
from dotenv import load_dotenv

load_dotenv() 

app = Flask(__name__) 

for bp in (webpage_content.webpage_content_bp,
           text_analyser.text_analyser_bp, 
           pdf_analyser.pdf_analyzer_bp,
           burn_after_use.bau_bp
           ):
    app.register_blueprint(bp, url_prefix="/")

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=20250, debug=True)
