import 'dart:convert';
import 'package:http/http.dart' as http;

class AIService {
  // 10.0.2.2 routes to your computer's localhost from the Android Emulator
  static const String _baseUrl = "http://10.0.2.2:8000/v1/pw_ai_answer";

  Future<String> askQuestion(String query) async {
    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"prompt": query}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Pathway's default response format
        return data['result'] ?? data['response'] ?? "I couldn't find an answer in the records.";
      } else {
        return "Server Error: ${response.statusCode}. Is the backend running?";
      }
    } catch (e) {
      return "Connection failed. Please ensure the Python Intelligence Engine is running on port 8000.";
    }
  }
}
