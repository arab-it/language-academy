import 'package:flutter/material.dart';
import 'package:arab_it/core/theme/app_colors.dart';

import '../database/hive_service.dart';
import '../services/language_controller.dart';
import 'statistics_page.dart';
import 'achievements_page.dart';
import 'settings_page.dart';
import 'favorites_page.dart';
import 'premium_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  static const Color bg = AppColors.background;
  static const Color card = AppColors.surface;

  static const Color purple = AppColors.primary;
  static const Color cyan = AppColors.cyan;
  static const Color green = AppColors.success;
  static const Color orange = AppColors.streak;
  static const Color pink = AppColors.aiCoachAccent;
  static const Color blue = AppColors.blue;
  static const Color white = Colors.white;
  static const Color muted = AppColors.textMuted;

  int xp = 0;
  int level = 1;
  int lessons = 0;
  int streak = 0;
  int favorites = 0;
  int completedReadings = 0;
  int readingGoal = 0;

  String username = 'Learner';

  bool loading = true;

  bool isPremium = false;
  String premiumPlan = 'monthly';

  @override
  void initState() {
    super.initState();

    LanguageController.language.addListener(_languageChanged);

    _loadProfile();
  }

  void _languageChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _loadProfile() async {
    try {
      await HiveService.init();

      if (!mounted) return;

      setState(() {
        xp = HiveService.xp;
        level = HiveService.level;
        lessons = HiveService.completedLessons.length;
        streak = HiveService.streak;
        favorites = HiveService.favorites.length;
        completedReadings = HiveService.completedReadings;
        readingGoal = HiveService.dailyGoal;
        isPremium = HiveService.isPremium;
        premiumPlan = HiveService.premiumPlan;

        final name = HiveService.username.trim();
        username = name.isEmpty ? 'Learner' : name;

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

  String t({required String en, required String it, required String ar}) {
    if (LanguageController.isArabic) return ar;
    if (LanguageController.isItalian) return it;
    return en;
  }

  TextDirection get textDirection {
    return LanguageController.isArabic ? TextDirection.rtl : TextDirection.ltr;
  }

  int get currentLevelXP => xp % 100;

  double get levelProgress {
    return (currentLevelXP / 100).clamp(0.0, 1.0);
  }

  int get remainingXP {
    return 100 - currentLevelXP;
  }

  void _openPage(Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => page),
    ).then((_) => _loadProfile());
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: loading
            ? const Center(child: CircularProgressIndicator(color: purple))
            : RefreshIndicator(
                color: purple,
                backgroundColor: card,
                onRefresh: _loadProfile,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(
                    parent: BouncingScrollPhysics(),
                  ),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: width >= 900 ? 1100 : double.infinity,
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: width >= 700 ? 32 : 18,
                          vertical: 20,
                        ),
                        child: Column(
                          children: [
                            _topBar(),
                            const SizedBox(height: 20),
                            _profileHero(),
                            const SizedBox(height: 18),
                            _premiumStatusCard(context),
                            const SizedBox(height: 18),
                            _levelCard(),
                            const SizedBox(height: 18),
                            _statsSection(width),
                            const SizedBox(height: 16),
                            _readingProgressCard(),
                            const SizedBox(height: 26),
                            _menuSection(width),
                            const SizedBox(height: 30),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  Widget _premiumStatusCard(BuildContext context) {
    final yearly = premiumPlan == 'yearly';

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const PremiumPage()),
          );

          if (!mounted) return;

          await _loadProfile();
        },
        borderRadius: BorderRadius.circular(24),
        child: Ink(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isPremium
                  ? const [AppColors.primaryDark, AppColors.primary]
                  : const [AppColors.primaryDark, AppColors.primaryDark],
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: isPremium
                  ? green.withValues(alpha: 0.35)
                  : purple.withValues(alpha: 0.35),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 54,
                    height: 54,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(17),
                    ),
                    child: Icon(
                      isPremium
                          ? Icons.workspace_premium_rounded
                          : Icons.lock_open_rounded,
                      color: isPremium ? const Color(0xFFFACC15) : Colors.white,
                      size: 28,
                    ),
                  ),

                  const SizedBox(width: 15),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isPremium
                              ? t(
                                  en: 'Premium Active',
                                  it: 'Premium Attivo',
                                  ar: 'Premium نشط',
                                )
                              : t(
                                  en: 'Upgrade to Premium',
                                  it: 'Passa a Premium',
                                  ar: 'الترقية إلى Premium',
                                ),
                          textDirection: textDirection,
                          style: const TextStyle(
                            color: white,
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                          ),
                        ),

                        const SizedBox(height: 5),

                        Text(
                          isPremium
                              ? (yearly
                                    ? t(
                                        en: 'Yearly plan • All features unlocked',
                                        it: 'Piano annuale • Tutte le funzioni sbloccate',
                                        ar: 'الخطة السنوية • جميع الميزات مفعلة',
                                      )
                                    : t(
                                        en: 'Monthly plan • All features unlocked',
                                        it: 'Piano mensile • Tutte le funzioni sbloccate',
                                        ar: 'الخطة الشهرية • جميع الميزات مفعلة',
                                      ))
                              : t(
                                  en: 'Unlock all lessons, quizzes and practice',
                                  it: 'Sblocca lezioni, quiz e pratica',
                                  ar: 'افتح جميع الدروس والاختبارات والتدريب',
                                ),
                          textDirection: textDirection,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.72),
                            fontSize: 12,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              if (isPremium) ...[
                const SizedBox(height: 18),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.08),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.verified_rounded,
                        color: AppColors.success,
                        size: 19,
                      ),

                      const SizedBox(width: 9),

                      Expanded(
                        child: Text(
                          yearly
                              ? t(
                                  en: 'Yearly membership',
                                  it: 'Abbonamento annuale',
                                  ar: 'العضوية السنوية',
                                )
                              : t(
                                  en: 'Monthly membership',
                                  it: 'Abbonamento mensile',
                                  ar: 'العضوية الشهرية',
                                ),
                          textDirection: textDirection,
                          style: const TextStyle(
                            color: white,
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),

                      Text(
                        t(en: 'Active', it: 'Attivo', ar: 'نشط'),
                        style: const TextStyle(
                          color: AppColors.success,
                          fontSize: 11,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                SizedBox(
                  width: double.infinity,
                  height: 44,
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const PremiumPage()),
                      );

                      if (!mounted) return;

                      await _loadProfile();
                    },
                    icon: const Icon(Icons.settings_rounded, size: 18),
                    label: Text(
                      t(
                        en: 'Manage Premium',
                        it: 'Gestisci Premium',
                        ar: 'إدارة Premium',
                      ),
                      textDirection: textDirection,
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: white,
                      side: BorderSide(
                        color: Colors.white.withValues(alpha: 0.22),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      textStyle: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
              ] else ...[
                const SizedBox(height: 16),

                SizedBox(
                  width: double.infinity,
                  height: 44,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const PremiumPage()),
                      );

                      if (!mounted) return;

                      await _loadProfile();
                    },
                    icon: const Icon(Icons.workspace_premium_rounded, size: 19),
                    label: Text(
                      t(
                        en: 'View Premium Plans',
                        it: 'Vedi i piani Premium',
                        ar: 'عرض خطط Premium',
                      ),
                      textDirection: textDirection,
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppColors.primaryDark,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      textStyle: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _topBar() {
    return Row(
      children: [
        Expanded(
          child: Text(
            t(en: 'Profile', it: 'Profilo', ar: 'الملف الشخصي'),
            textDirection: textDirection,
            style: const TextStyle(
              color: white,
              fontSize: 28,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.7,
            ),
          ),
        ),
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: card,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: white.withValues(alpha: 0.06)),
          ),
          child: const Icon(
            Icons.person_outline_rounded,
            color: muted,
            size: 22,
          ),
        ),
      ],
    );
  }

  Widget _profileHero() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primaryDark,
            AppColors.primaryDark,
            AppColors.blue,
          ],
        ),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: white.withValues(alpha: 0.08)),
        boxShadow: [
          BoxShadow(
            color: purple.withValues(alpha: 0.14),
            blurRadius: 35,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: white.withValues(alpha: 0.10),
              border: Border.all(
                color: white.withValues(alpha: 0.25),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.18),
                  blurRadius: 20,
                ),
              ],
            ),
            child: const Icon(Icons.person_rounded, color: white, size: 52),
          ),
          const SizedBox(height: 16),
          Text(
            username,
            textDirection: textDirection,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: white,
              fontSize: 25,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'ARAB.IT • ${t(en: 'Language Learning', it: 'Apprendimento linguistico', ar: 'تعلم اللغات')}',
            textDirection: textDirection,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: white.withValues(alpha: 0.68),
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.4,
            ),
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: white.withValues(alpha: 0.09),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: white.withValues(alpha: 0.10)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.auto_awesome_rounded,
                  color: Color(0xFFFACC15),
                  size: 16,
                ),
                const SizedBox(width: 7),
                Text(
                  t(
                    en: 'Level $level Learner',
                    it: 'Studente livello $level',
                    ar: 'متعلم المستوى $level',
                  ),
                  textDirection: textDirection,
                  style: const TextStyle(
                    color: white,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _levelCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: white.withValues(alpha: 0.055)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [purple, blue]),
                  borderRadius: BorderRadius.circular(17),
                ),
                child: const Icon(
                  Icons.workspace_premium_rounded,
                  color: white,
                  size: 29,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      t(
                        en: t(
                          en: 'CURRENT LEVEL',
                          it: 'LIVELLO ATTUALE',
                          ar: 'المستوى الحالي',
                        ),
                        it: 'LIVELLO ATTUALE',
                        ar: 'المستوى الحالي',
                      ),
                      textDirection: textDirection,
                      style: const TextStyle(
                        color: muted,
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.1,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Level $level',
                      style: const TextStyle(
                        color: white,
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '$xp',
                    style: const TextStyle(
                      color: cyan,
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Text(
                    t(
                      en: t(en: 'TOTAL XP', it: 'XP TOTALI', ar: 'إجمالي XP'),
                      it: 'XP TOTALI',
                      ar: 'إجمالي XP',
                    ),
                    textDirection: textDirection,
                    style: const TextStyle(
                      color: muted,
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: levelProgress == 0 ? 0.01 : levelProgress,
              minHeight: 9,
              backgroundColor: white.withValues(alpha: 0.07),
              valueColor: const AlwaysStoppedAnimation<Color>(purple),
            ),
          ),
          const SizedBox(height: 9),
          Row(
            children: [
              Text(
                '$currentLevelXP / 100 XP',
                style: const TextStyle(
                  color: muted,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Text(
                t(
                  en: '$remainingXP XP remaining',
                  it: '$remainingXP XP rimanenti',
                  ar: 'متبقي $remainingXP XP',
                ),
                textDirection: textDirection,
                style: const TextStyle(
                  color: muted,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statsSection(double width) {
    final cards = [
      _statData(
        Icons.bolt_rounded,
        '$xp',
        t(en: 'Total XP', it: 'XP totali', ar: 'إجمالي XP'),
        cyan,
      ),
      _statData(
        Icons.menu_book_rounded,
        '$lessons',
        t(en: 'Lessons', it: 'Lezioni', ar: 'الدروس'),
        purple,
      ),
      _statData(
        Icons.local_fire_department_rounded,
        '$streak',
        t(en: 'Day Streak', it: 'Serie giornaliera', ar: 'أيام متتالية'),
        orange,
      ),
    ];

    if (width >= 850) {
      return Row(
        children: [
          for (int i = 0; i < cards.length; i++) ...[
            Expanded(child: cards[i]),
            if (i != cards.length - 1) const SizedBox(width: 12),
          ],
        ],
      );
    }

    return Row(
      children: [
        Expanded(child: cards[0]),
        const SizedBox(width: 9),
        Expanded(child: cards[1]),
        const SizedBox(width: 9),
        Expanded(child: cards[2]),
      ],
    );
  }

  Widget _statData(IconData icon, String value, String title, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 10),
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(21),
        border: Border.all(color: white.withValues(alpha: 0.055)),
      ),
      child: Column(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(
              color: white,
              fontSize: 19,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: muted,
              fontSize: 10,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _readingProgressCard() {
    final goal = readingGoal <= 0 ? 1 : readingGoal;
    final progress = (completedReadings / goal).clamp(0.0, 1.0);
    final percent = (progress * 100).round();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: white.withValues(alpha: 0.055)),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      t(
                        en: 'Reading Progress',
                        it: 'Progresso lettura',
                        ar: 'تقدم القراءة',
                      ),
                      textDirection: textDirection,
                      style: const TextStyle(
                        color: white,
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      t(
                        en: 'Keep improving your reading',
                        it: 'Continua a migliorare la lettura',
                        ar: 'استمر في تحسين القراءة',
                      ),
                      textDirection: textDirection,
                      style: const TextStyle(
                        color: muted,
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
              backgroundColor: white.withValues(alpha: 0.07),
              valueColor: const AlwaysStoppedAnimation<Color>(cyan),
            ),
          ),
          const SizedBox(height: 11),
          Row(
            children: [
              Expanded(
                child: Text(
                  '$completedReadings / $readingGoal ${t(en: 'readings completed', it: 'letture completate', ar: 'قراءات مكتملة')}',
                  textDirection: textDirection,
                  style: const TextStyle(
                    color: muted,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Text(
                t(
                  en: '$percent% complete',
                  it: '$percent% completato',
                  ar: '$percent% مكتمل',
                ),
                textDirection: textDirection,
                style: const TextStyle(
                  color: white,
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

  Widget _menuSection(double width) {
    final items = [
      _menuData(
        Icons.bar_chart_rounded,
        t(en: 'Statistics', it: 'Statistiche', ar: 'الإحصائيات'),
        t(
          en: 'View your learning progress',
          it: 'Visualizza i tuoi progressi',
          ar: 'شاهد تقدمك في التعلم',
        ),
        cyan,
        const StatisticsPage(),
      ),
      _menuData(
        Icons.emoji_events_rounded,
        t(en: 'Achievements', it: 'Obiettivi', ar: 'الإنجازات'),
        t(
          en: 'Badges, rewards and milestones',
          it: 'Badge, premi e traguardi',
          ar: 'الشارات والمكافآت والإنجازات',
        ),
        orange,
        const AchievementsPage(),
      ),
      _menuData(
        Icons.favorite_rounded,
        t(
          en: 'Favorites',
          it: 'Preferiti',
          ar: '\u{627}\u{644}\u{645}\u{641}\u{636}\u{644}\u{629}',
        ),
        t(
          en: 'Your saved words and lessons',
          it: 'Le tue parole e lezioni salvate',
          ar: 'كلماتك ودروسك المحفوظة',
        ),
        pink,
        const FavoritesPage(),
      ),
      _menuData(
        Icons.settings_rounded,
        t(en: 'Settings', it: 'Impostazioni', ar: 'الإعدادات'),
        t(
          en: 'Language, theme and preferences',
          it: 'Lingua, tema e preferenze',
          ar: 'اللغة والمظهر والتفضيلات',
        ),
        green,
        const SettingsPage(),
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: LanguageController.isArabic
              ? Alignment.centerRight
              : Alignment.centerLeft,
          child: Text(
            t(
              en: 'Account & Learning',
              it: 'Account e apprendimento',
              ar: 'الحساب والتعلم',
            ),
            textDirection: textDirection,
            style: const TextStyle(
              color: white,
              fontSize: 19,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        const SizedBox(height: 12),
        if (width >= 850)
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 3.2,
            ),
            itemBuilder: (_, index) {
              return _menuItem(items[index]);
            },
          )
        else
          Column(
            children: items
                .map(
                  (item) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _menuItem(item),
                  ),
                )
                .toList(),
          ),
      ],
    );
  }

  _MenuData _menuData(
    IconData icon,
    String title,
    String subtitle,
    Color color,
    Widget page,
  ) {
    return _MenuData(
      icon: icon,
      title: title,
      subtitle: subtitle,
      color: color,
      page: page,
    );
  }

  Widget _menuItem(_MenuData item) {
    return Material(
      color: card,
      borderRadius: BorderRadius.circular(21),
      child: InkWell(
        onTap: () => _openPage(item.page),
        borderRadius: BorderRadius.circular(21),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: item.color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(item.icon, color: item.color, size: 23),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: LanguageController.isArabic
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      textDirection: textDirection,
                      textAlign: LanguageController.isArabic
                          ? TextAlign.right
                          : TextAlign.left,
                      style: const TextStyle(
                        color: white,
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textDirection: textDirection,
                      textAlign: LanguageController.isArabic
                          ? TextAlign.right
                          : TextAlign.left,
                      style: const TextStyle(
                        color: muted,
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                LanguageController.isArabic
                    ? Icons.arrow_back_ios_rounded
                    : Icons.arrow_forward_ios_rounded,
                color: muted,
                size: 15,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MenuData {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final Widget page;

  const _MenuData({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.page,
  });
}
