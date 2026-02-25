import pathway as pw
from pathway.xpacks.llm.llms import OpenAIChat, embedders
from pathway.xpacks.llm.vector_store import VectorStoreServer
import os
from dotenv import load_dotenv

load_dotenv()

# 1. The Real-Time Data Source
# This watches the './data' folder. 
# HACKATHON RULE: If you add a file here while the app is running, 
# the AI learns it INSTANTLY.
data_sources = [
    pw.io.fs.read(
        "./data",
        format="binary",
        mode="streaming",
        with_metadata=True,
    )
]

# 2. Define the RAG Server
# This creates a web server that Flutter can talk to.
# It handles embedding, indexing, and retrieval automatically.
rag_server = VectorStoreServer(
    *data_sources,
    embedder=embedders.OpenAIEmbedder(),
    llm=OpenAIChat(model="gpt-3.5-turbo"),
    parser=pw.xpacks.llm.parsers.ParseUnstructured(),
)

# 3. Run the Server
if __name__ == "__main__":
    # Create the data folder if it doesn't exist
    if not os.path.exists("./data"):
        os.makedirs("./data")
    
    print("🚀 SafeAbode Intelligence Engine Running on port 8000...")
    print("📂 Drop PDF/Text files into the 'backend/data' folder to update knowledge live!")
    
    # This runs the Pathway App
    rag_server.run(
        host="0.0.0.0",
        port=8000,
        threaded=False,
        with_cache=True,
    )
