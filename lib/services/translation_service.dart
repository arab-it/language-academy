import 'dart:convert';

import 'package:http/http.dart' as http;

class TranslationService {
  static Future<String> translate({
    required String text,
    required String sourceLanguage,
    required String targetLanguage,
  }) async {
    final cleanText = text.trim();

    if (cleanText.isEmpty) {
      return '';
    }

    final source = _languageCode(sourceLanguage);
    final target = _languageCode(targetLanguage);

    if (source == target) {
      return cleanText;
    }

    // Temporary public endpoint for development.
    // We will replace this with the production backend later.
    final uri = Uri.parse(
      'https://api.mymemory.translated.net/get'
      '?q=${Uri.encodeQueryComponent(cleanText)}'
      '&langpair=$source|$target',
    );

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Translation service unavailable.');
    }

    final data = jsonDecode(response.body);

    final responseData = data['responseData'];

    if (responseData is Map && responseData['translatedText'] != null) {
      return responseData['translatedText'].toString();
    }

    throw Exception('Translation result was not available.');
  }

  static String _languageCode(String language) {
    switch (language) {
      case 'English':
        return 'en';

      case 'Italiano':
        return 'it';

      case 'Ø§Ù„Ø¹Ø±Ø¨ÙŠØ©':
        return 'ar';

      default:
        return 'en';
    }
  }
}

