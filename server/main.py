from flask import Flask
from dotenv import load_dotenv

load_dotenv() 

app = Flask(__name__)

from routes import text_analyzer, webpage_content

for bp in (text_analyzer.text_analyzer_bp, 
           webpage_content.webpage_content_bp):
    app.register_blueprint(bp, url_prefix="/")

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=20250, debug=True)
