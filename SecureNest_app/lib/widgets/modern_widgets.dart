import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math';

class AppColors {
  static const Color primaryBlack = Color(0xFF111111);
  static const Color accentTeal = Color(0xFF26A69A);
  static const Color softGrey = Color(0xFFF5F5F5);
  static const Color textGrey = Color(0xFF888888);
}

// 1. REUSABLE SIDEBAR (FIXED: WHITE BACKGROUND)
class ModernDrawer extends StatelessWidget {
  final String? userName;
  final String? userEmail;
  final String? userPhoto;
  final VoidCallback onLogout;
  final Function(String) onNavigate;

  const ModernDrawer({
    super.key,
    required this.userName,
    required this.userEmail,
    required this.userPhoto,
    required this.onLogout,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white, // FORCED WHITE BACKGROUND
      surfaceTintColor: Colors.white, // REMOVES DARK TINT
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(color: AppColors.primaryBlack),
            accountName: Text(userName ?? "User", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.white)),
            accountEmail: Text(userEmail ?? "user@securenest.com", style: GoogleFonts.poppins(color: Colors.white70)),
            currentAccountPicture: CircleAvatar(
              backgroundImage: userPhoto != null ? NetworkImage(userPhoto!) : null,
              backgroundColor: AppColors.accentTeal,
              child: userPhoto == null ? const Icon(Icons.person, color: Colors.white) : null,
            ),
          ),
          _drawerItem(Icons.person_outline, "My Profile", () => onNavigate("Profile")),
          _drawerItem(Icons.history, "History", () => onNavigate("History")),
          _drawerItem(Icons.settings_outlined, "Settings", () => onNavigate("Settings")),
          _drawerItem(Icons.language, "Language", () => onNavigate("Language")),
          _drawerItem(Icons.verified_user_outlined, "Trust Score", () => onNavigate("Trust Score")),
          const Spacer(),
          const Divider(),
          _drawerItem(Icons.logout, "Logout", onLogout, isDestructive: true),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _drawerItem(IconData icon, String title, VoidCallback onTap, {bool isDestructive = false}) {
    return ListTile(
      leading: Icon(icon, color: isDestructive ? Colors.red : Colors.black87), // Dark Icon
      title: Text(title, style: GoogleFonts.poppins(color: isDestructive ? Colors.red : Colors.black87, fontWeight: FontWeight.w500)), // Dark Text
      onTap: onTap,
    );
  }
}

// 2. DUMMY GRAPH CARD (Landlord Stats)
class DummyGraphCard extends StatelessWidget {
  const DummyGraphCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 120,
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: AppColors.softGrey,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Occupancy Rate", style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey)),
            const Spacer(),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _bar(30), _bar(50), _bar(80, isActive: true), _bar(40),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _bar(double heightPct, {bool isActive = false}) {
    return Container(
      width: 12,
      height: 50 * (heightPct / 100),
      decoration: BoxDecoration(
        color: isActive ? AppColors.accentTeal : Colors.grey.shade300,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

// 3. INTERACTIVE MASCOT
class InteractiveMascot extends StatefulWidget {
  final Color color;
  final Offset position;
  final double size;
  const InteractiveMascot({super.key, required this.color, required this.position, required this.size});
  @override
  InteractiveMascotState createState() => InteractiveMascotState();
}

class InteractiveMascotState extends State<InteractiveMascot> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  Offset _eyeOffset = Offset.zero;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: Duration(milliseconds: 1000 + Random().nextInt(500)))..repeat(reverse: true);
  }
  void updateEyes(Offset touchPosition) {
    if (!mounted) return;
    final RenderBox? box = context.findRenderObject() as RenderBox?;
    if (box == null) return;
    final Offset localCenter = box.localToGlobal(Offset(widget.size / 2, widget.size / 2));
    double dx = touchPosition.dx - localCenter.dx;
    double dy = touchPosition.dy - localCenter.dy;
    double angle = atan2(dy, dx);
    double distance = min(4.0, sqrt(dx*dx + dy*dy));
    setState(() => _eyeOffset = Offset(cos(angle) * distance, sin(angle) * distance));
  }
  @override
  void dispose() { _controller.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: widget.position.dx, top: widget.position.dy,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (c, child) => Transform.translate(offset: Offset(0, -10 * _controller.value), child: child),
        child: Container(
          width: widget.size, height: widget.size,
          decoration: BoxDecoration(color: widget.color, borderRadius: BorderRadius.circular(widget.size/2.5), boxShadow: [BoxShadow(color: widget.color.withOpacity(0.4), blurRadius: 10, offset: const Offset(0,5))]),
          child: Stack(children: [Positioned(left: widget.size*0.25, top: widget.size*0.3, child: _eye()), Positioned(right: widget.size*0.25, top: widget.size*0.3, child: _eye())]),
        ),
      ),
    );
  }
  Widget _eye() => Container(width: widget.size*0.25, height: widget.size*0.25, decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle), child: Center(child: Transform.translate(offset: _eyeOffset, child: Container(width: widget.size*0.1, height: widget.size*0.1, decoration: const BoxDecoration(color: Colors.black, shape: BoxShape.circle)))));
}

