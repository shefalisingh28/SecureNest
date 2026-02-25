import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../widgets/modern_widgets.dart';
import '../common/dummy_pages.dart';
import '../common/trust_score_page.dart';

class TenantDashboard extends StatefulWidget {
  final Function toggleTheme;
  final bool isDarkMode;
  const TenantDashboard({super.key, required this.toggleTheme, required this.isDarkMode});

  @override
  State<TenantDashboard> createState() => _TenantDashboardState();
}

class _TenantDashboardState extends State<TenantDashboard> {
  int _tabIndex = 0;
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
        actions: [
          IconButton(icon: const Icon(Icons.notifications_none), onPressed: () => _openPage("Notifications")),
        ],
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
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  Text("Find", style: GoogleFonts.poppins(fontSize: 32, fontWeight: FontWeight.bold, height: 1.1)),
                  Text("The Perfect Place", style: GoogleFonts.poppins(fontSize: 32, fontWeight: FontWeight.bold, height: 1.1, color: AppColors.accentTeal)),
                  const SizedBox(height: 20),

                  Row(
                    children: [
                      _tab("Recommend", 0),
                      const SizedBox(width: 25),
                      _tab("New", 1),
                      const SizedBox(width: 25),
                      _tab("Nearby", 2),
                    ],
                  ),
                  const SizedBox(height: 20),

                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.only(bottom: 100),
                      children: [
                        ModernPropertyCard(title: "Opulence Apt", location: "Celina, Delaware", price: "\$5,590", imagePath: "assets/images/house1.png", onTap: () => _openPage("Opulence Apt")),
                        ModernPropertyCard(title: "Twisted Beauty", location: "Westheimer, CS", price: "\$2,590", imagePath: "assets/images/house2.png", onTap: () => _openPage("Twisted Beauty")),
                        ModernPropertyCard(title: "Bananza Palace", location: "Downtown", price: "\$4,490", imagePath: "assets/images/house3.png", onTap: () => _openPage("Bananza Palace")),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          FloatingNavBar(
            currentIndex: _navIndex, 
            onTap: (i) {
              setState(() => _navIndex = i);
              if (i == 1) _openPage("Map View");
              if (i == 2) _openPage("Chat");
              if (i == 3) _openPage("Bookmarks");
            }
          ),
        ],
      ),
    );
  }

  Widget _tab(String t, int i) {
    return GestureDetector(
      onTap: () => setState(() => _tabIndex = i),
      child: Column(children: [Text(t, style: GoogleFonts.poppins(fontSize: 16, fontWeight: _tabIndex == i ? FontWeight.bold : FontWeight.w500)), if (_tabIndex == i) Container(margin: const EdgeInsets.only(top: 5), height: 5, width: 5, decoration: const BoxDecoration(color: AppColors.accentTeal, shape: BoxShape.circle))]),
    );
  }

  void _openPage(String title) {
    if (title.contains("Trust Score")) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => const TrustScorePage(isLandlord: false)));
    } else {
      Navigator.push(context, MaterialPageRoute(builder: (_) => ContentPage(title: title, icon: Icons.info, color: AppColors.accentTeal, bodyText: "Details for $title")));
    }
  }
}