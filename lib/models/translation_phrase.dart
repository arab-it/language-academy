class TranslationPhrase {
  final String english;
  final String italian;
  final String arabic;
  final String albanian;
  final String category;

  const TranslationPhrase({
    required this.english,
    required this.italian,
    required this.arabic,
    this.albanian = '',
    required this.category,
  });
}

