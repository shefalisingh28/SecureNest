# 🛡️ SecureNest: AI-Powered Rental Management

SecureNest is a modern real estate platform designed to bridge the trust gap between landlords and tenants. It features a high-performance **Pathway RAG (Retrieval-Augmented Generation) Intelligence Engine** that provides real-time answers to rental queries based on local documents.

---

## 🚀 Features

### 🏢 Dashboards
* **Tenant Dashboard:** Explore properties with a premium Teal/Black UI, view Trust Scores, and interact with the AI assistant.
* **Landlord Dashboard:** Manage listings, track occupancy with graphical stats, and monitor income.

### 🤖 AI Intelligence Engine (RAG)
* **Powered by Pathway:** Uses a streaming vector store to learn from documents instantly.
* **Real-time Knowledge:** Simply drop a PDF or Text file into the `/backend/data` folder, and the AI updates its knowledge without a restart.

### 🛡️ SecureNest Trust Score
* Proprietary scoring system based on payment history, identity verification, and community reviews.

---

## 🛠️ Project Structure

```text
SecureNest/
├── SecureNest_app/      # Flutter Frontend
└── backend/             # Pathway RAG Python Backend
    ├── data/            # Knowledge base (drop PDFs/TXTs here)
    └── main.py          # Intelligence Engine
