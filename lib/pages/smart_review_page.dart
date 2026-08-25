import 'package:flutter/material.dart';
import 'package:arab_it/core/theme/app_colors.dart';

import '../data/vocabulary_data.dart';
import '../services/smart_review_service.dart';
import '../services/language_controller.dart';
import '../services/progress_service.dart';

class SmartReviewPage extends StatefulWidget {
  const SmartReviewPage({super.key});

  @override
  State<SmartReviewPage> createState() => _SmartReviewPageState();
}

class _SmartReviewPageState extends State<SmartReviewPage> {
  List<String> reviewWords = [];
  int currentIndex = 0;
  bool showAnswer = false;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    LanguageController.language.addListener(_languageChanged);
    _loadReviewWords();
  }

  void _languageChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  String _t({
    required String en,
    required String it,
    required String ar,
  }) {
    return LanguageController.text(
      english: en,
      italian: it,
      arabic: ar,
    );
  }

  Future<void> _loadReviewWords() async {
    await SmartReviewService.init();

    final words = vocabularyWords
        .map((word) => word.english)
        .toSet()
        .toList();

    final prioritizedWords = SmartReviewService.getPrioritizedWords(
      words,
      limit: 20,
    );

    if (!mounted) return;

    setState(() {
      reviewWords = prioritizedWords;
      loading = false;
    });
  }
  Future<void> _answer(bool correct) async {
    if (reviewWords.isEmpty) return;

    final word = reviewWords[currentIndex];

    await SmartReviewService.recordAnswer(
      word,
      correct: correct,
    );

    // Smart Review XP reward.
    await ProgressService.addXP(
      correct ? 10 : 2,
    );

    if (!mounted) return;

    if (currentIndex >= reviewWords.length - 1) {
      setState(() {
        showAnswer = false;
      });

      _showCompletedDialog();
      return;
    }

    setState(() {
      currentIndex++;
      showAnswer = false;
    });
  }

  void _showCompletedDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return AlertDialog(
          title: const Text('Review Complete'),
          content: const Text(
            'Great work! Your Smart Review progress has been updated.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text('Done'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    LanguageController.language.removeListener(_languageChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF070A12),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          _t(
            en: 'Smart Review',
            it: 'Ripasso intelligente',
            ar: 'المراجعة الذكية',
          ),
          style: const TextStyle(
            fontWeight: FontWeight.w900,
          ),
        ),
        centerTitle: true,
      ),
      body: reviewWords.isEmpty
          ? _emptyState()
          : _reviewCard(),
    );
  }

  Widget _emptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: const Color(0xFF8B5CF6).withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.auto_awesome_rounded,
                size: 45,
                color: Color(0xFF8B5CF6),
              ),
            ),
            const SizedBox(height: 22),
            Text(
              _t(
                en: 'You are all caught up!',
                it: 'Sei completamente aggiornato!',
                ar: 'لقد أكملت كل المراجعات!',
              ),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              _t(
              en: 'No words need review right now.',
              it: 'Nessuna parola da ripassare al momento.',
              ar: 'لا توجد كلمات تحتاج إلى مراجعة الآن.',
            ),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.55),
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _reviewCard() {
    final word = reviewWords[currentIndex];

    final vocabularyWord = vocabularyWords.firstWhere(
      (item) => item.english == word,
    );

    final progress = (currentIndex + 1) / reviewWords.length;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 10, 18, 24),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${currentIndex + 1} / ${reviewWords.length}',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.55),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Icon(
                  Icons.auto_awesome_rounded,
                  color: Color(0xFF8B5CF6),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 7,
                backgroundColor: Colors.white.withValues(alpha: 0.08),
                valueColor: const AlwaysStoppedAnimation(
                  Color(0xFF8B5CF6),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  color: const Color(0xFF111725),
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.06),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _t(
                      en: 'Remember this word',
                      it: 'Ricorda questa parola',
                      ar: 'تذكّر هذه الكلمة',
                    ),
                      style: TextStyle(
                        color: Color(0xFF94A3B8),
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 25),
                    Text(
                      vocabularyWord.english,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 34,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      vocabularyWord.pronunciation,
                      style: const TextStyle(
                        color: AppColors.cyan,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 30),
                    if (showAnswer) ...[
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: const Color(0xFF8B5CF6)
                              .withValues(alpha: 0.10),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Column(
                          children: [
                            Text(
                              _t(
                              en: 'Italian',
                              it: 'Italiano',
                              ar: 'الإيطالية',
                            ),
                              style: TextStyle(
                                color: Color(0xFF94A3B8),
                                fontSize: 11,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              vocabularyWord.italian,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            const SizedBox(height: 15),
                            Text(
                              _t(
                              en: 'Arabic',
                              it: 'Italiano',
                              ar: 'العربية',
                            ),
                              style: TextStyle(
                                color: Color(0xFF94A3B8),
                                fontSize: 11,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              vocabularyWord.arabic,
                              textDirection: TextDirection.rtl,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 18),
            if (!showAnswer)
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      showAnswer = true;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8B5CF6),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(17),
                    ),
                  ),
                  child: Text(
                    _t(
                    en: 'Show Answer',
                    it: 'Mostra risposta',
                    ar: 'إظهار الإجابة',
                  ),
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              )
            else
              Row(
                children: [
                  Expanded(
                    child: _answerButton(
                      title: _t(
                        en: 'Again',
                        it: 'Ancora',
                        ar: 'مرة أخرى',
                      ),
                      icon: Icons.close_rounded,
                      color: const Color(0xFFEF4444),
                      onTap: () => _answer(false),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _answerButton(
                      title: _t(
                        en: 'I Know It',
                        it: 'Lo so',
                        ar: 'أعرفها',
                      ),
                      icon: Icons.check_rounded,
                      color: const Color(0xFF22C55E),
                      onTap: () => _answer(true),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _answerButton({
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      height: 55,
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icon),
        label: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w900,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(17),
          ),
        ),
      ),
    );
  }
}















