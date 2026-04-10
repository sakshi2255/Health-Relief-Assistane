import 'package:google_cloud_translation/google_cloud_translation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
class TranslationController {
  // ✅ Global state for the app's current language
  static String currentLang = 'en';

  // ✅ Your Google Cloud API Key
  static String get _apiKey => dotenv.env['GOOGLE_TRANSLATE_API_KEY'] ?? "";
  // ✅ Initialize the Translation instance
  static final Translation _translation = Translation(apiKey: _apiKey);

  /// 1. Initialize Language
  /// Call this in main() or right after Login/Signup success.
  static Future<void> initializeLanguage() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (doc.exists) {
          // Use 'lang' to match your AuthService and UserModel
          currentLang = doc.get('lang') ?? 'en';
          debugPrint("✅ Language set to: $currentLang");
        }
      } else {
        currentLang = 'en'; // Guest or Logged out
      }
    } catch (e) {
      debugPrint("❌ Init Error: $e");
      currentLang = 'en';
    }
  }
  /// 2. Translate Function
  /// Fixed the "Too many positional arguments" error by adding 'text:' label
  static Future<String> translate(String text) async {
    // If language is English or text is empty, don't waste API quota
    if (currentLang == 'en' || text.trim().isEmpty) return text;

    try {
      // ✅ FIX: Added the 'text:' named argument for the 0.0.4 package
      final res = await _translation.translate(
          text: text,
          to: currentLang
      );
      return res.translatedText;
    } catch (e) {
      debugPrint("Translation API Error: $e");
      return text; // Fallback to original English if API fails
    }
  }

  /// 3. Update Language (For Settings Page)
  /// Call this when the user manually switches language in Settings.
  static Future<void> updateLanguage(String newLangCode) async {
    currentLang = newLangCode;
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({'lang': newLangCode});
    }
  }
}