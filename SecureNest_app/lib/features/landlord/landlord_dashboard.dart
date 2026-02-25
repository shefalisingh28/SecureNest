import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../widgets/modern_widgets.dart';
import '../common/dummy_pages.dart';
import '../common/trust_score_page.dart';
import 'add_property_screen.dart';

class LandlordDashboard extends StatefulWidget {
  final Function toggleTheme;
  final bool isDarkMode;
  const LandlordDashboard({super.key, required this.toggleTheme, required this.isDarkMode});

  @override
  State<LandlordDashboard> createState() => _LandlordDashboardState();
}

class _LandlordDashboardState extends State<LandlordDashboard> {
  int _navIndex = 0;
  final User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 90,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Image.asset('assets/images/logo.png', height: 80, fit: BoxFit.contain),
        centerTitle: true,
      ),
      drawer: ModernDrawer(
        userName: user?.displayName,
        userEmail: user?.email,
        userPhoto: user?.photoURL,
        onLogout: () async {
          await FirebaseAuth.instance.signOut();
          if (mounted) Navigator.pushReplacementNamed(context, '/');
        },
        onNavigate: (page) => _openPage(page),
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Manage", style: GoogleFonts.poppins(fontSize: 32, fontWeight: FontWeight.bold)),
                  Text("Properties", style: GoogleFonts.poppins(fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.textGrey)),
                  const SizedBox(height: 30),

                  Row(
                    children: [
                      _statBox("Income", "₹85k", Colors.black, Colors.white),
                      const SizedBox(width: 15),
                      const DummyGraphCard(),
                    ],
                  ),
                  const SizedBox(height: 30),

                  Text("My Listings", style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 15),

                  ModernPropertyCard(title: "Sunny Apt", location: "New Delhi", price: "₹15,000", imagePath: "assets/images/house1.png", onTap: () => _openPage("Sunny Apt Edit")),
                  ModernPropertyCard(title: "Green Villa", location: "Noida", price: "₹25,000", imagePath: "assets/images/house2.png", onTap: () => _openPage("Green Villa Edit")),
                ],
              ),
            ),
          ),
          FloatingNavBar(
            currentIndex: _navIndex, 
            onTap: (i) {
              setState(() => _navIndex = i);
              if (i == 1) _openPage("Analytics");
              if (i == 2) _openPage("Messages");
              if (i == 3) _openPage("Saved");
            }
          ),
        ],
      ),
    );
  }

  Widget _statBox(String label, String value, Color bg, Color text) {
    return Expanded(
      child: GestureDetector(
        onTap: () => _openPage("Financial Reports"),
        child: Container(
          height: 120,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(24), border: Border.all(color: Colors.grey.shade200)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(value, style: GoogleFonts.poppins(fontSize: 28, fontWeight: FontWeight.bold, color: text)),
              Text(label, style: GoogleFonts.poppins(fontSize: 14, color: text.withOpacity(0.7))),
            ],
          ),
        ),
      ),
    );
  }

  void _openPage(String title) {
    if (title.contains("Trust Score")) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => const TrustScorePage(isLandlord: true)));
    } else if (title.contains("Add")) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => const AddPropertyScreen()));
    } else {
      Navigator.push(context, MaterialPageRoute(builder: (_) => ContentPage(title: title, icon: Icons.analytics, color: AppColors.accentTeal, bodyText: "Data for $title")));
    }
  }
}