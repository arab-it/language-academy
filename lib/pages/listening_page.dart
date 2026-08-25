import 'package:flutter/material.dart';
import 'package:arab_it/core/theme/app_colors.dart';
import 'package:flutter_tts/flutter_tts.dart';

class ListeningPage extends StatefulWidget {
  const ListeningPage({super.key});

  @override
  State<ListeningPage> createState() => _ListeningPageState();
}

class _ListeningPageState extends State<ListeningPage> {
  static const Color bg = Color(0xFF070A12);
  static const Color card = Color(0xFF111725);
  static const Color cyan = AppColors.cyan;
  static const Color blue = Color(0xFF3B82F6);
  static const Color green = Color(0xFF22C55E);
  static const Color orange = Color(0xFFF97316);
  static const Color purple = Color(0xFF8B5CF6);
  static const Color white = Colors.white;
  static const Color muted = Color(0xFF94A3B8);

  final FlutterTts _tts = FlutterTts();

  String selectedLanguage = 'English';
  int currentQuestion = 0;
  int score = 0;
  bool playing = false;
  String? selectedAnswer;

  final List<Map<String, dynamic>> questions = [
    {
      'language': 'English',
      'text': 'Hello, how are you today?',
      'question': 'What greeting did you hear?',
      'answers': ['Hello', 'Goodbye', 'Thank you', 'Good night'],
      'correct': 'Hello',
    },
    {
      'language': 'English',
      'text': 'I would like a glass of water, please.',
      'question': 'What does the speaker want?',
      'answers': ['Coffee', 'Water', 'Food', 'Tea'],
      'correct': 'Water',
    },
    {
      'language': 'English',
      'text': 'My name is Daniel. Nice to meet you.',
      'question': 'What is the speaker doing?',
      'answers': [
        'Introducing himself',
        'Ordering food',
        'Asking for directions',
        'Saying goodbye',
      ],
      'correct': 'Introducing himself',
    },
    {
      'language': 'Italian',
      'text': 'Ciao, come stai oggi?',
      'question': 'What greeting did you hear?',
      'answers': ['Ciao', 'Grazie', 'Arrivederci', 'Buonanotte'],
      'correct': 'Ciao',
    },
    {
      'language': 'Italian',
      'text': 'Vorrei un bicchiere d’acqua, per favore.',
      'question': 'What does the speaker want?',
      'answers': ['Acqua', 'Caffè', 'Pane', 'Tè'],
      'correct': 'Acqua',
    },
    {
      'language': 'Italian',
      'text': 'Mi chiamo Marco. Piacere di conoscerti.',
      'question': 'What is the speaker doing?',
      'answers': [
        'Presenting himself',
        'Ordering food',
        'Asking for directions',
        'Saying goodbye',
      ],
      'correct': 'Presenting himself',
    },
    {
      'language': 'Arabic',
      'text': 'مرحباً، كيف حالك اليوم؟',
      'question': 'ما هي التحية التي سمعتها؟',
      'answers': ['مرحباً', 'شكراً', 'مع السلامة', 'تصبح على خير'],
      'correct': 'مرحباً',
    },
    {
      'language': 'Arabic',
      'text': 'أريد كوباً من الماء، من فضلك.',
      'question': 'ماذا يريد المتحدث؟',
      'answers': ['الماء', 'القهوة', 'الخبز', 'الشاي'],
      'correct': 'الماء',
    },
    {
      'language': 'Arabic',
      'text': 'اسمي أحمد. تشرفت بمعرفتك.',
      'question': 'ماذا يفعل المتحدث؟',
      'answers': [
        'يقدم نفسه',
        'يطلب الطعام',
        'يسأل عن الاتجاهات',
        'يودع شخصاً',
      ],
      'correct': 'يقدم نفسه',
    },
  ];

  @override
  void initState() {
    super.initState();
    _configureTts();
  }

