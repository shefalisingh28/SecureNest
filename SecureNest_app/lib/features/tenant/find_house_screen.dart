import 'package:flutter/material.dart';
import '../../widgets/glossy_card.dart';

class FindHouseScreen extends StatelessWidget {
  const FindHouseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Find New House")),
      body: Column(
        children: [
          // Filter Chips
          SizedBox(
            height: 60,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: const [
                Chip(label: Text("Location"), avatar: Icon(Icons.map)),
                SizedBox(width: 10),
                Chip(label: Text("Price Range"), avatar: Icon(Icons.attach_money)),
                SizedBox(width: 10),
                Chip(label: Text("Furnished"), avatar: Icon(Icons.chair)),
              ],
            ),
          ),
          // Listings List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: 5,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: GlossyCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 150,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: const Center(child: Icon(Icons.image, size: 50, color: Colors.grey)),
                        ),
                        const SizedBox(height: 10),
                        Text("Luxury Apartment ${index + 1}", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        const Text("Connaught Place, New Delhi", style: TextStyle(color: Colors.grey)),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("₹22,000 / month", style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold)),
                            ElevatedButton(onPressed: () {}, child: const Text("View Details")),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}