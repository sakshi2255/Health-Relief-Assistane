import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_projectt/screens/splash_screen.dart';
import 'services/notification_service.dart';
import 'services/translation_controller.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ FIXED: Load .env before anything else to prevent NotInitializedError
  try {
    await dotenv.load(fileName: ".env");
    debugPrint("✅ .env file loaded successfully");
  } catch (e) {
    debugPrint("❌ Failed to load .env file: $e");
  }

  // 1. Initialize Firebase
  if (Firebase.apps.isEmpty) {
    if (kIsWeb) {
      await Firebase.initializeApp(
        options: const FirebaseOptions(
          apiKey: "AIzaSyAQMtmWRQvvOm876vZOm40OZ3IEYflAQ_s",
          authDomain: "health-relief-assistant.firebaseapp.com",
          projectId: "health-relief-assistant",
          storageBucket: "health-relief-assistant.firebasestorage.app",
          messagingSenderId: "834023988020",
          appId: "1:834023988020:web:ede074bb27ac6372912361",
          measurementId: "G-25WPD7GxZFP",
        ),
      );
    } else {
      await Firebase.initializeApp();
    }
  }

  // 2. ALWAYS initialize notifications on Mobile
  if (!kIsWeb) {
    await NotificationService.init();
  }
  await TranslationController.initializeLanguage();
  runApp(const HealthReliefApp());
}

class HealthReliefApp extends StatelessWidget {
  const HealthReliefApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Health Relief Assistant',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF4DB6AC),
        // Clean global font theme matching your React style
        textTheme: GoogleFonts.poppinsTextTheme(
          Theme.of(context).textTheme,
        ),
        useMaterial3: true,
      ),
      // ✅ FIX: Force the app to start at SplashScreen.
      // The Login/Home check now happens inside splash_screen.dart
      // after the animation is done.
      home: const SplashScreen(),
    );
  }
}