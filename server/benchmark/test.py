import numpy as np
import faiss
import time

# -----------------------------
# Helper: Normal cosine search
# -----------------------------
def cosine_similarity(a, b):
    return np.dot(a, b) / (np.linalg.norm(a) * np.linalg.norm(b))

def search_cosine(query, embeddings, top_k=3):
    sims = []
    for e in embeddings:
        sims.append(cosine_similarity(query, e))
    idx = np.argsort(sims)[::-1][:top_k]
    return idx


# -----------------------------
# Helper: FAISS search (cosine)
# -----------------------------
def build_faiss(embeddings):
    embeddings = embeddings.astype("float32")
    faiss.normalize_L2(embeddings)  # cosine → inner product
    dim = embeddings.shape[1]
    index = faiss.IndexFlatIP(dim)
    index.add(embeddings)
    return index

def search_faiss(query, index, top_k=3):
    q = query.astype("float32").reshape(1, -1)
    faiss.normalize_L2(q)
    scores, ids = index.search(q, top_k)
    return ids[0]


# -----------------------------
# Benchmark
# -----------------------------
def benchmark(num_vectors=10000, dim=1024, top_k=3):

    print(f"\n=== Benchmark with {num_vectors} vectors, dim={dim} ===")

    # Generate synthetic data
    embeddings = np.random.rand(num_vectors, dim).astype("float32")
    query = np.random.rand(dim).astype("float32")

    # ----- Test cosine (Python) -----
    t0 = time.time()
    search_cosine(query, embeddings, top_k)
    t1 = time.time()
    cosine_time = (t1 - t0) * 1000
    print(f"Python cosine search: {cosine_time:.3f} ms")

    # ----- Test FAISS -----
    index = build_faiss(embeddings)
    t0 = time.time()
    search_faiss(query, index, top_k)
    t1 = time.time()
    faiss_time = (t1 - t0) * 1000
    print(f"FAISS search:         {faiss_time:.3f} ms")


if __name__ == "__main__":
    for N in [1_000, 10_000, 50_000, 100_000]:
        benchmark(num_vectors=N)
