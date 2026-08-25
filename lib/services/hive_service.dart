import '../database/hive_service.dart' as database;

class HiveService {
  Future<void> init() => database.HiveService.init();

  String get username => database.HiveService.username;
  int get xp => database.HiveService.xp;
  int get points => database.HiveService.points;
  int get level => database.HiveService.level;
  int get streak => database.HiveService.streak;

  String get themeMode => database.HiveService.themeMode;
  String get selectedLanguage => database.HiveService.selectedLanguage;

  int get dailyXp => database.HiveService.dailyXp;
  int get dailyGoal => database.HiveService.dailyGoal;

  int get completedQuizzes => database.HiveService.completedQuizzes;
  int get completedReadings => database.HiveService.completedReadings;
  int get pronunciationPractices => database.HiveService.pronunciationPractices;

  List<String> get completedLessons => database.HiveService.completedLessons;

  List<String> get favorites => database.HiveService.favorites;

  List<String> get savedTranslations => database.HiveService.savedTranslations;

  List<Map<String, String>> get translationHistory =>
      database.HiveService.translationHistory;

  double get lessonProgress => database.HiveService.lessonProgress;

  double get readingProgress => database.HiveService.readingProgress;

  double get pronunciationProgress =>
      database.HiveService.pronunciationProgress;

  Future<void> setUsername(String value) =>
      database.HiveService.setUsername(value);

  Future<void> setThemeMode(String value) =>
      database.HiveService.setThemeMode(value);

  Future<void> setSelectedLanguage(String value) =>
      database.HiveService.setSelectedLanguage(value);

  Future<void> addXp(int amount) => database.HiveService.addXp(amount);

  Future<void> updateLevelAutomatically() =>
      database.HiveService.updateLevelAutomatically();

  Future<void> updateDailyStreak() => database.HiveService.updateDailyStreak();

  Future<void> addCompletedLesson(String id) =>
      database.HiveService.addCompletedLesson(id);

  Future<void> addCompletedQuiz([int score = 0]) =>
      database.HiveService.addCompletedQuiz(score);

  Future<void> addCompletedReading() =>
      database.HiveService.addCompletedReading();

  Future<void> addPronunciationPractice() =>
      database.HiveService.addPronunciationPractice();

  Future<void> addFavorite(String word) =>
      database.HiveService.addFavorite(word);

  Future<void> removeFavorite(String word) =>
      database.HiveService.removeFavorite(word);

  bool isFavorite(String word) => database.HiveService.isFavorite(word);

  Future<void> saveTranslation(String value) =>
      database.HiveService.saveTranslation(value);

  Future<void> removeSavedTranslation(String value) =>
      database.HiveService.removeSavedTranslation(value);

  Future<void> addTranslationHistory({
    required String source,
    required String result,
    required String from,
    required String to,
  }) => database.HiveService.addTranslationHistory(
    source: source,
    result: result,
    from: from,
    to: to,
  );

  Future<void> clearTranslationHistory() =>
      database.HiveService.clearTranslationHistory();
}

final HiveService hiveService = HiveService();

