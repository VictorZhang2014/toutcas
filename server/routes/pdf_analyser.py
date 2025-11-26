import os  
import requests
from flask import Blueprint, current_app, json, request, jsonify
from huggingface_hub import InferenceClient
import numpy as np
import PyPDF2
from tiktoken import get_encoding

HF_TOKEN = os.getenv("HUGGING_FACE_API_TOKEN") 
HF_ENDPOINT = "https://router.huggingface.co/v1/chat/completions"

DEFAULT_MODEL = "openai/gpt-oss-120b:novita"
DEFAULT_PROMPT = "You are ToutCas, a helpful AI assistant integrated into a web browser application. Provide concise and relevant answers to user queries based on the context of web browsing or file content (such as PDF). Always maintain a friendly and professional tone."


pdf_analyzer_bp = Blueprint("pdf_analyzer", __name__)


def pdf_to_chunks(file_path, chunk_size=500):
    pdf = PyPDF2.PdfReader(file_path)
    text = ""
    for page in pdf.pages:
        text += page.extract_text() + "\n"
    
    # 计算 token 数（示例使用 tiktoken）
    enc = get_encoding("cl100k_base")
    tokens = enc.encode(text)

    # 拆分 chunks
    chunks = []
    for i in range(0, len(tokens), chunk_size):
        chunk_tokens = tokens[i:i+chunk_size]
        chunk_text = enc.decode(chunk_tokens)
        chunks.append(chunk_text)
    return chunks

def embed_text(text: str):
    client = InferenceClient(
      provider="hf-inference",
      api_key=HF_TOKEN,
    ) 
    result = client.feature_extraction(
      text,
      model="google/embeddinggemma-300m",
    )  
    return result

def pdf_to_embeddings(file_path, out_file):
    chunks = pdf_to_chunks(file_path)
    embeddings = []
    for i, chunk in enumerate(chunks):
        emb = embed_text(chunk)
        embeddings.append({
            "id": i,
            "chunk": chunk,
            "embedding": emb.tolist()
        }) 
    with open(out_file, "w", encoding="utf-8") as f:
        json.dump(embeddings, f)
    print(f"Saved {len(chunks)} embeddings to {out_file}")
    return embeddings
    

def load_embeddings(file_path):
    with open(file_path, "r", encoding="utf-8") as f:
        return json.load(f)
    
def cosine_similarity(a, b):
    a = np.array(a)
    b = np.array(b)
    return np.dot(a, b) / (np.linalg.norm(a) * np.linalg.norm(b))

def search(query, embeddings, top_k=3):
    q_emb = embed_text(query)
    scored = []
    for item in embeddings:
        sim = cosine_similarity(q_emb, item["embedding"])
        scored.append((sim, item))
    scored.sort(reverse=True, key=lambda x: x[0])
    return [item["chunk"] for _, item in scored[:top_k]]

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
    resp = requests.post(HF_ENDPOINT, headers=headers, data=json.dumps(payload))
    resp.raise_for_status()
    data = resp.json()
    return data["choices"][0]["message"]["content"]

@pdf_analyzer_bp.route("/pdf_analyzer", methods=["POST"])
def run():  
    pdf_dir = os.path.join(current_app.root_path, "pdf") 
    os.makedirs(pdf_dir, exist_ok=True)
    file_name = request.form.get("file_name").strip()
    embeddings_path = os.path.join(pdf_dir, file_name + ".embeddings.json")
    if (not os.path.exists(embeddings_path)):
      file = request.files["file"]
      if file.filename == "":
        return jsonify({"success": False, "error": "No selected file"}), 400
      save_path = os.path.join(pdf_dir, file.filename)
      file.save(save_path)
      
      chunks = pdf_to_embeddings(save_path, embeddings_path)
    else:
      chunks = load_embeddings(embeddings_path)
         
    model_name = request.form.get("model", DEFAULT_MODEL) 
    user_query = request.form.get("text").strip()
    message_list = request.form.get("messages", [ {"role": "system", "content": DEFAULT_PROMPT} ])

    docs = search(user_query, chunks)
    context = "\n\n".join(docs) 
    prompt = f"""
Context:
{context}

Question:
{user_query}

Now analyze and respond to the user request:
""" 
    response = call_llm(prompt, model_name, message_list)  
    return jsonify({
        "success": True, 
        "llm_response": response
    })



