class ListeningQuestion {
  final String id;
  final String lessonId;
  final String audioText;
  final String question;
  final List<String> options;
  final int correctIndex;

  const ListeningQuestion({
    required this.id,
    required this.lessonId,
    required this.audioText,
    required this.question,
    required this.options,
    required this.correctIndex,
  });
}

