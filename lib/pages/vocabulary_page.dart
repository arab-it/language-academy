import 'package:flutter/material.dart';

import '../data/vocabulary_data.dart';
import '../models/vocabulary_word.dart';
import '../services/translate_service.dart';

class VocabularyPage extends StatefulWidget {
  const VocabularyPage({super.key});

  @override
  State<VocabularyPage> createState() => _VocabularyPageState();
}

class _VocabularyPageState extends State<VocabularyPage> {
  final TextEditingController _searchController = TextEditingController();
  final TranslateService _translateService = TranslateService.instance;

  String selectedCategory = 'All';
  String searchQuery = '';
  String translateTo = 'Italian';
  final Map<String, String> _translations = {};
  final Set<String> _loadingTranslations = {};

  @override
  void initState() {
    super.initState();

    _searchController.addListener(() {
      setState(() {
        searchQuery = _searchController.text.trim().toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<String> get categories {
    final values = vocabularyWords
        .map((word) => word.category)
        .toSet()
        .toList();

    values.sort();

    return ['All', ...values];
  }

  List<VocabularyWord> get filteredWords {
    return vocabularyWords.where((word) {
      final matchesCategory =
          selectedCategory == 'All' || word.category == selectedCategory;

      final matchesSearch =
          searchQuery.isEmpty ||
          word.english.toLowerCase().contains(searchQuery) ||
          word.italian.toLowerCase().contains(searchQuery) ||
          word.arabic.toLowerCase().contains(searchQuery);

      return matchesCategory && matchesSearch;
    }).toList();
  }

  String _sourceLanguage(VocabularyWord word) {
    if (word.english.isNotEmpty) {
      return 'English';
    }

    return 'English';
  }

  String _sourceText(VocabularyWord word) {
    return word.english;
  }

  Future<void> _translateWord(VocabularyWord word) async {
    final text = _sourceText(word);

    if (text.trim().isEmpty) return;

    final key = '${text}_$translateTo';

    if (_translations.containsKey(key)) {
      setState(() {});
      return;
    }

    setState(() {
      _loadingTranslations.add(key);
    });

    try {
      final result = await _translateService.translate(
        text: text,
        from: _sourceLanguage(word),
        to: translateTo,
      );

      if (!mounted) return;

      setState(() {
        _translations[key] = result;
        _loadingTranslations.remove(key);
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _loadingTranslations.remove(key);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Translation failed: $e'),
          backgroundColor: Colors.red.shade700,
        ),
      );
    }
  }

  void _changeTranslateLanguage(String language) {
    setState(() {
      translateTo = language;
    });
  }

  @override
  Widget build(BuildContext context) {
    const background = Color(0xFF080808);
    const card = Color(0xFF151515);
    const green = Color(0xFF008C45);
    const cyan = Color(0xFF00BCD4);

    final words = filteredWords;

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: background,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Vocabulary',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 12),
            child: TextField(
              controller: _searchController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search words...',
                hintStyle: TextStyle(
                  color: Colors.white.withValues(alpha: 0.4),
                ),
                prefixIcon: const Icon(
                  Icons.search_rounded,
                  color: green,
                ),
                suffixIcon: searchQuery.isNotEmpty
                    ? IconButton(
                        onPressed: _searchController.clear,
                        icon: const Icon(
                          Icons.clear_rounded,
                          color: Colors.white54,
                        ),
                      )
                    : null,
                filled: true,
                fillColor: card,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 5,
              ),
              decoration: BoxDecoration(
                color: card,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: cyan.withValues(alpha: 0.15),
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.translate_rounded,
                    color: cyan,
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      'Translate to',
                      style: TextStyle(
                        color: Colors.white70,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: translateTo,
                      dropdownColor: card,
                      icon: const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: cyan,
                      ),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'Italian',
                          child: Text('Italiano'),
                        ),
                        DropdownMenuItem(
                          value: 'Arabic',
                          child: Text('Ø§Ù„Ø¹Ø±Ø¨ÙŠØ©'),
                        ),
                        DropdownMenuItem(
                          value: 'English',
                          child: Text('English'),
                        ),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          _changeTranslateLanguage(value);
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 10),

          SizedBox(
            height: 48,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final category = categories[index];
                final selected = selectedCategory == category;

                return ChoiceChip(
                  label: Text(category),
                  selected: selected,
                  onSelected: (_) {
                    setState(() {
                      selectedCategory = category;
                    });
                  },
                  selectedColor: green.withValues(alpha: 0.85),
                  backgroundColor: card,
                  labelStyle: TextStyle(
                    color: selected ? Colors.white : Colors.white70,
                    fontWeight: FontWeight.w700,
                  ),
                  side: BorderSide.none,
                );
              },
            ),
          ),

          const SizedBox(height: 12),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                const Icon(
                  Icons.menu_book_rounded,
                  color: green,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  '${words.length} words',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
                if (selectedCategory != 'All')
                  Text(
                    selectedCategory,
                    style: const TextStyle(
                      color: green,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          Expanded(
            child: words.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.search_off_rounded,
                          color: Colors.white38,
                          size: 50,
                        ),
                        SizedBox(height: 12),
                        Text(
                          'No words found',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(20, 4, 20, 30),
                    itemCount: words.length,
                    itemBuilder: (context, index) {
                      return _wordCard(words[index], card, green);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _wordCard(
    VocabularyWord word,
    Color card,
    Color green,
  ) {
    final key = '${word.english}_$translateTo';
    final translation = _translations[key];
    final loading = _loadingTranslations.contains(key);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.05),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: green.withValues(alpha: 0.13),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  Icons.language_rounded,
                  color: green,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  word.category,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.45),
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          _languageRow(
            'EN',
            'English',
            word.english,
          ),

          const SizedBox(height: 10),

          _languageRow(
            'IT',
            'Italian',
            word.italian,
          ),

          const SizedBox(height: 10),

          _languageRow(
            'AR',
            'Arabic',
            word.arabic,
          ),

          const SizedBox(height: 14),

          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 9,
            ),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.record_voice_over_rounded,
                  color: Colors.white38,
                  size: 17,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    word.pronunciation,
                    style: const TextStyle(
                      color: Colors.white54,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: loading
                  ? null
                  : () => _translateWord(word),
              icon: loading
                  ? const SizedBox(
                      width: 17,
                      height: 17,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(
                      Icons.translate_rounded,
                      size: 18,
                    ),
              label: Text(
                loading
                    ? 'Translating...'
                    : 'Translate to $translateTo',
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF008C45),
                foregroundColor: Colors.white,
                disabledBackgroundColor:
                    Colors.white.withValues(alpha: 0.08),
                disabledForegroundColor: Colors.white54,
                minimumSize: const Size(double.infinity, 46),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ),

          if (translation != null) ...[
            const SizedBox(height: 12),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFF008C45).withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: const Color(0xFF008C45).withValues(alpha: 0.22),
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.check_circle_outline_rounded,
                    color: Color(0xFF008C45),
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      translation,
                      textAlign: translateTo == 'Arabic'
                          ? TextAlign.right
                          : TextAlign.left,
                      textDirection: translateTo == 'Arabic'
                          ? TextDirection.rtl
                          : TextDirection.ltr,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _languageRow(
    String flag,
    String language,
    String value,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          flag,
          style: const TextStyle(fontSize: 20),
        ),
        const SizedBox(width: 10),
        SizedBox(
          width: 62,
          child: Text(
            language,
            style: const TextStyle(
              color: Colors.white38,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            textAlign: language == 'Arabic'
                ? TextAlign.right
                : TextAlign.left,
            textDirection: language == 'Arabic'
                ? TextDirection.rtl
                : TextDirection.ltr,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    );
  }
}