// 4. FLOATING NAVBAR
class FloatingNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  const FloatingNavBar({super.key, required this.currentIndex, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      height: 70,
      decoration: BoxDecoration(color: AppColors.primaryBlack, borderRadius: BorderRadius.circular(35), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10))]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          GestureDetector(
            onTap: () => onTap(0),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(color: currentIndex == 0 ? Colors.white.withOpacity(0.1) : Colors.transparent, borderRadius: BorderRadius.circular(20)),
              child: Row(children: [const Icon(Icons.explore, color: Colors.white, size: 20), if (currentIndex == 0) ...[const SizedBox(width: 8), Text("Explore", style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600))]]),
            ),
          ),
          _icon(Icons.map_outlined, 1),
          _icon(Icons.chat_bubble_outline, 2),
          _icon(Icons.bookmark_border, 3),
        ],
      ),
    );
  }
  Widget _icon(IconData i, int idx) => IconButton(icon: Icon(i, color: currentIndex == idx ? AppColors.accentTeal : Colors.white54), onPressed: () => onTap(idx));
}

// 5. MODERN PROPERTY CARD
class ModernPropertyCard extends StatelessWidget {
  final String title, location, price, imagePath;
  final VoidCallback onTap;
  const ModernPropertyCard({super.key, required this.title, required this.location, required this.price, required this.imagePath, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 380, margin: const EdgeInsets.only(bottom: 25),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), image: DecorationImage(image: AssetImage(imagePath), fit: BoxFit.cover, onError: (e, s) => const AssetImage('assets/images/logo.png')), boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 20, offset: const Offset(0, 10))]),
        child: Stack(children: [Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.transparent, Colors.black.withOpacity(0.1), AppColors.accentTeal.withOpacity(0.9)], stops: const [0.4, 0.7, 1.0]))), Padding(padding: const EdgeInsets.all(25.0), child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.end, children: [Text(title, style: GoogleFonts.poppins(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white)), const SizedBox(height: 5), Row(children: [const Icon(Icons.location_on, color: Colors.white70, size: 16), const SizedBox(width: 5), Text(location, style: GoogleFonts.poppins(color: Colors.white70, fontSize: 14))]), const SizedBox(height: 15), Text("$price / Month", style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white)), const SizedBox(height: 20), Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Container(padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)), child: Text("Take a look", style: GoogleFonts.poppins(color: AppColors.primaryBlack, fontWeight: FontWeight.bold))), Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: Colors.black.withOpacity(0.2), shape: BoxShape.circle, border: Border.all(color: Colors.white30)), child: const Icon(Icons.bookmark_border, color: Colors.white, size: 20))])]))]),
      ),
    );
  }
}