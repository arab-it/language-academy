class QuizQuestion {
  final String language;
  final String level;
  final String category;
  final String question;
  final List<String> answers;
  final int correctAnswer;
  final int points;

  const QuizQuestion({
    required this.language,
    required this.level,
    required this.category,
    required this.question,
    required this.answers,
    required this.correctAnswer,
    this.points = 10,
  });
}

