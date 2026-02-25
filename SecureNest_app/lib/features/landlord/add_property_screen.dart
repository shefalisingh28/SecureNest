import 'package:flutter/material.dart';

class AddPropertyScreen extends StatelessWidget {
  const AddPropertyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("List New Property")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              height: 150, width: double.infinity,
              color: Colors.grey[200],
              child: const Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.upload_file), Text("Upload Images")])),
            ),
            const SizedBox(height: 20),
            const TextField(decoration: InputDecoration(labelText: "Property Title", border: OutlineInputBorder())),
            const SizedBox(height: 15),
            const TextField(decoration: InputDecoration(labelText: "Location", border: OutlineInputBorder())),
            const SizedBox(height: 15),
            const TextField(decoration: InputDecoration(labelText: "Rent Amount (₹)", border: OutlineInputBorder()), keyboardType: TextInputType.number),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Property Listed Successfully!")));
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
              child: const Text("Submit Listing"),
            ),
          ],
        ),
      ),
    );
  }
}