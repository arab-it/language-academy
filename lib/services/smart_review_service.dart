import 'package:hive_flutter/hive_flutter.dart';

class SmartReviewService {
  static const String _boxName = 'smart_review';

  static late Box _box;

  static Future<void> init() async {
    if (!Hive.isBoxOpen(_boxName)) {
      _box = await Hive.openBox(_boxName);
    } else {
      _box = Hive.box(_boxName);
    }
  }

  static String _key(String word) {
    return word.trim().toLowerCase();
  }

  static Map<String, dynamic> _getData(String word) {
    final key = _key(word);
    final data = _box.get(key);

    if (data is Map) {
      return {
        'correct': (data['correct'] as num?)?.toInt() ?? 0,
        'wrong': (data['wrong'] as num?)?.toInt() ?? 0,
        'reviews': (data['reviews'] as num?)?.toInt() ?? 0,
        'difficulty':
            (data['difficulty'] as num?)?.toDouble() ?? 1.0,
        'nextReview': data['nextReview']?.toString() ?? '',
        'lastReview': data['lastReview']?.toString() ?? '',
        'streak': (data['streak'] as num?)?.toInt() ?? 0,
        'intervalDays':
            (data['intervalDays'] as num?)?.toInt() ?? 0,
        'easeFactor':
            (data['easeFactor'] as num?)?.toDouble() ?? 2.3,
        'mastery':
            (data['mastery'] as num?)?.toDouble() ?? 0.0,
      };
    }

    return {
      'correct': 0,
      'wrong': 0,
      'reviews': 0,
      'difficulty': 1.0,
      'nextReview': '',
      'lastReview': '',
      'streak': 0,
      'intervalDays': 0,
      'easeFactor': 2.3,
      'mastery': 0.0,
    };
  }

  static Future<void> recordAnswer(
    String word, {
    required bool correct,
  }) async {
    await _record(
      word,
      correct: correct,
      quality: correct ? 'good' : 'again',
    );
  }

  static Future<void> recordQuality(
    String word, {
    required String quality,
  }) async {
    final normalized = quality.trim().toLowerCase();

    if (![
      'again',
      'hard',
      'good',
      'easy',
    ].contains(normalized)) {
      return;
    }

    await _record(
      word,
      correct: normalized != 'again',
      quality: normalized,
    );
  }

  static Future<void> _record(
    String word, {
    required bool correct,
    required String quality,
  }) async {
    final key = _key(word);

    if (key.isEmpty) return;

    final data = _getData(word);

    int correctCount = data['correct'] as int;
    int wrongCount = data['wrong'] as int;
    int reviews = data['reviews'] as int;
    double difficulty = data['difficulty'] as double;
    int streak = data['streak'] as int;
    int intervalDays = data['intervalDays'] as int;
    double easeFactor = data['easeFactor'] as double;
    double mastery = data['mastery'] as double;

    reviews++;

    final now = DateTime.now();

    if (quality == 'again') {
      wrongCount++;
      streak = 0;

      difficulty = (difficulty + 0.40).clamp(0.5, 3.0);
      easeFactor = (easeFactor - 0.20).clamp(1.3, 3.0);

      intervalDays = 1;

      mastery = (mastery - 12.0).clamp(0.0, 100.0);
    } else if (quality == 'hard') {
      correctCount++;
      streak++;

      difficulty = (difficulty + 0.10).clamp(0.5, 3.0);
      easeFactor = (easeFactor - 0.10).clamp(1.3, 3.0);

      if (intervalDays <= 0) {
        intervalDays = 1;
      } else {
        intervalDays = (intervalDays * 1.2).round();
      }

      intervalDays = intervalDays.clamp(1, 30);

      mastery = (mastery + 5.0).clamp(0.0, 100.0);
    } else if (quality == 'good') {
      correctCount++;
      streak++;

      difficulty = (difficulty - 0.10).clamp(0.5, 3.0);
      easeFactor = (easeFactor + 0.05).clamp(1.3, 3.0);

      if (intervalDays <= 0) {
        intervalDays = 1;
      } else if (intervalDays == 1) {
        intervalDays = 3;
      } else {
        intervalDays =
            (intervalDays * easeFactor).round();
      }

      intervalDays = intervalDays.clamp(1, 60);

      mastery = (mastery + 8.0).clamp(0.0, 100.0);
    } else if (quality == 'easy') {
      correctCount++;
      streak++;

      difficulty = (difficulty - 0.20).clamp(0.5, 3.0);
      easeFactor = (easeFactor + 0.15).clamp(1.3, 3.0);

      if (intervalDays <= 0) {
        intervalDays = 4;
      } else {
        intervalDays =
            (intervalDays * easeFactor * 1.3).round();
      }

      intervalDays = intervalDays.clamp(2, 120);

      mastery = (mastery + 12.0).clamp(0.0, 100.0);
    }

    final nextReview = now.add(
      Duration(days: intervalDays),
    );

    await _box.put(key, {
      'correct': correctCount,
      'wrong': wrongCount,
      'reviews': reviews,
      'difficulty': difficulty,
      'lastReview': now.toIso8601String(),
      'nextReview': nextReview.toIso8601String(),
      'streak': streak,
      'intervalDays': intervalDays,
      'easeFactor': easeFactor,
      'mastery': mastery,
    });
  }

