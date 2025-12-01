import os  
import shutil
from flask import Blueprint, current_app, request, jsonify

HF_TOKEN = os.getenv("HUGGING_FACE_API_TOKEN") 

bau_bp = Blueprint("burn_after_use", __name__)

@bau_bp.route("/burn_after_use", methods=["POST"])
def run():  
    body = request.get_json() 
    conversation_id = body.get("conversation_id")
    pdf_dir = os.path.join(current_app.root_path, "pdf", conversation_id)
    if (os.path.exists(pdf_dir)): 
        try:
            shutil.rmtree(pdf_dir)  
        except OSError as e: 
            print(f"Error removing directory {pdf_dir}: {e}")
    return jsonify({
        "success": True
    })


