import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_screen.dart';
import 'main_shell.dart';
import '../widgets/tr_text.dart'; // ✅ Handles translations

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    // 1. Setup Spring Animation for the logo
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    );

    _controller.forward();

    // 2. Check login status and navigate
    _checkAuthAndNavigate();
  }

  void _checkAuthAndNavigate() async {
    // Show splash for 3 seconds for branding
    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) return;

    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainShell()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ✅ Responsive dimensions based on device screen
    final Size screenSize = MediaQuery.of(context).size;
    final double screenWidth = screenSize.width;
    final double screenHeight = screenSize.height;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF4DB6AC), Color(0xFF00796B)],
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Decorative background bubbles
            ..._buildBackgroundBubbles(screenWidth, screenHeight),

            // --- CENTER CONTENT (App Logo & Localized Title) ---
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ScaleTransition(
                  scale: _scaleAnimation,
                  child: Container(
                    padding: EdgeInsets.all(screenWidth * 0.02),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(screenWidth * 0.08),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        )
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(screenWidth * 0.07),
                      child: Image.asset(
                        "assets/logo.jpg", // ✅ Ensure this is in pubspec.yaml
                        width: screenWidth * 0.25,
                        height: screenWidth * 0.25,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.03),
                const TrText(
                  'Health Relief',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1.2,
                  ),
                ),
                SizedBox(height: screenHeight * 0.01),
                TrText(
                  'Your Personal Wellness Assistant',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.9),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),

            // --- BOTTOM CONTENT (Powered By Section) ---
            Positioned(
              bottom: screenHeight * 0.05,
              child: Column(
                children: [
                  const TrText(
                    "Powered by",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 1.0,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Small, Transparent-friendly container for University Logo
                  SizedBox(
                    width: screenWidth * 0.5, // ✅ Kept small (50% of width)
                    child: Image.asset(
                      "assets/mu-logo.png", // ✅ Ensure this is a PNG with transparent bg
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildBackgroundBubbles(double w, double h) {
    return [
      Positioned(top: h * 0.12, left: -w * 0.05, child: _bubble(w * 0.25)),
      Positioned(top: h * 0.30, right: w * 0.08, child: _bubble(w * 0.15)),
      Positioned(bottom: h * 0.18, left: w * 0.12, child: _bubble(w * 0.20)),
    ];
  }

  Widget _bubble(double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withOpacity(0.1),
      ),
    );
  }
}