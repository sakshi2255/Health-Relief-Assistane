import 'package:flutter/material.dart';
import 'package:flutter_projectt/services/translation_service.dart';

class TranslateText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final String targetLang; // Fetch this from your Firestore user doc

  const TranslateText(this.text, {super.key, this.style, required this.targetLang});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: TranslationService.translateText(text, targetLang),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Text(snapshot.data!, style: style);
        }
        // Show original English while translating
        return Text(text, style: style);
      },
    );
  }
}