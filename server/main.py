from flask import Flask
from dotenv import load_dotenv

load_dotenv() 

app = Flask(__name__)

from routes.text_analyzer import text_analyzer_bp
app.register_blueprint(text_analyzer_bp, url_prefix="/")

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=20250, debug=True)
