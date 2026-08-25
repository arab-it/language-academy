import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

import '../data/vocabulary_data.dart';
import '../models/vocabulary_word.dart';
import '../services/progress_service.dart';
import '../database/hive_service.dart';

class FlashcardPage extends StatefulWidget {
  const FlashcardPage({super.key});

  @override
  State<FlashcardPage> createState() => _FlashcardPageState();
}

class _FlashcardPageState extends State<FlashcardPage> {
  int currentIndex = 0;
  bool showAnswer = false;
  int knownWords = 0;
  int againWords = 0;
  final FlutterTts _tts = FlutterTts();

  VocabularyWord get currentWord => vocabularyWords[currentIndex];

  Future<void> _speak(String text, String code) async {
    if (text.trim().isEmpty) return;

    final locale = code == 'ar'
        ? 'ar-SA'
        : code == 'en'
        ? 'en-US'
        : 'it-IT';

    await _tts.setLanguage(locale);
    await _tts.setSpeechRate(0.45);
    await _tts.setVolume(1.0);
    await _tts.speak(text);
  }

  void _nextCard() {
    setState(() {
      currentIndex = (currentIndex + 1) % vocabularyWords.length;
      showAnswer = false;
    });
  }

  Future<void> _markKnown() async {
    setState(() {
      knownWords++;
    });

    await ProgressService.addXP(5);
    await HiveService.updateDailyStreak();

    _nextCard();
  }

  void _markAgain() {
    setState(() {
      againWords++;
    });
    _nextCard();
  }

  @override
  Widget build(BuildContext context) {
    const green = Color(0xFF008C45);
    const red = Color(0xFFCD212A);

    final word = currentWord;
    final progress = (currentIndex + 1) / vocabularyWords.length;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Flashcards',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Row(
            children: [
              Expanded(
                child: _statCard(
                  icon: Icons.check_circle_rounded,
                  value: '$knownWords',
                  label: 'Known',
                  color: green,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _statCard(
                  icon: Icons.refresh_rounded,
                  value: '$againWords',
                  label: 'Again',
                  color: red,
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Vocabulary',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                '${currentIndex + 1} / ${vocabularyWords.length}',
                style: const TextStyle(
                  color: Colors.white54,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 7,
              backgroundColor: Colors.white12,
              valueColor: const AlwaysStoppedAnimation<Color>(green),
            ),
          ),

          const SizedBox(height: 24),

          GestureDetector(
            onTap: () {
              setState(() {
                showAnswer = !showAnswer;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              width: double.infinity,
              constraints: const BoxConstraints(minHeight: 380),
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainer,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: showAnswer
                      ? green.withValues(alpha: 0.4)
                      : Colors.white.withValues(alpha: 0.06),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: green.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      word.category,
                      style: const TextStyle(
                        color: green,
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),

                  const SizedBox(height: 35),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        '🇬🇧 English',
                        style: TextStyle(
                          color: Colors.white38,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      IconButton(
                        tooltip: 'Listen',
                        onPressed: () => _speak(word.english, 'en'),
                        icon: const Icon(
                          Icons.volume_up_rounded,
                          color: Colors.white54,
                          size: 19,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  Text(
                    word.english,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 34,
                      fontWeight: FontWeight.w900,
                    ),
                  ),

                  const SizedBox(height: 25),

                  if (showAnswer) ...[
                    Container(height: 1, color: Colors.white10),
                    const SizedBox(height: 25),

                    Text(
                      '🇮🇹  ${word.italian}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: green,
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                      ),
                    ),

                    const SizedBox(height: 14),

                    Text(
                      '🇸🇦  ${word.arabic}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                      ),
                    ),

                    const SizedBox(height: 18),

                    Text(
                      'Pronunciation: ${word.pronunciation}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 13,
                      ),
                    ),
                  ] else
                    const Text(
                      'Tap the card to reveal the answer',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white38, fontSize: 13),
                    ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          if (showAnswer)
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 54,
                    child: OutlinedButton.icon(
                      onPressed: _markAgain,
                      icon: const Icon(Icons.refresh_rounded),
                      label: const Text('Again'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: red,
                        side: BorderSide(color: red.withValues(alpha: 0.6)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: SizedBox(
                    height: 54,
                    child: ElevatedButton.icon(
                      onPressed: _markKnown,
                      icon: const Icon(Icons.check_rounded),
                      label: const Text('I Know'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: green,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )
          else
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    showAnswer = true;
                  });
                },
                icon: const Icon(Icons.visibility_rounded),
                label: const Text('Show Answer'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: green,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),

          const SizedBox(height: 14),

          TextButton.icon(
            onPressed: _nextCard,
            icon: const Icon(Icons.arrow_forward_rounded),
            label: const Text('Skip'),
            style: TextButton.styleFrom(foregroundColor: Colors.white54),
          ),
        ],
      ),
    );
  }

  Widget _statCard({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 25),
          const SizedBox(width: 9),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Text(
                label,
                style: const TextStyle(color: Colors.white38, fontSize: 11),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
