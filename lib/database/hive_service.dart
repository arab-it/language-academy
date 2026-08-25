import 'package:hive_flutter/hive_flutter.dart';

class HiveService {
  static const String _boxName = 'language_academy';

  static late Box _box;

  static Future<void> init() async {
    if (!Hive.isBoxOpen(_boxName)) {
      _box = await Hive.openBox(_boxName);
    } else {
      _box = Hive.box(_boxName);
    }

    await _initializeDefaults();
  }

  static Future<void> _initializeDefaults() async {
    if (!_box.containsKey('username')) {
      await _box.put('username', 'Learner');
    }

    if (!_box.containsKey('isPremium')) {
      await _box.put('isPremium', false);
    }

    if (!_box.containsKey('themeMode')) {
      await _box.put('themeMode', 'dark');
    }

    if (!_box.containsKey('selectedLanguage')) {
      await _box.put('selectedLanguage', 'Italian');
    }

    if (!_box.containsKey('xp')) {
      await _box.put('xp', 0);
    }

    if (!_box.containsKey('level')) {
      await _box.put('level', 1);
    }

    if (!_box.containsKey('streak')) {
      await _box.put('streak', 0);
    }

    if (!_box.containsKey('lastActivityDate')) {
      await _box.put('lastActivityDate', '');
    }

    if (!_box.containsKey('dailyGoal')) {
      await _box.put('dailyGoal', 20);
    }

    if (!_box.containsKey('dailyXp')) {
      await _box.put('dailyXp', 0);
    }

    if (!_box.containsKey('dailyGoalDate')) {
      await _box.put('dailyGoalDate', '');
    }

    if (!_box.containsKey('completedLessons')) {
      await _box.put('completedLessons', <String>[]);
    }

    if (!_box.containsKey('completedQuizzes')) {
      await _box.put('completedQuizzes', 0);
    }

    if (!_box.containsKey('completedReadings')) {
      await _box.put('completedReadings', 0);
    }

    if (!_box.containsKey('pronunciationPractices')) {
      await _box.put('pronunciationPractices', 0);
    }

    if (!_box.containsKey('quizScore')) {
      await _box.put('quizScore', 0);
    }

    if (!_box.containsKey('favorites')) {
      await _box.put('favorites', <String>[]);
    }

    if (!_box.containsKey('savedTranslations')) {
      await _box.put('savedTranslations', <String>[]);
    }

    if (!_box.containsKey('translationHistory')) {
      await _box.put('translationHistory', <Map<String, String>>[]);
    }

    if (!_box.containsKey('notifications')) {
      await _box.put('notifications', true);
    }

    if (!_box.containsKey('dailyReminder')) {
      await _box.put('dailyReminder', true);
    }

    if (!_box.containsKey('soundEffects')) {
      await _box.put('soundEffects', true);
    }

    if (!_box.containsKey('vibration')) {
      await _box.put('vibration', true);
    }
  }

  // USER

  static String get username =>
      _box.get('username', defaultValue: 'Learner').toString();

  static Future<void> setUsername(String value) async {
    final name = value.trim().isEmpty ? 'Learner' : value.trim();
    await _box.put('username', name);
  }

  // PREMIUM

  static bool get isPremium =>
      _box.get('isPremium', defaultValue: false) == true;

  static Future<void> setPremium(bool value) async {
    await _box.put('isPremium', value);
  }

  static String get premiumPlan =>
      _box.get('premiumPlan', defaultValue: 'monthly').toString();

  static Future<void> setPremiumPlan(String plan) async {
    final value = plan == 'yearly' ? 'yearly' : 'monthly';
    await _box.put('premiumPlan', value);
  }

  // THEME

  static String get themeMode =>
      _box.get('themeMode', defaultValue: 'dark').toString();

  static Future<void> setThemeMode(String mode) async {
    await _box.put('themeMode', mode);
  }

  // LANGUAGE

  static String get selectedLanguage =>
      _box.get('selectedLanguage', defaultValue: 'Italian').toString();

  static Future<void> setSelectedLanguage(String language) async {
    await _box.put('selectedLanguage', language);
  }

  // SETTINGS

  static bool get notifications =>
      _box.get('notifications', defaultValue: true) == true;

  static Future<void> setNotifications(bool value) async {
    await _box.put('notifications', value);
  }

  static bool get dailyReminder =>
      _box.get('dailyReminder', defaultValue: true) == true;

  static Future<void> setDailyReminder(bool value) async {
    await _box.put('dailyReminder', value);
  }

  static bool get soundEffects =>
      _box.get('soundEffects', defaultValue: true) == true;

  static Future<void> setSoundEffects(bool value) async {
    await _box.put('soundEffects', value);
  }

  static bool get vibration =>
      _box.get('vibration', defaultValue: true) == true;

  static Future<void> setVibration(bool value) async {
    await _box.put('vibration', value);
  }

