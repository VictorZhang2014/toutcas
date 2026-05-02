from datetime import datetime
import os  
import time
import shutil
from flask import Blueprint, current_app, request, jsonify

HF_TOKEN = os.getenv("HUGGING_FACE_API_TOKEN") 

bau_bp = Blueprint("burn_after_use", __name__)

@bau_bp.route("/burn_after_use", methods=["POST"])
def run():  
    start_time = datetime.now()
    start = time.perf_counter()

    body = request.get_json() 
    conversation_id = body.get("conversation_id")
    pdf_dir = os.path.join(current_app.root_path, "pdf", conversation_id)
    if (os.path.exists(pdf_dir)): 
        try:
            shutil.rmtree(pdf_dir)  
        except OSError as e: 
            print(f"Error removing directory {pdf_dir}: {e}")
 
    end = time.perf_counter()
    end_time = datetime.now()
    latency_ms = (end - start) * 1000 
    current_app.logger.info(
        f"REMOTE_CACHE_INVALIDATION | "
        f"start={start_time.isoformat()} | "
        f"end={end_time.isoformat()} | "
        f"latency={latency_ms:.2f} ms"
    )

    return jsonify({
        "success": True
    })


