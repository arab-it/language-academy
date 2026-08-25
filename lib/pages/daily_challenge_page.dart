import 'package:flutter/material.dart';
import 'package:arab_it/core/theme/app_colors.dart';
import '../services/progress_service.dart';
import '../database/hive_service.dart';

class DailyChallengePage extends StatefulWidget {
  const DailyChallengePage({super.key});

  @override
  State<DailyChallengePage> createState() => _DailyChallengePageState();
}

class _DailyChallengePageState extends State<DailyChallengePage> {
  static const Color bg = Color(0xFF070A12);
  static const Color card = Color(0xFF111725);
  static const Color purple = Color(0xFF8B5CF6);
  static const Color cyan = AppColors.cyan;
  static const Color green = Color(0xFF22C55E);
  static const Color white = Colors.white;
  static const Color muted = Color(0xFF94A3B8);

  final List<Map<String, dynamic>> challenges = [
    {
      'question': 'What does "Hello" mean?',
      'answers': [
        'Goodbye',
        'Hello / Greeting',
        'Thank you',
        'Please',
      ],
      'correct': 1,
    },
    {
      'question': 'What does "Grazie" mean?',
      'answers': [
        'Please',
        'Good morning',
        'Thank you',
        'Goodbye',
      ],
      'correct': 2,
    },
    {
      'question': 'What does "Please" mean?',
      'answers': [
        'A polite request',
        'Goodbye',
        'Thank you',
        'Morning',
      ],
      'correct': 0,
    },
  ];

  int currentIndex = 0;
  int? selectedAnswer;
  int correctAnswers = 0;

  bool answered = false;
  bool completed = false;
  bool isSaving = false;
  bool alreadyCompletedToday = false;

  Map<String, dynamic> get challenge => challenges[currentIndex];

    @override
  void initState() {
    super.initState();
    _loadDailyChallengeStatus();
  }



  Future<void> _loadDailyChallengeStatus() async {
    final completed =
        await ProgressService.isDailyChallengeCompleted();

    if (!mounted) return;

    setState(() {
      alreadyCompletedToday = completed;
    });
  }
  void _selectAnswer(int index) {
    if (answered || completed || alreadyCompletedToday) return;

    setState(() {
      selectedAnswer = index;
      answered = true;

      if (index == challenge['correct']) {
        correctAnswers++;
      }
    });
  }

  Future<void> _nextChallenge() async {
    if (!answered || isSaving || alreadyCompletedToday) return;

    if (currentIndex < challenges.length - 1) {
      setState(() {
        currentIndex++;
        selectedAnswer = null;
        answered = false;
      });
      return;
    }

    await _finishChallenge();
  }

