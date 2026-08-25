enum ExerciseType {
  multipleChoice,
  fillBlank,
  translate,
  matchWords,
  wordOrder,
  reading,
}

class ExerciseQuestion {
  final String language;
  final String level;
  final ExerciseType type;
  final String question;
  final List<String> options;
  final String correctAnswer;
  final String? explanation;
  final int points;

  const ExerciseQuestion({
    required this.language,
    required this.level,
    required this.type,
    required this.question,
    this.options = const [],
    required this.correctAnswer,
    this.explanation,
    this.points = 1,
  });
}

