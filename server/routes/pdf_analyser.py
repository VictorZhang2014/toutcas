import os  
import requests
from flask import Blueprint, current_app, json, request, jsonify
from huggingface_hub import InferenceClient
import numpy as np
import PyPDF2
from tiktoken import get_encoding

from constants import DEFAULT_EMBEDDING_MODEL, DEFAULT_INFERENCE_MODEL, DEFAULT_PROMPT, LLM_ENDPOINT

HF_TOKEN = os.getenv("HUGGING_FACE_API_TOKEN") 

pdf_analyzer_bp = Blueprint("pdf_analyzer", __name__)


def pdf_to_chunks(file_path, chunk_size=500):
    pdf = PyPDF2.PdfReader(file_path)
    text = ""
    for page in pdf.pages:
        text += page.extract_text() + "\n"
    enc = get_encoding("cl100k_base")
    tokens = enc.encode(text)
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
      model=DEFAULT_EMBEDDING_MODEL,
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

def sentence_similarity_search(query: str, embeddings, top_k: int = 3):
    client = InferenceClient(
        provider="hf-inference",
        api_key=HF_TOKEN,
    ) 
    sentences = [item["chunk"] for item in embeddings]
    scores = client.sentence_similarity(
        query, 
        sentences,
        model=DEFAULT_EMBEDDING_MODEL,
    ) 
    scored = sorted(
        zip(scores, sentences),
        key=lambda x: x[0],
        reverse=True
    )
    return [text for _, text in scored[:top_k]]

def search_with_sentence_similarity(query, embeddings, top_k=3):
    sentences = [item["chunk"] for item in embeddings]
    results = sentence_similarity_search(query, sentences, top_k)
    return [x[1] for x in results]

def load_embedding_chunks(pdf_dir: str, filename: str, file_entry_name: str):
    file_name = request.form.get(filename).strip()
    embeddings_path = os.path.join(pdf_dir, file_name + ".embeddings.json")
    if (not os.path.exists(embeddings_path)):
      file = request.files.get(file_entry_name)
      if file is None or file.filename == "":
          return None
      save_path = os.path.join(pdf_dir, file.filename)
      file.save(save_path) 
      chunks = pdf_to_embeddings(save_path, embeddings_path)
    else:
      chunks = load_embeddings(embeddings_path)
    return chunks

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
   

@pdf_analyzer_bp.route("/pdf_analyzer", methods=["POST"])
def run():  
    conversation_id = request.form.get("conversation_id")
    model_name = request.form.get("model", DEFAULT_INFERENCE_MODEL) 
    user_query = request.form.get("text").strip()
    message_list = request.form.get("messages", [ {"role": "system", "content": DEFAULT_PROMPT} ]) 
    pdf_dir = os.path.join(current_app.root_path, "pdf", conversation_id) 
    os.makedirs(pdf_dir, exist_ok=True)

    # Web page as a pdf file
    embedding_chunks_web = load_embedding_chunks(pdf_dir, "file_name_web", "file_web")  
    # User uploaded pdf file
    embedding_chunks_useruploaded = load_embedding_chunks(pdf_dir, "file_name_user_uploaded", "file_user_uploaded") 

    # Attack Test 2: Log-Pipeline Leakage Across Tenants
    current_app.logger.info("===========embedding_chunks_useruploaded==========>>>")
    current_app.logger.info(embedding_chunks_useruploaded)

    context = ""
    if embedding_chunks_web is not None:
      docs = search(user_query, embedding_chunks_web)
      context = f"The web content is like `{docs}`\n\n"
    if embedding_chunks_useruploaded is not None:
      docs = search(user_query, embedding_chunks_useruploaded)
      context += f"The user uploaded content is like `{docs}`\n\n"
    prompt = f"""
Context:
{context}

The Question by the user's request:
{user_query}

Now analyze and respond to the user request:
""" 
    response = call_llm(prompt, model_name, message_list)  
    return jsonify({
        "success": True, 
        "llm_response": response
    })



