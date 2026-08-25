import 'package:flutter/material.dart';
import 'package:arab_it/core/theme/app_colors.dart';

import '../database/hive_service.dart';
import '../theme/app_colors.dart';
import '../services/language_controller.dart';
import 'lessons_page.dart';
import 'practice_page.dart';
import 'profile_page.dart';
import 'smart_review_page.dart';
import 'daily_challenge_page.dart';
import 'pronunciation_page.dart';
import 'progress_page.dart';
import 'favorites_page.dart';
import 'quiz_page.dart';

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

  @override
  void initState() {
    super.initState();

    LanguageController.language.addListener(_languageChanged);
    _loadData();
  }

  void _languageChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _loadData() async {
    try {
      await HiveService.init();

      if (!mounted) return;

      setState(() {
        xp = HiveService.xp;
        level = HiveService.level;
        streak = HiveService.streak;
        lessons = HiveService.completedLessons.length;
        favorites = HiveService.favorites.length;
        dailyXp = HiveService.dailyXp;
        dailyGoal = HiveService.dailyGoal;

        final name = HiveService.username.trim();
        username = name.isEmpty ? 'Learner' : name;

        language = HiveService.selectedLanguage;
        loading = false;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        loading = false;
      });
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

  String get languageCode {
    if (language == '???????') return 'AR';
    if (language == 'Italiano') return 'IT';
    return 'EN';
  }

  double get levelProgress {
    return ((xp % 100) / 100).clamp(0.0, 1.0);
  }

  double get dailyProgress {
    if (dailyGoal <= 0) return 0;
    return (dailyXp / dailyGoal).clamp(0.0, 1.0);
  }

  void _open(Widget page) {
    Navigator.of(context)
        .push(
          MaterialPageRoute(builder: (_) => page),
        )
        .then((_) => _loadData());
  }

  Future<void> _selectLanguage(String value) async {
    await HiveService.setSelectedLanguage(value);
    await LanguageController.setLanguage(value);

    if (!mounted) return;

    setState(() {
      language = value;
    });
  }

  void _languagePicker() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.darkSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(30),
        ),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(22, 14, 22, 30),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 42,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                const SizedBox(height: 24),
                Align(
                  alignment: LanguageController.isArabic
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Text(
                    t(
                      en: 'Learning language',
                      it: 'Lingua di apprendimento',
                      ar: '??? ??????',
                    ),
                    style: const TextStyle(
                      color: AppColors.white,
                      fontSize: 23,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                _languageItem(context, 'English', 'EN', AppColors.info),
                const SizedBox(height: 10),
                _languageItem(context, 'Italiano', 'IT', AppColors.success),
                const SizedBox(height: 10),
                _languageItem(context, '???????', 'AR', AppColors.error),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _languageItem(
    BuildContext context,
    String value,
    String code,
    Color color,
  ) {
    final selected = language == value;

    return Material(
      color: selected
          ? color.withValues(alpha: 0.12)
          : AppColors.darkSurfaceSecondary,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () async {
          Navigator.pop(context);
          await _selectLanguage(value);
        },
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.13),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(
                  code,
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  value,
                  textDirection:
                      value == '???????'
                          ? TextDirection.rtl
                          : TextDirection.ltr,
                  style: const TextStyle(
                    color: AppColors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Icon(
                selected
                    ? Icons.check_circle_rounded
                    : Icons.circle_outlined,
                color: selected ? color : AppColors.darkTextSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: SafeArea(
        child: RefreshIndicator(
          color: AppColors.primaryLight,
          backgroundColor: AppColors.darkSurface,
          onRefresh: _loadData,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final desktop = constraints.maxWidth >= 900;

              return CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                slivers: [
                  SliverToBoxAdapter(
                    child: _header(desktop),
                  ),
                  SliverToBoxAdapter(
                    child: _content(desktop),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _content(bool desktop) {
    final maxWidth = desktop ? 1180.0 : double.infinity;

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: maxWidth,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: desktop ? 28 : 18,
            vertical: 4,
          ),
          child: Column(
            children: [
              _hero(desktop),
              const SizedBox(height: 18),
              _stats(desktop),
              const SizedBox(height: 22),
              _mainGrid(desktop),
              const SizedBox(height: 22),
              _languages(),
              const SizedBox(height: 22),
              _tools(desktop),
              const SizedBox(height: 35),
            ],
          ),
        ),
      ),
    );
  }

  Widget _header(bool desktop) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: desktop ? 1180 : double.infinity,
        ),
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            desktop ? 28 : 18,
            18,
            desktop ? 28 : 18,
            14,
          ),
          child: Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.primaryLight, AppColors.accentLight],
                  ),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryLight.withValues(alpha: 0.25),
                      blurRadius: 20,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.language_rounded,
                  color: AppColors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Arab.it',
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.5,
                  ),
                ),
              ),
              _glassButton(
                icon: Icons.translate_rounded,
                label: languageCode,
                onTap: _languagePicker,
              ),
              const SizedBox(width: 9),
              _glassButton(
                icon: Icons.person_outline_rounded,
                label: '',
                onTap: () => _open(const ProfilePage()),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _glassButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Material(
      color: AppColors.darkSurface,
      borderRadius: BorderRadius.circular(15),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 11,
            vertical: 10,
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: AppColors.darkTextSecondary,
                size: 19,
              ),
              if (label.isNotEmpty) ...[
                const SizedBox(width: 6),
                Text(
                  label,
                  style: const TextStyle(
                    color: AppColors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _hero(bool desktop) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(desktop ? 32 : 22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF19122B),
            Color(0xFF101A28),
            Color(0xFF0C1518),
          ],
        ),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: AppColors.primaryLight.withValues(alpha: 0.25),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryLight.withValues(alpha: 0.08),
            blurRadius: 35,
            spreadRadius: 2,
          ),
        ],
      ),
      child: desktop
          ? Row(
              children: [
                Expanded(child: _heroText()),
                const SizedBox(width: 30),
                _heroProgress(),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _heroText(),
                const SizedBox(height: 25),
                _heroProgress(),
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
            horizontal: 10,
            vertical: 6,
          ),
          decoration: BoxDecoration(
            color: AppColors.primaryLight.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Text(
            'ARAB.IT • 2026',
            style: TextStyle(
              color: Color(0xFFC4B5FD),
              fontSize: 10,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.2,
            ),
          ),
        ),
        const SizedBox(height: 18),
        Text(
          loading
              ? t(
                  en: 'Ready to learn?',
                  it: 'Pronto per imparare?',
                  ar: '?? ??? ????? ???????',
                )
              : t(
                  en: 'Welcome back, $username',
                  it: 'Bentornato, $username',
                  ar: '?????? ??????? $username',
                ),
          textDirection: LanguageController.isArabic
              ? TextDirection.rtl
              : TextDirection.ltr,
          style: const TextStyle(
            color: AppColors.white,
            fontSize: 30,
            height: 1.05,
            fontWeight: FontWeight.w900,
            letterSpacing: -1,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          t(
            en: 'Build real language skills with focused lessons, smart review and daily practice.',
            it: 'Migliora le tue lingue con lezioni mirate, ripasso intelligente e pratica quotidiana.',
            ar: '???? ??????? ??????? ?? ???? ???? ????? ??????? ???? ??????? ?????.',
          ),
          textDirection: LanguageController.isArabic
              ? TextDirection.rtl
              : TextDirection.ltr,
          style: const TextStyle(
            color: AppColors.darkTextSecondary,
            fontSize: 14,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 22),
        SizedBox(
          height: 50,
          child: ElevatedButton.icon(
            onPressed: () => _open(LessonsPage()),
            icon: const Icon(Icons.play_arrow_rounded),
            label: Text(
              t(
                en: 'Continue learning',
                it: 'Continua a imparare',
                ar: '?????? ??????',
              ),
              style: const TextStyle(
                fontWeight: FontWeight.w900,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.white,
              foregroundColor: Colors.black,
              elevation: 0,
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
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

  Widget _heroProgress() {
    return SizedBox(
      width: 155,
      height: 155,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 155,
            height: 155,
            child: CircularProgressIndicator(
              value: levelProgress == 0 ? 0.02 : levelProgress,
              strokeWidth: 10,
              backgroundColor: Colors.white.withValues(alpha: 0.06),
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.accentLight),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'LEVEL',
                style: TextStyle(
                  color: AppColors.darkTextSecondary,
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.5,
                ),
              ),
              Text(
                '$level',
                style: const TextStyle(
                  color: AppColors.white,
                  fontSize: 38,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Text(
                '$xp XP',
                style: const TextStyle(
                  color: AppColors.accentLight,
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _stats(bool desktop) {
    final cards = [
      _stat(
        Icons.local_fire_department_rounded,
        '$streak',
        t(en: 'Day streak', it: 'Serie', ar: '???? ???????'),
        AppColors.warning,
      ),
      _stat(
        Icons.bolt_rounded,
        '$xp',
        'XP',
        AppColors.accentLight,
      ),
      _stat(
        Icons.menu_book_rounded,
        '$lessons',
        t(en: 'Lessons', it: 'Lezioni', ar: '??????'),
        AppColors.success,
      ),
      _stat(
        Icons.favorite_rounded,
        '$favorites',
        t(en: 'Saved', it: 'Salvati', ar: '?????????'),
        AppColors.error,
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: cards.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: desktop ? 4 : 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: desktop ? 2.4 : 1.65,
      ),
      itemBuilder: (_, index) => cards[index],
    );
  }

  Widget _stat(
    IconData icon,
    String value,
    String label,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.darkSurface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.05),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(
              icon,
              color: color,
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
                  value,
                  style: const TextStyle(
                    color: AppColors.white,
                    fontSize: 19,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.darkTextSecondary,
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
  }

  Widget _mainGrid(bool desktop) {
    final cards = [
      _feature(
        Icons.auto_awesome_rounded,
        t(
          en: 'Smart Review',
          it: 'Ripasso intelligente',
          ar: '???????? ??????',
        ),
        t(
          en: 'Review words you need most.',
          it: 'Ripassa le parole più importanti.',
          ar: '???? ??????? ???? ??????? ????.',
        ),
        AppColors.primaryLight,
        () => _open(const SmartReviewPage()),
      ),
      _feature(
        Icons.local_fire_department_rounded,
        t(
          en: 'Daily Challenge',
          it: 'Sfida giornaliera',
          ar: '?????? ??????',
        ),
        t(
          en: 'Complete today’s challenge.',
          it: 'Completa la sfida di oggi.',
          ar: '???? ???? ?????.',
        ),
        AppColors.warning,
        () => _open(const DailyChallengePage()),
      ),
      _feature(
        Icons.record_voice_over_rounded,
        t(
          en: 'Pronunciation',
          it: 'Pronuncia',
          ar: '?????',
        ),
        t(
          en: 'Train your speaking.',
          it: 'Migliora la pronuncia.',
          ar: '???? ????.',
        ),
        AppColors.accentLight,
        () => _open(const PronunciationPage()),
      ),
      _feature(
        Icons.quiz_rounded,
        t(
          en: 'Quiz',
          it: 'Quiz',
          ar: '??????',
        ),
        t(
          en: 'Test what you know.',
          it: 'Metti alla prova le tue conoscenze.',
          ar: '????? ?? ??????.',
        ),
        AppColors.info,
        () => _open(const QuizPage()),
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: cards.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: desktop ? 4 : 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: desktop ? 1.45 : 1.15,
      ),
      itemBuilder: (_, index) => cards[index],
    );
  }

  Widget _feature(
    IconData icon,
    String title,
    String subtitle,
    Color color,
    VoidCallback onTap,
  ) {
    return Material(
      color: AppColors.darkSurface,
      borderRadius: BorderRadius.circular(22),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Padding(
          padding: const EdgeInsets.all(17),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 23,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: AppColors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                subtitle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: AppColors.darkTextSecondary,
                  fontSize: 10,
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _languages() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          t(
            en: 'Your languages',
            it: 'Le tue lingue',
            ar: '?????',
          ),
          style: const TextStyle(
            color: AppColors.white,
            fontSize: 20,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _languageCard(
                'English',
                'EN',
                AppColors.info,
              ),
            ),
            const SizedBox(width: 9),
            Expanded(
              child: _languageCard(
                'Italiano',
                'IT',
                AppColors.success,
              ),
            ),
            const SizedBox(width: 9),
            Expanded(
              child: _languageCard(
                '???????',
                'AR',
                AppColors.error,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _languageCard(
    String value,
    String code,
    Color color,
  ) {
    final selected = language == value;

    return GestureDetector(
      onTap: () => _selectLanguage(value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        padding: const EdgeInsets.symmetric(
          vertical: 17,
          horizontal: 5,
        ),
        decoration: BoxDecoration(
          color: selected
              ? color.withValues(alpha: 0.13)
              : AppColors.darkSurface,
          borderRadius: BorderRadius.circular(19),
          border: Border.all(
            color: selected
                ? color.withValues(alpha: 0.55)
                : Colors.white.withValues(alpha: 0.05),
          ),
        ),
        child: Column(
          children: [
            Container(
              width: 44,
              height: 44,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Text(
                code,
                style: TextStyle(
                  color: color,
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            const SizedBox(height: 9),
            Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textDirection: value == '???????'
                  ? TextDirection.rtl
                  : TextDirection.ltr,
              style: const TextStyle(
                color: AppColors.white,
                fontSize: 10,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 6),
            Icon(
              selected
                  ? Icons.check_circle_rounded
                  : Icons.circle_outlined,
              color: selected ? color : Colors.white24,
              size: 15,
            ),
          ],
        ),
      ),
    );
  }

  Widget _tools(bool desktop) {
    final items = [
      _tool(
        Icons.bar_chart_rounded,
        t(en: 'Progress', it: 'Progressi', ar: '??????'),
        t(
          en: 'Track your learning journey',
          it: 'Segui il tuo percorso',
          ar: '???? ???? ?????',
        ),
        AppColors.primaryLight,
        () => _open(const ProgressPage()),
      ),
      _tool(
        Icons.favorite_rounded,
        t(en: 'Favorites', it: 'Preferiti', ar: '???????'),
        t(
          en: 'Your saved words',
          it: 'Le tue parole salvate',
          ar: '?????? ????????',
        ),
        AppColors.error,
        () => _open(const FavoritesPage()),
      ),
      _tool(
        Icons.school_rounded,
        t(en: 'Practice', it: 'Pratica', ar: '????????'),
        t(
          en: 'Build your skills',
          it: 'Sviluppa le tue abilità',
          ar: '???? ???????',
        ),
        AppColors.success,
        () => _open(const PracticePage()),
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          t(
            en: 'Explore Arab.it',
            it: 'Esplora Arab.it',
            ar: '?????? Arab.it',
          ),
          style: const TextStyle(
            color: AppColors.white,
            fontSize: 20,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: desktop ? 3 : 1,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: desktop ? 3.3 : 4.0,
          ),
          itemBuilder: (_, index) => items[index],
        ),
      ],
    );
  }

  Widget _tool(
    IconData icon,
    String title,
    String subtitle,
    Color color,
    VoidCallback onTap,
  ) {
    return Material(
      color: AppColors.darkSurface,
      borderRadius: BorderRadius.circular(19),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(19),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 22,
                ),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: AppColors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.darkTextSecondary,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                color: AppColors.darkTextSecondary,
                size: 15,
              ),
            ],
          ),
        ),
      ),
    );
  }
}







