import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/translation_history_item.dart';

class TranslationHistoryService {
  static const String _key = 'translation_history';

  static List<TranslationHistoryItem> items = [];

  static Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();

    final stored = prefs.getStringList(_key) ?? [];

    items = stored
        .map((value) {
          try {
            final json = jsonDecode(value) as Map<String, dynamic>;

            return TranslationHistoryItem.fromJson(json);
          } catch (_) {
            return null;
          }
        })
        .whereType<TranslationHistoryItem>()
        .toList();
  }

  static Future<void> add({
    required String sourceLanguage,
    required String targetLanguage,
    required String originalText,
    required String translatedText,
  }) async {
    if (originalText.trim().isEmpty ||
        translatedText.trim().isEmpty) {
      return;
    }

    final item = TranslationHistoryItem(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      sourceLanguage: sourceLanguage,
      targetLanguage: targetLanguage,
      originalText: originalText,
      translatedText: translatedText,
      createdAt: DateTime.now(),
    );

    items.removeWhere(
      (old) =>
          old.sourceLanguage == sourceLanguage &&
          old.targetLanguage == targetLanguage &&
          old.originalText == originalText &&
          old.translatedText == translatedText,
    );

    items.insert(0, item);

    if (items.length > 100) {
      items = items.sublist(0, 100);
    }

    await _save();
  }

  static Future<void> remove(String id) async {
    items.removeWhere((item) => item.id == id);

    await _save();
  }

  static Future<void> clear() async {
    items.clear();

    final prefs = await SharedPreferences.getInstance();

    await prefs.remove(_key);
  }

  static Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setStringList(
      _key,
      items.map((item) => jsonEncode(item.toJson())).toList(),
    );
  }
}

