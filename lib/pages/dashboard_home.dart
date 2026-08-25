import '../core/theme/app_colors.dart';
import 'package:flutter/material.dart';

import '../database/hive_service.dart';
import '../services/language_controller.dart';
import 'lessons_page.dart';
import 'practice_page.dart';
import 'smart_review_page.dart';
import 'daily_challenge_page.dart';
import 'pronunciation_page.dart';
import 'quiz_page.dart';
import 'progress_page.dart';
import 'favorites_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int xp = 0;
  int level = 1;
  int streak = 0;
  int lessons = 0;
  int favorites = 0;
  int dailyXp = 0;
  int dailyGoal = 20;

  String username = 'Learner';
  String language = 'English';

  bool loading = true;

  static const bg = AppColors.background;
  static const card = AppColors.card;
  static const purple = AppColors.primaryLight;
  static const blue = AppColors.english;
  static const cyan = AppColors.cyan;
  static const pink = AppColors.pink;
  static const green = AppColors.success;
  static const white = AppColors.textPrimary;
  static const muted = AppColors.textMuted;

  @override
  void initState() {
    super.initState();

    LanguageController.language.addListener(_languageChanged);
    _loadData();
  }

  void _languageChanged() {
    if (mounted) setState(() {});
  }

  Future<void> _loadData() async {
    try {
      await HiveService.init();

      if (!mounted) return;

      final name = HiveService.username.trim();

      setState(() {
        xp = HiveService.xp;
        level = HiveService.level;
        streak = HiveService.streak;
        lessons = HiveService.completedLessons.length;
        favorites = HiveService.favorites.length;
        dailyXp = HiveService.dailyXp;
        dailyGoal = HiveService.dailyGoal;
        username = name.isEmpty ? 'Learner' : name;
        language = HiveService.selectedLanguage;
        loading = false;
      });
    } catch (_) {
      if (mounted) {
        setState(() => loading = false);
      }
    }
  }

  @override
  void dispose() {
    LanguageController.language.removeListener(_languageChanged);
    super.dispose();
  }

  String t({
    required String en,
    required String it,
    required String ar,
  }) {
    if (LanguageController.isArabic) return ar;
    if (LanguageController.isItalian) return it;
    return en;
  }

  double get dailyProgress {
    if (dailyGoal <= 0) return 0;
    return (dailyXp / dailyGoal).clamp(0.0, 1.0);
  }

  double get levelProgress {
    return ((xp % 500) / 500).clamp(0.0, 1.0);
  }

  void _open(Widget page) {
    Navigator.of(context)
        .push(
          MaterialPageRoute(builder: (_) => page),
        )
        .then((_) => _loadData());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      body: RefreshIndicator(
        color: purple,
        backgroundColor: card,
        onRefresh: _loadData,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          slivers: [
            SliverToBoxAdapter(child: _topBar()),
            SliverToBoxAdapter(child: _body()),
          ],
        ),
      ),
    );
  }

  Widget _topBar() {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(22, 18, 22, 8),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [purple, blue],
                ),
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: purple.withValues(alpha: .35),
                    blurRadius: 22,
                  ),
                ],
              ),
              child: const Icon(
                Icons.auto_awesome_rounded,
                color: white,
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ARAB.IT',
                    style: TextStyle(
                      color: white,
                      fontSize: 17,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.2,
                    ),
                  ),
                  Text(
                    'LANGUAGE ACADEMY',
                    style: TextStyle(
                      color: muted,
                      fontSize: 8,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: .06),
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withValues(alpha: .08),
                ),
              ),
              child: const Icon(
                Icons.notifications_none_rounded,
                color: white,
                size: 21,
              ),
            ),
            const SizedBox(width: 9),
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [pink, purple],
                ),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  username.isEmpty
                      ? 'L'
                      : username.substring(0, 1).toUpperCase(),
                  style: const TextStyle(
                    color: white,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _body() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final desktop = constraints.maxWidth >= 950;
        final width = desktop ? 1180.0 : double.infinity;

        return Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: width),
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                desktop ? 22 : 18,
                18,
                desktop ? 22 : 18,
                40,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _hero(desktop),
                  const SizedBox(height: 18),
                  _stats(desktop),
                  const SizedBox(height: 20),
                  _weeklyStreak(),
                  const SizedBox(height: 28),
                  _sectionTitle(
                    t(
                      en: 'Continue learning',
                      it: 'Continua ad imparare',
                      ar: 'تابع التعلم',
                    ),
                    t(
                      en: 'Pick up where you left off',
                      it: 'Riprendi da dove hai lasciato',
                      ar: 'تابع من حيث توقفت',
                    ),
                  ),
                  const SizedBox(height: 12),
                  _continueCard(),
                  const SizedBox(height: 28),
                  _sectionTitle(
                    t(
                      en: 'Practice your skills',
                      it: 'Pratica le tue abilità',
                      ar: 'تدرّب على مهاراتك',
                    ),
                    t(
                      en: 'Short activities, real progress',
                      it: 'Attività brevi, progressi reali',
                      ar: 'أنشطة قصيرة وتقدم حقيقي',
                    ),
                  ),
                  const SizedBox(height: 12),
                  _practiceGrid(desktop),
                  const SizedBox(height: 28),
                  _dailyGoal(),
                  const SizedBox(height: 28),
                  _languages(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _weeklyStreak() {
    final days = <String>[
      t(en: 'M', it: 'L', ar: 'ن'),
      t(en: 'T', it: 'M', ar: 'ث'),
      t(en: 'W', it: 'M', ar: 'ر'),
      t(en: 'T', it: 'G', ar: 'خ'),
      t(en: 'F', it: 'V', ar: 'ج'),
      t(en: 'S', it: 'S', ar: 'س'),
      t(en: 'S', it: 'D', ar: 'ح'),
    ];

    final activeDays = streak.clamp(0, 7);
    final progress = activeDays / 7;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.dashboardHeroPurple,
            AppColors.dashboardHeroDark,
            AppColors.dashboardHeroBlue,
          ],
        ),
        border: Border.all(
          color: AppColors.dashboardGlowPurple,
          width: 1,
        ),
        boxShadow: const [
          BoxShadow(
            color: AppColors.dashboardGlowPurpleSoft,
            blurRadius: 32,
            offset: Offset(0, 14),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.dashboardGold,
                      AppColors.dashboardOrange,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(17),
                  boxShadow: const [
                    BoxShadow(
                      color: AppColors.dashboardGlowOrange,
                      blurRadius: 18,
                      offset: Offset(0, 7),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.local_fire_department_rounded,
                  color: white,
                  size: 27,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      t(
                        en: 'Weekly streak',
                        it: 'Serie settimanale',
                        ar: 'سلسلة هذا الأسبوع',
                      ),
                      style: const TextStyle(
                        color: white,
                        fontSize: 17,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.2,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      t(
                        en: '$streak days in a row',
                        it: '$streak giorni consecutivi',
                        ar: '$streak أيام متتالية',
                      ),
                      style: const TextStyle(
                        color: AppColors.dashboardTextSoft,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 9,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.075),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.09),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.bolt_rounded,
                      color: AppColors.dashboardGold,
                      size: 16,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      '$xp XP',
                      style: const TextStyle(
                        color: white,
                        fontSize: 11,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 22),

          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 7,
              backgroundColor: Colors.white.withValues(alpha: 0.07),
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppColors.dashboardGoldLight,
              ),
            ),
          ),

          const SizedBox(height: 18),

          Row(
            children: List.generate(
              days.length,
              (index) {
                final active = index < activeDays;

                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      right: index == days.length - 1 ? 0 : 7,
                    ),
                    child: Column(
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          curve: Curves.easeOutCubic,
                          width: double.infinity,
                          height: 44,
                          decoration: BoxDecoration(
                            gradient: active
                                ? const LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      AppColors.dashboardGold,
                                      AppColors.dashboardOrange,
                                    ],
                                  )
                                : null,
                            color: active
                                ? null
                                : Colors.white.withValues(alpha: 0.045),
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: active
                                  ? Colors.transparent
                                  : Colors.white.withValues(alpha: 0.075),
                            ),
                            boxShadow: active
                                ? const [
                                    BoxShadow(
                                      color: AppColors.dashboardGlowOrangeSoft,
                                      blurRadius: 12,
                                      offset: Offset(0, 5),
                                    ),
                                  ]
                                : null,
                          ),
                          child: Icon(
                            active
                                ? Icons.check_rounded
                                : Icons.remove_rounded,
                            color: active
                                ? white
                                : Colors.white.withValues(alpha: 0.25),
                            size: 18,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          days[index],
                          style: TextStyle(
                            color: active
                                ? white
                                : Colors.white.withValues(alpha: 0.38),
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
  Widget _hero(bool desktop) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(desktop ? 32 : 24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.dashboardCardPurple,
            AppColors.dashboardCardBlue,
            AppColors.dashboardCardBackground,
          ],
        ),
        border: Border.all(
          color: purple.withValues(alpha: .30),
        ),
        boxShadow: [
          BoxShadow(
            color: purple.withValues(alpha: .18),
            blurRadius: 48,
            spreadRadius: 1,
            offset: const Offset(0, 20),
          ),
          BoxShadow(
            color: blue.withValues(alpha: .08),
            blurRadius: 30,
            offset: const Offset(18, 8),
          ),
        ],
      ),
      child: desktop
          ? Row(
              children: [
                Expanded(child: _heroText()),
                const SizedBox(width: 30),
                _levelCircle(),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _heroText(),
                const SizedBox(height: 26),
                Center(child: _levelCircle()),
              ],
            ),
    );
  }

  Widget _heroText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 11,
            vertical: 7,
          ),
          decoration: BoxDecoration(
            color: purple.withValues(alpha: .14),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: purple.withValues(alpha: .25),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.auto_awesome_rounded,
                color: AppColors.dashboardPurpleLight,
                size: 14,
              ),
              const SizedBox(width: 6),
              Text(
                t(
                  en: 'YOUR JOURNEY',
                  it: 'IL TUO PERCORSO',
                  ar: 'رحلتك التعليمية',
                ),
                style: const TextStyle(
                  color: AppColors.dashboardPurpleLight,
                  fontSize: 9,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        Text(
          loading
              ? t(
                  en: 'Ready to learn?',
                  it: 'Pronto per imparare?',
                  ar: 'هل أنت مستعد للتعلم؟',
                )
              : t(
                  en: 'Welcome back, $username',
                  it: 'Bentornato, $username',
                  ar: 'مرحباً بعودتك، $username',
                ),
          textDirection:
              LanguageController.isArabic
                  ? TextDirection.rtl
                  : TextDirection.ltr,
          style: const TextStyle(
            color: white,
            fontSize: 30,
            height: 1.05,
            fontWeight: FontWeight.w900,
            letterSpacing: -1,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          t(
            en: 'Every lesson gets you closer to fluency.',
            it: 'Ogni lezione ti avvicina alla fluidità.',
            ar: 'كل درس يقرّبك أكثر من الطلاقة.',
          ),
          style: const TextStyle(
            color: AppColors.dashboardTextMuted,
            fontSize: 13,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 22),
        Row(
          children: [
            ElevatedButton.icon(
              onPressed: () => _open(const LessonsPage()),
              icon: const Icon(
                Icons.play_arrow_rounded,
                size: 19,
              ),
              label: Text(
                t(
                  en: 'Start learning',
                  it: 'Inizia',
                  ar: 'ابدأ التعلم',
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: white,
                foregroundColor: AppColors.dashboardDeepIndigo,
                elevation: 0,
                shadowColor: Colors.black.withValues(alpha: .20),
                padding: const EdgeInsets.symmetric(
                  horizontal: 19,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                textStyle: const TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 12,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 13,
                vertical: 12,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withValues(alpha: .10),
                    Colors.white.withValues(alpha: .045),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.white.withValues(alpha: .12),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: .10),
                    blurRadius: 16,
                    offset: const Offset(0, 7),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.local_fire_department_rounded,
                    color: AppColors.dashboardStreakOrange,
                    size: 17,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    '$streak',
                    style: const TextStyle(
                      color: white,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    t(
                      en: 'days',
                      it: 'giorni',
                      ar: 'أيام',
                    ),
                    style: const TextStyle(
                      color: muted,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _levelCircle() {
    return Container(
      width: 170,
      height: 170,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.dashboardPurpleAccent,
            AppColors.dashboardDeepBlue,
            AppColors.dashboardHeroBlue,
          ],
        ),
        border: Border.all(
          color: Colors.white.withValues(alpha: .08),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: blue.withValues(alpha: .24),
            blurRadius: 44,
            spreadRadius: 5,
          ),
          BoxShadow(
            color: purple.withValues(alpha: .12),
            blurRadius: 28,
            offset: const Offset(-8, 10),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 145,
            height: 145,
            child: CircularProgressIndicator(
              value: levelProgress == 0 ? .03 : levelProgress,
              strokeWidth: 9,
              backgroundColor: Colors.white.withValues(alpha: .07),
              valueColor: const AlwaysStoppedAnimation(purple),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'LEVEL',
                style: TextStyle(
                  color: muted,
                  fontSize: 9,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '$level',
                style: const TextStyle(
                  color: white,
                  fontSize: 39,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Text(
                '$xp XP',
                style: const TextStyle(
                  color: AppColors.dashboardPurpleSoft,
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _stats(bool desktop) {
    final data = [
      (
        Icons.bolt_rounded,
        '$xp',
        'XP',
        purple,
      ),
      (
        Icons.local_fire_department_rounded,
        '$streak',
        t(en: 'Streak', it: 'Serie', ar: 'السلسلة'),
        AppColors.dashboardOrangeStrong,
      ),
      (
        Icons.menu_book_rounded,
        '$lessons',
        t(en: 'Lessons', it: 'Lezioni', ar: 'الدروس'),
        blue,
      ),
      (
        Icons.favorite_rounded,
        '$favorites',
        t(en: 'Saved', it: 'Salvati', ar: 'المحفوظات'),
        pink,
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: data.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: desktop ? 4 : 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: desktop ? 2.15 : 1.65,
      ),
      itemBuilder: (_, i) {
        final item = data[i];

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: card,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withValues(alpha: .06),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: item.$4.withValues(alpha: .12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  item.$1,
                  color: item.$4,
                  size: 21,
                ),
              ),
              const SizedBox(width: 11),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.$2,
                      style: const TextStyle(
                        color: white,
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Text(
                      item.$3,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: muted,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _sectionTitle(String title, String subtitle) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: white,
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -.4,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                subtitle,
                style: const TextStyle(
                  color: muted,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
        const Icon(
          Icons.arrow_forward_rounded,
          color: muted,
          size: 18,
        ),
      ],
    );
  }

  Widget _continueCard() {
    final isArabic = LanguageController.isArabic;

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(26),
      child: InkWell(
        onTap: () => _open(const LessonsPage()),
        borderRadius: BorderRadius.circular(26),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.dashboardDeepCyan,
                AppColors.dashboardDeepBlue,
                AppColors.dashboardDeepIndigo,
              ],
            ),
            borderRadius: BorderRadius.circular(26),
            border: Border.all(
              color: purple.withValues(alpha: .22),
            ),
            boxShadow: [
              BoxShadow(
                color: purple.withValues(alpha: .16),
                blurRadius: 28,
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
                    width: 58,
                    height: 58,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          purple,
                          blue,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: purple.withValues(alpha: .25),
                          blurRadius: 18,
                          offset: const Offset(0, 7),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.menu_book_rounded,
                      color: white,
                      size: 27,
                    ),
                  ),

                  const SizedBox(width: 15),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: isArabic
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                      children: [
                        Text(
                          t(
                            en: 'Continue learning',
                            it: 'Continua ad imparare',
                            ar: 'تابع التعلم',
                          ),
                          textDirection: isArabic
                              ? TextDirection.rtl
                              : TextDirection.ltr,
                          style: const TextStyle(
                            color: white,
                            fontSize: 17,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -.3,
                          ),
                        ),

                        const SizedBox(height: 5),

                        Text(
                          language,
                          textDirection: isArabic
                              ? TextDirection.rtl
                              : TextDirection.ltr,
                          style: const TextStyle(
                            color: AppColors.dashboardTextSoft,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: .08),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withValues(alpha: .08),
                      ),
                    ),
                    child: const Icon(
                      Icons.arrow_forward_rounded,
                      color: white,
                      size: 19,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              Text(
                t(
                  en: 'Continue with your next lesson',
                  it: 'Continua con la prossima lezione',
                  ar: 'تابع درسك التالي',
                ),
                textDirection: isArabic
                    ? TextDirection.rtl
                    : TextDirection.ltr,
                style: const TextStyle(
                  color: AppColors.dashboardTextFaint,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 14),

              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: levelProgress,
                  minHeight: 8,
                  backgroundColor: Colors.white.withValues(alpha: .07),
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    purple,
                  ),
                ),
              ),

              const SizedBox(height: 10),

              Row(
                children: [
                  Text(
                    '${(levelProgress * 100).round()}%',
                    style: const TextStyle(
                      color: white,
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                    ),
                  ),

                  const SizedBox(width: 6),

                  Text(
                    t(
                      en: 'lesson progress',
                      it: 'progresso della lezione',
                      ar: 'تقدم الدرس',
                    ),
                    textDirection: isArabic
                        ? TextDirection.rtl
                        : TextDirection.ltr,
                    style: const TextStyle(
                      color: AppColors.dashboardTextDim,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const Spacer(),

                  Text(
                    t(
                      en: 'Open Lessons',
                      it: 'Apri lezioni',
                      ar: 'افتح الدروس',
                    ),
                    textDirection: isArabic
                        ? TextDirection.rtl
                        : TextDirection.ltr,
                    style: const TextStyle(
                      color: purple,
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                    ),
                  ),

                  const SizedBox(width: 5),

                  const Icon(
                    Icons.arrow_outward_rounded,
                    color: purple,
                    size: 14,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget _practiceGrid(bool desktop) {
    final items = [
      (
        Icons.auto_awesome_rounded,
        t(en: 'Smart Review', it: 'Ripasso', ar: 'المراجعة الذكية'),
        purple,
        const SmartReviewPage(),
      ),
      (
        Icons.local_fire_department_rounded,
        t(en: 'Daily Challenge', it: 'Sfida', ar: 'التحدي اليومي'),
        AppColors.dashboardOrangeStrong,
        const DailyChallengePage(),
      ),
      (
        Icons.record_voice_over_rounded,
        t(en: 'Pronunciation', it: 'Pronuncia', ar: 'النطق'),
        cyan,
        const PronunciationPage(),
      ),
      (
        Icons.quiz_rounded,
        t(en: 'Quiz', it: 'Quiz', ar: 'اختبار'),
        pink,
        const QuizPage(),
      ),
      (
        Icons.bar_chart_rounded,
        t(en: 'Progress', it: 'Progressi', ar: 'التقدم'),
        green,
        const ProgressPage(),
      ),
      (
        Icons.favorite_rounded,
        t(en: 'Favorites', it: 'Preferiti', ar: 'المفضلة'),
        pink,
        const FavoritesPage(),
      ),
      (
        Icons.school_rounded,
        t(en: 'Practice', it: 'Pratica', ar: 'تدريب'),
        blue,
        const PracticePage(),
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: desktop ? 4 : 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: desktop ? 1.55 : 1.15,
      ),
      itemBuilder: (_, i) {
        final item = items[i];

        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => _open(item.$4),
            borderRadius: BorderRadius.circular(21),
            splashColor: item.$3.withValues(alpha: .08),
            highlightColor: item.$3.withValues(alpha: .04),
            child: Ink(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    item.$3.withValues(alpha: .055),
                    card,
                    card,
                  ],
                ),
                borderRadius: BorderRadius.circular(21),
                border: Border.all(
                  color: item.$3.withValues(alpha: .12),
                ),
                boxShadow: [
                  BoxShadow(
                    color: item.$3.withValues(alpha: .045),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 47,
                    height: 47,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          item.$3.withValues(alpha: .22),
                          item.$3.withValues(alpha: .08),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: item.$3.withValues(alpha: .14),
                      ),
                    ),
                    child: Icon(
                      item.$1,
                      color: item.$3,
                      size: 22,
                    ),
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          item.$2,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: white,
                            fontSize: 12,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 25,
                        height: 25,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: .055),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.arrow_outward_rounded,
                          color: muted,
                          size: 13,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _dailyGoal() {
    final percentage = (dailyProgress * 100).round();
    final completed = dailyProgress >= 1.0;
    final remaining = (dailyGoal - dailyXp).clamp(0, dailyGoal);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(21),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: completed
              ? [
                  AppColors.dashboardGreenDark,
                  AppColors.dashboardCyanDark,
                  AppColors.dashboardDeepIndigo,
                ]
              : [
                  AppColors.dashboardDeepGreen,
                  AppColors.dashboardDeepTeal,
                  AppColors.dashboardDeepIndigo,
                ],
        ),
        border: Border.all(
          color: completed
              ? green.withValues(alpha: .32)
              : cyan.withValues(alpha: .18),
        ),
        boxShadow: [
          BoxShadow(
            color: (completed ? green : cyan).withValues(alpha: .10),
            blurRadius: 28,
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
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: completed
                        ? [
                            AppColors.dashboardGreen,
                            AppColors.dashboardCyan,
                          ]
                        : [
                            AppColors.dashboardGreenAlt,
                            AppColors.dashboardCyan,
                          ],
                  ),
                  borderRadius: BorderRadius.circular(17),
                  boxShadow: [
                    BoxShadow(
                      color: (completed ? green : cyan)
                          .withValues(alpha: .20),
                      blurRadius: 18,
                      offset: const Offset(0, 7),
                    ),
                  ],
                ),
                child: Icon(
                  completed
                      ? Icons.check_rounded
                      : Icons.flag_rounded,
                  color: white,
                  size: 23,
                ),
              ),

              const SizedBox(width: 13),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      t(
                        en: 'Daily goal',
                        it: 'Obiettivo giornaliero',
                        ar: 'الهدف اليومي',
                      ),
                      textDirection: LanguageController.isArabic
                          ? TextDirection.rtl
                          : TextDirection.ltr,
                      style: const TextStyle(
                        color: white,
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      completed
                          ? t(
                              en: 'Goal completed today',
                              it: 'Obiettivo completato oggi',
                              ar: 'تم تحقيق الهدف اليوم',
                            )
                          : t(
                              en: '$dailyXp / $dailyGoal XP earned today',
                              it: '$dailyXp / $dailyGoal XP guadagnati oggi',
                              ar: 'تم كسب $dailyXp من $dailyGoal XP اليوم',
                            ),
                      textDirection: LanguageController.isArabic
                          ? TextDirection.rtl
                          : TextDirection.ltr,
                      style: const TextStyle(
                        color: muted,
                        fontSize: 10.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 11,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: .07),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: .06),
                  ),
                ),
                child: Text(
                  '$percentage%',
                  style: TextStyle(
                    color: completed ? green : cyan,
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 21),

          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Stack(
              children: [
                Container(
                  height: 11,
                  width: double.infinity,
                  color: Colors.white.withValues(alpha: .07),
                ),
                FractionallySizedBox(
                  widthFactor: dailyProgress,
                  child: Container(
                    height: 11,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: completed
                            ? [
                                AppColors.dashboardGreen,
                                AppColors.dashboardCyan,
                              ]
                            : [
                                AppColors.dashboardGreenAlt,
                                AppColors.dashboardCyan,
                              ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 13),

          Row(
            children: [
              Icon(
                completed
                    ? Icons.emoji_events_rounded
                    : Icons.bolt_rounded,
                color: completed ? AppColors.dashboardGold : cyan,
                size: 16,
              ),

              const SizedBox(width: 6),

              Expanded(
                child: Text(
                  completed
                      ? t(
                          en: 'Excellent! You reached today’s goal.',
                          it: 'Ottimo! Hai raggiunto l’obiettivo di oggi.',
                          ar: 'ممتاز! لقد حققت هدف اليوم.',
                        )
                      : t(
                          en: '$remaining XP left to reach your goal',
                          it: 'Ancora $remaining XP per raggiungere il tuo obiettivo',
                          ar: 'تبقى $remaining XP لتحقيق هدفك',
                        ),
                  textDirection: LanguageController.isArabic
                      ? TextDirection.rtl
                      : TextDirection.ltr,
                  style: const TextStyle(
                    color: muted,
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),

              if (completed)
                const Icon(
                  Icons.check_circle_rounded,
                  color: green,
                  size: 18,
                ),
            ],
          ),
        ],
      ),
    );
  }
    Widget _languages() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle(
          t(
            en: 'Your languages',
            it: 'Le tue lingue',
            ar: 'لغاتك',
          ),
          t(
            en: 'Choose your learning language',
            it: 'Scegli la lingua da imparare',
            ar: 'اختر لغة التعلم',
          ),
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child: _languageCard(
                'English',
                '🇬🇧',
                blue,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _languageCard(
                'Italiano',
                '🇮🇹',
                green,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _languageCard(
                'العربية',
                '🇸🇦',
                purple,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _languageCard(
    String value,
    String flag,
    Color color,
  ) {
    final selected = language == value;

    return GestureDetector(
      onTap: () async {
        await HiveService.setSelectedLanguage(value);
        await LanguageController.setLanguage(value);

        if (mounted) {
          setState(() => language = value);
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 260),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(
          vertical: 20,
          horizontal: 8,
        ),
        decoration: BoxDecoration(
          gradient: selected
              ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    color.withValues(alpha: .20),
                    color.withValues(alpha: .07),
                  ],
                )
              : null,
          color: selected ? null : card,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: selected
                ? color.withValues(alpha: .65)
                : Colors.white.withValues(alpha: .07),
            width: selected ? 1.5 : 1,
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: color.withValues(alpha: .18),
                    blurRadius: 22,
                    offset: const Offset(0, 8),
                  ),
                ]
              : null,
        ),
        child: Column(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 260),
              width: 58,
              height: 58,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    color.withValues(
                      alpha: selected ? .24 : .12,
                    ),
                    color.withValues(
                      alpha: selected ? .10 : .05,
                    ),
                  ],
                ),
                border: Border.all(
                  color: color.withValues(
                    alpha: selected ? .45 : .18,
                  ),
                  width: 1,
                ),
              ),
              child: Center(
                child: Text(
                  flag,
                  style: const TextStyle(
                    fontSize: 29,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textDirection: value == 'العربية'
                  ? TextDirection.rtl
                  : TextDirection.ltr,
              style: TextStyle(
                color: selected ? white : muted,
                fontSize: 12,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 9),
            AnimatedContainer(
              duration: const Duration(milliseconds: 260),
              width: selected ? 24 : 20,
              height: selected ? 24 : 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: selected
                    ? color
                    : Colors.white.withValues(alpha: .05),
                border: Border.all(
                  color: selected
                      ? color
                      : Colors.white.withValues(alpha: .10),
                ),
              ),
              child: Icon(
                selected
                    ? Icons.check_rounded
                    : Icons.circle_outlined,
                color: selected
                    ? white
                    : Colors.white.withValues(alpha: .25),
                size: selected ? 15 : 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}







