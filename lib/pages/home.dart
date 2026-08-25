import 'package:flutter/material.dart';
import 'package:arab_it/core/theme/app_colors.dart';
import '../core/ai_coach/ai_coach_card.dart';

import '../services/progress_service.dart';
import '../database/hive_service.dart';
import '../core/premium_guard.dart';
import '../services/language_controller.dart';
import 'achievements_page.dart';
import 'lessons_page.dart';
import 'pronunciation_new.dart';
import 'quiz_page.dart';
import 'reading_page.dart';
import 'statistics_page.dart';
import 'premium_page.dart';
import 'translate_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const Color background = AppColors.background;
  static const Color surface = AppColors.surface;

  static const Color purple = AppColors.primary;
  static const Color cyan = AppColors.cyan;
  static const Color green = AppColors.success;

  static const Color textPrimary = AppColors.textPrimary;
  static const Color textSecondary = AppColors.textMuted;

  static const int totalLessons = 15;

  int _xp = 0;
  int _lessonsCompleted = 0;
  int _streak = 0;
  int _completedReadings = 0;
  double _readingProgress = 0.0;
  int _readingGoal = 0;

  int _completedQuizzes = 0;
  int _quizScore = 0;

  int _pronunciationPractices = 0;
  double _pronunciationProgress = 0.0;
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

      await HiveService.init();

      final completedReadings = HiveService.completedReadings;
      final readingGoal = HiveService.dailyGoal;
      final readingProgress = HiveService.readingProgress;

      final completedQuizzes = HiveService.completedQuizzes;
      final quizScore = HiveService.quizScore;

      final pronunciationPractices =
          HiveService.pronunciationPractices;

      final pronunciationProgress =
          HiveService.pronunciationProgress;

      if (!mounted) return;

      setState(() {
        _pronunciationPractices = pronunciationPractices;
        _pronunciationProgress = pronunciationProgress;
        _xp = results[0];
        _lessonsCompleted = results[1];
        _streak = results[2];
        _completedReadings = completedReadings;
        _readingGoal = readingGoal;
        _readingProgress = readingProgress;

        _completedQuizzes = completedQuizzes;
        _quizScore = quizScore;
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


  double get _levelProgress => _xpInLevel / 500;

  int get _xpToNextLevel => 500 - _xpInLevel;

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

                                  _premiumCard(context),

                                  _continueLearning(context),

                                  const SizedBox(height: 28),

                                  const AICoachCard(),

                                  const SizedBox(height: 28),

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

                                  const SizedBox(height: 18),

                                  _readingProgressCard(),
                                  _quizProgressCard(),

                                  const SizedBox(height: 14),

                                  _pronunciationProgressCard(),

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
          width: 54,
          height: 54,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.primaryLight,
                AppColors.cyan,
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: purple.withValues(alpha: 0.28),
                blurRadius: 24,
                spreadRadius: -4,
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
                letterSpacing: -1,
              ),
            ),
          ),
        ),

        const SizedBox(width: 14),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Arab.it',
                style: TextStyle(
                  color: textPrimary,
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.8,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _t(
                  'Your language journey starts here',
                  'Il tuo viaggio linguistico inizia qui',
                  'رحلتك في تعلم اللغات تبدأ هنا',
                ),
                style: const TextStyle(
                  color: textSecondary,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
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
    final levelProgress = _levelProgress.clamp(0.0, 1.0);
    final progressPercent = (levelProgress * 100).round();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.homeHeroPurple,
            AppColors.homeHeroBlue,
            AppColors.homeHeroCyan,
          ],
        ),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.08),
        ),
        boxShadow: [
          BoxShadow(
            color: purple.withValues(alpha: 0.20),
            blurRadius: 40,
            spreadRadius: -8,
            offset: const Offset(0, 18),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -45,
            top: -55,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: cyan.withValues(alpha: 0.10),
              ),
            ),
          ),

          Positioned(
            right: 25,
            bottom: -80,
            child: Container(
              width: 130,
              height: 130,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: purple.withValues(alpha: 0.12),
              ),
            ),
          ),

          Column(
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
                      color: Colors.white.withValues(alpha: 0.10),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.08),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.local_fire_department_rounded,
                          color: AppColors.xp,
                          size: 17,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '$_streak ${_streak == 1 ? 'DAY' : 'DAYS'}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Spacer(),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 11,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.10),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.08),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.auto_awesome_rounded,
                          color: AppColors.primaryLight,
                          size: 15,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          'LEVEL $_level',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              Text(
                _t(
                  'Ready to learn?',
                  'Pronto a imparare?',
                  'هل أنت مستعد للتعلم؟',
                ),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -1.0,
                ),
              ),

              const SizedBox(height: 7),

              Text(
                _t(
                  'Keep your streak alive and make progress every day.',
                  'Mantieni la tua serie e migliora ogni giorno.',
                  'حافظ على سلسلتك وتقدم كل يوم.',
                ),
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.70),
                  fontSize: 13,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 22),

              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.bolt_rounded,
                              color: AppColors.xp,
                              size: 18,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              '$_xp XP',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              '$progressPercent%',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.72),
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 9),

                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: LinearProgressIndicator(
                            value: levelProgress,
                            minHeight: 8,
                            backgroundColor:
                                Colors.white.withValues(alpha: 0.10),
                            valueColor:
                                const AlwaysStoppedAnimation<Color>(
                              AppColors.primaryLight,
                            ),
                          ),
                        ),

                        const SizedBox(height: 7),

                        Text(
                          '$_xpInLevel / 500 XP',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.55),
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              SizedBox(
                height: 52,
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
                    foregroundColor: AppColors.background,
                    elevation: 0,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(17),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.play_arrow_rounded,
                        size: 20,
                      ),
                      const SizedBox(width: 7),
                      Text(
                        _t(
                          'Start learning',
                          'Inizia a imparare',
                          'ابدأ التعلم',
                        ),
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(width: 8),
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
            native: 'العربية',
            icon: Icons.language_rounded,
            colors: const [
              AppColors.homeSuccessDark,
              AppColors.homeSuccess,
            ],
          ),
          _languageCard(
            context,
            title: 'Italian',
            native: 'Italiano',
            icon: Icons.translate_rounded,
            colors: const [
              AppColors.homeErrorDark,
              AppColors.homeError,
            ],
          ),
          _languageCard(
            context,
            title: 'English',
            native: 'English',
            icon: Icons.public_rounded,
            colors: const [
              AppColors.homeBlueDark,
              AppColors.english,
            ],
          ),
        ];

        if (wide) {
          return Row(
            children: [
              Expanded(child: cards[0]),
              const SizedBox(width: 14),
              Expanded(child: cards[1]),
              const SizedBox(width: 14),
              Expanded(child: cards[2]),
            ],
          );
        }

        return Column(
          children: [
            cards[0],
            const SizedBox(height: 12),
            cards[1],
            const SizedBox(height: 12),
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
        borderRadius: BorderRadius.circular(24),
        child: Ink(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: colors,
            ),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.10),
            ),
            boxShadow: [
              BoxShadow(
                color: colors.first.withValues(alpha: 0.24),
                blurRadius: 24,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(17),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.10),
                  ),
                ),
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 25,
                ),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.2,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      native,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.70),
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.09),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.08),
                  ),
                ),
                child: const Icon(
                  Icons.arrow_forward_rounded,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget _premiumCard(BuildContext context) {
    final isPremium = PremiumGuard.isPremium;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const PremiumPage(),
            ),
          ).then((_) {
            if (mounted) {
              setState(() {});
            }
          });
        },
        borderRadius: BorderRadius.circular(24),
        child: Ink(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isPremium
                  ? const [
                      AppColors.homeSuccessDark,
                      AppColors.homeSuccess,
                      AppColors.success,
                    ]
                  : const [
                      AppColors.homeDarkPurple,
                      AppColors.primary,
                      AppColors.homePremiumPink,
                    ],
            ),
            boxShadow: [
              BoxShadow(
                color: isPremium
                    ? AppColors.success
                    : AppColors.primary,
                blurRadius: 25,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(17),
                ),
                child: Icon(
                  isPremium
                      ? Icons.verified_rounded
                      : Icons.workspace_premium_rounded,
                  color: isPremium
                      ? AppColors.homePremiumGreenLight
                      : AppColors.homePremiumYellow,
                  size: 28,
                ),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isPremium
                          ? _t(
                              'Premium Active',
                              'Premium Attivo',
                              'Premium نشط',
                            )
                          : _t(
                              'Premium',
                              'Premium',
                              'بريميوم',
                            ),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w900,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      isPremium
                          ? _t(
                              'All learning features are unlocked',
                              'Tutte le funzioni sono sbloccate',
                              'جميع ميزات التعلم مفتوحة',
                            )
                          : _t(
                              'Unlock all learning features',
                              'Sblocca tutte le funzioni',
                              'افتح جميع ميزات التعلم',
                            ),
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.70),
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.10),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isPremium
                      ? Icons.check_rounded
                      : Icons.arrow_forward_rounded,
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
  Widget _continueLearning(BuildContext context) {
    final progress = _lessonProgress.clamp(0.0, 1.0);
    final percent = (progress * 100).round();

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
        borderRadius: BorderRadius.circular(30),
        child: Ink(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.homeDeepPurple,
                AppColors.homeDeepBlue,
                AppColors.homeDeepCyanBlue,
              ],
            ),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.08),
            ),
            boxShadow: [
              BoxShadow(
                color: purple.withValues(alpha: 0.16),
                blurRadius: 36,
                offset: const Offset(0, 16),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 62,
                    height: 62,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColors.primaryLight,
                          AppColors.cyan,
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: purple.withValues(alpha: 0.30),
                          blurRadius: 24,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.auto_stories_rounded,
                      color: Colors.white,
                      size: 29,
                    ),
                  ),

                  const SizedBox(width: 15),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _t(
                            'Continue learning',
                            'Continua a imparare',
                            'تابع التعلم',
                          ),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -0.4,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          _t(
                            'Pick up where you left off',
                            'Riprendi da dove hai lasciato',
                            'تابع من حيث توقفت',
                          ),
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.62),
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.08),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.08),
                      ),
                    ),
                    child: const Icon(
                      Icons.arrow_forward_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              Row(
                children: [
                  Text(
                    _t(
                      'Course progress',
                      'Progresso del corso',
                      'تقدم الدورة',
                    ),
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.58),
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '$percent%',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 10,
                  backgroundColor: Colors.white.withValues(alpha: 0.08),
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    cyan,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              Row(
                children: [
                  Icon(
                    Icons.menu_book_rounded,
                    color: cyan.withValues(alpha: 0.90),
                    size: 16,
                  ),
                  const SizedBox(width: 7),
                  Text(
                    _t(
                      '$_lessonsCompleted of $totalLessons lessons completed',
                      '$_lessonsCompleted di $totalLessons lezioni completate',
                      '$_lessonsCompleted من $totalLessons دروس مكتملة',
                    ),
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.62),
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
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
            icon: PremiumGuard.isPremium
                ? Icons.record_voice_over_rounded
                : Icons.lock_rounded,
            title: _t(
              'Pronunciation',
              'Pronuncia',
              'النطق',
            ),
            subtitle: PremiumGuard.isPremium
                ? _t(
                    'Speak clearly and confidently',
                    'Parla in modo chiaro e sicuro',
                    'تحدث بوضوح وثقة',
                  )
                : _t(
                    'Premium feature',
                    'Funzione Premium',
                    'ميزة بريميوم',
                  ),
            colors: const [
              AppColors.homeWarmOrange,
              AppColors.orange,
            ],
            page: PremiumGuard.isPremium
                ? const PronunciationPage()
                : const PremiumPage(),
          ),

          _practiceCard(
            context,
            icon: Icons.headphones_rounded,
            title: _t(
              'Listening',
              'Ascolto',
              'الاستماع',
            ),
            subtitle: _t(
              'Train your listening skills',
              'Allena le tue capacità di ascolto',
              'درّب مهارات الاستماع لديك',
            ),
            colors: const [
              AppColors.homeDeepCyan,
              AppColors.cyan,
            ],
            page: const ReadingPage(),
          ),

          _practiceCard(
            context,
            icon: Icons.quiz_rounded,
            title: _t(
              'Quiz',
              'Quiz',
              'اختبار',
            ),
            subtitle: _t(
              'Challenge your knowledge',
              'Metti alla prova le tue conoscenze',
              'اختبر معلوماتك',
            ),
            colors: const [
              AppColors.homePremiumPurple,
              AppColors.primary,
            ],
            page: const QuizPage(),
          ),
        ];

        if (wide) {
          return Row(
            children: [
              Expanded(child: cards[0]),
              const SizedBox(width: 14),
              Expanded(child: cards[1]),
              const SizedBox(width: 14),
              Expanded(child: cards[2]),
            ],
          );
        }

        return Column(
          children: [
            cards[0],
            const SizedBox(height: 12),
            cards[1],
            const SizedBox(height: 12),
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
          ).then((_) => _loadProgress());
        },
        borderRadius: BorderRadius.circular(24),
        child: Ink(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: colors,
            ),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.10),
            ),
            boxShadow: [
              BoxShadow(
                color: colors.first.withValues(alpha: 0.22),
                blurRadius: 24,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(17),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.10),
                  ),
                ),
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 25,
                ),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.2,
                      ),
                    ),

                    const SizedBox(height: 5),

                    Text(
                      subtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.70),
                        fontSize: 11,
                        height: 1.35,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 10),

              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.09),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.08),
                  ),
                ),
                child: const Icon(
                  Icons.arrow_forward_rounded,
                  color: Colors.white,
                  size: 18,
                ),
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
                  color: AppColors.primaryLight,
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
              'XP المطلوبة للمستوى التالي',
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
    final isPremium = PremiumGuard.isPremium;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => isPremium
                  ? const StatisticsPage()
                  : const PremiumPage(),
            ),
          ).then((_) {
            if (mounted) {
              setState(() {});
            }
          });
        },
        borderRadius: BorderRadius.circular(24),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: surface,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: isPremium
                  ? purple.withValues(alpha: 0.18)
                  : Colors.white.withValues(alpha: 0.08),
            ),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: isPremium
                          ? purple.withValues(alpha: 0.14)
                          : Colors.white.withValues(alpha: 0.07),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(
                      isPremium
                          ? Icons.insights_rounded
                          : Icons.lock_rounded,
                      color: isPremium
                          ? AppColors.primaryLight
                          : Colors.white54,
                      size: 23,
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isPremium
                              ? _t(
                                  'Overall progress',
                                  'Progresso complessivo',
                                  'التقدم الإجمالي',
                                )
                              : _t(
                                  'Advanced Progress',
                                  'Progressi avanzati',
                                  'التقدم المتقدم',
                                ),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                          ),
                        ),

                        const SizedBox(height: 4),

                        Text(
                          isPremium
                              ? _t(
                                  'View your complete statistics',
                                  'Visualizza tutte le statistiche',
                                  'شاهد إحصائياتك الكاملة',
                                )
                              : _t(
                                  'Premium feature',
                                  'Funzione Premium',
                                  'ميزة بريميوم',
                                ),
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.55),
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.07),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isPremium
                          ? Icons.arrow_forward_rounded
                          : Icons.lock_rounded,
                      color: Colors.white70,
                      size: 18,
                    ),
                  ),
                ],
              ),

              if (isPremium) ...[
                const SizedBox(height: 18),

                Row(
                  children: [
                    Expanded(
                      child: Text(
                        '$_progressPercent%',
                        style: const TextStyle(
                          color: AppColors.primaryLight,
                          fontSize: 25,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),

                    Text(
                      _t(
                        'Complete',
                        'Completato',
                        'مكتمل',
                      ),
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.55),
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: _lessonProgress,
                    minHeight: 9,
                    backgroundColor:
                        Colors.white.withValues(alpha: 0.07),
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(purple),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
  Widget _quizProgressCard() {
    final completed = _completedQuizzes;
    final score = _quizScore.clamp(0, 100);
    final progress = (score / 100).clamp(0.0, 1.0);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.055),
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
                  color: Colors.purple.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Icon(
                  Icons.quiz_rounded,
                  color: Colors.purpleAccent,
                  size: 23,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _t(
                        'Quiz Progress',
                        'Progresso quiz',
                        'تقدم الاختبارات',
                      ),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      _t(
                        'Keep testing your knowledge',
                        'Continua a testare le tue conoscenze',
                        'واصل اختبار معرفتك',
                      ),
                      style: const TextStyle(
                        color: textSecondary,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '$score%',
                style: const TextStyle(
                  color: Colors.purpleAccent,
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 9,
              backgroundColor:
                  Colors.white.withValues(alpha: 0.07),
              valueColor:
                  const AlwaysStoppedAnimation<Color>(
                Colors.purpleAccent,
              ),
            ),
          ),

          const SizedBox(height: 11),

          Row(
            children: [
              Expanded(
                child: Text(
                  '$completed ${_t(
                    'quizzes completed',
                    'quiz completati',
                    'اختبارات مكتملة',
                  )}',
                  style: const TextStyle(
                    color: textSecondary,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Text(
                _t(
                  '$score% best score',
                  '$score% miglior risultato',
                  '$score% أفضل نتيجة',
                ),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  Widget _pronunciationProgressCard() {
    final progress = _pronunciationProgress.clamp(0.0, 1.0);
    final percent = (progress * 100).round();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.055),
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
                  color: Colors.orange.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Icon(
                  Icons.record_voice_over_rounded,
                  color: Colors.orangeAccent,
                  size: 23,
                ),
              ),
              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _t(
                        'Pronunciation Progress',
                        'Progresso pronuncia',
                        'تقدم النطق',
                      ),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      _t(
                        'Practice your pronunciation',
                        'Esercita la tua pronuncia',
                        'تدرّب على نطقك',
                      ),
                      style: const TextStyle(
                        color: textSecondary,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              Text(
                '$percent%',
                style: const TextStyle(
                  color: Colors.orangeAccent,
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 9,
              backgroundColor:
                  Colors.white.withValues(alpha: 0.07),
              valueColor:
                  const AlwaysStoppedAnimation<Color>(
                Colors.orangeAccent,
              ),
            ),
          ),

          const SizedBox(height: 11),

          Row(
            children: [
              Expanded(
                child: Text(
                  '$_pronunciationPractices ${_t(
                    'practices completed',
                    'esercizi completati',
                    'تمارين مكتملة',
                  )}',
                  style: const TextStyle(
                    color: textSecondary,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Text(
                _t(
                  '$percent% complete',
                  '$percent% completato',
                  '$percent% مكتمل',
                ),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  Widget _readingProgressCard() {
    final progress = _readingProgress.clamp(0.0, 1.0);

    final percent = (progress * 100).round();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.055),
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
                  color: cyan.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Icon(
                  Icons.menu_book_rounded,
                  color: cyan,
                  size: 23,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      _t(
                        'Reading Progress',
                        'Progresso lettura',
                        'تقدم القراءة',
                      ),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      _t(
                        'Keep improving your reading',
                        'Continua a migliorare la lettura',
                        'استمر في تحسين القراءة',
                      ),
                      style: const TextStyle(
                        color: textSecondary,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '$percent%',
                style: const TextStyle(
                  color: cyan,
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 9,
              backgroundColor:
                  Colors.white.withValues(alpha: 0.07),
              valueColor:
                  const AlwaysStoppedAnimation<Color>(cyan),
            ),
          ),

          const SizedBox(height: 11),

          Row(
            children: [
              Expanded(
                child: Text(
                  '$_completedReadings / $_readingGoal ${_t(
                    'readings completed',
                    'letture completate',
                    'قراءات مكتملة',
                  )}',
                  style: const TextStyle(
                    color: textSecondary,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Text(
                _t(
                  '$percent% complete',
                  '$percent% completato',
                  '$percent% مكتمل',
                ),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ],
      ),
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
                AppColors.homeHeroBlue,
                AppColors.homeDeepBlueCyan,
                AppColors.homeDarkCyan,
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
    final isPremium = PremiumGuard.isPremium;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => isPremium ? const AchievementsPage() : const PremiumPage(),
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
                      AppColors.homeAchievementGreenDark,
                      AppColors.homeAchievementGreen,
                    ]
                  : const [
                      AppColors.homeDarkBlue,
                      AppColors.homeAchievementIndigo,
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
                      ? AppColors.xp
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































