  Future<void> _configureTts() async {
    await _tts.setSpeechRate(0.42);
    await _tts.setVolume(1.0);
    await _tts.setPitch(1.0);

    _tts.setStartHandler(() {
      if (mounted) {
        setState(() {
          playing = true;
        });
      }
    });

    _tts.setCompletionHandler(() {
      if (mounted) {
        setState(() {
          playing = false;
        });
      }
    });

    _tts.setCancelHandler(() {
      if (mounted) {
        setState(() {
          playing = false;
        });
      }
    });

    _tts.setErrorHandler((_) {
      if (mounted) {
        setState(() {
          playing = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _tts.stop();
    super.dispose();
  }

  List<Map<String, dynamic>> get currentQuestions {
    return questions
        .where((question) => question['language'] == selectedLanguage)
        .toList();
  }

  Map<String, dynamic> get current => currentQuestions[currentQuestion];

  String get languageCode {
    switch (selectedLanguage) {
      case 'Italian':
        return 'it-IT';
      case 'Arabic':
        return 'ar-SA';
      default:
        return 'en-US';
    }
  }

  Color get languageColor {
    switch (selectedLanguage) {
      case 'Italian':
        return green;
      case 'Arabic':
        return orange;
      default:
        return blue;
    }
  }

  bool get isArabic => selectedLanguage == 'Arabic';

  Future<void> _speak() async {
    await _tts.stop();

    setState(() {
      playing = true;
    });

    await _tts.setLanguage(languageCode);
    await _tts.speak(current['text']);
  }

  void _selectAnswer(String answer) {
    if (selectedAnswer != null) return;

    final correct = answer == current['correct'];

    setState(() {
      selectedAnswer = answer;

      if (correct) {
        score++;
      }
    });
  }

  void _nextQuestion() {
    if (selectedAnswer == null) return;

    if (currentQuestion < currentQuestions.length - 1) {
      setState(() {
        currentQuestion++;
        selectedAnswer = null;
      });
    } else {
      _showResult();
    }
  }

  void _showResult() {
    final total = currentQuestions.length;
    final percentage = ((score / total) * 100).round();

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isDismissible: false,
      enableDrag: false,
      builder: (sheetContext) {
        return Container(
          padding: const EdgeInsets.fromLTRB(24, 28, 24, 30),
          decoration: const BoxDecoration(
            color: card,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(30),
            ),
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 74,
                  height: 74,
                  decoration: BoxDecoration(
                    color: green.withValues(alpha: 0.13),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.headphones_rounded,
                    color: green,
                    size: 36,
                  ),
                ),
                const SizedBox(height: 18),
                const Text(
                  'Listening complete',
                  style: TextStyle(
                    color: white,
                    fontSize: 23,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '$score / $total correct',
                  style: const TextStyle(
                    color: cyan,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  '$percentage% accuracy',
                  style: const TextStyle(
                    color: muted,
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 22),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(sheetContext).pop();
                      setState(() {
                        currentQuestion = 0;
                        score = 0;
                        selectedAnswer = null;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: cyan,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      'Practice again',
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final total = currentQuestions.length;
    final progress = (currentQuestion + 1) / total;

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Directionality(
          textDirection:
              isArabic ? TextDirection.rtl : TextDirection.ltr,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(18, 15, 18, 35),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _header(),
                const SizedBox(height: 22),
                _languageSelector(),
                const SizedBox(height: 20),
                _progressCard(progress),
                const SizedBox(height: 20),
                _listeningCard(),
                const SizedBox(height: 18),
                _questionCard(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _header() {
    return Row(
      children: [
        GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: card,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: white.withValues(alpha: 0.06),
              ),
            ),
            child: const Icon(
              Icons.arrow_back_rounded,
              color: white,
              size: 20,
            ),
          ),
        ),
        const SizedBox(width: 12),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'LISTENING',
                style: TextStyle(
                  color: cyan,
                  fontSize: 9,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.4,
                ),
              ),
              SizedBox(height: 3),
              Text(
                'Train your ear',
                style: TextStyle(
                  color: white,
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: cyan.withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Icon(
            Icons.headphones_rounded,
            color: cyan,
            size: 21,
          ),
        ),
      ],
    );
  }

  Widget _languageSelector() {
    final languages = [
      ('English', 'EN', blue),
      ('Italian', 'IT', green),
      ('Arabic', 'AR', orange),
    ];

    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: white.withValues(alpha: 0.06),
        ),
      ),
      child: Row(
        children: languages.map((language) {
          final selected = selectedLanguage == language.$1;

          return Expanded(
            child: GestureDetector(
              onTap: () {
                if (selected) return;

                setState(() {
                  selectedLanguage = language.$1;
                  currentQuestion = 0;
                  score = 0;
                  selectedAnswer = null;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: 48,
                decoration: BoxDecoration(
                  color: selected
                      ? language.$3.withValues(alpha: 0.14)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(13),
                  border: Border.all(
                    color: selected
                        ? language.$3.withValues(alpha: 0.45)
                        : Colors.transparent,
                  ),
                ),
                child: Center(
                  child: Text(
                    language.$1 == 'Arabic'
                        ? 'العربية'
                        : language.$1 == 'Italian'
                            ? 'Italiano'
                            : 'English',
                    style: TextStyle(
                      color: selected ? language.$3 : muted,
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _progressCard(double progress) {
    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(21),
        border: Border.all(
          color: white.withValues(alpha: 0.055),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 43,
                height: 43,
                decoration: BoxDecoration(
                  color: languageColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Icon(
                  Icons.graphic_eq_rounded,
                  color: languageColor,
                  size: 21,
                ),
              ),
              const SizedBox(width: 11),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Listening progress',
                      style: TextStyle(
                        color: white,
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '${currentQuestion + 1} of ${currentQuestions.length}',
                      style: const TextStyle(
                        color: muted,
                        fontSize: 9,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '${(progress * 100).round()}%',
                style: TextStyle(
                  color: languageColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 13),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 7,
              backgroundColor: white.withValues(alpha: 0.06),
              valueColor:
                  AlwaysStoppedAnimation<Color>(languageColor),
            ),
          ),
        ],
      ),
    );
  }

  Widget _listeningCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            languageColor.withValues(alpha: 0.30),
            const Color(0xFF111725),
          ],
        ),
        borderRadius: BorderRadius.circular(27),
        border: Border.all(
          color: languageColor.withValues(alpha: 0.25),
        ),
        boxShadow: [
          BoxShadow(
            color: languageColor.withValues(alpha: 0.08),
            blurRadius: 28,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'LISTEN',
            style: TextStyle(
              color: languageColor,
              fontSize: 9,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: _speak,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 86,
              height: 86,
              decoration: BoxDecoration(
                color: playing
                    ? languageColor.withValues(alpha: 0.25)
                    : white.withValues(alpha: 0.08),
                shape: BoxShape.circle,
                border: Border.all(
                  color: languageColor.withValues(alpha: 0.45),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: languageColor.withValues(
                      alpha: playing ? 0.25 : 0.08,
                    ),
                    blurRadius: 28,
                  ),
                ],
              ),
              child: Icon(
                playing
                    ? Icons.volume_up_rounded
                    : Icons.play_arrow_rounded,
                color: white,
                size: 39,
              ),
            ),
          ),
          const SizedBox(height: 18),
          Text(
            current['text'],
            textAlign: TextAlign.center,
            textDirection:
                isArabic ? TextDirection.rtl : TextDirection.ltr,
            style: TextStyle(
              color: white,
              fontSize: isArabic ? 22 : 18,
              height: 1.45,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 9),
          const Text(
            'Tap the button to listen again',
            style: TextStyle(
              color: muted,
              fontSize: 9,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _questionCard() {
    final answers = current['answers'] as List<dynamic>;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(19),
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(23),
        border: Border.all(
          color: white.withValues(alpha: 0.055),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'QUESTION',
            style: TextStyle(
              color: purple,
              fontSize: 9,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            current['question'],
            textDirection:
                isArabic ? TextDirection.rtl : TextDirection.ltr,
            style: const TextStyle(
              color: white,
              fontSize: 15,
              height: 1.35,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 15),
          ...answers.map(
            (answer) => Padding(
              padding: const EdgeInsets.only(bottom: 9),
              child: _answerButton(answer.toString()),
            ),
          ),
          const SizedBox(height: 4),
          SizedBox(
            width: double.infinity,
            height: 51,
            child: ElevatedButton(
              onPressed: selectedAnswer == null ? null : _nextQuestion,
              style: ElevatedButton.styleFrom(
                backgroundColor: cyan,
                disabledBackgroundColor:
                    white.withValues(alpha: 0.06),
                foregroundColor: white,
                disabledForegroundColor: muted,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: Text(
                currentQuestion == currentQuestions.length - 1
                    ? 'Finish'
                    : 'Next',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _answerButton(String answer) {
    final selected = selectedAnswer == answer;
    final correct = answer == current['correct'];

    Color borderColor = white.withValues(alpha: 0.06);
    Color backgroundColor = white.withValues(alpha: 0.025);
    Color textColor = white;

    if (selected && correct) {
      borderColor = green.withValues(alpha: 0.55);
      backgroundColor = green.withValues(alpha: 0.12);
      textColor = green;
    } else if (selected && !correct) {
      borderColor = Colors.red.withValues(alpha: 0.55);
      backgroundColor = Colors.red.withValues(alpha: 0.10);
      textColor = Colors.redAccent;
    }

    if (selectedAnswer != null && !selected && correct) {
      borderColor = green.withValues(alpha: 0.30);
      backgroundColor = green.withValues(alpha: 0.06);
    }

    return GestureDetector(
      onTap: () => _selectAnswer(answer),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 13,
        ),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: borderColor),
        ),
        child: Row(
          children: [
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: selected
                    ? textColor.withValues(alpha: 0.14)
                    : Colors.transparent,
                border: Border.all(
                  color: selected
                      ? textColor
                      : white.withValues(alpha: 0.20),
                ),
              ),
              child: selected
                  ? Icon(
                      correct
                          ? Icons.check_rounded
                          : Icons.close_rounded,
                      color: textColor,
                      size: 14,
                    )
                  : null,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                answer,
                textDirection:
                    isArabic ? TextDirection.rtl : TextDirection.ltr,
                style: TextStyle(
                  color: textColor,
                  fontSize: isArabic ? 12 : 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}




