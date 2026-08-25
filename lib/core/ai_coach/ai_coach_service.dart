import '../../database/hive_service.dart';
import '../../services/smart_review_service.dart';
import '../../data/vocabulary_data.dart';
import '../ai_mistakes/mistake_service.dart';

class AiCoachRecommendation {
  final String type;
  final String title;
  final String message;
  final String action;
  final int xp;
  final int minutes;
  final String? category;

  const AiCoachRecommendation({
    required this.type,
    required this.title,
    required this.message,
    required this.action,
    required this.xp,
    required this.minutes,
    this.category,
  });
}

class AiCoachService {
  const AiCoachService._();

  static AiCoachRecommendation getRecommendation() {
    final language = HiveService.selectedLanguage;
    final streak = HiveService.streak;
    final dailyXp = HiveService.dailyXp;
    final dailyGoal = HiveService.dailyGoal;

    final completedLessons = HiveService.completedLessons.length;
    final completedQuizzes = HiveService.completedQuizzes;
    final completedReadings = HiveService.completedReadings;
    final pronunciation = HiveService.pronunciationPractices;
    final quizScore = HiveService.quizScore;

    final vocabularyWords = vocabulary.map((word) => word.english).toList();
    final smartReviewWords = SmartReviewService.getPrioritizedWords(vocabularyWords);

    // 1. AI Mistakes
    final activeMistakes = MistakeService.activeMistakes;

    if (activeMistakes.isNotEmpty) {
      final topMistake = activeMistakes.first;

      return AiCoachRecommendation(
        type: 'ai_mistakes',
        category: topMistake.category,
        title: 'Review your mistakes',
        message:
            'You have ${activeMistakes.length} mistakes that need more practice.',
        action: 'Review My Mistakes',
        xp: 25,
        minutes: 10,
      );
    }
    // 0. AI Mistakes
    if (activeMistakes.isNotEmpty) {
      final topMistake = activeMistakes.first;
      final count = activeMistakes.length;

      final priority = topMistake.attempts >= 3
          ? 'High Priority'
          : topMistake.attempts == 2
              ? 'Needs Practice'
              : 'New Mistake';

      return AiCoachRecommendation(
        type: 'ai_mistakes',
        category: topMistake.category,
        title: priority == 'High Priority'
            ? 'Your biggest mistake needs attention'
            : priority == 'Needs Practice'
                ? 'You should practice this again'
                : 'You have a mistake to review',
        message: count == 1
            ? 'AI Coach found one mistake that needs your attention.'
            : 'AI Coach found $count mistakes that need your attention.',
        action: 'Review My Mistakes',
        xp: topMistake.attempts >= 3 ? 25 : 15,
        minutes: topMistake.attempts >= 3 ? 10 : 5,
      );
    }

    // 1. Smart Review
    if (smartReviewWords.isNotEmpty) {
      final count = smartReviewWords.length;
      final topWord = smartReviewWords.first;
      final category = SmartReviewService.getReviewCategory(topWord);

      return AiCoachRecommendation(
        type: 'smart_review',
        category: category,
        title: category == 'Need Practice'
            ? 'Your vocabulary needs practice'
            : category == 'Almost Mastered'
                ? 'You are almost mastering vocabulary'
                : 'Time to review your vocabulary',
        message:
            'You have $count words in your Smart Review. Start with "$topWord".',
        action: 'Start Smart Review',
        xp: category == 'Need Practice' ? 25 : category == 'Almost Mastered' ? 10 : 15,
        minutes: category == 'Need Practice' ? 10 : 5,
      );
    }

    // 2. Daily goal
    if (dailyXp < dailyGoal) {
      final remaining = dailyGoal - dailyXp;

      return AiCoachRecommendation(
        type: 'daily_goal',
        title: 'Finish your daily goal',
        message: 'You are $remaining XP away from today’s goal. Keep going!',
        action: 'Continue learning',
        xp: remaining,
        minutes: 10,
      );
    }

    // 5. Quiz performance
    if (completedQuizzes > 0 && quizScore < 70) {
      return AiCoachRecommendation(
        type: 'quiz',
        title: 'Review your weak areas',
        message: 'Your recent quiz score suggests that a little more practice could help.',
        action: 'Practice exercises',
        xp: 20,
        minutes: 15,
      );
    }

    // 4. Reading
    if (completedReadings == 0 || completedReadings < (completedLessons ~/ 2)) {
      return AiCoachRecommendation(
        type: 'reading',
        title: 'Improve your reading',
        message: 'Reading will help you understand sentences and build vocabulary faster.',
        action: 'Start reading',
        xp: 15,
        minutes: 10,
      );
    }

    // 3. Pronunciation needs attention
    if (pronunciation == 0 ||
        pronunciation < completedLessons && pronunciation < 3) {
      return AiCoachRecommendation(
        type: 'pronunciation',
        title: 'Practice your pronunciation',
        message: 'Speaking clearly is important. Let’s improve your pronunciation today.',
        action: 'Practice pronunciation',
        xp: 10,
        minutes: 10,
      );
    }

    // 6. No lessons yet
    if (completedLessons == 0) {
      return AiCoachRecommendation(
        type: 'lesson',
        title: 'Start your first lesson',
        message:
            'Let’s build your foundation in $language before moving forward.',
        action: 'Start lesson',
        xp: 20,
        minutes: 10,
      );
    }

    // 7. Good streak
    if (streak >= 7) {
      return AiCoachRecommendation(
        type: 'streak',
        title: 'Keep your streak alive',
        message:
            'Amazing! You have a $streak-day streak. A short practice today keeps your momentum going.',
        action: 'Continue practice',
        xp: 20,
        minutes: 10,
      );
    }

    // 8. Default recommendation
    return AiCoachRecommendation(
      type: 'lesson',
      title: 'Continue your learning',
      message:
          'You are making progress. Continue with your next $language lesson.',
      action: 'Continue lesson',
      xp: 20,
      minutes: 15,
    );
  }
}









