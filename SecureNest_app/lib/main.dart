import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    // MANUAL INITIALIZATION (Keeps your app working without build errors)
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyDo9_1nSQEoPwAGGsIUNia1Izqz0Gtt4bA", 
        appId: "1:1167588446:android:3354efafc3ffe3b39448cf", 
        messagingSenderId: "1167588446", 
        projectId: "nest-f0ad9", 
        storageBucket: "nest-f0ad9.firebasestorage.app", 
      ),
    );
    print("✅ Firebase Initialized Successfully!");
  } catch (e) {
    print("------------------------------------------------");
    print("❌ FIREBASE ERROR: $e");
    print("------------------------------------------------");
  }
  
  runApp(const SecureNestApp());
}

class SecureNestApp extends StatefulWidget {
  const SecureNestApp({super.key});

  @override
  State<SecureNestApp> createState() => _SecureNestAppState();
}

class _SecureNestAppState extends State<SecureNestApp> {
  bool isDarkMode = false;

  void toggleTheme() {
    setState(() {
      isDarkMode = !isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SecureNest',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: SplashScreen(toggleTheme: toggleTheme, isDarkMode: isDarkMode),
    );
  }
}

// --- UPDATED PROFESSIONAL SPLASH SCREEN ---
class SplashScreen extends StatefulWidget {
  final Function toggleTheme;
  final bool isDarkMode;
  const SplashScreen({super.key, required this.toggleTheme, required this.isDarkMode});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Wait 3 seconds, then go to Login
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => LoginScreen(
              toggleTheme: widget.toggleTheme, 
              isDarkMode: widget.isDarkMode
            ),
            transitionsBuilder: (_, animation, __, child) {
              return FadeTransition(opacity: animation, child: child);
            },
            transitionDuration: const Duration(milliseconds: 800),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Color(0xFFEFF6FF)], // Matches Login Screen Gradient
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // HERO LOGO ANIMATION
            Hero(
              tag: 'logo',
              child: Container(
                height: 180, 
                width: 180,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 30,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(20),
                child: Image.asset(
                  'assets/images/logo.png',
                  fit: BoxFit.contain,
                  errorBuilder: (c, e, s) => const Icon(Icons.security, size: 80, color: Colors.blueAccent),
                ),
              ),
            ),
            const SizedBox(height: 40),
            
            // Loading Indicator
            const CircularProgressIndicator(
              color: Color(0xFF2563EB), // Professional Blue
              strokeWidth: 3,
            ),
            const SizedBox(height: 20),
            
            // App Name
            const Text(
              "SecureNest",
              style: TextStyle(
                fontSize: 28, 
                fontWeight: FontWeight.w800, 
                color: Color(0xFF1E293B), // Dark Slate
                letterSpacing: 1.0,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              "Safe • Transparent • Reliable",
              style: TextStyle(
                color: Colors.grey[500],
                fontSize: 14,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}