  Future<void> _finishChallenge() async {
    if (isSaving || completed || alreadyCompletedToday) return;

    setState(() {
      isSaving = true;
    });

    final xp = correctAnswers * 20;

    if (xp > 0) {
      await ProgressService.addXP(xp);
    }

    await HiveService.updateDailyStreak();
    await ProgressService.markDailyChallengeCompleted();

    if (!mounted) return;

    setState(() {
      isSaving = false;
      completed = true;
      alreadyCompletedToday = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Challenge completed! +$xp XP',
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        foregroundColor: white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Daily Challenge',
          style: TextStyle(
            color: white,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
      body: SafeArea(
        child: alreadyCompletedToday && !completed
            ? _alreadyCompletedView()
            : completed
                ? _completedView()
                : SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(
                      18,
                      10,
                      18,
                      30,
                    ),
                    child: Column(
                      children: [
                        _header(),
                        const SizedBox(height: 20),
                        _progress(),
                        const SizedBox(height: 22),
                        _questionCard(),
                        const SizedBox(height: 18),
                        _answers(),
                        const SizedBox(height: 20),
                        _nextButton(),
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
          colors: [
            Color(0xFF4C1D95),
            Color(0xFF1D4ED8),
            Color(0xFF0E7490),
          ],
        ),
        borderRadius: BorderRadius.circular(26),
      ),
      child: const Row(
        children: [
          Icon(
            Icons.local_fire_department_rounded,
            color: Colors.orangeAccent,
            size: 42,
          ),
          SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Daily Challenge',
                  style: TextStyle(
                    color: white,
                    fontSize: 21,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Answer the questions and earn XP.',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _progress() {
    final progress =
        (currentIndex + 1) / challenges.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment:
              MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Question ${currentIndex + 1} of ${challenges.length}',
              style: const TextStyle(
                color: white,
                fontSize: 13,
                fontWeight: FontWeight.w800,
              ),
            ),
            Text(
              '$correctAnswers correct',
              style: const TextStyle(
                color: green,
                fontSize: 12,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 8,
            backgroundColor: card,
            valueColor:
                const AlwaysStoppedAnimation<Color>(purple),
          ),
        ),
      ],
    );
  }

  Widget _questionCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: white.withValues(alpha: 0.06),
        ),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.quiz_rounded,
            color: cyan,
            size: 38,
          ),
          const SizedBox(height: 16),
          Text(
            challenge['question'] as String,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: white,
              fontSize: 21,
              fontWeight: FontWeight.w900,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _answers() {
    final answers =
        challenge['answers'] as List<String>;
    final correct =
        challenge['correct'] as int;

    return Column(
      children: List.generate(
        answers.length,
        (index) {
          final selected =
              selectedAnswer == index;
          final isCorrect =
              index == correct;

          Color borderColor =
              white.withValues(alpha: 0.06);
          Color background = card;
          IconData? icon;

          if (answered && isCorrect) {
            borderColor = green;
            background =
                green.withValues(alpha: 0.10);
            icon = Icons.check_circle_rounded;
          } else if (answered &&
              selected &&
              !isCorrect) {
            borderColor = Colors.redAccent;
            background =
                Colors.redAccent.withValues(
              alpha: 0.10,
            );
            icon = Icons.cancel_rounded;
          }

          return GestureDetector(
            onTap: () => _selectAnswer(index),
            child: AnimatedContainer(
              duration:
                  const Duration(milliseconds: 180),
              width: double.infinity,
              margin:
                  const EdgeInsets.only(bottom: 11),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: background,
                borderRadius:
                    BorderRadius.circular(18),
                border: Border.all(
                  color: borderColor,
                  width: 1.3,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color:
                          white.withValues(alpha: 0.06),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        String.fromCharCode(
                          65 + index,
                        ),
                        style: const TextStyle(
                          color: white,
                          fontWeight:
                              FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 13),
                  Expanded(
                    child: Text(
                      answers[index],
                      style: const TextStyle(
                        color: white,
                        fontSize: 14,
                        fontWeight:
                            FontWeight.w700,
                      ),
                    ),
                  ),
                  if (icon != null)
                    Icon(
                      icon,
                      color: isCorrect
                          ? green
                          : Colors.redAccent,
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _nextButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed:
            answered && !isSaving
                ? _nextChallenge
                : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: purple,
          foregroundColor: white,
          disabledBackgroundColor: card,
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(18),
          ),
        ),
        child: Text(
          currentIndex ==
                  challenges.length - 1
              ? 'Finish Challenge'
              : 'Next Question',
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }

  Widget _alreadyCompletedView() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(22),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: card,
            borderRadius:
                BorderRadius.circular(28),
            border: Border.all(
              color:
                  Colors.orange.withValues(
                alpha: 0.25,
              ),
            ),
          ),
          child: Column(
            children: [
              const Icon(
                Icons.check_circle_rounded,
                color: green,
                size: 78,
              ),
              const SizedBox(height: 20),
              const Text(
                'Completed Today',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: white,
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'You already completed today\'s challenge.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: muted,
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 22),
              Container(
                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color:
                      green.withValues(alpha: 0.10),
                  borderRadius:
                      BorderRadius.circular(16),
                ),
                child: const Text(
                  'Come back tomorrow for a new challenge.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: green,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _completedView() {
    final xp = correctAnswers * 20;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(22),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: card,
            borderRadius:
                BorderRadius.circular(28),
            border: Border.all(
              color:
                  green.withValues(alpha: 0.25),
            ),
          ),
          child: Column(
            children: [
              const Icon(
                Icons.emoji_events_rounded,
                color: Colors.amber,
                size: 75,
              ),
              const SizedBox(height: 18),
              const Text(
                'Challenge Complete!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: white,
                  fontSize: 25,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                '$correctAnswers / ${challenges.length} correct',
                style: const TextStyle(
                  color: cyan,
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 22,
                  vertical: 13,
                ),
                decoration: BoxDecoration(
                  color:
                      green.withValues(alpha: 0.10),
                  borderRadius:
                      BorderRadius.circular(18),
                ),
                child: Text(
                  '+$xp XP',
                  style: const TextStyle(
                    color: green,
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Your progress and streak have been updated.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: muted,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}













