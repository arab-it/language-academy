import '../data/albanian_phrases.dart';
import '../data/translation_phrases.dart';
import '../data/vocabulary_data.dart';

class LocalTranslationService {
  static String _normalize(String value) {
    return value
        .trim()
        .toLowerCase()
        .replaceAll(RegExp(r'[?!.,;:]+$'), '')
        .replaceAll(RegExp(r'\s+'), ' ');
  }

  static String? translateWord({
    required String text,
    required String source,
    required String target,
  }) {
    final query = _normalize(text);

    if (query.isEmpty) return null;

    if (source == target) {
      return text.trim();
    }

    // ============================================================
    // ALBANIAN PHRASES
    // ============================================================

    for (final phrase in albanianPhrases) {
      final values = {
        'en': phrase.english,
        'it': phrase.italian,
        'ar': phrase.arabic,
        'sq': phrase.albanian,
      };

      final sourceValue = values[source];

      if (sourceValue != null &&
          sourceValue.isNotEmpty &&
          _normalize(sourceValue) == query) {
        final result = values[target];

        if (result != null && result.isNotEmpty) {
          return result;
        }
      }
    }

    // ============================================================
    // EXISTING TRANSLATION PHRASES
    // ============================================================

    for (final phrase in translationPhrases) {
      final values = {
        'en': phrase.english,
        'it': phrase.italian,
        'ar': phrase.arabic,
        'sq': phrase.albanian,
      };

      final sourceValue = values[source];

      if (sourceValue != null &&
          sourceValue.isNotEmpty &&
          _normalize(sourceValue) == query) {
        final result = values[target];

        if (result != null && result.isNotEmpty) {
          return result;
        }
      }
    }

    // ============================================================
    // VOCABULARY
    // ============================================================

    for (final word in vocabularyWords) {
      final values = {
        'en': word.english,
        'it': word.italian,
        'ar': word.arabic,
      };

      final sourceValue = values[source];

      if (sourceValue != null &&
          sourceValue.isNotEmpty &&
          _normalize(sourceValue) == query) {
        final result = values[target];

        if (result != null && result.isNotEmpty) {
          return result;
        }
      }
    }

    // ============================================================
    // PARTIAL SEARCH
    // ============================================================

    for (final phrase in albanianPhrases) {
      final values = {
        'en': phrase.english,
        'it': phrase.italian,
        'ar': phrase.arabic,
        'sq': phrase.albanian,
      };

      final sourceValue = values[source];

      if (sourceValue != null && sourceValue.isNotEmpty) {
        final normalizedSource = _normalize(sourceValue);

        if (normalizedSource.contains(query) ||
            query.contains(normalizedSource)) {
          final result = values[target];

          if (result != null && result.isNotEmpty) {
            return result;
          }
        }
      }
    }

    return null;
  }
}

