import 'package:flutter/material.dart';

import '../services/progress_service.dart';
import 'quiz_page.dart';

class LessonDetailPage extends StatefulWidget {
  final String lessonId;
  final String language;
  final String lessonTitle;
  final int xp;

  const LessonDetailPage({
    super.key,
    required this.lessonId,
    required this.language,
    required this.lessonTitle,
    required this.xp,
  });

  @override
  State<LessonDetailPage> createState() => _LessonDetailPageState();
}

class _LessonDetailPageState extends State<LessonDetailPage>
    with SingleTickerProviderStateMixin {
  static const Color background = Color(0xFF07090D);
  static const Color surface = Color(0xFF11151C);
  static const Color surface2 = Color(0xFF171D26);
  static const Color green = Color(0xFF00A86B);
  static const Color greenLight = Color(0xFF35D69A);
  static const Color blue = Color(0xFF4DA3FF);
  static const Color orange = Color(0xFFFFB020);
  static const Color purple = Color(0xFF9B6DFF);
  static const Color muted = Color(0xFF8E99A8);

  late AnimationController _animationController;

  int currentStep = 0;
  bool completed = false;
  bool saving = false;

  final List<Map<String, String>> vocabulary = const [
    {
      'word': 'Hello',
      'translation': 'A common greeting',
      'example': 'Hello, nice to meet you.',
    },
    {
      'word': 'Welcome',
      'translation': 'A friendly greeting',
      'example': 'Welcome to our lesson.',
    },
    {
      'word': 'Learn',
      'translation': 'To gain knowledge or skill',
      'example': 'I want to learn a new language.',
    },
  ];

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  String get languageDisplay {
    switch (widget.language) {
      case 'Italian':
        return 'Italiano';
      case 'Arabic':
        return 'العربية';
      default:
        return 'English';
    }
  }

  String get languageFlag {
    switch (widget.language) {
      case 'Italian':
        return '🇮🇹';
      case 'Arabic':
        return '🇸🇦';
      default:
        return '🇬🇧';
    }
  }

  Future<void> _completeLesson() async {
    if (completed || saving) return;

    setState(() {
      saving = true;
    });

    try {
      final firstCompletion =
          await ProgressService.completeLesson(
        widget.lessonId,
        xpReward: widget.xp,
      );

      if (!mounted) return;

      setState(() {
        completed = true;
        saving = false;
      });

      if (firstCompletion) {
        _showSuccess();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'This lesson is already completed.',
            ),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (_) {
      if (!mounted) return;

      setState(() {
        saving = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not save your progress. Please try again.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _showSuccess() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isDismissible: false,
      enableDrag: false,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.fromLTRB(24, 28, 24, 30),
          decoration: const BoxDecoration(
            color: surface,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(30),
            ),
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [green, greenLight],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: green.withValues(alpha: 0.28),
                        blurRadius: 25,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    color: Colors.white,
                    size: 38,
                  ),
                ),
                const SizedBox(height: 18),
                const Text(
                  'Lesson completed',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 23,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  '+${widget.xp} XP added to your progress',
                  style: const TextStyle(
                    color: greenLight,
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 22),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(this.context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: green,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      'Continue',
                      style: TextStyle(
                        fontSize: 13,
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

  void _showInfo(String title, String text) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.fromLTRB(24, 25, 24, 30),
          decoration: const BoxDecoration(
            color: surface,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(28),
            ),
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 21,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  text,
                  style: const TextStyle(
                    color: muted,
                    fontSize: 12,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 22),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: surface2,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: const Text(
                      'Got it',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
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
    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: FadeTransition(
          opacity: CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOut,
          ),
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(child: _buildHeader()),
              SliverToBoxAdapter(child: _buildHero()),
              SliverToBoxAdapter(child: _buildLearningPath()),
              SliverToBoxAdapter(child: _buildVocabulary()),
              SliverToBoxAdapter(child: _buildPractice()),
              SliverToBoxAdapter(child: _buildStartQuizButton()),
              SliverToBoxAdapter(child: _buildCompleteButton()),
              const SliverToBoxAdapter(
                child: SizedBox(height: 35),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 14, 18, 10),
      child: Row(
        children: [
          _roundButton(
            icon: Icons.arrow_back_rounded,
            onTap: () => Navigator.of(context).pop(),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'LESSON',
                  style: TextStyle(
                    color: greenLight,
                    fontSize: 9,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.4,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  languageDisplay,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
          _roundButton(
            icon: Icons.info_outline_rounded,
            onTap: () {
              _showInfo(
                'About this lesson',
                'Complete the learning sections and finish the lesson to receive your XP reward.',
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _roundButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: surface,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.055),
            ),
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: 20,
          ),
        ),
      ),
    );
  }

  Widget _buildHero() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 10, 18, 18),
      child: Container(
        padding: const EdgeInsets.all(21),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF10251D),
              Color(0xFF0C1412),
            ],
          ),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: green.withValues(alpha: 0.22),
          ),
          boxShadow: [
            BoxShadow(
              color: green.withValues(alpha: 0.06),
              blurRadius: 30,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: green.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: Text(
                    '$languageFlag  $languageDisplay',
                    style: const TextStyle(
                      color: greenLight,
                      fontSize: 9,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: orange.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.bolt_rounded,
                        color: orange,
                        size: 14,
                      ),
                      const SizedBox(width: 3),
                      Text(
                        '+${widget.xp} XP',
                        style: const TextStyle(
                          color: orange,
                          fontSize: 9,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              widget.lessonTitle,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 27,
                height: 1.08,
                fontWeight: FontWeight.w900,
                letterSpacing: -0.6,
              ),
            ),
            const SizedBox(height: 9),
            const Text(
              'Learn something useful today. Keep your progress moving forward.',
              style: TextStyle(
                color: muted,
                fontSize: 11,
                height: 1.45,
              ),
            ),
            const SizedBox(height: 19),
            Row(
              children: [
                _miniStat(
                  Icons.menu_book_rounded,
                  '3',
                  'Sections',
                  blue,
                ),
                const SizedBox(width: 9),
                _miniStat(
                  Icons.schedule_rounded,
                  '5 min',
                  'Duration',
                  purple,
                ),
                const SizedBox(width: 9),
                _miniStat(
                  Icons.workspace_premium_rounded,
                  '${widget.xp}',
                  'XP',
                  orange,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _miniStat(
    IconData icon,
    String value,
    String label,
    Color color,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 4,
        ),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.045),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: color,
              size: 17,
            ),
            const SizedBox(height: 5),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(
                color: muted,
                fontSize: 7,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLearningPath() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 0, 18, 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionHeader(
            'Learning path',
            'Build the lesson step by step',
          ),
          const SizedBox(height: 12),
          _learningCard(
            number: '01',
            icon: Icons.record_voice_over_rounded,
            color: blue,
            title: 'Understand',
            description: 'Read the key idea and pronunciation.',
            active: currentStep >= 0,
          ),
          const SizedBox(height: 9),
          _learningCard(
            number: '02',
            icon: Icons.menu_book_rounded,
            color: purple,
            title: 'Vocabulary',
            description: 'Learn useful words and examples.',
            active: currentStep >= 1,
          ),
          const SizedBox(height: 9),
          _learningCard(
            number: '03',
            icon: Icons.psychology_rounded,
            color: orange,
            title: 'Practice',
            description: 'Review what you have learned.',
            active: currentStep >= 2,
          ),
        ],
      ),
    );
  }

  Widget _sectionHeader(
    String title,
    String subtitle,
  ) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                subtitle,
                style: const TextStyle(
                  color: muted,
                  fontSize: 9,
                ),
              ),
            ],
          ),
        ),
        if (completed)
          const Icon(
            Icons.check_circle_rounded,
            color: green,
            size: 21,
          ),
      ],
    );
  }

  Widget _learningCard({
    required String number,
    required IconData icon,
    required Color color,
    required String title,
    required String description,
    required bool active,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          setState(() {
            if (number == '01') {
              currentStep = 0;
            } else if (number == '02') {
              currentStep = 1;
            } else {
              currentStep = 2;
            }
          });
        },
        borderRadius: BorderRadius.circular(20),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: active
                ? color.withValues(alpha: 0.07)
                : surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: active
                  ? color.withValues(alpha: 0.20)
                  : Colors.white.withValues(alpha: 0.05),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 47,
                height: 47,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.11),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 21,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          number,
                          style: TextStyle(
                            color: color,
                            fontSize: 8,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1,
                          ),
                        ),
                        const SizedBox(width: 7),
                        Text(
                          title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: const TextStyle(
                        color: muted,
                        fontSize: 9,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.white.withValues(alpha: 0.28),
                size: 13,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVocabulary() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 0, 18, 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionHeader(
            'Key vocabulary',
            'Words worth remembering',
          ),
          const SizedBox(height: 12),
          ...vocabulary.asMap().entries.map(
                (entry) => _vocabularyCard(
                  entry.value,
                  entry.key,
                ),
              ),
        ],
      ),
    );
  }

  Widget _vocabularyCard(
    Map<String, String> word,
    int index,
  ) {
    final colors = [green, blue, purple];
    final color = colors[index % colors.length];

    return Container(
      margin: const EdgeInsets.only(bottom: 9),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.05),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              Icons.volume_up_rounded,
              color: color,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  word['word']!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  word['translation']!,
                  style: const TextStyle(
                    color: muted,
                    fontSize: 9,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  word['example']!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: color.withValues(alpha: 0.9),
                    fontSize: 9,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPractice() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 0, 18, 22),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF171325),
              Color(0xFF11151C),
            ],
          ),
          borderRadius: BorderRadius.circular(23),
          border: Border.all(
            color: purple.withValues(alpha: 0.17),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: purple.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: const Icon(
                    Icons.psychology_rounded,
                    color: purple,
                    size: 21,
                  ),
                ),
                const SizedBox(width: 11),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Quick practice',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      SizedBox(height: 3),
                      Text(
                        'Test your memory before finishing.',
                        style: TextStyle(
                          color: muted,
                          fontSize: 9,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 17),
            const Text(
              'What is the main goal of this lesson?',
              style: TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 12),
            _practiceOption('Build useful language skills', true),
            const SizedBox(height: 7),
            _practiceOption('Change your device settings', false),
            const SizedBox(height: 7),
            _practiceOption('Create a new social account', false),
          ],
        ),
      ),
    );
  }

  Widget _practiceOption(
    String text,
    bool correct,
  ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          _showInfo(
            correct ? 'Great choice' : 'Keep practicing',
            correct
                ? 'You are ready to continue with the lesson.'
                : 'Review the lesson sections and try again.',
          );
        },
        borderRadius: BorderRadius.circular(14),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            horizontal: 13,
            vertical: 12,
          ),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.035),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.05),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 19,
                height: 19,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.22),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  text,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildStartQuizButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF24143D),
              Color(0xFF151B2A),
            ],
          ),
          borderRadius: BorderRadius.circular(23),
          border: Border.all(
            color: purple.withValues(alpha: 0.22),
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
                    color: purple.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.quiz_rounded,
                    color: purple,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Lesson Quiz',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Test what you learned in this lesson.',
                        style: TextStyle(
                          color: muted,
                          fontSize: 9,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.white38,
                  size: 14,
                ),
              ],
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                _quizInfo(
                  Icons.help_outline_rounded,
                  '10',
                  'Questions',
                ),
                const SizedBox(width: 8),
                _quizInfo(
                  Icons.timer_outlined,
                  '5 min',
                  'Duration',
                ),
                const SizedBox(width: 8),
                _quizInfo(
                  Icons.bolt_rounded,
                  '${widget.xp}',
                  'XP',
                ),
              ],
            ),
            const SizedBox(height: 15),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => QuizPage(
                        lessonId: widget.lessonId,
                        lessonTitle: widget.lessonTitle,
                        language: widget.language,
                      ),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.play_arrow_rounded,
                  size: 21,
                ),
                label: const Text(
                  'Start Quiz',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: purple,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _quizInfo(
    IconData icon,
    String value,
    String label,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 4,
        ),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.045),
          borderRadius: BorderRadius.circular(13),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: purple,
              size: 16,
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(
                color: muted,
                fontSize: 7,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildCompleteButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 0, 18, 0),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: 56,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: completed
                    ? const LinearGradient(
                        colors: [
                          Color(0xFF087F55),
                          green,
                        ],
                      )
                    : const LinearGradient(
                        colors: [
                          green,
                          greenLight,
                        ],
                      ),
                borderRadius: BorderRadius.circular(17),
                boxShadow: [
                  BoxShadow(
                    color: green.withValues(alpha: 0.20),
                    blurRadius: 20,
                    offset: const Offset(0, 9),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: saving || completed
                    ? null
                    : _completeLesson,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  disabledBackgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  foregroundColor: Colors.white,
                  disabledForegroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(17),
                  ),
                ),
                child: saving
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.2,
                          color: Colors.white,
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            completed
                                ? Icons.check_circle_rounded
                                : Icons.check_rounded,
                            size: 19,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            completed
                                ? 'Lesson completed'
                                : 'Complete lesson  •  +${widget.xp} XP',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ),
          const SizedBox(height: 9),
          Text(
            completed
                ? 'Your progress has been saved.'
                : 'Complete this lesson to save your progress.',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: muted,
              fontSize: 8,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}






