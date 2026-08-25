import 'package:flutter/material.dart';

import '../services/progress_service.dart';
import '../services/language_controller.dart';
import 'achievements_page.dart';
import 'lessons_page.dart';
import 'pronunciation_new.dart';
import 'quiz_page.dart';
import 'reading_page.dart';
import 'statistics_page.dart';
import 'translate_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const Color background = Color(0xFF070A12);
  static const Color surface = Color(0xFF111725);
  static const Color surface2 = Color(0xFF171D2B);

  static const Color purple = Color(0xFF7C3AED);
  static const Color cyan = Color(0xFF06B6D4);
  static const Color green = Color(0xFF22C55E);
  static const Color orange = Color(0xFFF97316);
  static const Color pink = Color(0xFFEC4899);

  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Color(0xFF94A3B8);

  static const int totalLessons = 15;

  int _xp = 0;
  int _lessonsCompleted = 0;
  int _streak = 0;
  bool _loading = true;

  String _t(
    String english,
    String italian,
    String arabic,
  ) {
    return LanguageController.text(
      english: english,
      italian: italian,
      arabic: arabic,
    );
  }

  @override
  void initState() {
    super.initState();
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    try {
      final results = await Future.wait([
        ProgressService.getXP(),
        ProgressService.getLessonsCompleted(),
        ProgressService.getStreak(),
      ]);

      if (!mounted) return;

      setState(() {
        _xp = results[0];
        _lessonsCompleted = results[1];
        _streak = results[2];
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _loading = false);
    }
  }

  double get _lessonProgress {
    if (totalLessons == 0) return 0;
    return (_lessonsCompleted / totalLessons).clamp(0.0, 1.0);
  }

  int get _progressPercent => (_lessonProgress * 100).round();

  int get _level => (_xp ~/ 500) + 1;

  int get _xpInLevel => _xp % 500;

  int get _xpToNextLevel => 500 - _xpInLevel;

  double get _levelProgress => _xpInLevel / 500;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: LanguageController.language,
      builder: (context, language, child) {
        return Scaffold(
          backgroundColor: background,
          body: SafeArea(
            child: RefreshIndicator(
              color: cyan,
              backgroundColor: surface,
              onRefresh: _loadProgress,
              child: _loading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: cyan,
                      ),
                    )
                  : LayoutBuilder(
                      builder: (context, constraints) {
                        final horizontalPadding =
                            constraints.maxWidth > 700 ? 48.0 : 20.0;

                        return SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(
                            parent: BouncingScrollPhysics(),
                          ),
                          padding: EdgeInsets.fromLTRB(
                            horizontalPadding,
                            20,
                            horizontalPadding,
                            40,
                          ),
                          child: Center(
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(
                                maxWidth: 1100,
                              ),
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  _header(),

                                  const SizedBox(height: 24),

                                  _heroCard(context),

                                  const SizedBox(height: 28),

                                  _sectionHeader(
                                    _t(
                                      'Your languages',
                                      'Le tue lingue',
                                      '?????',
                                    ),
                                    _t(
                                      'Choose a language to continue',
                                      'Scegli una lingua per continuare',
                                      '???? ??? ????????',
                                    ),
                                  ),

                                  const SizedBox(height: 14),

                                  _languageGrid(context),

                                  const SizedBox(height: 28),

                                  _sectionHeader(
                                    _t(
                                      'Continue learning',
                                      'Continua a imparare',
                                      '???? ??????',
                                    ),
                                    _t(
                                      'Pick up where you left off',
                                      'Riprendi da dove hai lasciato',
                                      '???? ?? ??? ?????',
                                    ),
                                  ),

                                  const SizedBox(height: 14),

                                  _continueLearning(context),

                                  const SizedBox(height: 28),

                                  _sectionHeader(
                                    _t(
                                      'Quick practice',
                                      'Pratica veloce',
                                      '????? ????',
                                    ),
                                    _t(
                                      'Build your skills every day',
                                      'Migliora le tue abilità ogni giorno',
                                      '???? ??????? ?? ???',
                                    ),
                                  ),

                                  const SizedBox(height: 14),

                                  _practiceGrid(context),

                                  const SizedBox(height: 28),

                                  _levelCard(),

                                  const SizedBox(height: 28),

                                  _progressCard(context),

                                  const SizedBox(height: 28),

                                  _translateCard(context),

                                  const SizedBox(height: 28),

                                  _achievementCard(context),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ),
        );
      },
    );
  }

  Widget _header() {
    return Row(
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(17),
            gradient: const LinearGradient(
              colors: [
                purple,
                cyan,
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: purple.withValues(alpha: 0.22),
                blurRadius: 24,
              ),
            ],
          ),
          child: const Center(
            child: Text(
              'A',
              style: TextStyle(
                color: Colors.white,
                fontSize: 27,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ),

        const SizedBox(width: 13),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Arab.it',
                style: TextStyle(
                  color: textPrimary,
                  fontSize: 23,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.7,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                _t(
                  'Learn languages. Connect worlds.',
                  'Impara le lingue. Connetti il mondo.',
                  '????? ?????? ????? ??????',
                ),
                style: const TextStyle(
                  color: textSecondary,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),

        _headerButton(
          Icons.notifications_none_rounded,
          () {},
        ),
      ],
    );
  }

  Widget _headerButton(
    IconData icon,
    VoidCallback onTap,
  ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.07),
            ),
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: 22,
          ),
        ),
      ),
    );
  }

  Widget _heroCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF34206D),
            Color(0xFF153E75),
            Color(0xFF075B68),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: purple.withValues(alpha: 0.15),
            blurRadius: 35,
            spreadRadius: -5,
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
                  horizontal: 11,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.11),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.local_fire_department_rounded,
                      color: Color(0xFFFFB020),
                      size: 17,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '$_streak ${_streak == 1 ? 'DAY' : 'DAYS'}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'LEVEL $_level',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 22),

          Text(
            _t(
              'Ready to learn?',
              'Pronto a imparare?',
              '?? ??? ????? ???????',
            ),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 29,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.8,
            ),
          ),

          const SizedBox(height: 7),

          Text(
            _t(
              'Make today count. A few minutes every day can make a big difference.',
              'Fai contare ogni giorno. Pochi minuti possono fare una grande differenza.',
              '???? ???? ??????. ??? ????? ?????? ???? ?? ???? ????? ??????.',
            ),
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.72),
              fontSize: 13,
              height: 1.5,
            ),
          ),

          const SizedBox(height: 21),

          SizedBox(
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const LessonsPage(),
                  ),
                ).then((_) => _loadProgress());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF17122B),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _t(
                      'Start learning',
                      'Inizia a imparare',
                      '???? ??????',
                    ),
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(width: 9),
                  const Icon(
                    Icons.arrow_forward_rounded,
                    size: 18,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionHeader(
    String title,
    String subtitle,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: const TextStyle(
            color: textSecondary,
            fontSize: 11,
          ),
        ),
      ],
    );
  }

  Widget _languageGrid(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth > 650;

        final cards = [
          _languageCard(
            context,
            title: 'Arabic',
            native: '???????',
            icon: Icons.language_rounded,
            colors: const [
              Color(0xFF064E3B),
              Color(0xFF059669),
            ],
          ),
          _languageCard(
            context,
            title: 'Italian',
            native: 'Italiano',
            icon: Icons.translate_rounded,
            colors: const [
              Color(0xFF7F1D1D),
              Color(0xFFDC2626),
            ],
          ),
          _languageCard(
            context,
            title: 'English',
            native: 'English',
            icon: Icons.public_rounded,
            colors: const [
              Color(0xFF1E3A8A),
              Color(0xFF2563EB),
            ],
          ),
        ];

        if (wide) {
          return Row(
            children: [
              Expanded(child: cards[0]),
              const SizedBox(width: 12),
              Expanded(child: cards[1]),
              const SizedBox(width: 12),
              Expanded(child: cards[2]),
            ],
          );
        }

        return Column(
          children: [
            cards[0],
            const SizedBox(height: 10),
            cards[1],
            const SizedBox(height: 10),
            cards[2],
          ],
        );
      },
    );
  }

  Widget _languageCard(
    BuildContext context, {
    required String title,
    required String native,
    required IconData icon,
    required List<Color> colors,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const LessonsPage(),
            ),
          ).then((_) => _loadProgress());
        },
        borderRadius: BorderRadius.circular(22),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: colors,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 24,
                ),
              ),

              const SizedBox(width: 13),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      native,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.68),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),

              const Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.white70,
                size: 15,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _continueLearning(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const LessonsPage(),
            ),
          ).then((_) => _loadProgress());
        },
        borderRadius: BorderRadius.circular(24),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: surface,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.07),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(19),
                  gradient: const LinearGradient(
                    colors: [
                      purple,
                      Color(0xFF4F46E5),
                    ],
                  ),
                ),
                child: const Icon(
                  Icons.menu_book_rounded,
                  color: Colors.white,
                  size: 29,
                ),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _t(
                        'Italian',
                        'Italiano',
                        '?????????',
                      ),
                      style: const TextStyle(
                        color: Color(0xFFA78BFA),
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _t(
                        'Greetings & Introductions',
                        'Saluti e presentazioni',
                        '??????? ???????? ??????',
                      ),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      _t(
                        'Continue your lesson',
                        'Continua la lezione',
                        '???? ?????',
                      ),
                      style: const TextStyle(
                        color: textSecondary,
                        fontSize: 10.5,
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      purple,
                      cyan,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.arrow_forward_rounded,
                  color: Colors.white,
                  size: 19,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _practiceGrid(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth > 650;

        final cards = [
          _practiceCard(
            context,
            icon: Icons.record_voice_over_rounded,
            title: _t(
              'Speaking',
              'Conversazione',
              '??????',
            ),
            subtitle: _t(
              'Improve pronunciation',
              'Migliora la pronuncia',
              '???? ?????',
            ),
            colors: const [
              Color(0xFF7C2D12),
              Color(0xFFEA580C),
            ],
            page: const PronunciationPage(),
          ),
          _practiceCard(
            context,
            icon: Icons.headphones_rounded,
            title: _t(
              'Listening',
              'Ascolto',
              '????????',
            ),
            subtitle: _t(
              'Train your ear',
              'Allena il tuo orecchio',
              '???? ????',
            ),
            colors: const [
              Color(0xFF164E63),
              Color(0xFF0891B2),
            ],
            page: const ReadingPage(),
          ),
          _practiceCard(
            context,
            icon: Icons.quiz_rounded,
            title: _t(
              'Quiz',
              'Quiz',
              '??????',
            ),
            subtitle: _t(
              'Test yourself',
              'Mettiti alla prova',
              '????? ????',
            ),
            colors: const [
              Color(0xFF581C87),
              Color(0xFFA855F7),
            ],
            page: const QuizPage(),
          ),
        ];

        if (wide) {
          return Row(
            children: [
              Expanded(child: cards[0]),
              const SizedBox(width: 12),
              Expanded(child: cards[1]),
              const SizedBox(width: 12),
              Expanded(child: cards[2]),
            ],
          );
        }

        return Column(
          children: [
            cards[0],
            const SizedBox(height: 10),
            cards[1],
            const SizedBox(height: 10),
            cards[2],
          ],
        );
      },
    );
  }

  Widget _practiceCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required List<Color> colors,
    required Widget page,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => page,
            ),
          );
        },
        borderRadius: BorderRadius.circular(21),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(17),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(21),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: colors,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 23,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.68),
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),

              const Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.white60,
                size: 14,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _levelCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.07),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: purple.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Icon(
                  Icons.bolt_rounded,
                  color: Color(0xFFA78BFA),
                  size: 25,
                ),
              ),

              const SizedBox(width: 13),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Level $_level',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '$_xp XP total',
                      style: const TextStyle(
                        color: textSecondary,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),

              Text(
                '$_xpToNextLevel XP',
                style: const TextStyle(
                  color: green,
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: _levelProgress,
              minHeight: 8,
              backgroundColor: Colors.white.withValues(alpha: 0.07),
              valueColor: const AlwaysStoppedAnimation<Color>(
                purple,
              ),
            ),
          ),

          const SizedBox(height: 8),

          Text(
            _t(
              'XP needed for the next level',
              'XP necessari per il prossimo livello',
              '?????? ???????? ??????? ??????',
            ),
            style: const TextStyle(
              color: textSecondary,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _progressCard(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const StatisticsPage(),
            ),
          );
        },
        borderRadius: BorderRadius.circular(24),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: surface,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: purple.withValues(alpha: 0.18),
            ),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _t(
                        'Overall progress',
                        'Progresso complessivo',
                        '?????? ?????',
                      ),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  Text(
                    '$_progressPercent%',
                    style: const TextStyle(
                      color: Color(0xFFA78BFA),
                      fontSize: 19,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 15),

              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: _lessonProgress,
                  minHeight: 9,
                  backgroundColor: Colors.white.withValues(alpha: 0.07),
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    purple,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Row(
                children: [
                  _stat(
                    Icons.menu_book_rounded,
                    '$_lessonsCompleted',
                    _t('Lessons', 'Lezioni', '??????'),
                    purple,
                  ),
                  _verticalDivider(),
                  _stat(
                    Icons.bolt_rounded,
                    '$_xp',
                    'XP',
                    cyan,
                  ),
                  _verticalDivider(),
                  _stat(
                    Icons.local_fire_department_rounded,
                    '$_streak',
                    _t('Streak', 'Serie', '???????'),
                    orange,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _stat(
    IconData icon,
    String value,
    String label,
    Color color,
  ) {
    return Expanded(
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: 20,
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              color: textSecondary,
              fontSize: 9,
            ),
          ),
        ],
      ),
    );
  }

  Widget _verticalDivider() {
    return Container(
      width: 1,
      height: 42,
      color: Colors.white.withValues(alpha: 0.08),
    );
  }

  Widget _translateCard(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const TranslatePage(),
            ),
          );
        },
        borderRadius: BorderRadius.circular(24),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF31206B),
                Color(0xFF123B61),
                Color(0xFF07556A),
              ],
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.11),
                  borderRadius: BorderRadius.circular(17),
                ),
                child: const Icon(
                  Icons.translate_rounded,
                  color: Colors.white,
                  size: 27,
                ),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _t(
                        'Translator',
                        'Traduttore',
                        '???????',
                      ),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      _t(
                        'Translate words and sentences between languages.',
                        'Traduci parole e frasi tra le lingue.',
                        '???? ??????? ?????? ??? ??????.',
                      ),
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.68),
                        fontSize: 10.5,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 10),

              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: const Icon(
                  Icons.arrow_forward_rounded,
                  color: Colors.white,
                  size: 19,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _achievementCard(BuildContext context) {
    final unlocked = _lessonsCompleted >= 5;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AchievementsPage(),
            ),
          );
        },
        borderRadius: BorderRadius.circular(24),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: LinearGradient(
              colors: unlocked
                  ? const [
                      Color(0xFF14532D),
                      Color(0xFF166534),
                    ]
                  : const [
                      Color(0xFF172554),
                      Color(0xFF312E81),
                    ],
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.11),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  unlocked
                      ? Icons.emoji_events_rounded
                      : Icons.lock_outline_rounded,
                  color: unlocked
                      ? const Color(0xFFFACC15)
                      : Colors.white70,
                  size: 27,
                ),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      unlocked
                          ? _t(
                              'Achievement unlocked',
                              'Obiettivo sbloccato',
                              '?? ??? ???????',
                            )
                          : _t(
                              'Keep learning',
                              'Continua a imparare',
                              '???? ??????',
                            ),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      unlocked
                          ? _t(
                              'You completed $_lessonsCompleted lessons.',
                              'Hai completato $_lessonsCompleted lezioni.',
                              '????? $_lessonsCompleted ????.',
                            )
                          : _t(
                              '${5 - _lessonsCompleted} more lessons to unlock your first achievement.',
                              'Ancora ${5 - _lessonsCompleted} lezioni per il primo obiettivo.',
                              '???? ${5 - _lessonsCompleted} ???? ???? ??? ?????.',
                            ),
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.68),
                        fontSize: 10.5,
                      ),
                    ),
                  ],
                ),
              ),

              const Icon(
                Icons.chevron_right_rounded,
                color: Colors.white,
                size: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
