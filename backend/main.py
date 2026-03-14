import os
import numpy as np
from fastapi import FastAPI
from pydantic import BaseModel
from dotenv import load_dotenv
from litellm import completion, embedding

load_dotenv()

GROQ_API_KEY = os.getenv("GROQ_API_KEY")
VOYAGE_API_KEY = os.getenv("VOYAGE_API_KEY")

app = FastAPI()
DATA_FOLDER = "./data"

# GLOBAL CACHE: This saves your API quota!
doc_cache = [] 

def get_embedding(text):
    res = embedding(
        model="voyage/voyage-3",
        input=[text],
        api_key=VOYAGE_API_KEY
    )
    return res.data[0]["embedding"]

def cosine_similarity(v1, v2):
    return np.dot(v1, v2) / (np.linalg.norm(v1) * np.linalg.norm(v2))

# -----------------------------
# PRE-LOAD DATA (Run this at startup)
# -----------------------------
def load_and_embed_all():
    global doc_cache
    doc_cache = []
    print("ndexing documents... (Staying under Rate Limits)")
    for file in os.listdir(DATA_FOLDER):
        if file.endswith(".txt"):
            with open(os.path.join(DATA_FOLDER, file), "r") as f:
                content = f.read()
                # Embed once and save it
                vector = get_embedding(content)
                doc_cache.append({"text": content, "vector": vector})
    print(f"✅ Indexed {len(doc_cache)} documents.")

class Query(BaseModel):
    question: str

@app.post("/ask")
async def ask(q: Query):
    try:
        if not doc_cache:
            return {"answer": "No documents indexed. Add .txt files to /data and restart."}

        # 1. Embed the user question
        query_vec = get_embedding(q.question)
        
        # 2. Search cached vectors (No API call needed here!)
        best_context = ""
        max_sim = -1
        for item in doc_cache:
            sim = cosine_similarity(query_vec, item["vector"])
            if sim > max_sim:
                max_sim = sim
                best_context = item["text"]

        # 3. Get Answer from Groq
        res = completion(
            model="groq/llama-3.1-8b-instant",
            messages=[{"role": "user", "content": f"Context: {best_context}\n\nQuestion: {q.question}"}],
            api_key=GROQ_API_KEY
        )
        
        return {"answer": res.choices[0].message.content}
    
    except Exception as e:
        if "rate_limit" in str(e).lower():
            return {"answer": "Voyage API Rate Limit hit. Wait 60 seconds."}
        return {"answer": f"Backend Error: {str(e)}"}

if __name__ == "__main__":
    import uvicorn
    # Load and embed files BEFORE starting the server
    load_and_embed_all()
    print("🚀 SecureNest API Ready")
    uvicorn.run(app, host="0.0.0.0", port=8000)