  // XP / POINTS

  static int get xp => (_box.get('xp', defaultValue: 0) as num).toInt();

  static int get points => xp;

  static Future<void> addXp(int amount) async {
    if (amount <= 0) return;

    await _box.put('xp', xp + amount);
    await addDailyXp(amount);
    await updateLevelAutomatically();
  }

  static Future<void> updateLevelAutomatically() async {
    final newLevel = (xp ~/ 100) + 1;

    if (newLevel != level) {
      await _box.put('level', newLevel);
    }
  }

  // LEVEL

  static int get level => (_box.get('level', defaultValue: 1) as num).toInt();

  // STREAK

  static int get streak => (_box.get('streak', defaultValue: 0) as num).toInt();

  static Future<void> setStreak(int value) async {
    await _box.put('streak', value);
  }

  static String get lastActivityDate =>
      _box.get('lastActivityDate', defaultValue: '').toString();

  static Future<void> updateDailyStreak() async {
    final now = DateTime.now();
    final today = '${now.year}-${now.month}-${now.day}';

    if (lastActivityDate == today) {
      return;
    }

    if (lastActivityDate.isEmpty) {
      await setStreak(1);
    } else {
      final previous = DateTime.tryParse(lastActivityDate);

      if (previous == null) {
        await setStreak(1);
      } else {
        final todayDate = DateTime(now.year, now.month, now.day);
        final previousDate = DateTime(
          previous.year,
          previous.month,
          previous.day,
        );

        final difference = todayDate.difference(previousDate).inDays;

        if (difference == 1) {
          await setStreak(streak + 1);
        } else if (difference > 1) {
          await setStreak(1);
        }
      }
    }

    await _box.put('lastActivityDate', today);
  }

  // DAILY GOAL

  static int get dailyGoal =>
      (_box.get('dailyGoal', defaultValue: 20) as num).toInt();

  static Future<void> setDailyGoal(int value) async {
    if (value < 1) return;
    await _box.put('dailyGoal', value);
  }

  static String get dailyGoalDate =>
      _box.get('dailyGoalDate', defaultValue: '').toString();

  static int get dailyXp {
    final now = DateTime.now();
    final today = '${now.year}-${now.month}-${now.day}';

    if (dailyGoalDate != today) {
      return 0;
    }

    return (_box.get('dailyXp', defaultValue: 0) as num).toInt();
  }

  static Future<void> addDailyXp(int amount) async {
    if (amount <= 0) return;

    final now = DateTime.now();
    final today = '${now.year}-${now.month}-${now.day}';

    if (dailyGoalDate != today) {
      await _box.put('dailyGoalDate', today);
      await _box.put('dailyXp', amount);
    } else {
      await _box.put('dailyXp', dailyXp + amount);
    }
  }

  static double get dailyGoalProgress {
    if (dailyGoal <= 0) return 0;

    return (dailyXp / dailyGoal).clamp(0.0, 1.0);
  }

  static bool get dailyGoalCompleted => dailyXp >= dailyGoal;

  // LESSONS

  static List<String> get completedLessons {
    final data = _box.get('completedLessons', defaultValue: <String>[]);

    if (data is List) {
      return data.map((e) => e.toString()).toList();
    }

    return <String>[];
  }

  static Future<void> addCompletedLesson(String lessonId) async {
    final lessons = List<String>.from(completedLessons);

    if (lessons.contains(lessonId)) return;

    lessons.add(lessonId);

    await _box.put('completedLessons', lessons);
    await addXp(20);
    await updateDailyStreak();
  }

  // QUIZZES

  static int get completedQuizzes =>
      (_box.get('completedQuizzes', defaultValue: 0) as num).toInt();

  static Future<void> addCompletedQuiz([int score = 0]) async {
    await _box.put('completedQuizzes', completedQuizzes + 1);

    await setQuizScore(score);

    await addXp(score > 0 ? score : 25);
    await updateDailyStreak();
  }

  static int get quizScore =>
      (_box.get('quizScore', defaultValue: 0) as num).toInt();

  static Future<void> setQuizScore(int score) async {
    await _box.put('quizScore', score);
  }

  // READINGS

  static int get completedReadings =>
      (_box.get('completedReadings', defaultValue: 0) as num).toInt();

  static Future<void> addCompletedReading() async {
    await _box.put('completedReadings', completedReadings + 1);

    await addXp(15);
    await updateDailyStreak();
  }

  // PRONUNCIATION

  static int get pronunciationPractices =>
      (_box.get('pronunciationPractices', defaultValue: 0) as num).toInt();

  static Future<void> addPronunciationPractice() async {
    await _box.put('pronunciationPractices', pronunciationPractices + 1);

    await addXp(10);
    await updateDailyStreak();
  }

  // FAVORITES

