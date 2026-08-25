class TranslationHistoryItem {
  final String id;
  final String sourceLanguage;
  final String targetLanguage;
  final String originalText;
  final String translatedText;
  final DateTime createdAt;

  const TranslationHistoryItem({
    required this.id,
    required this.sourceLanguage,
    required this.targetLanguage,
    required this.originalText,
    required this.translatedText,
    required this.createdAt,
  });

  factory TranslationHistoryItem.fromJson(Map<String, dynamic> json) {
    return TranslationHistoryItem(
      id: json['id']?.toString() ?? '',
      sourceLanguage: json['sourceLanguage']?.toString() ?? '',
      targetLanguage: json['targetLanguage']?.toString() ?? '',
      originalText: json['originalText']?.toString() ?? '',
      translatedText: json['translatedText']?.toString() ?? '',
      createdAt: DateTime.tryParse(
            json['createdAt']?.toString() ?? '',
          ) ??
          DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sourceLanguage': sourceLanguage,
      'targetLanguage': targetLanguage,
      'originalText': originalText,
      'translatedText': translatedText,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

