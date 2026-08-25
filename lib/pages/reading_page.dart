import 'package:flutter/material.dart';
import 'package:arab_it/core/theme/app_colors.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../database/hive_service.dart';
import '../core/premium_guard.dart';

import 'premium_page.dart';

import '../services/language_controller.dart';

class ReadingPage extends StatefulWidget {
  const ReadingPage({super.key});

  @override
  State<ReadingPage> createState() => _ReadingPageState();
}

class _ReadingPageState extends State<ReadingPage> {
  final FlutterTts _tts = FlutterTts();

  int _selectedLanguage = 0;
  int _currentText = 0;
  bool _isPlaying = false;
  bool _readingCompleted = false;

  final List<String> _languages = const [
    'English',
    'Italiano',
    'العربية',
  ];

  final List<ReadingText> _texts = const [
    ReadingText(
      englishTitle: 'My Daily Routine',
      italianTitle: 'La mia routine quotidiana',
      arabicTitle: 'روتيني اليومي',
      english: '''Every morning, I wake up early and prepare for my day.

I have breakfast, drink some water, and review my vocabulary.

After that, I continue with my daily activities.

In the evening, I spend some time reading and learning new words.

Learning a little every day helps me improve.''',
      italian: '''Ogni mattina mi sveglio presto e mi preparo per la giornata.

Faccio colazione, bevo un po’ d’acqua e ripasso il mio vocabolario.

Dopo continuo con le mie attività quotidiane.

La sera passo un po’ di tempo a leggere e a imparare nuove parole.

Imparare un po’ ogni giorno mi aiuta a migliorare.''',
      arabic: '''كل صباح أستيقظ مبكراً وأستعد ليومي.

أتناول الإفطار وأشرب بعض الماء وأراجع مفرداتي.

بعد ذلك أتابع أنشطتي اليومية.

في المساء أقضي بعض الوقت في القراءة وتعلم كلمات جديدة.

التعلم قليلاً كل يوم يساعدني على التحسن.''',
    ),
    ReadingText(
      englishTitle: 'A New Day',
      italianTitle: 'Un nuovo giorno',
      arabicTitle: 'يوم جديد',
      english: '''Today is a new day and I have a new opportunity to learn.

I do not need to be perfect.

I only need to practice, listen, read, and continue.

Every new word brings me one step closer to my goal.

I believe that consistency creates progress.''',
      italian: '''Oggi è un nuovo giorno e ho una nuova opportunità per imparare.

Non devo essere perfetto.

Devo solo esercitarmi, ascoltare, leggere e continuare.

Ogni nuova parola mi porta un passo più vicino al mio obiettivo.

Credo che la costanza crei progresso.''',
      arabic: '''اليوم يوم جديد ولدي فرصة جديدة للتعلم.

لا أحتاج إلى أن أكون مثالياً.

أحتاج فقط إلى التدريب والاستماع والقراءة والاستمرار.

كل كلمة جديدة تقربني خطوة من هدفي.

أؤمن بأن الاستمرار يصنع التقدم.''',
    ),
    ReadingText(
      englishTitle: 'Learning Languages',
      italianTitle: 'Imparare le lingue',
      arabicTitle: 'تعلم اللغات',
      english: '''Learning a language takes time and practice.

Every day I can learn something new.

I listen carefully, repeat words, and read simple texts.

Mistakes are part of learning.

With patience and consistency, I can improve.''',
      italian: '''Imparare una lingua richiede tempo e pratica.

Ogni giorno posso imparare qualcosa di nuovo.

Ascolto attentamente, ripeto le parole e leggo testi semplici.

Gli errori fanno parte dell’apprendimento.

Con pazienza e costanza posso migliorare.''',
      arabic: '''تعلم اللغة يحتاج إلى الوقت والممارسة.

كل يوم يمكنني أن أتعلم شيئاً جديداً.

أستمع بعناية وأكرر الكلمات وأقرأ نصوصاً بسيطة.

الأخطاء جزء من عملية التعلم.

بالصبر والاستمرار يمكنني أن أتطور.''',
    ),
  ];

