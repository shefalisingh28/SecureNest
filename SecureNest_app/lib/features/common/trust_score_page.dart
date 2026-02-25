import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../widgets/modern_widgets.dart';

class TrustScorePage extends StatelessWidget {
  final bool isLandlord;
  const TrustScorePage({super.key, required this.isLandlord});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Trust Score", style: GoogleFonts.poppins(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // 1. SCORE GAUGE
            Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    height: 200, width: 200,
                    child: CircularProgressIndicator(
                      value: 0.85, 
                      strokeWidth: 15,
                      backgroundColor: AppColors.softGrey,
                      valueColor: const AlwaysStoppedAnimation<Color>(AppColors.accentTeal),
                      strokeCap: StrokeCap.round,
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("850", style: GoogleFonts.poppins(fontSize: 48, fontWeight: FontWeight.bold, color: AppColors.primaryBlack)),
                      Text("Excellent", style: GoogleFonts.poppins(fontSize: 18, color: AppColors.accentTeal, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),

            // 2. HISTORY GRAPH
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: AppColors.softGrey, borderRadius: BorderRadius.circular(20)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Score History (6 Months)", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _bar(40, "Jan"), _bar(55, "Feb"), _bar(60, "Mar"), 
                      _bar(75, "Apr"), _bar(80, "May"), _bar(85, "Jun", isActive: true),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // 3. SCORE FACTORS
            Align(alignment: Alignment.centerLeft, child: Text("Score Factors", style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold))),
            const SizedBox(height: 15),
            
            _factorTile("Payment History", "100% On Time Payments", Icons.calendar_today, Colors.green),
            _factorTile("Identity Verified", "Aadhaar & PAN Linked", Icons.verified_user, Colors.blue),
            _factorTile("Community Reviews", "4.8/5.0 Average Rating", Icons.star, Colors.orange),
            
            if (isLandlord) 
              _factorTile("Property Upkeep", "Verified Maintenance Records", Icons.home_work, Colors.purple)
            else
              _factorTile("Rental Duration", "2 Years Average Stay", Icons.access_time, Colors.teal),
          ],
        ),
      ),
    );
  }

  Widget _bar(double height, String label, {bool isActive = false}) {
    return Column(
      children: [
        Container(height: height, width: 12, decoration: BoxDecoration(color: isActive ? AppColors.accentTeal : Colors.grey.shade400, borderRadius: BorderRadius.circular(4))),
        const SizedBox(height: 8),
        Text(label, style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey)),
      ],
    );
  }

  Widget _factorTile(String title, String subtitle, IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey.shade200), boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5))]),
      child: Row(
        children: [
          Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle), child: Icon(icon, color: color, size: 24)),
          const SizedBox(width: 15),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: GoogleFonts.poppins(fontWeight: FontWeight.bold)), Text(subtitle, style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey))])),
          Icon(Icons.check_circle, color: color, size: 20),
        ],
      ),
    );
  }
}