import 'package:hive_flutter/hive_flutter.dart';

class FavoritesService {
  static const String _boxName = 'favorites';

  static Future<void> init() async {
    if (!Hive.isBoxOpen(_boxName)) {
      await Hive.openBox(_boxName);
    }
  }

  static Box get _box => Hive.box(_boxName);

  static List<String> get favorites {
    final data = _box.get('words', defaultValue: <dynamic>[]);

    return List<String>.from(data);
  }

  static bool isFavorite(String word) {
    return favorites.contains(word);
  }

  static Future<void> addFavorite(String word) async {
    final list = favorites;

    if (!list.contains(word)) {
      list.add(word);
      await _box.put('words', list);
    }
  }

  static Future<void> removeFavorite(String word) async {
    final list = favorites;

    list.remove(word);

    await _box.put('words', list);
  }

  static Future<void> toggleFavorite(String word) async {
    if (isFavorite(word)) {
      await removeFavorite(word);
    } else {
      await addFavorite(word);
    }
  }

  static Future<void> clearFavorites() async {
    await _box.delete('words');
  }
}
