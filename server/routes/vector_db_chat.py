import os
import json
import requests
from flask import Blueprint, request, jsonify
from constants import DEFAULT_INFERENCE_MODEL, LLM_ENDPOINT
from db.sql_base import SQLBase
from db.text_to_embedding import TextToEmbed

HF_TOKEN = os.getenv("HUGGING_FACE_API_TOKEN")
VECTOR_DEFAULT_PROMPT = "You are ToutCas, a helpful AI expert in analyzing the user's request and responding to them through the Vector Database information. Always maintain a friendly and professional tone."

vector_db_chat_bp = Blueprint("vector_db_chat", __name__)

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

def build_context_text(results, max_chars_per_doc=1000):
    context_blocks = []
    for i, row in enumerate(results, start=1):
        content = row["content"][:max_chars_per_doc]
        similarity = round(row["similarity"], 3)
        context_blocks.append(
            f"[Document {i} | similarity={similarity}]\n{content}"
        )
    return "\n\n".join(context_blocks)

@vector_db_chat_bp.route("/vector_db_chat", methods=["POST"])
def run():
    body = request.get_json() 
    model_name = body.get("model", DEFAULT_INFERENCE_MODEL) 
    message_list = body.get("messages", [ {"role": "system", "content": VECTOR_DEFAULT_PROMPT} ])
    user_text = body.get("text", "").strip() 

    user_text_embedding = TextToEmbed().encode2embedding(user_text)
    matched_embeddings = SQLBase().query_by_embedding(user_text_embedding)
    matched_context = build_context_text(matched_embeddings)

    final_prompt = ( 
      "User's request:\n\n"
      f"{user_text}\n\n"
      "The matched context from Vector Database:\n\n"
      f"{matched_context}\n\n"
      "Now analyze and respond to the request."
    ) 
    
    response = call_llm(final_prompt, model_name, message_list)

    return jsonify({
        "success": True, 
        "llm_response": response
    })
