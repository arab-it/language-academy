import 'dart:convert';

import 'package:http/http.dart' as http;

import 'local_translation_service.dart';

class TranslationResult {
  final String translatedText;
  final String? detectedLanguage;
  final double? confidence;

  const TranslationResult({
    required this.translatedText,
    this.detectedLanguage,
    this.confidence,
  });
}

class HybridTranslationService {
  static const String _server = 'http://127.0.0.1:5000';

  static Future<TranslationResult?> translate({
    required String text,
    required String target,
    String? source,
  }) async {
    final input = text.trim();

    if (input.isEmpty) {
      return null;
    }

    try {
      final response = await http
          .post(
            Uri.parse('$_server/translate'),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode({
              'q': input,
              'source': source ?? 'auto',
              'target': target,
              'format': 'text',
            }),
          )
          .timeout(const Duration(seconds: 20));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;

        final translated = data['translatedText']?.toString();

        if (translated != null && translated.trim().isNotEmpty) {
          String? detectedCode;
          double? confidence;

          final detected = data['detectedLanguage'];

          if (detected is Map) {
            detectedCode = detected['language']?.toString();

            final rawConfidence = detected['confidence'];

            if (rawConfidence is num) {
              confidence = rawConfidence.toDouble();
            }
          }

          return TranslationResult(
            translatedText: translated,
            detectedLanguage: detectedCode,
            confidence: confidence,
          );
        }
      }

      if (source != null && source != 'auto') {
        final local = LocalTranslationService.translateWord(
          text: input,
          source: source,
          target: target,
        );

        if (local != null) {
          return TranslationResult(
            translatedText: local,
            detectedLanguage: source,
          );
        }
      }

      return null;
    } catch (_) {
      if (source != null && source != 'auto') {
        final local = LocalTranslationService.translateWord(
          text: input,
          source: source,
          target: target,
        );

        if (local != null) {
          return TranslationResult(
            translatedText: local,
            detectedLanguage: source,
          );
        }
      }

      return null;
    }
  }
}

