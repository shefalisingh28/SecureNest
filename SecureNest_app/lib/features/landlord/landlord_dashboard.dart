import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart'; 
import 'package:http/http.dart' as http; 
import 'dart:convert';                   

import '../../widgets/modern_widgets.dart';
import '../common/app_screens.dart'; 
import '../common/trust_score_page.dart';

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

  late GoogleMapController _mapController;
  final LatLng _center = const LatLng(28.6139, 77.2090);
  LatLng? _selectedLocation;
  final Set<Marker> _markers = {};

  void _onMapTapped(LatLng location) {
    setState(() {
      _selectedLocation = location; _markers.clear();
      _markers.add(Marker(markerId: const MarkerId("selected_property"), position: location, icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet)));
    });
  }

  void _openChatModal() { showModalBottomSheet(context: context, isScrollControlled: true, backgroundColor: Colors.transparent, builder: (context) => const LandlordAIChatModal()); }

  void _openPage(String title) {
    Widget screen;
    switch(title) {
      case "My Profile": screen = const ProfileScreen(); break;
      case "KYC Verification": screen = const KYCScreen(); break;
      case "History": screen = const HistoryScreen(); break;
      case "Settings": screen = const SettingsScreen(); break;
      case "Language": screen = const LanguageScreen(); break;
      case "Trust Score": screen = const TrustScorePage(isLandlord: true); break;
      case "Notifications": screen = const NotificationsScreen(isLandlord: true); break;
      case "Saved": screen = const PropertiesListScreen(title: "Saved Prospects"); break;
      case "Analytics": screen = const AnalyticsDummyScreen(title: "Property Analytics"); break;
      case "Check Rent": screen = const PaymentScreen(title: "Check Rent Status", isLandlord: true); break;
      case "Check Electricity": screen = const PaymentScreen(title: "Electricity Status", isLandlord: true); break;
      case "Check Water": screen = const PaymentScreen(title: "Water Status", isLandlord: true); break;
      case "Occupancy Rate": screen = const AnalyticsDummyScreen(title: "Occupancy Metrics"); break;
      case "My Properties": screen = const PropertiesListScreen(title: "My Listings"); break;
      case "Complain Damage": screen = const ReportIssueScreen(title: "Report Property Damage"); break;
      default: screen = const ProfileScreen(); 
    }
    Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
  }

  @override
  Widget build(BuildContext context) {
    Color bg = widget.isDarkMode ? Colors.grey.shade900 : Colors.white;
    Color textCol = widget.isDarkMode ? Colors.white : Colors.black;

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg, elevation: 0, toolbarHeight: 70,
        iconTheme: IconThemeData(color: textCol), titleSpacing: 0, 
        title: Row(
          children: [
            Image.asset('assets/images/logo.png', height: 40, fit: BoxFit.contain, errorBuilder: (c, e, s) => const Icon(Icons.security, color: Colors.teal)),
            const SizedBox(width: 8),
            Text("SecureNest", style: GoogleFonts.poppins(color: Colors.teal, fontSize: 22, fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          IconButton(icon: Icon(Icons.search, color: textCol), onPressed: () => showSearch(context: context, delegate: DummySearchDelegate())),
          IconButton(icon: Icon(Icons.notifications_none, color: textCol), onPressed: () => _openPage("Notifications")),
        ],
      ),
      drawer: SecureNestDrawer( 
        userName: user?.displayName, userEmail: user?.email,
        isLandlord: true, isDarkMode: widget.isDarkMode,
        toggleTheme: () => widget.toggleTheme(),
        onLogout: () async { await FirebaseAuth.instance.signOut(); if (mounted) Navigator.pushReplacementNamed(context, '/'); },
        onNavigate: (page) { Navigator.pop(context); _openPage(page); },
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          IndexedStack(index: _navIndex == 1 ? 1 : 0, children: [ _buildHomeView(textCol), _buildMapView() ]),
          FloatingNavBar(currentIndex: _navIndex, onTap: (i) {
            if (i == 2) { _openChatModal(); } else if (i == 3) { _openPage("Saved"); } else { setState(() => _navIndex = i); }
          }),
        ],
      ),
    );
  }

  Widget _buildHomeView(Color textCol) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Manage", style: GoogleFonts.poppins(fontSize: 32, fontWeight: FontWeight.bold, color: textCol)),
            Text("Properties", style: GoogleFonts.poppins(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.grey)),
            const SizedBox(height: 30),
            Row(children: [_statBox("Income", "₹85k", Colors.black, Colors.white), const SizedBox(width: 15), const DummyGraphCard()]),
            const SizedBox(height: 30),
            Text("My Listings", style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: textCol)),
            const SizedBox(height: 15),
            ModernPropertyCard(title: "Sunny Apt", location: "New Delhi", price: "₹15,000", imagePath: "assets/images/house1.png", onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PropertyDetailScreen(title: "Sunny Apt", price: "₹15,000", location: "New Delhi", imagePath: "assets/images/house1.png")))),
            ModernPropertyCard(title: "Green Villa", location: "Noida", price: "₹25,000", imagePath: "assets/images/house2.png", onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PropertyDetailScreen(title: "Green Villa", price: "₹25,000", location: "Noida", imagePath: "assets/images/house2.png")))),
          ],
        ),
      ),
    );
  }

  Widget _buildMapView() => Stack(children: [ GoogleMap(onMapCreated: (c) => _mapController = c, initialCameraPosition: CameraPosition(target: _center, zoom: 13.0), markers: _markers, onTap: _onMapTapped, myLocationEnabled: true, padding: const EdgeInsets.only(bottom: 90)), if (_selectedLocation != null) Positioned(bottom: 110, left: 20, right: 20, child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.black, padding: const EdgeInsets.symmetric(vertical: 15), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))), onPressed: () { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Location Saved"))); setState(() => _navIndex = 0); }, child: const Text("Confirm Location", style: TextStyle(color: Colors.white))))]);
  Widget _statBox(String label, String value, Color bg, Color text) => Expanded(child: GestureDetector(onTap: () => _openPage("Analytics"), child: Container(height: 120, padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(24)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [Text(value, style: GoogleFonts.poppins(fontSize: 28, fontWeight: FontWeight.bold, color: text)), Text(label, style: GoogleFonts.poppins(fontSize: 14, color: text.withOpacity(0.7)))]))));
}

