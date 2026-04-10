import 'package:flutter/material.dart';
import '../services/translation_controller.dart';

class TrText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines; // ✅ Added to handle descriptions
  final TextOverflow? overflow; // ✅ Added to handle long text

  const TrText(
      this.text, {
        super.key,
        this.style,
        this.textAlign,
        this.maxLines, // ✅ Added to constructor
        this.overflow, // ✅ Added to constructor
      });

  @override
  Widget build(BuildContext context) {
    // If language is English or text is empty, return normal Text immediately
    if (TranslationController.currentLang == 'en' || text.isEmpty) {
      return Text(
        text,
        style: style,
        textAlign: textAlign,
        maxLines: maxLines,
        overflow: overflow,
      );
    }

    return FutureBuilder<String>(
      future: TranslationController.translate(text),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show original text slightly faded while loading translation
          return Text(
            text,
            style: style?.copyWith(color: style?.color?.withOpacity(0.5)),
            textAlign: textAlign,
            maxLines: maxLines,
            overflow: overflow,
          );
        }

        return Text(
          snapshot.data ?? text,
          style: style,
          textAlign: textAlign,
          maxLines: maxLines,
          overflow: overflow,
        );
      },
    );
  }
}