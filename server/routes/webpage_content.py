import os
import trafilatura 
import requests
import json 
from flask import Blueprint, request, jsonify

from constants import DEFAULT_INFERENCE_MODEL, LLM_ENDPOINT

HF_TOKEN = os.getenv("HUGGING_FACE_API_TOKEN") 

webpage_content_bp = Blueprint("webpage_content", __name__)

def extract_content(url: str, htmlcode: str) -> str:
    try: 
        content = trafilatura.extract(htmlcode)
        return content if content else ""
    except Exception as e:
        return f"[Error extracting {url}: {e}]"
    
def check_if_pdf_only(htmlcode: str) -> str:
    headers = {
        "Authorization": f"Bearer {HF_TOKEN}",
        "Content-Type": "application/json"
    }  
    messages = [ {"role": "system", "content": "You are a PDF finder expert in the HTML sourcecode. Answer only one word: YES or NO."} ]
    messages.append({"role": "user", "content": f"Is the following HTML sourcecode mainly to show a PDF? `{htmlcode}`"}) 
    payload = {
        "model": DEFAULT_INFERENCE_MODEL,
        "stream": False,
        "messages": messages
    }  
    resp = requests.post(LLM_ENDPOINT, headers=headers, data=json.dumps(payload))
    resp.raise_for_status()
    data = resp.json()
    return data["choices"][0]["message"]["content"]

@webpage_content_bp.route("/webpage_content", methods=["POST"])
def run():
    body = request.get_json()  
    url = body.get("url")  
    htmlcode = body.get("htmlcode").strip() 
    # respConfirm = check_if_pdf_only(htmlcode)  # Consumes too many tokens
    isPDFViewer = '<embed name="plugin" src="'+url+'" type="application/pdf">' in htmlcode
    if (isPDFViewer):
        return jsonify({
            "success": True,   
            "is_pdf": True,
            "content": ""
        })
    else: 
        content = extract_content(url, htmlcode)   
        return jsonify({
            "success": True,  
            "is_pdf": False,
            "content": content  
        })