// --- LANDLORD CHAT MODAL ---
class LandlordAIChatModal extends StatefulWidget {
  const LandlordAIChatModal({super.key});

  @override
  State<LandlordAIChatModal> createState() => _LandlordAIChatModalState();
}

class _LandlordAIChatModalState extends State<LandlordAIChatModal> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];
  bool _isLoading = false;

  Future<void> _sendMessage() async {
    if (_controller.text.trim().isEmpty) return;
    String userMsg = _controller.text;
    setState(() { _messages.add({"role": "user", "content": userMsg}); _isLoading = true; });
    _controller.clear();
    try {
      final response = await http.post(Uri.parse('http://10.0.2.2:8000/ask'), headers: {"Content-Type": "application/json"}, body: jsonEncode({"question": userMsg}));
      if (response.statusCode == 200) { final data = jsonDecode(response.body); setState(() => _messages.add({"role": "ai", "content": data['answer']})); } 
      else { setState(() => _messages.add({"role": "ai", "content": "Server error"})); }
    } catch (e) { setState(() => _messages.add({"role": "ai", "content": "Connection failed"})); } finally { setState(() => _isLoading = false); }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8, decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(30))), padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 20, right: 20, top: 10),
      child: Column(
        children: [
          Container(width: 40, height: 4, margin: const EdgeInsets.only(bottom: 20), decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10))), Text("SecureNest Landlord AI", style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold)), const Divider(),
          Expanded(child: ListView.builder(itemCount: _messages.length, itemBuilder: (context, index) {
                bool isUser = _messages[index]["role"] == "user";
                return Align(alignment: isUser ? Alignment.centerRight : Alignment.centerLeft, child: Container(margin: const EdgeInsets.symmetric(vertical: 5), padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: isUser ? Colors.black : Colors.grey[100], borderRadius: BorderRadius.circular(15)), child: Text(_messages[index]["content"]!, style: GoogleFonts.poppins(color: isUser ? Colors.white : Colors.black87))));
          })),
          if (_isLoading) const Padding(padding: EdgeInsets.all(8.0), child: LinearProgressIndicator(color: Colors.black)),
          Padding(padding: const EdgeInsets.symmetric(vertical: 15), child: TextField(controller: _controller, decoration: InputDecoration(hintText: "Type a message...", suffixIcon: IconButton(icon: const Icon(Icons.send, color: Colors.black), onPressed: _sendMessage), border: OutlineInputBorder(borderRadius: BorderRadius.circular(30))), onSubmitted: (_) => _sendMessage())),
        ],
      ),
    );
  }
}
