class VocabularyWord {
  final String id;

  final String english;
  final String italian;
  final String arabic;

  final String englishPronunciation;
  final String italianPronunciation;
  final String arabicPronunciation;

  final String category;
  final String level;

  final String englishExample;
  final String italianExample;
  final String arabicExample;

  final int points;

  const VocabularyWord({
    required this.id,
    required this.english,
    required this.italian,
    required this.arabic,
    required this.englishPronunciation,
    required this.italianPronunciation,
    required this.arabicPronunciation,
    required this.category,
    required this.level,
    required this.englishExample,
    required this.italianExample,
    required this.arabicExample,
    required this.points,
  });
}

