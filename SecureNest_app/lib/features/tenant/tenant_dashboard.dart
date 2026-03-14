import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart'; 
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async'; // ADDED FOR THE CAROUSEL TIMER

import '../../widgets/modern_widgets.dart';
import '../common/app_screens.dart'; 
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

  late GoogleMapController _mapController;
  final LatLng _center = const LatLng(28.6139, 77.2090); 
  final Set<Marker> _markers = {};

  // --- CAROUSEL STATE VARIABLES ---
  late PageController _pageController;
  Timer? _carouselTimer;
  int _currentCarouselPage = 0;

  final List<Map<String, String>> _featuredProperties = [
    {"img": "assets/images/house1.png", "title": "Opulence Apt", "price": "₹45,000/mo"},
    {"img": "assets/images/house2.png", "title": "Twisted Beauty", "price": "₹25,000/mo"},
    {"img": "assets/images/house3.png", "title": "Bananza Palace", "price": "₹85,000/mo"},
    {"img": "assets/images/house1.png", "title": "Sunny Villa", "price": "₹15,000/mo"},
  ];

  @override
  void initState() {
    super.initState();
    // Setup Map Markers
    _markers.add(_createRentalMarker("prop1", 28.6150, 77.2100, "3BHK Luxury", "₹45,000/mo", BitmapDescriptor.hueBlue));
    _markers.add(_createRentalMarker("prop2", 28.6120, 77.2050, "2BHK Cozy", "₹25,000/mo", BitmapDescriptor.hueGreen));
    _markers.add(_createRentalMarker("prop3", 28.6180, 77.2150, "1BHK Studio", "₹15,000/mo", BitmapDescriptor.hueOrange));
    
    // Setup Carousel Controller & Timer
    _pageController = PageController(viewportFraction: 0.85, initialPage: 0);
    _startCarousel();
  }

  void _startCarousel() {
    _carouselTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (_pageController.hasClients) {
        _currentCarouselPage++;
        if (_currentCarouselPage >= _featuredProperties.length) {
          _currentCarouselPage = 0;
          _pageController.animateToPage(
            0, 
            duration: const Duration(milliseconds: 600), 
            curve: Curves.easeInOut,
          );
        } else {
          _pageController.animateToPage(
            _currentCarouselPage, 
            duration: const Duration(milliseconds: 400), 
            curve: Curves.easeIn,
          );
        }
      }
    });
  }

  @override
  void dispose() {
    _carouselTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  Marker _createRentalMarker(String id, double lat, double lng, String title, String price, double colorHue) {
    return Marker(markerId: MarkerId(id), position: LatLng(lat, lng), icon: BitmapDescriptor.defaultMarkerWithHue(colorHue), infoWindow: InfoWindow(title: title, snippet: price));
  }

  void _openChatModal() { showModalBottomSheet(context: context, isScrollControlled: true, backgroundColor: Colors.transparent, builder: (context) => const ChatAssistantModal()); }

  void _openPage(String title) {
    Widget screen;
    switch(title) {
      case "My Profile": screen = const ProfileScreen(); break;
      case "KYC Verification": screen = const KYCScreen(); break;
      case "History": screen = const HistoryScreen(); break;
      case "Settings": screen = const SettingsScreen(); break;
      case "Language": screen = const LanguageScreen(); break;
      case "Trust Score": screen = const TrustScorePage(isLandlord: false); break;
      case "Notifications": screen = const NotificationsScreen(isLandlord: false); break;
      case "Bookmarks": screen = const PropertiesListScreen(title: "Saved Properties"); break;
      case "Pay Rent": screen = const PaymentScreen(title: "Pay Rent", isLandlord: false); break;
      case "Pay Electricity": screen = const PaymentScreen(title: "Pay Electricity Bill", isLandlord: false); break;
      case "Pay Water": screen = const PaymentScreen(title: "Pay Water Bill", isLandlord: false); break;
      case "Report Issue": screen = const ReportIssueScreen(title: "Report an Issue"); break;
      case "Rate House": screen = const RateHouseScreen(); break;
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
        isLandlord: false, isDarkMode: widget.isDarkMode,
        toggleTheme: () => widget.toggleTheme(),
        onLogout: () async { await FirebaseAuth.instance.signOut(); if (mounted) Navigator.pushReplacementNamed(context, '/'); },
        onNavigate: (page) { Navigator.pop(context); _openPage(page); },
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          IndexedStack(index: _navIndex == 1 ? 1 : 0, children: [ _buildHomeView(textCol), _buildMapView() ]),
          FloatingNavBar(currentIndex: _navIndex, onTap: (i) {
              if (i == 2) { _openChatModal(); } else if (i == 3) { _openPage("Bookmarks"); } else { setState(() => _navIndex = i); }
          }),
        ],
      ),
    );
  }

  Widget _buildHomeView(Color textCol) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 10, 24, 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Find", style: GoogleFonts.poppins(fontSize: 32, fontWeight: FontWeight.bold, height: 1.1, color: textCol)),
            Text("The Perfect Place", style: GoogleFonts.poppins(fontSize: 32, fontWeight: FontWeight.bold, height: 1.1, color: AppColors.accentTeal)),
            const SizedBox(height: 20),
            
            Text("Featured Picks", style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: textCol)),
            const SizedBox(height: 10),
            
            // --- AUTOMATIC SLIDING CAROUSEL ---
            SizedBox(
              height: 200,
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (int page) => _currentCarouselPage = page,
                itemCount: _featuredProperties.length,
                itemBuilder: (context, index) {
                  final prop = _featuredProperties[index];
                  return _carouselCard(prop["img"]!, prop["title"]!, prop["price"]!);
                },
              ),
            ),
            const SizedBox(height: 20),

            Row(children: [_tab("Recommend", 0, textCol), const SizedBox(width: 25), _tab("New", 1, textCol), const SizedBox(width: 25), _tab("Nearby", 2, textCol)]),
            const SizedBox(height: 20),
            
            ModernPropertyCard(title: "Opulence Apt", location: "Celina, Delaware", price: "\$5,590", imagePath: "assets/images/house1.png", onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PropertyDetailScreen(title: "Opulence Apt", price: "\$5,590", location: "Celina, Delaware", imagePath: "assets/images/house1.png")))),
            ModernPropertyCard(title: "Twisted Beauty", location: "Westheimer, CS", price: "\$2,590", imagePath: "assets/images/house2.png", onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PropertyDetailScreen(title: "Twisted Beauty", price: "\$2,590", location: "Westheimer, CS", imagePath: "assets/images/house2.png")))),
          ],
        ),
      ),
    );
  }

  Widget _carouselCard(String img, String title, String price) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => PropertyDetailScreen(title: title, price: price, location: "Verified Location", imagePath: img))),
      child: Container(
        margin: const EdgeInsets.only(right: 15), // Spacing between slides
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20), 
          image: DecorationImage(image: AssetImage(img), fit: BoxFit.cover)
        ),
        child: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), gradient: const LinearGradient(begin: Alignment.bottomCenter, end: Alignment.topCenter, colors: [Colors.black87, Colors.transparent])),
          padding: const EdgeInsets.all(15), alignment: Alignment.bottomLeft,
          child: Column(
            mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
              Text(price, style: const TextStyle(color: Colors.tealAccent, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMapView() => GoogleMap(onMapCreated: (c) => _mapController = c, initialCameraPosition: CameraPosition(target: _center, zoom: 14.0), markers: _markers, myLocationEnabled: true, zoomControlsEnabled: false, padding: const EdgeInsets.only(bottom: 90));
  Widget _tab(String t, int i, Color textCol) => GestureDetector(onTap: () => setState(() => _tabIndex = i), child: Column(children: [Text(t, style: GoogleFonts.poppins(fontSize: 16, color: textCol, fontWeight: _tabIndex == i ? FontWeight.bold : FontWeight.w500)), if (_tabIndex == i) Container(margin: const EdgeInsets.only(top: 5), height: 5, width: 5, decoration: const BoxDecoration(color: AppColors.accentTeal, shape: BoxShape.circle))]));
}

// --- SECURENEST AI CHATBOT WIDGET ---
class ChatAssistantModal extends StatefulWidget {
  const ChatAssistantModal({super.key});

  @override
  State<ChatAssistantModal> createState() => _ChatAssistantModalState();
}

class _ChatAssistantModalState extends State<ChatAssistantModal> {
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
      else { setState(() => _messages.add({"role": "ai", "content": "Server Error"})); }
    } catch (e) { setState(() => _messages.add({"role": "ai", "content": "Connection Error."})); } finally { setState(() => _isLoading = false); }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75, decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(25))), padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 20, right: 20, top: 10),
      child: Column(
        children: [
          Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10))), const SizedBox(height: 15),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [const Icon(Icons.security, color: AppColors.accentTeal), const SizedBox(width: 8), Text("SecureNest AI", style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold))]), const Divider(),
          Expanded(child: ListView.builder(itemCount: _messages.length, itemBuilder: (context, index) {
                bool isUser = _messages[index]["role"] == "user";
                return Align(alignment: isUser ? Alignment.centerRight : Alignment.centerLeft, child: Container(margin: const EdgeInsets.symmetric(vertical: 5), padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: isUser ? AppColors.accentTeal : Colors.grey[100], borderRadius: BorderRadius.circular(15)), child: Text(_messages[index]["content"]!, style: GoogleFonts.poppins(color: isUser ? Colors.white : Colors.black87))));
          })),
          if (_isLoading) const Padding(padding: EdgeInsets.all(8.0), child: LinearProgressIndicator(color: AppColors.accentTeal)),
          Padding(padding: const EdgeInsets.symmetric(vertical: 10), child: TextField(controller: _controller, style: GoogleFonts.poppins(), decoration: InputDecoration(hintText: "Ask about rental rules...", suffixIcon: IconButton(icon: const Icon(Icons.send, color: AppColors.accentTeal), onPressed: _sendMessage), border: OutlineInputBorder(borderRadius: BorderRadius.circular(30))), onSubmitted: (_) => _sendMessage())),
        ],
      ),
    );
  }
}