  @override
  void initState() {
    super.initState();

    LanguageController.language.addListener(_languageChanged);

    _tts.setSpeechRate(0.42);
    _tts.setVolume(1.0);
    _tts.setPitch(1.0);

    _syncLanguage();
  }

  void _syncLanguage() {
    final language = LanguageController.current;

    if (language == 'Italiano') {
      _selectedLanguage = 1;
    } else if (language == 'العربية') {
      _selectedLanguage = 2;
    } else {
      _selectedLanguage = 0;
    }
  }

  void _languageChanged() {
    if (!mounted) return;

    setState(() {
      _syncLanguage();
    });

    _stop();
  }

  String _t({
    required String english,
    required String italian,
    required String arabic,
  }) {
    switch (_selectedLanguage) {
      case 1:
        return italian;
      case 2:
        return arabic;
      default:
        return english;
    }
  }

  ReadingText get _currentReading {
    return _texts[_currentText];
  }

  String get _currentTitle {
    final text = _currentReading;

    return _t(
      english: text.englishTitle,
      italian: text.italianTitle,
      arabic: text.arabicTitle,
    );
  }

  String get _currentTextContent {
    final text = _currentReading;

    switch (_selectedLanguage) {
      case 1:
        return text.italian;
      case 2:
        return text.arabic;
      default:
        return text.english;
    }
  }

  bool get _isArabic => _selectedLanguage == 2;

  String get _ttsLanguage {
    switch (_selectedLanguage) {
      case 1:
        return 'it-IT';
      case 2:
        return 'ar-SA';
      default:
        return 'en-US';
    }
  }

