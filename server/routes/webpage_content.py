import trafilatura 
from flask import Blueprint, request, jsonify

webpage_content_bp = Blueprint("webpage_content", __name__)

def extract_content(url: str, htmlcode: str) -> str:
    try: 
        content = trafilatura.extract(htmlcode)
        return content if content else ""
    except Exception as e:
        return f"[Error extracting {url}: {e}]"
    
@webpage_content_bp.route("/webpage_content", methods=["POST"])
def run():
    body = request.get_json() 
    url = body.get("url", "")  
    htmlcode = body.get("htmlcode", "").strip()
    content = extract_content(url, htmlcode)   

    return jsonify({
        "success": True, 
        "content": content
    })



