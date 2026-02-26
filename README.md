# 🛡️ SecureNest: AI-Powered Rental Ecosystem

**SecureNest** is an innovative, AI-driven real estate platform designed to foster transparency and trust between landlords and tenants. By leveraging a high-performance **Pathway RAG (Retrieval-Augmented Generation) Intelligence Engine**, SecureNest provides real-time, document-verified answers to complex rental queries.

---

## 👥 Team Contributors

* **Chaitanya Arora**
* **Shefali Singh**
* **Himani Bhatnagar**
* **Vaibhav Maheshwari**

---

## 🚀 Key Features

### 🏢 Intelligent Dashboards
* **Tenant Portal:** Premium Teal/Black UI for property discovery, Trust Score tracking, and AI-assisted agreement navigation.
* **Landlord Portal:** Advanced property management with occupancy visualization, income tracking, and automated listing tools.

### 🤖 Pathway RAG Intelligence Engine
* **Live Knowledge:** Drop any PDF or Text file into the backend, and the AI learns the rules/details instantly without a server restart.
* **Vector Search:** Highly accurate retrieval using OpenAI embeddings and Pathway’s streaming vector store.

### 🛡️ SecureNest Trust Score
* A proprietary algorithm that evaluates rental reliability based on payment history, verification status, and community feedback.

---

## 🛠️ System Architecture



SecureNest uses a decoupled architecture:
1.  **Frontend:** Flutter (Mobile/Web)
2.  **Backend:** Python with Pathway (RAG Server)
3.  **Database:** Firebase (Authentication & Storage)

---

## ⚙️ Detailed Setup Guide

### 1. Prerequisites
* **Flutter SDK:** [Install Flutter](https://docs.flutter.dev/get-started/install)
* **Python 3.10+**: Ensure `python3-full` is installed on Linux.
* **OpenAI API Key**: Required for the RAG engine.

---

### 2. Backend Setup (Pathway Intelligence Engine)

Navigate to the backend directory:
```bash
cd backend
Create and Setup Virtual Environment (venv):

Bash
# Create the environment
python3 -m venv venv

# Activate it
# On Linux/macOS:
source venv/bin/activate
# On Windows:
.\venv\Scripts\activate

# Update pip and install dependencies
pip install --upgrade pip
pip install pathway unstructured openai python-dotenv
Configure Environment Variables:
Create a .env file in the backend/ folder:

Plaintext
OPENAI_API_KEY=your_openai_api_key_here
Running the Engine:

Bash
python main.py
Wait for the message: 🚀 SafeAbode Intelligence Engine Running on port 8000...

3. Frontend Setup (Flutter App)
Navigate to the app directory:

Bash
cd SecureNest_app
Install Dependencies:

Bash
flutter pub get
Configure API Connection:
Open lib/services/ai_service.dart and ensure the _baseUrl matches your environment:

Android Emulator: http://10.0.2.2:8000/v1/query

Physical Device/Web: http://<YOUR_LOCAL_IP>:8000/v1/query

Launch the App:

Bash
flutter run
📂 How to Update AI Knowledge
Navigate to backend/data/.

Drop any .txt or .pdf file (e.g., house_rules.txt).

The AI will automatically ingest the data. You can now ask the SecureNest Chatbot questions like "What is the late fee policy?" based on your uploaded file.

📝 License
This project is developed for hackathon purposes. All rights reserved by the contributors.
