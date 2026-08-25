import 'package:hive/hive.dart';

class StudentMistake {
  final String id;
  final String language;
  final String category;
  final String question;
  final String wrongAnswer;
  final String correctAnswer;
  final String source;
  final DateTime createdAt;
  final int attempts;
  final bool improved;

  const StudentMistake({
    required this.id,
    required this.language,
    required this.category,
    required this.question,
    required this.wrongAnswer,
    required this.correctAnswer,
    required this.source,
    required this.createdAt,
    this.attempts = 1,
    this.improved = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'language': language,
      'category': category,
      'question': question,
      'wrongAnswer': wrongAnswer,
      'correctAnswer': correctAnswer,
      'source': source,
      'createdAt': createdAt.toIso8601String(),
      'attempts': attempts,
      'improved': improved,
    };
  }

  factory StudentMistake.fromMap(Map<String, dynamic> map) {
    return StudentMistake(
      id: map['id']?.toString() ?? '',
      language: map['language']?.toString() ?? 'English',
      category: map['category']?.toString() ?? 'General',
      question: map['question']?.toString() ?? '',
      wrongAnswer: map['wrongAnswer']?.toString() ?? '',
      correctAnswer: map['correctAnswer']?.toString() ?? '',
      source: map['source']?.toString() ?? 'Unknown',
      createdAt:
          DateTime.tryParse(map['createdAt']?.toString() ?? '') ??
          DateTime.now(),
      attempts: (map['attempts'] as num?)?.toInt() ?? 1,
      improved: map['improved'] == true,
    );
  }

  StudentMistake copyWith({
    int? attempts,
    bool? improved,
  }) {
    return StudentMistake(
      id: id,
      language: language,
      category: category,
      question: question,
      wrongAnswer: wrongAnswer,
      correctAnswer: correctAnswer,
      source: source,
      createdAt: createdAt,
      attempts: attempts ?? this.attempts,
      improved: improved ?? this.improved,
    );
  }
}

class MistakeService {
  static const String _boxName = 'language_academy';
  static const String _mistakesKey = 'ai_student_mistakes';

  static Box<dynamic> get _box => Hive.box<dynamic>(_boxName);

  static List<StudentMistake> get mistakes {
    final data = _box.get(
      _mistakesKey,
      defaultValue: <dynamic>[],
    );

    if (data is! List) {
      return [];
    }

    return data
        .whereType<Map>()
        .map(
          (item) => StudentMistake.fromMap(
            Map<String, dynamic>.from(item),
          ),
        )
        .toList();
  }

  static Future<void> addMistake({
    required String language,
    required String category,
    required String question,
    required String wrongAnswer,
    required String correctAnswer,
    required String source,
  }) async {
    final existing = mistakes;

    final existingIndex = existing.indexWhere(
      (mistake) =>
          mistake.language.toLowerCase() == language.toLowerCase() &&
          mistake.question == question,
    );

    if (existingIndex >= 0) {
      final old = existing[existingIndex];

      existing[existingIndex] = old.copyWith(
        attempts: old.attempts + 1,
        improved: false,
      );
    } else {
      existing.add(
        StudentMistake(
          id: DateTime.now().microsecondsSinceEpoch.toString(),
          language: language,
          category: category,
          question: question,
          wrongAnswer: wrongAnswer,
          correctAnswer: correctAnswer,
          source: source,
          createdAt: DateTime.now(),
        ),
      );
    }

    await _save(existing);
  }

  static Future<void> markImproved(String id) async {
    final updated = mistakes.map((mistake) {
      if (mistake.id == id) {
        return mistake.copyWith(improved: true);
      }

      return mistake;
    }).toList();

    await _save(updated);
  }

  static List<StudentMistake> get activeMistakes {
    return mistakes.where((mistake) => !mistake.improved).toList();
  }

  static Map<String, int> get mistakesByCategory {
    final result = <String, int>{};

    for (final mistake in activeMistakes) {
      result[mistake.category] =
          (result[mistake.category] ?? 0) + 1;
    }

    return result;
  }

  static List<StudentMistake> get weakestMistakes {
    final sorted = List<StudentMistake>.from(activeMistakes);

    sorted.sort(
      (a, b) => b.attempts.compareTo(a.attempts),
    );

    return sorted;
  }

  static Future<void> clearImproved() async {
    final remaining =
        mistakes.where((mistake) => !mistake.improved).toList();

    await _save(remaining);
  }

  static Future<void> clearAll() async {
    await _save([]);
  }

  static Future<void> _save(
    List<StudentMistake> value,
  ) async {
    await _box.put(
      _mistakesKey,
      value.map((mistake) => mistake.toMap()).toList(),
    );
  }
}

