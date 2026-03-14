import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/ai_service.dart';
import '../../widgets/modern_widgets.dart';

class AIChatbotScreen extends StatefulWidget {
  const AIChatbotScreen({super.key});

  @override
  State<AIChatbotScreen> createState() => _AIChatbotScreenState();
}

class _AIChatbotScreenState extends State<AIChatbotScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [
    {"role": "ai", "text": "Hello! I'm SecureNest AI. Ask me anything about your property, rules, or rental agreements."}
  ];
  final AIService _aiService = AIService();
  bool _isLoading = false;

  void _sendMessage() async {
    if (_controller.text.trim().isEmpty) return;

    String userQuery = _controller.text;
    setState(() {
      _messages.add({"role": "user", "text": userQuery});
      _isLoading = true;
    });
    _controller.clear();

    // Send query to the Python Backend
    String aiResponse = await _aiService.askQuestion(userQuery);

    setState(() {
      _isLoading = false;
      _messages.add({"role": "ai", "text": aiResponse});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("SecureNest AI", style: GoogleFonts.poppins(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                bool isAi = msg['role'] == "ai";
                return Align(
                  alignment: isAi ? Alignment.centerLeft : Alignment.centerRight,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 15),
                    padding: const EdgeInsets.all(16),
                    constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
                    decoration: BoxDecoration(
                      color: isAi ? AppColors.softGrey : AppColors.primaryBlack,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(20),
                        topRight: const Radius.circular(20),
                        bottomLeft: Radius.circular(isAi ? 0 : 20),
                        bottomRight: Radius.circular(isAi ? 20 : 0),
                      ),
                    ),
                    child: Text(
                      msg['text']!, 
                      style: GoogleFonts.poppins(color: isAi ? Colors.black87 : Colors.white, fontSize: 15),
                    ),
                  ),
                );
              },
            ),
          ),
          if (_isLoading) 
            const Padding(
              padding: EdgeInsets.all(8.0), 
              child: CircularProgressIndicator(color: AppColors.accentTeal),
            ),
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        color: Colors.white, 
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 15, offset: const Offset(0, -5))],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(color: AppColors.softGrey, borderRadius: BorderRadius.circular(25)),
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText: "Ask about rent rules...", 
                    border: InputBorder.none, 
                    hintStyle: GoogleFonts.poppins(color: Colors.grey),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Container(
              decoration: const BoxDecoration(color: AppColors.accentTeal, shape: BoxShape.circle),
              child: IconButton(
                onPressed: _sendMessage, 
                icon: const Icon(Icons.send, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
