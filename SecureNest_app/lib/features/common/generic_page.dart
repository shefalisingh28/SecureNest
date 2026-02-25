import 'package:flutter/material.dart';

class GenericPage extends StatelessWidget {
  final String title;
  const GenericPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      appBar: AppBar(
        title: Text(title, style: const TextStyle(color: Colors.black87)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 120, width: 120,
              decoration: BoxDecoration(
                color: Colors.blueAccent.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.construction, size: 50, color: Colors.blueAccent),
            ),
            const SizedBox(height: 20),
            Text("Coming Soon", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.grey[800])),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text("The '$title' module is currently under development.", textAlign: TextAlign.center, style: TextStyle(color: Colors.grey[600])),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black87,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12)
              ),
              child: const Text("Go Back", style: TextStyle(color: Colors.white)),
            )
          ],
        ),
      ),
    );
  }
}