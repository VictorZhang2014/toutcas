import os
import json
import requests
from flask import Blueprint, request, jsonify

from constants import DEFAULT_INFERENCE_MODEL, DEFAULT_PROMPT, LLM_ENDPOINT

HF_TOKEN = os.getenv("HUGGING_FACE_API_TOKEN")

text_analyser_bp = Blueprint("text_analyser", __name__)

def call_llm(prompt: str, model: str, messages: list[str]) -> str:
    headers = {
        "Authorization": f"Bearer {HF_TOKEN}",
        "Content-Type": "application/json"
    }  
    messages.append({"role": "user", "content": prompt}) 
    payload = {
        "model": model,
        "stream": False,
        "messages": messages
    } 
    resp = requests.post(LLM_ENDPOINT, headers=headers, data=json.dumps(payload))
    resp.raise_for_status()
    data = resp.json()
    return data["choices"][0]["message"]["content"]


@text_analyser_bp.route("/text_analyser", methods=["POST"])
def run():
    body = request.get_json() 
    model_name = body.get("model", DEFAULT_INFERENCE_MODEL) 
    message_list = body.get("messages", [ {"role": "system", "content": DEFAULT_PROMPT} ])
    user_text = body.get("text", "").strip()
    web_content = body.get("web_content", "").strip()

    final_prompt = ( 
      f"{user_text}\n\n"
      "The extracted webpage contents:\n\n"
      f"{web_content}\n\n"
      "Now analyze and respond to my request."
    ) 
    
    response = call_llm(final_prompt, model_name, message_list)

    return jsonify({
        "success": True, 
        "llm_response": response
    })





# ================ Attention to the following ================
# Always return 404 response because of the targeting website is anti-scraping.

# import trafilatura
# from playwright.sync_api import sync_playwright

# def extract_urls(text: str):
#     url_pattern = r'https?://[^\s]+' 
#     return re.findall(url_pattern, text)

# def fetch_html_with_playwright(url: str) -> str:
#     with sync_playwright() as p:
#         browser = p.chromium.launch(headless=True)
#         page = browser.new_page()
#         page.set_user_agent(
#          "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 "
#           "(KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36"
#         )
#         page.set_extra_http_headers({
#           "Accept-Language": "en-US,en;q=0.9",
#           "Accept": "text/html,application/xhtml+xml"
#         })
#         page.goto(url, timeout=80000)
#         page.wait_for_timeout(1500)
#         html = page.content()
#         browser.close() 
#         return html


# def extract_main_content(url: str) -> str:
#     try:
#         html = fetch_html_with_playwright(url)
#         content = trafilatura.extract(html)
#         return content if content else ""
#     except Exception as e:
#         return f"[Error extracting {url}: {e}]"

# @text_analyzer_bp.route("/text_analyzer", methods=["POST"])
# def run():
#     body = request.get_json() 
#     model_name = body.get("model", DEFAULT_MODEL) 
#     message_list = body.get("messages", [ {"role": "system", "content": DEFAULT_PROMPT} ])
#     user_text = body.get("text", "").strip() 

#     # step 1: extract URLs
#     urls = extract_urls(user_text)  
#     print("urls=", urls)

#     # step 2: extract web main content for each URL
#     extracted_contents = []
#     for url in urls:
#         content = extract_main_content(url) 
#         extracted_contents.append({
#             "url": url,
#             "content": content[:5000]  # limit for safety
#         }) 

#     # step 3: construct prompt
#     final_prompt = ( 
#         f"{user_text}\n\n"
#         "Extracted webpage contents:\n\n"
#     ) 
#     for item in extracted_contents:
#         # final_prompt += f"=== URL: {item['url']} ===\n"
#         final_prompt += item["content"] + "\n\n" 
#     final_prompt += "Now analyze and respond to my request."

#     # step 4: call LLM
#     response = call_llm(final_prompt, model_name, message_list)

#     return jsonify({
#         "success": True, 
#         "llm_response": response
#     })

