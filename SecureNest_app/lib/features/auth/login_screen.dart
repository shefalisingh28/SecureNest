import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../widgets/modern_widgets.dart';
import '../tenant/tenant_dashboard.dart';
import '../landlord/landlord_dashboard.dart';

class LoginScreen extends StatefulWidget {
  final Function toggleTheme;
  final bool isDarkMode;
  const LoginScreen({super.key, required this.toggleTheme, required this.isDarkMode});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String selectedRole = 'Tenant';
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  
  final List<GlobalKey<InteractiveMascotState>> _mascotKeys = [
    GlobalKey<InteractiveMascotState>(),
    GlobalKey<InteractiveMascotState>(),
    GlobalKey<InteractiveMascotState>(),
  ];

  void _onHoverOrTouch(PointerEvent details) {
    for (var key in _mascotKeys) { key.currentState?.updateEyes(details.position); }
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: _onHoverOrTouch,
      onPointerMove: _onHoverOrTouch,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            // Mascots
            InteractiveMascot(key: _mascotKeys[0], color: const Color(0xFFFFD700), position: const Offset(40, 100), size: 60),
            InteractiveMascot(key: _mascotKeys[1], color: const Color(0xFFFF5252), position: const Offset(300, 150), size: 50),
            InteractiveMascot(key: _mascotKeys[2], color: AppColors.accentTeal, position: const Offset(30, 700), size: 70),

            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                    children: [
                      // HUGE LOGO (3x Size)
                      Container(
                        height: 220, width: 220,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.grey.shade100, width: 2)),
                        child: Image.asset('assets/images/logo.png', fit: BoxFit.contain),
                      ),
                      const SizedBox(height: 30),
                      Text("Welcome Back", style: GoogleFonts.poppins(fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.primaryBlack)),
                      const SizedBox(height: 30),

                      // Role Selector
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _roleChip("Tenant"),
                          const SizedBox(width: 15),
                          _roleChip("Landlord"),
                        ],
                      ),
                      const SizedBox(height: 30),

                      // Email Inputs
                      _inputField("Email", Icons.email_outlined, _emailController),
                      const SizedBox(height: 15),
                      _inputField("Password", Icons.lock_outline, _passController, isPass: true),
                      const SizedBox(height: 25),

                      // Login Buttons
                      SizedBox(
                        width: double.infinity, height: 55,
                        child: ElevatedButton(
                          onPressed: _handleEmailLogin,
                          style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryBlack, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                          child: Text("Login", style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold)),
                        ),
                      ),
                      const SizedBox(height: 15),
                      TextButton.icon(
                        onPressed: _handleGoogleLogin,
                        icon: const Icon(Icons.g_mobiledata, color: Colors.grey, size: 28),
                        label: Text("Sign in with Google", style: GoogleFonts.poppins(color: Colors.grey)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _inputField(String hint, IconData icon, TextEditingController c, {bool isPass = false}) {
    return TextField(
      controller: c, obscureText: isPass,
      decoration: InputDecoration(
        hintText: hint, prefixIcon: Icon(icon, color: Colors.grey),
        filled: true, fillColor: AppColors.softGrey,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
      ),
    );
  }

  Widget _roleChip(String role) {
    bool isSelected = selectedRole == role;
    return GestureDetector(
      onTap: () => setState(() => selectedRole = role),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(color: isSelected ? AppColors.accentTeal : AppColors.softGrey, borderRadius: BorderRadius.circular(30)),
        child: Text(role, style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: isSelected ? Colors.white : Colors.black54)),
      ),
    );
  }

  Future<void> _handleEmailLogin() async { _navigate(); }
  Future<void> _handleGoogleLogin() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return;
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
      await FirebaseAuth.instance.signInWithCredential(credential);
      _navigate();
    } catch (e) { ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e"))); }
  }

  void _navigate() {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => 
      selectedRole == 'Tenant' 
      ? TenantDashboard(toggleTheme: widget.toggleTheme, isDarkMode: widget.isDarkMode)
      : LandlordDashboard(toggleTheme: widget.toggleTheme, isDarkMode: widget.isDarkMode)
    ));
  }
}