  Future<void> _speak() async {
    await _tts.stop();

    if (!mounted) return;

    setState(() {
      _isPlaying = true;
    });

    await _tts.setLanguage(_ttsLanguage);
    await _tts.setSpeechRate(0.42);
    await _tts.setVolume(1.0);
    await _tts.setPitch(1.0);

    try {
      await _tts.speak(_currentTextContent);
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _isPlaying = false;
      });
    }
  }

  Future<void> _stop() async {
    await _tts.stop();

    if (!mounted) return;

    setState(() {
      _isPlaying = false;
    });
  }

  void _changeLanguage(int index) {
    if (_isPlaying) {
      _tts.stop();
    }

    setState(() {
      _selectedLanguage = index;
      _isPlaying = false;
    });
  }

  Future<void> _completeReading() async {
    if (_readingCompleted) return;

    _readingCompleted = true;

    await HiveService.addCompletedReading();

    final progress = HiveService.completedReadings / _texts.length;

    await HiveService.setReadingProgress(
      progress.clamp(0.0, 1.0),
    );

    if (!mounted) return;

    setState(() {});
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _t(
            english: 'Reading completed! +15 XP',
            italian: 'Lettura completata! +15 XP',
            arabic: 'اكتملت القراءة! +15 XP',
          ),
          textDirection: _isArabic
              ? TextDirection.rtl
              : TextDirection.ltr,
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
  void _previousText() {
    if (_currentText == 0) return;

    if (_isPlaying) {
      _tts.stop();
    }

    setState(() {
      _currentText--;
      _isPlaying = false;
    });
  }

  Future<void> _nextText() async {
    if (_isPlaying) {
      await _tts.stop();
    }

    if (_currentText >= _texts.length - 1) {
      await _completeReading();
      return;
    }

    setState(() {
      _currentText++;
      _isPlaying = false;
    });
  }

  @override
  void dispose() {
    LanguageController.language.removeListener(_languageChanged);
    _tts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!PremiumGuard.isPremium) {
      return Scaffold(
        backgroundColor: const Color(0xFF070A12),
        appBar: AppBar(
          backgroundColor: const Color(0xFF070A12),
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          title: const Text(
            'Premium Reading',
            style: TextStyle(
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(26),
              decoration: BoxDecoration(
                color: const Color(0xFF111725),
                borderRadius: BorderRadius.circular(28),
                border: Border.all(
                  color: const Color(0xFF8B5CF6)
                      .withValues(alpha: 0.28),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 78,
                    height: 78,
                    decoration: BoxDecoration(
                      color: const Color(0xFF8B5CF6)
                          .withValues(alpha: 0.14),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.menu_book_rounded,
                      color: Color(0xFFFACC15),
                      size: 42,
                    ),
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    'Unlock Premium Reading',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                    ),
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    'Unlock unlimited reading practice and improve your language skills without limits.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF94A3B8),
                      fontSize: 13,
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 24),

                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const PremiumPage(),
                          ),
                        );

                        if (!mounted) return;

                        setState(() {});
                      },
                      icon: const Icon(
                        Icons.workspace_premium_rounded,
                      ),
                      label: const Text(
                        'Open Premium',
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF8B5CF6),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(17),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF070A12),
      appBar: AppBar(
        backgroundColor: const Color(0xFF070A12),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Reading',
          style: TextStyle(
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(18, 8, 18, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _header(),
              const SizedBox(height: 22),
              _languageSelector(),
              const SizedBox(height: 22),
              _readingCard(),
              const SizedBox(height: 18),
              _navigation(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _header() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF8B5CF6),
            Color(0xFF3B82F6),
          ],
        ),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF8B5CF6).withValues(alpha: 0.18),
            blurRadius: 25,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: const Row(
        children: [
          Icon(
            Icons.menu_book_rounded,
            color: Colors.white,
            size: 42,
          ),
          SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Improve your reading',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 19,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'Read, listen and practice every day.',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _languageSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Choose Language',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 48,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _languages.length,
            itemBuilder: (context, index) {
              final selected = index == _selectedLanguage;
              final arabic = index == 2;

              return GestureDetector(
                onTap: () => _changeLanguage(index),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.only(right: 10),
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  decoration: BoxDecoration(
                    color: selected
                        ? const Color(0xFF8B5CF6)
                        : const Color(0xFF111725),
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(
                      color: selected
                          ? const Color(0xFF9F7AEA)
                          : Colors.white.withValues(alpha: 0.05),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      _languages[index],
                      textDirection: arabic
                          ? TextDirection.rtl
                          : TextDirection.ltr,
                      style: TextStyle(
                        color: selected
                            ? Colors.white
                            : Colors.white54,
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _readingCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: const Color(0xFF111725),
        borderRadius: BorderRadius.circular(27),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.06),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  _currentTitle,
                  textDirection: _isArabic
                      ? TextDirection.rtl
                      : TextDirection.ltr,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF8B5CF6)
                      .withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${_currentText + 1}/${_texts.length}',
                  style: const TextStyle(
                    color: Color(0xFFB59CFF),
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.035),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Text(
              _currentTextContent,
              textDirection: _isArabic
                  ? TextDirection.rtl
                  : TextDirection.ltr,
              textAlign: _isArabic
                  ? TextAlign.right
                  : TextAlign.left,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                height: 1.8,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 52,
                  child: ElevatedButton.icon(
                    onPressed: _isPlaying ? _stop : _speak,
                    icon: Icon(
                      _isPlaying
                          ? Icons.stop_rounded
                          : Icons.volume_up_rounded,
                    ),
                    label: Text(
                      _isPlaying
                          ? _t(
                              english: 'Stop',
                              italian: 'Stop',
                              arabic: 'إيقاف',
                            )
                          : _t(
                              english: 'Listen',
                              italian: 'Ascolta',
                              arabic: 'استمع',
                            ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.cyan,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _navigation() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed:
                _currentText > 0 ? _previousText : null,
            icon: const Icon(
              Icons.arrow_back_rounded,
            ),
            label: Text(
              _t(
                english: 'Previous',
                italian: 'Precedente',
                arabic: 'السابق',
              ),
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white,
              disabledForegroundColor: Colors.white24,
              side: BorderSide(
                color: Colors.white.withValues(alpha: 0.08),
              ),
              padding: const EdgeInsets.symmetric(
                vertical: 15,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: _nextText,
            icon: const Icon(
              Icons.arrow_forward_rounded,
            ),
            label: Text(
              _t(
                english: 'Next',
                italian: 'Successivo',
                arabic: 'التالي',
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF8B5CF6),
              foregroundColor: Colors.white,
              disabledBackgroundColor:
                  Colors.white.withValues(alpha: 0.06),
              disabledForegroundColor: Colors.white24,
              elevation: 0,
              padding: const EdgeInsets.symmetric(
                vertical: 15,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class ReadingQuestion {
  final String question;
  final List<String> options;
  final String correctAnswer;
  final String explanation;

  const ReadingQuestion({
    required this.question,
    required this.options,
    required this.correctAnswer,
    required this.explanation,
  });
}
const List<List<ReadingQuestion>> readingQuestions = [
  [
    ReadingQuestion(
      question: 'What does the person do every morning?',
      options: [
        'Wakes up early',
        'Goes to school',
        'Works at night',
        'Travels',
      ],
      correctAnswer: 'Wakes up early',
      explanation: 'The text says that the person wakes up early every morning.',
    ),
    ReadingQuestion(
      question: 'What does the person prepare for?',
      options: [
        'The day',
        'A trip',
        'A test',
        'A party',
      ],
      correctAnswer: 'The day',
      explanation: 'The text explains that the person prepares for the day.',
    ),
    ReadingQuestion(
      question: 'When does the person wake up?',
      options: [
        'Every morning',
        'Every evening',
        'At midnight',
        'Only on weekends',
      ],
      correctAnswer: 'Every morning',
      explanation: 'The phrase Every morning tells us when the person wakes up.',
    ),
  ],
  [
    ReadingQuestion(
      question: 'What is today described as?',
      options: [
        'A new day',
        'A difficult day',
        'A holiday',
        'A busy evening',
      ],
      correctAnswer: 'A new day',
      explanation: 'The text begins by saying that today is a new day.',
    ),
    ReadingQuestion(
      question: 'What opportunity does the person have?',
      options: [
        'An opportunity to learn',
        'An opportunity to travel',
        'An opportunity to work',
        'An opportunity to sleep',
      ],
      correctAnswer: 'An opportunity to learn',
      explanation: 'The text says there is a new opportunity to learn.',
    ),
    ReadingQuestion(
      question: 'What does the text encourage?',
      options: [
        'Learning',
        'Sleeping',
        'Shopping',
        'Travelling',
      ],
      correctAnswer: 'Learning',
      explanation: 'The main idea is about seeing a new day as an opportunity to learn.',
    ),
  ],
  [
    ReadingQuestion(
      question: 'What does learning a language require?',
      options: [
        'Time and practice',
        'Only money',
        'Only books',
        'No effort',
      ],
      correctAnswer: 'Time and practice',
      explanation: 'The text clearly states that learning a language takes time and practice.',
    ),
    ReadingQuestion(
      question: 'What is important when learning a language?',
      options: [
        'Consistency and practice',
        'Giving up quickly',
        'Avoiding practice',
        'Only memorizing words',
      ],
      correctAnswer: 'Consistency and practice',
      explanation: 'Regular practice and consistency help language learners improve.',
    ),
    ReadingQuestion(
      question: 'What is the main topic of the text?',
      options: [
        'Learning languages',
        'Travelling',
        'Daily routines',
        'Cooking',
      ],
      correctAnswer: 'Learning languages',
      explanation: 'The text focuses on the time and practice needed to learn a language.',
    ),
  ],
];
class ReadingText {
  final String englishTitle;
  final String italianTitle;
  final String arabicTitle;

  final String english;
  final String italian;
  final String arabic;

  const ReadingText({
    required this.englishTitle,
    required this.italianTitle,
    required this.arabicTitle,
    required this.english,
    required this.italian,
    required this.arabic,
  });
}