  static bool isDue(String word) {
    final data = _getData(word);
    final nextReviewString = data['nextReview'] as String;

    if (nextReviewString.isEmpty) {
      return true;
    }

    final nextReview = DateTime.tryParse(nextReviewString);

    if (nextReview == null) {
      return true;
    }

    return !DateTime.now().isBefore(nextReview);
  }

  static int getCorrect(String word) {
    return _getData(word)['correct'] as int;
  }

  static int getWrong(String word) {
    return _getData(word)['wrong'] as int;
  }

  static int getReviews(String word) {
    return _getData(word)['reviews'] as int;
  }

  static int getStreak(String word) {
    return _getData(word)['streak'] as int;
  }

  static int getIntervalDays(String word) {
    return _getData(word)['intervalDays'] as int;
  }

  static double getEaseFactor(String word) {
    return _getData(word)['easeFactor'] as double;
  }

  static double getDifficulty(String word) {
    return _getData(word)['difficulty'] as double;
  }

  static double getMastery(String word) {
    return _getData(word)['mastery'] as double;
  }

  static double getPriorityScore(String word) {
    final data = _getData(word);

    final correct = data['correct'] as int;
    final wrong = data['wrong'] as int;
    final reviews = data['reviews'] as int;
    final difficulty = data['difficulty'] as double;
    final mastery = data['mastery'] as double;

    double score = 0.0;

    // Strong signal: repeated mistakes.
    score += wrong * 4.0;

    // Difficulty increases priority.
    score += difficulty * 5.0;

    // Due words should be reviewed now.
    if (isDue(word)) {
      score += 10.0;
    }

    // Repeated failure.
    if (wrong > correct && wrong > 0) {
      score += 8.0;
    }

    // Low mastery.
    if (reviews > 0 && mastery < 50) {
      score += 6.0;
    }

    // Never-reviewed words are allowed,
    // but they should not dominate real weak words.
    if (reviews == 0) {
      score += 0.5;
    }

    // Strongly mastered words get lower priority.
    if (mastery >= 90 && correct > wrong) {
      score -= 8.0;
    }

    // Good historical performance lowers priority.
    if (correct > wrong && correct >= 3) {
      score -= 2.0;
    }

    return score.clamp(0.0, 100.0);
  }

  static String getReviewCategory(String word) {
    final data = _getData(word);

    final correct = data['correct'] as int;
    final wrong = data['wrong'] as int;
    final reviews = data['reviews'] as int;
    final mastery = data['mastery'] as double;

    if (wrong > 0 && wrong >= correct) {
      return 'Need Practice';
    }

    if (isDue(word)) {
      return 'Need Review';
    }

    if (reviews >= 4 && mastery >= 80) {
      return 'Almost Mastered';
    }

    return 'Need Review';
  }

  static int getCategoryCount(
    List<String> words,
    String category,
  ) {
    return words
        .where(
          (word) => getReviewCategory(word) == category,
        )
        .length;
  }

  static List<String> getPrioritizedWords(
    List<String> words, {
    int limit = 20,
  }) {
    final uniqueWords = words
        .map((word) => word.trim())
        .where((word) => word.isNotEmpty)
        .toSet()
        .toList();

    uniqueWords.sort(
      (a, b) => getPriorityScore(b).compareTo(
        getPriorityScore(a),
      ),
    );

    return uniqueWords.take(limit).toList();
  }

  static List<String> getDueWords(List<String> words) {
    final result = words.where(isDue).toList();

    result.sort(
      (a, b) => getPriorityScore(b).compareTo(
        getPriorityScore(a),
      ),
    );

    return result;
  }

  static List<String> getWeakWords(List<String> words) {
    final result = words.where((word) {
      final data = _getData(word);

      final correct = data['correct'] as int;
      final wrong = data['wrong'] as int;
      final mastery = data['mastery'] as double;

      return wrong > 0 &&
          wrong >= correct &&
          mastery < 80;
    }).toList();

    result.sort(
      (a, b) => getPriorityScore(b).compareTo(
        getPriorityScore(a),
      ),
    );

    return result;
  }

  static List<String> getMasteredWords(List<String> words) {
    final result = words.where((word) {
      final data = _getData(word);

      final reviews = data['reviews'] as int;
      final mastery = data['mastery'] as double;
      final correct = data['correct'] as int;
      final wrong = data['wrong'] as int;

      return reviews >= 4 &&
          mastery >= 90 &&
          correct > wrong;
    }).toList();

    result.sort(
      (a, b) => getMastery(b).compareTo(
        getMastery(a),
      ),
    );

    return result;
  }

  static Future<void> clear() async {
    await _box.clear();
  }
}