  static List<String> get favorites {
    final data = _box.get('favorites', defaultValue: <String>[]);

    if (data is List) {
      return data.map((e) => e.toString()).toList();
    }

    return <String>[];
  }

  static int get favoriteWords => favorites.length;

  static bool isFavorite(String word) {
    return favorites.contains(word);
  }

  static Future<void> addFavorite(String word) async {
    final list = List<String>.from(favorites);

    if (!list.contains(word)) {
      list.add(word);
      await _box.put('favorites', list);
    }
  }

  static Future<void> removeFavorite(String word) async {
    final list = List<String>.from(favorites);

    list.remove(word);

    await _box.put('favorites', list);
  }

  // SAVED TRANSLATIONS

  static List<String> get savedTranslations {
    final data = _box.get('savedTranslations', defaultValue: <String>[]);

    if (data is List) {
      return data.map((e) => e.toString()).toList();
    }

    return <String>[];
  }

  static bool isTranslationSaved(String value) {
    return savedTranslations.contains(value);
  }

  static Future<void> saveTranslation(String value) async {
    final text = value.trim();

    if (text.isEmpty) return;

    final items = List<String>.from(savedTranslations);

    if (!items.contains(text)) {
      items.insert(0, text);

      if (items.length > 100) {
        items.removeLast();
      }

      await _box.put('savedTranslations', items);
    }
  }

  static Future<void> removeSavedTranslation(String value) async {
    final items = List<String>.from(savedTranslations);

    items.remove(value);

    await _box.put('savedTranslations', items);
  }

  // TRANSLATION HISTORY

  static List<Map<String, String>> get translationHistory {
    final data = _box.get('translationHistory', defaultValue: <dynamic>[]);

    if (data is List) {
      return data
          .whereType<Map>()
          .map(
            (item) => item.map(
              (key, value) => MapEntry(key.toString(), value.toString()),
            ),
          )
          .toList();
    }

    return <Map<String, String>>[];
  }

  static Future<void> addTranslationHistory({
    required String source,
    required String result,
    required String from,
    required String to,
  }) async {
    final history = translationHistory;

    history.insert(0, {
      'source': source,
      'result': result,
      'from': from,
      'to': to,
    });

    if (history.length > 20) {
      history.removeRange(20, history.length);
    }

    await _box.put('translationHistory', history);
  }

  static Future<void> clearTranslationHistory() async {
    await _box.put('translationHistory', <Map<String, String>>[]);
  }

  // PROGRESS

  static double get lessonProgress {
    if (dailyGoal <= 0) return 0;
    return (completedLessons.length / dailyGoal).clamp(0.0, 1.0);
  }

  static Future<void> setLessonProgress(double value) async {
    await _box.put('lessonProgress', value.clamp(0.0, 1.0));
  }

  static double get readingProgress {
    if (dailyGoal <= 0) return 0;
    return (completedReadings / dailyGoal).clamp(0.0, 1.0);
  }

  static Future<void> setReadingProgress(double value) async {
    await _box.put('readingProgress', value.clamp(0.0, 1.0));
  }

  static double get pronunciationProgress {
    if (dailyGoal <= 0) return 0;
    return (pronunciationPractices / dailyGoal).clamp(0.0, 1.0);
  }

  static Future<void> setPronunciationProgress(double value) async {
    await _box.put('pronunciationProgress', value.clamp(0.0, 1.0));
  }

  static double get storedLessonProgress =>
      (_box.get('lessonProgress', defaultValue: 0.0) as num).toDouble();

  static double get storedReadingProgress =>
      (_box.get('readingProgress', defaultValue: 0.0) as num).toDouble();

  static double get storedPronunciationProgress =>
      (_box.get('pronunciationProgress', defaultValue: 0.0) as num).toDouble();

  static int get totalActivities =>
      completedLessons.length +
      completedQuizzes +
      completedReadings +
      pronunciationPractices;

  // DAILY CHALLENGE

  static String get dailyChallengeDate =>
      _box.get('dailyChallengeDate', defaultValue: '').toString();

  static Future<void> setDailyChallengeDate(String value) async {
    await _box.put('dailyChallengeDate', value);
  }

  // CLEAR PROGRESS

  static Future<void> clearProgress() async {
    await _box.delete('xp');
    await _box.delete('level');
    await _box.delete('streak');
    await _box.delete('lastActivityDate');
    await _box.delete('dailyXp');
    await _box.delete('dailyGoalDate');
    await _box.delete('completedLessons');
    await _box.delete('completedQuizzes');
    await _box.delete('completedReadings');
    await _box.delete('pronunciationPractices');
    await _box.delete('quizScore');
    await _box.delete('lessonProgress');
    await _box.delete('readingProgress');
    await _box.delete('pronunciationProgress');
    await _box.delete('dailyChallengeDate');

    await _initializeDefaults();
  }
  static Future<void> clearAll() async {
    await _box.clear();
    await _initializeDefaults();
  }
}




