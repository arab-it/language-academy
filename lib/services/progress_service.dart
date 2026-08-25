import '../database/hive_service.dart';

class ProgressService {
  // =========================
  // XP
  // =========================

  static Future<int> getXP() async {
    await HiveService.init();
    return HiveService.xp;
  }

  static Future<void> addXP(int value) async {
    await HiveService.init();

    if (value <= 0) return;

    await HiveService.addXp(value);
  }

  // =========================
  // COMPLETED LESSONS
  // =========================

  static Future<List<String>> getCompletedLessonIds() async {
    await HiveService.init();
    return HiveService.completedLessons;
  }

  static Future<bool> isLessonCompleted(String lessonId) async {
    await HiveService.init();

    return HiveService.completedLessons.contains(lessonId);
  }

  static Future<bool> completeLesson(
    String lessonId, {
    int xpReward = 0,
  }) async {
    await HiveService.init();

    final completed = HiveService.completedLessons;

    // Already completed.
    // Do not give XP again.
    if (completed.contains(lessonId)) {
      return false;
    }

    await HiveService.addCompletedLesson(lessonId);

    // addCompletedLesson already gives 20 XP.
    // Only add the extra reward if it is greater than 20.
    if (xpReward > 20) {
      await HiveService.addXp(xpReward - 20);
    }

    return true;
  }

  static Future<int> getLessonsCompleted() async {
    await HiveService.init();
    return HiveService.completedLessons.length;
  }

  // =========================
  // STREAK
  // =========================

  static Future<int> getStreak() async {
    await HiveService.init();
    return HiveService.streak;
  }

  static Future<void> setStreak(int value) async {
    await HiveService.init();
    await HiveService.setStreak(value);
  }

  static Future<void> increaseStreak() async {
    await HiveService.init();
    await HiveService.updateDailyStreak();
  }

  // =========================
  // QUIZ
  // =========================

  static Future<int> getQuizScore() async {
    await HiveService.init();
    return HiveService.quizScore;
  }

  static Future<int> getCompletedQuizzes() async {
    await HiveService.init();
    return HiveService.completedQuizzes;
  }

  static Future<void> saveQuizResult({
    required int score,
    required int totalQuestions,
  }) async {
    await HiveService.init();

    final percentage = totalQuestions == 0
        ? 0
        : ((score / totalQuestions) * 100).round();

    await HiveService.addCompletedQuiz(percentage);
  }

  // =========================
  // DAILY CHALLENGE
  // =========================

  static Future<bool> isDailyChallengeCompleted() async {
    await HiveService.init();

    final today = DateTime.now();
    final todayKey =
        '${today.year}-${today.month}-${today.day}';

    return HiveService.dailyChallengeDate == todayKey;
  }

  static Future<void> markDailyChallengeCompleted() async {
    await HiveService.init();

    final today = DateTime.now();
    final todayKey =
        '${today.year}-${today.month}-${today.day}';

    await HiveService.setDailyChallengeDate(todayKey);
  }

  // =========================
  // RESET
  // =========================

  static Future<void> resetProgress() async {
    await HiveService.init();

    await HiveService.clearProgress();
  }
}

