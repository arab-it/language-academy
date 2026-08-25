class VocabularyWord {
  final String english;
  final String italian;
  final String arabic;
  final String albanian;
  final String category;
  final String pronunciation;

  const VocabularyWord({
    required this.english,
    required this.italian,
    required this.arabic,
    this.albanian = '',
    required this.category,
    required this.pronunciation,
  });
}

