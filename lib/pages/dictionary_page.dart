import 'package:flutter/material.dart';
import 'package:arab_it/core/theme/app_colors.dart';
import 'package:flutter_tts/flutter_tts.dart';

import '../data/vocabulary_data.dart';
import '../models/vocabulary_word.dart';

class DictionaryPage extends StatefulWidget {
  const DictionaryPage({super.key});

  @override
  State<DictionaryPage> createState() => _DictionaryPageState();
}

class _DictionaryPageState extends State<DictionaryPage> {
  final TextEditingController _searchController = TextEditingController();
  final FlutterTts _tts = FlutterTts();

  String _query = '';

  List<VocabularyWord> get _results {
    final query = _query.trim().toLowerCase();

    if (query.isEmpty) {
      return vocabularyWords;
    }

    return vocabularyWords.where((word) {
      return word.english.toLowerCase().contains(query) ||
          word.italian.toLowerCase().contains(query) ||
          word.arabic.contains(_query.trim());
    }).toList();
  }

  @override
  void initState() {
    super.initState();

    _searchController.addListener(() {
      setState(() {
        _query = _searchController.text;
      });
    });
  }

  Future<void> _speak(String text, String language) async {
    final locale = switch (language) {
      'en' => 'en-US',
      'it' => 'it-IT',
      'ar' => 'ar-SA',
      _ => 'en-US',
    };

    await _tts.setLanguage(locale);
    await _tts.setSpeechRate(0.45);
    await _tts.setVolume(1.0);
    await _tts.speak(text);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _tts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final results = _results;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        title: const Text(
          'Dictionary',
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: TextField(
              controller: _searchController,
              autofocus: false,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search English, Italian or Arabic...',
                hintStyle: const TextStyle(color: Colors.white30),
                prefixIcon: const Icon(
                  Icons.search_rounded,
                  color: AppColors.cyan,
                ),
                suffixIcon: _query.isEmpty
                    ? null
                    : IconButton(
                        onPressed: _searchController.clear,
                        icon: const Icon(
                          Icons.clear_rounded,
                          color: Colors.white54,
                        ),
                      ),
                filled: true,
                fillColor: Theme.of(context).colorScheme.surfaceContainer,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '${results.length} words',
                style: const TextStyle(
                  color: Colors.white38,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),

          const SizedBox(height: 8),

          Expanded(
            child: results.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.menu_book_rounded,
                          size: 58,
                          color: Colors.white.withValues(alpha: 0.20),
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
                        SizedBox(height: 6),
                        Text(
                          'Try another word.',
                          style: TextStyle(color: Colors.white38),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 30),
                    itemCount: results.length,
                    itemBuilder: (context, index) {
                      final word = results[index];

                      return _wordCard(word);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _wordCard(VocabularyWord word) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  word.english,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              IconButton(
                tooltip: 'Listen',
                onPressed: () => _speak(word.english, 'en'),
                icon: const Icon(
                  Icons.volume_up_rounded,
                  color: AppColors.cyan,
                ),
              ),
            ],
          ),

          const SizedBox(height: 4),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
            decoration: BoxDecoration(
              color: const Color(0xFF008C45).withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(9),
            ),
            child: Text(
              word.category,
              style: const TextStyle(
                color: Color(0xFF008C45),
                fontSize: 10,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              const Text(
                'Italian',
                style: TextStyle(color: Colors.white38, fontSize: 11),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  word.italian,
                  style: const TextStyle(
                    color: Color(0xFF008C45),
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              IconButton(
                tooltip: 'Listen',
                onPressed: () => _speak(word.italian, 'it'),
                icon: const Icon(
                  Icons.volume_up_rounded,
                  color: Color(0xFF008C45),
                  size: 20,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          Row(
            children: [
              const Text(
                'Arabic',
                style: TextStyle(color: Colors.white38, fontSize: 11),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  word.arabic,
                  textDirection: TextDirection.rtl,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 19,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              IconButton(
                tooltip: 'Listen',
                onPressed: () => _speak(word.arabic, 'ar'),
                icon: const Icon(
                  Icons.volume_up_rounded,
                  color: Colors.white54,
                  size: 20,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          Text(
            'Pronunciation: ${word.pronunciation}',
            style: const TextStyle(color: Colors.white38, fontSize: 12),
          ),
        ],
      ),
    );
  }
}




