import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

import '../database/hive_service.dart';
import '../services/language_controller.dart';
import 'lessons_page.dart';
import 'profile_page.dart';
import 'smart_review_page.dart';
import 'daily_challenge_page.dart';
import 'pronunciation_page.dart';
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

  String username = 'Learner';
  String language = 'English';

  @override
  void initState() {
    super.initState();
    LanguageController.language.addListener(_refreshLanguage);
    _loadData();
  }

  void _refreshLanguage() {
    if (mounted) setState(() {});
  }

  Future<void> _loadData() async {
    await HiveService.init();

    if (!mounted) return;

    setState(() {
      xp = HiveService.xp;
      level = HiveService.level;
      streak = HiveService.streak;
      lessons = HiveService.completedLessons.length;

      final name = HiveService.username.trim();
      username = name.isEmpty ? 'Learner' : name;

      language = HiveService.selectedLanguage;
    });
  }

  @override
  void dispose() {
    LanguageController.language.removeListener(_refreshLanguage);
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

  bool get arabic => LanguageController.isArabic;

  void _open(Widget page) {
    Navigator.of(context)
        .push(
          MaterialPageRoute(builder: (_) => page),
        )
        .then((_) => _loadData());
  }

  Future<void> _changeLanguage(String value) async {
    await HiveService.setSelectedLanguage(value);
    await LanguageController.setLanguage(value);

    if (!mounted) return;

    setState(() {
      language = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final wide = constraints.maxWidth >= 850;

            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 1250,
                ),
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: wide ? 36 : 20,
                    vertical: 24,
                  ),
                  child: Column(
                    children: [
                      _topBar(),
                      const SizedBox(height: 28),
                      _hero(wide),
                      const SizedBox(height: 24),
                      _stats(wide),
                      const SizedBox(height: 30),
                      _section(
                        t(
                          en: 'Start learning',
                          it: 'Inizia a imparare',
                          ar: 'ابدأ التعلم',
                        ),
                        _learningCards(wide),
                      ),
                      const SizedBox(height: 30),
                      _section(
                        t(
                          en: 'Practice',
                          it: 'Pratica',
                          ar: 'تدريب',
                        ),
                        _practiceCards(wide),
                      ),
                      const SizedBox(height: 30),
                      _languagePanel(),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _topBar() {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                AppColors.primary,
                AppColors.secondary,
              ],
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(
            Icons.auto_awesome_rounded,
            color: AppColors.textPrimary,
            size: 25,
          ),
        ),
        const SizedBox(width: 14),
        const Expanded(
          child: Text(
            'ARAB.IT',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.2,
            ),
          ),
        ),
        _languageButton(),
        const SizedBox(width: 10),
        GestureDetector(
          onTap: () => _open(const ProfilePage()),
          child: Container(
            width: 46,
            height: 46,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.textPrimary.withValues(alpha: 0.10),
              ),
            ),
            child: Text(
              username.substring(0, 1).toUpperCase(),
              style: const TextStyle(
                color: AppColors.secondaryLight,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _languageButton() {
    return PopupMenuButton<String>(
      onSelected: _changeLanguage,
      color: AppColors.surfaceVariant,
      itemBuilder: (_) => const [
        PopupMenuItem(
          value: 'English',
          child: Text(
            'English',
            style: TextStyle(color: AppColors.textPrimary),
          ),
        ),
        PopupMenuItem(
          value: 'Italiano',
          child: Text(
            'Italiano',
            style: TextStyle(color: AppColors.textPrimary),
          ),
        ),
        PopupMenuItem(
          value: 'العربية',
          child: Text(
            'العربية',
            style: TextStyle(color: AppColors.textPrimary),
          ),
        ),
      ],
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 11,
        ),
        decoration: BoxDecoration(
          color: AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: AppColors.textPrimary.withValues(alpha: 0.08),
          ),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.language_rounded,
              color: AppColors.secondaryLight,
              size: 18,
            ),
            const SizedBox(width: 6),
            Text(
              language == 'العربية'
                  ? 'AR'
                  : language == 'Italiano'
                      ? 'IT'
                      : 'EN',
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 12,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _hero(bool wide) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(wide ? 38 : 26),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primaryDark,
            AppColors.backgroundSecondary,
            AppColors.backgroundTertiary,
          ],
        ),
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: AppColors.secondary.withValues(alpha: 0.14),
            blurRadius: 40,
            spreadRadius: 2,
          ),
        ],
      ),
      child: wide
          ? Row(
              children: [
                Expanded(child: _heroText()),
                const SizedBox(width: 40),
                _levelCircle(),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _heroText(),
                const SizedBox(height: 28),
                Align(
                  alignment: Alignment.center,
                  child: _levelCircle(),
                ),
              ],
            ),
    );
  }

  Widget _heroText() {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 11,
            vertical: 7,
          ),
          decoration: BoxDecoration(
            color: AppColors.textPrimary.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Text(
            language,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 11,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        const SizedBox(height: 18),
        Text(
          t(
            en: 'Welcome back, $username',
            it: 'Bentornato, $username',
            ar: 'مرحباً بك، $username',
          ),
          textDirection:
              arabic ? TextDirection.rtl : TextDirection.ltr,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 32,
            height: 1.1,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          t(
            en: 'Your next language breakthrough starts today.',
            it: 'Il tuo prossimo passo nella lingua inizia oggi.',
            ar: 'خطوتك التالية في تعلم اللغة تبدأ اليوم.',
          ),
          textDirection:
              arabic ? TextDirection.rtl : TextDirection.ltr,
          style: TextStyle(
            color: AppColors.textPrimary.withValues(alpha: 0.72),
            fontSize: 14,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: () => _open(LessonsPage()),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.textPrimary,
            foregroundColor: AppColors.primaryDark,
            elevation: 0,
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 15,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          child: Text(
            t(
              en: 'Continue learning',
              it: 'Continua a imparare',
              ar: 'متابعة التعلم',
            ),
            style: const TextStyle(
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ],
    );
  }

  Widget _levelCircle() {
    final progress = ((xp % 100) / 100).clamp(0.04, 1.0);

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
              value: progress,
              strokeWidth: 10,
              backgroundColor:
                  AppColors.textPrimary.withValues(alpha: 0.12),
              valueColor:
                  const AlwaysStoppedAnimation<Color>(
                AppColors.textPrimary,
              ),
            ),
          ),
          Column(
            mainAxisAlignment:
                MainAxisAlignment.center,
            children: [
              Text(
                'LEVEL',
                style: TextStyle(
                  color: AppColors.textPrimary.withValues(alpha: 0.65),
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.5,
                ),
              ),
              Text(
                '$level',
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 42,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Text(
                '$xp XP',
                style: const TextStyle(
                  color: AppColors.secondaryLight,
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _stats(bool wide) {
    final data = [
      (
        Icons.bolt_rounded,
        '$xp',
        'XP',
        AppColors.xp,
      ),
      (
        Icons.local_fire_department_rounded,
        '$streak',
        t(
          en: 'Day streak',
          it: 'Giorni',
          ar: 'أيام متتالية',
        ),
        AppColors.streak,
      ),
      (
        Icons.menu_book_rounded,
        '$lessons',
        t(
          en: 'Lessons',
          it: 'Lezioni',
          ar: 'الدروس',
        ),
        AppColors.secondary,
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics:
          const NeverScrollableScrollPhysics(),
      itemCount: data.length,
      gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: wide ? 3 : 1,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: wide ? 3.1 : 4.2,
      ),
      itemBuilder: (_, index) {
        final item = data[index];

        return Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: AppColors.textPrimary.withValues(alpha: 0.06),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: item.$4.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(
                  item.$1,
                  color: item.$4,
                  size: 23,
                ),
              ),
              const SizedBox(width: 14),
              Column(
                mainAxisAlignment:
                    MainAxisAlignment.center,
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    item.$2,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Text(
                    item.$3,
                    style: TextStyle(
                      color: AppColors.textPrimary.withValues(alpha: 0.45),
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _section(
    String title,
    Widget content,
  ) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Align(
          alignment: arabic
              ? Alignment.centerRight
              : Alignment.centerLeft,
          child: Text(
            title,
            textDirection:
                arabic ? TextDirection.rtl : TextDirection.ltr,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 22,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        const SizedBox(height: 14),
        content,
      ],
    );
  }

  Widget _learningCards(bool wide) {
    final cards = [
      _bigCard(
        Icons.menu_book_rounded,
        t(
          en: 'Lessons',
          it: 'Lezioni',
          ar: 'الدروس',
        ),
        t(
          en: 'Learn step by step',
          it: 'Impara passo dopo passo',
          ar: 'تعلم خطوة بخطوة',
        ),
        AppColors.primary,
        () => _open(LessonsPage()),
      ),
      _bigCard(
        Icons.auto_awesome_rounded,
        t(
          en: 'Smart Review',
          it: 'Ripasso intelligente',
          ar: 'المراجعة الذكية',
        ),
        t(
          en: 'Review what you need',
          it: 'Ripassa ciò che ti serve',
          ar: 'راجع ما تحتاجه',
        ),
        AppColors.secondary,
        () => _open(const SmartReviewPage()),
      ),
    ];

    return GridView.count(
      shrinkWrap: true,
      physics:
          const NeverScrollableScrollPhysics(),
      crossAxisCount: wide ? 2 : 1,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: wide ? 2.8 : 2.5,
      children: cards,
    );
  }

  Widget _bigCard(
    IconData icon,
    String title,
    String subtitle,
    Color color,
    VoidCallback onTap,
  ) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      color,
                      color.withValues(alpha: 0.45),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Icon(
                  icon,
                  color: AppColors.textPrimary,
                  size: 27,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  mainAxisAlignment:
                      MainAxisAlignment.center,
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      subtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: AppColors.textPrimary.withValues(alpha: 0.48),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_rounded,
                color: Colors.white38,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _practiceCards(bool wide) {
    final cards = [
      _smallCard(
        Icons.calendar_today_rounded,
        t(
          en: 'Daily Challenge',
          it: 'Sfida giornaliera',
          ar: 'التحدي اليومي',
        ),
        AppColors.streak,
        () => _open(const DailyChallengePage()),
      ),
      _smallCard(
        Icons.record_voice_over_rounded,
        t(
          en: 'Pronunciation',
          it: 'Pronuncia',
          ar: 'النطق',
        ),
        AppColors.secondary,
        () => _open(const PronunciationPage()),
      ),
      _smallCard(
        Icons.quiz_rounded,
        t(
          en: 'Quiz',
          it: 'Quiz',
          ar: 'اختبار',
        ),
        AppColors.xp,
        () => _open(const QuizPage()),
      ),
    ];

    return GridView.count(
      shrinkWrap: true,
      physics:
          const NeverScrollableScrollPhysics(),
      crossAxisCount: wide ? 3 : 1,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: wide ? 2.1 : 4.0,
      children: cards,
    );
  }

  Widget _smallCard(
    IconData icon,
    String title,
    Color color,
    VoidCallback onTap,
  ) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(
                  icon,
                  color: color,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.white30,
                size: 14,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _languagePanel() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            AppColors.surfaceVariant,
            AppColors.surface,
          ],
        ),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(
          color: AppColors.textPrimary.withValues(alpha: 0.06),
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Text(
            t(
              en: 'Learning language',
              it: 'Lingua di apprendimento',
              ar: 'لغة التعلم',
            ),
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 17,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _languageChoice(
                  'English',
                  'EN',
                  AppColors.english,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _languageChoice(
                  'Italiano',
                  'IT',
                  AppColors.success,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _languageChoice(
                  'العربية',
                  'AR',
                  AppColors.warning,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _languageChoice(
    String value,
    String code,
    Color color,
  ) {
    final selected = language == value;

    return GestureDetector(
      onTap: () => _changeLanguage(value),
      child: AnimatedContainer(
        duration:
            const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 8,
        ),
        decoration: BoxDecoration(
          color: selected
              ? color.withValues(alpha: 0.14)
              : AppColors.background,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: selected
                ? color.withValues(alpha: 0.65)
                : AppColors.textPrimary.withValues(alpha: 0.06),
          ),
        ),
        child: Column(
          children: [
            Text(
              code,
              style: TextStyle(
                color: color,
                fontSize: 17,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textDirection: value == 'العربية'
                  ? TextDirection.rtl
                  : TextDirection.ltr,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 10,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 5),
            Icon(
              selected
                  ? Icons.check_circle_rounded
                  : Icons.circle_outlined,
              color: selected
                  ? color
                  : Colors.white24,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}




