import 'package:google_cloud_translation/google_cloud_translation.dart';
import 'package:flutter/foundation.dart'; // ✅ Added for debugPrint
import 'package:flutter_dotenv/flutter_dotenv.dart';
class TranslationService {
  static final String _apiKey = dotenv.env['GOOGLE_TRANSLATE_API_KEY'] ?? "";
  static late Translation _translation;

  static void init() {
    _translation = Translation(apiKey: _apiKey);
  }

  // ✅ This function translates ANY text you give it
  static Future<String> translateText(String text, String targetLanguage) async {
    if (targetLanguage == 'en' || text.isEmpty) return text;

    try {
      // ✅ FIX: Changed 'target:' to 'to:' to match package 0.0.4 requirements
      var response = await _translation.translate(
        text: text,
        to: targetLanguage,
      );
      return response.translatedText;
    } catch (e) {
      // ✅ FIX: Changed 'print' to 'debugPrint' to clear the production code warning
      debugPrint("Translation Error: $e");
      return text;
    }
  }
}