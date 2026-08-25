import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageController {
  static const String _key = 'app_language';

  static final ValueNotifier<String> language = ValueNotifier<String>(
    'English',
  );

  static Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();

    language.value = prefs.getString(_key) ?? 'English';
  }

  static Future<void> setLanguage(String value) async {
    language.value = value;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, value);
  }

  static String get current => language.value;

  static bool get isArabic => current == 'العربية';
  static bool get isItalian => current == 'Italiano';
  static bool get isEnglish => current == 'English';

  static String text({
    required String english,
    String? italian,
    String? arabic,
  }) {
    if (isArabic) {
      return arabic ?? english;
    }

    if (isItalian) {
      return italian ?? english;
    }

    return english;
  }
}


