import 'package:google_mlkit_translation/google_mlkit_translation.dart';

class TranslateService {
  static final TranslateService instance = TranslateService._internal();

  TranslateService._internal();

  final Map<String, OnDeviceTranslator> _translators = {};

  String _languageCode(String language) {
    switch (language.toLowerCase()) {
      case 'english':
        return 'en';
      case 'italian':
      case 'italiano':
        return 'it';
      case 'arabic':
      case 'العربية':
        return 'ar';
      default:
        return 'en';
    }
  }

  Future<String> translate({
    required String text,
    required String from,
    required String to,
  }) async {
    if (text.trim().isEmpty) return '';

    final sourceCode = _languageCode(from);
    final targetCode = _languageCode(to);

    if (sourceCode == targetCode) {
      return text;
    }

    final sourceLanguage = TranslateLanguage.values.firstWhere(
      (language) => language.bcpCode == sourceCode,
    );

    final targetLanguage = TranslateLanguage.values.firstWhere(
      (language) => language.bcpCode == targetCode,
    );

    final key = '${sourceCode}_$targetCode';

    final translator = _translators.putIfAbsent(
      key,
      () => OnDeviceTranslator(
        sourceLanguage: sourceLanguage,
        targetLanguage: targetLanguage,
      ),
    );

    return translator.translateText(text);
  }

  Future<void> close() async {
    for (final translator in _translators.values) {
      await translator.close();
    }

    _translators.clear();
  }
}

