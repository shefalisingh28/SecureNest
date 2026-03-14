# 🏠 SecureNest - Hackathon Project

Welcome to SecureNest! This project consists of two main parts that must run simultaneously:
1. **The Python Backend** (Powers the AI Chatbot)
2. **The Flutter Frontend** (The mobile app UI)

Follow these steps carefully to get the app running on your Windows/linux/Mac

---

## 🛠️ Prerequisites

Before you begin, ensure you have the following installed on your PC:
1. **[Python 3.x](https://www.python.org/downloads/)**: Make sure to check the box that says **"Add Python to PATH"** during installation.
2. **[Flutter SDK](https://docs.flutter.dev/get-started/install/windows)**: Installed and added to your system environment variables.
3. **[Android Studio](https://developer.android.com/studio)**: You will need this to set up and run an Android Emulator.

---

## 🧠 Step 1: Start the AI Chatbot Backend (Python)

The mobile app relies on a local Python server to answer chatbot queries. If this isn't running, the chatbot will show a connection error.

1. Extract the project ZIP file.
2. Open **Command Prompt** or **PowerShell** and navigate to the **backend folder** (where the Python script is located).
3. Create a virtual environment by running:
   ```cmd
   python -m venv venv
Activate the virtual environment:

DOS
venv\Scripts\activate
(You should see (venv) appear at the beginning of your command prompt).

Install all required dependencies:

DOS
pip install -r requirements.txt
Start the backend server (replace app.py with the actual name of the main Python file if it's different):

DOS
python app.py
(Note: The server must run on port 8000. Leave this terminal window open in the background!)

📱 Step 2: Start the Mobile App (Flutter)
Now that the backend is listening, let's launch the frontend.

Open the SecureNest_app folder in VS Code or Android Studio.

CRITICAL SECURITY STEP: Because API keys are kept secret, you need to manually add the Google Maps key.

Inside the SecureNest_app folder, create a new file and name it exactly .env

Open the .env file and paste the following line inside it:

Plaintext
MAPS_API_KEY=XXXXXXXXXXXXXXX
Save the file. (Note: Windows sometimes hides files starting with a dot, so make sure your file explorer is set to show hidden files).

Open a new terminal inside your code editor (make sure you are in the SecureNest_app directory) and download the Flutter packages:

flutter pub get

Launch your Android Emulator from Android Studio.

Once the emulator is fully booted and on the home screen, run the app:

flutter run
