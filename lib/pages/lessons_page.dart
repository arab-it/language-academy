import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';

import '../core/premium_guard.dart';
import '../data/lessons.dart';
import '../services/progress_service.dart';
import 'lesson_detail_page.dart';
import 'premium_page.dart';

class LessonsPage extends StatefulWidget {
  const LessonsPage({super.key});

  @override
  State<LessonsPage> createState() => _LessonsPageState();
}

class _LessonsPageState extends State<LessonsPage> {
  // STEP 25 â€” unified dark visual system
  static const Color background = AppColors.background;
  static const Color surface = AppColors.surface;
  static const Color surfaceAlt = AppColors.surfaceVariant;
  static const Color text = Colors.white;
  static const Color secondary = AppColors.textSecondary;
  static const Color border = AppColors.border;

  static const Color blue = AppColors.english;
  static const Color green = AppColors.primaryLight;
  static const Color red = AppColors.error;
  static const Color purple = AppColors.primary;
  static const Color orange = AppColors.streak;

  // Internal language identifiers used by lessons.dart.
  // UI labels are handled separately.
  String selectedLanguage = 'English';
  String selectedLevel = 'Beginner';

  String get displayLanguage {
    switch (selectedLanguage) {
      case 'Italian':
        return 'Italiano';
      case 'Arabic':
        return 'العربية';
      default:
        return 'English';
    }
  }

  String get displayLanguageCode {
    switch (selectedLanguage) {
      case 'Italian':
        return 'IT';
      case 'Arabic':
        return 'AR';
      default:
        return 'EN';
    }
  }

  Set<String> completedLessons = <String>{};
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    try {
      final ids = await ProgressService.getCompletedLessonIds();

      if (!mounted) return;

      setState(() {
        completedLessons = ids.toSet();
        loading = false;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        loading = false;
      });
    }
  }

  List<Lesson> get visibleLessons {
    return lessons.where((lesson) {
      return lesson.language == selectedLanguage &&
          lesson.level == selectedLevel;
    }).toList();
  }

  int get completedCount {
    return visibleLessons
        .where((lesson) => completedLessons.contains(lesson.id))
        .length;
  }

  double get progress {
    if (visibleLessons.isEmpty) return 0;
    return completedCount / visibleLessons.length;
  }

  int get totalXP {
    return visibleLessons.fold(0, (sum, lesson) => sum + lesson.xp);
  }

  String get languageName {
    switch (selectedLanguage) {
      case 'Italian':
        return 'Italiano';
      case 'Arabic':
        return 'العربية';
      default:
        return 'English';
    }
  }

  String get languageCode {
    switch (selectedLanguage) {
      case 'Italian':
        return 'IT';
      case 'Arabic':
        return 'AR';
      default:
        return 'EN';
    }
  }

  Color get languageColor {
    switch (selectedLanguage) {
      case 'Italian':
        return green;
      case 'Arabic':
        return red;
      default:
        return blue;
    }
  }

  Color get levelColor {
    switch (selectedLevel) {
      case 'Intermediate':
        return blue;
      case 'Advanced':
        return purple;
      default:
        return green;
    }
  }

  Future<void> _openLesson(Lesson lesson) async {
    if (lesson.locked) return;

    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => LessonDetailPage(
          lessonId: lesson.id,
          language: lesson.language,
          lessonTitle: lesson.title,
          xp: lesson.xp,
        ),
      ),
    );

    if (!mounted) return;

    await _loadProgress();
  }

  void _selectLanguage(String value) {
    // Keep internal values aligned with lessons.dart:
    // English / Italian / Arabic.
    final normalized = switch (value) {
      'Italiano' => 'Italian',
      'العربية' => 'Arabic',
      _ => 'English',
    };

    if (selectedLanguage == normalized) return;

    setState(() {
      selectedLanguage = normalized;
      selectedLevel = 'Beginner';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: loading
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: _loadProgress,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final desktop = constraints.maxWidth >= 950;
                    final maxWidth = desktop ? 1180.0 : 720.0;

                    return CustomScrollView(
                      physics: const AlwaysScrollableScrollPhysics(
                        parent: BouncingScrollPhysics(),
                      ),
                      slivers: [
                        SliverToBoxAdapter(
                          child: Center(
                            child: ConstrainedBox(
                              constraints: BoxConstraints(maxWidth: maxWidth),
                              child: _header(desktop),
                            ),
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: Center(
                            child: ConstrainedBox(
                              constraints: BoxConstraints(maxWidth: maxWidth),
                              child: _hero(desktop),
                            ),
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: Center(
                            child: ConstrainedBox(
                              constraints: BoxConstraints(maxWidth: maxWidth),
                              child: _languageTabs(),
                            ),
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: Center(
                            child: ConstrainedBox(
                              constraints: BoxConstraints(maxWidth: maxWidth),
                              child: _levelTabs(),
                            ),
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: Center(
                            child: ConstrainedBox(
                              constraints: BoxConstraints(maxWidth: maxWidth),
                              child: _progressSummary(),
                            ),
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: Center(
                            child: ConstrainedBox(
                              constraints: BoxConstraints(maxWidth: maxWidth),
                              child: _sectionTitle(),
                            ),
                          ),
                        ),
                        _lessonSliver(desktop, maxWidth),
                        const SliverToBoxAdapter(child: SizedBox(height: 50)),
                      ],
                    );
                  },
                ),
              ),
      ),
    );
  }

  Widget _header(bool desktop) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        desktop ? 30 : 20,
        22,
        desktop ? 30 : 20,
        14,
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: surfaceAlt,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.school_rounded,
              color: Colors.white,
              size: 23,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Lessons',
                  style: TextStyle(
                    color: text,
                    fontSize: 23,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.7,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Build your language skills',
                  style: TextStyle(
                    color: secondary,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 8),
            decoration: BoxDecoration(
              color: surface,
              borderRadius: BorderRadius.circular(13),
              border: Border.all(color: border),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.language_rounded, color: languageColor, size: 16),
                const SizedBox(width: 6),
                Text(
                  displayLanguageCode,
                  style: TextStyle(
                    color: languageColor,
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _hero(bool desktop) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: desktop ? 30 : 20, vertical: 8),
      child: Container(
        padding: EdgeInsets.all(desktop ? 30 : 23),
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
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: AppColors.glowBlue,
              blurRadius: 35,
              spreadRadius: 1,
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
                  const SizedBox(height: 24),
                  _heroProgress(),
                ],
              ),
      ),
    );
  }

  Widget _heroText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: languageColor.withValues(alpha: 0.16),
            borderRadius: BorderRadius.circular(9),
          ),
          child: Text(
            '$languageCode • $selectedLevel',
            style: TextStyle(
              color: languageColor,
              fontSize: 9,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.8,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          '$languageName learning path',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 29,
            fontWeight: FontWeight.w900,
            letterSpacing: -1,
            height: 1.05,
          ),
        ),
        const SizedBox(height: 9),
        const Text(
          'Short lessons. Real practice. Visible progress.',
          style: TextStyle(
            color: AppColors.textMuted,
            fontSize: 12,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            _heroStat(
              Icons.menu_book_rounded,
              '${visibleLessons.length}',
              'Lessons',
            ),
            const SizedBox(width: 20),
            _heroStat(Icons.bolt_rounded, '$totalXP', 'XP'),
            const SizedBox(width: 20),
            _heroStat(Icons.check_circle_rounded, '$completedCount', 'Done'),
          ],
        ),
      ],
    );
  }

  Widget _heroStat(IconData icon, String value, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: languageColor, size: 17),
        const SizedBox(width: 6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w900,
              ),
            ),
            Text(
              label,
              style: const TextStyle(color: AppColors.textMuted, fontSize: 8),
            ),
          ],
        ),
      ],
    );
  }

  Widget _heroProgress() {
    return SizedBox(
      width: 125,
      height: 125,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 116,
            height: 116,
            child: CircularProgressIndicator(
              value: progress,
              strokeWidth: 9,
              backgroundColor: Colors.white.withValues(alpha: 0.08),
              valueColor: AlwaysStoppedAnimation<Color>(languageColor),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${(progress * 100).round()}%',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const Text(
                'complete',
                style: TextStyle(color: AppColors.textMuted, fontSize: 9),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _languageTabs() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
      child: Row(
        children: [
          _languageTab('English', 'EN', blue),
          const SizedBox(width: 8),
          _languageTab('Italian', 'IT', green),
          const SizedBox(width: 8),
          _languageTab('Arabic', 'AR', red),
        ],
      ),
    );
  }

  Widget _languageTab(String language, String code, Color color) {
    final selected = selectedLanguage == language;

    return Expanded(
      child: GestureDetector(
        onTap: () => _selectLanguage(language),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: selected ? color : surfaceAlt,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: selected ? color : border),
          ),
          child: Column(
            children: [
              Text(
                code,
                style: TextStyle(
                  color: selected ? Colors.white : color,
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                language == 'Arabic'
                    ? 'العربية'
                    : language == 'Italian'
                    ? 'Italiano'
                    : 'English',
                textDirection: language == 'Arabic'
                    ? TextDirection.rtl
                    : TextDirection.ltr,
                style: TextStyle(
                  color: selected ? Colors.white : text,
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _levelTabs() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 15),
      child: Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: surfaceAlt,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: border),
        ),
        child: Row(
          children: [
            _levelTab('Beginner', green),
            _levelTab('Intermediate', blue),
            _levelTab('Advanced', purple),
          ],
        ),
      ),
    );
  }

  Widget _levelTab(String level, Color color) {
    final selected = selectedLevel == level;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedLevel = level;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(vertical: 11),
          decoration: BoxDecoration(
            color: selected ? color : Colors.transparent,
            borderRadius: BorderRadius.circular(11),
          ),
          child: Text(
            level,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: selected ? Colors.white : secondary,
              fontSize: 9,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ),
    );
  }

  Widget _progressSummary() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 22),
      child: Container(
        padding: const EdgeInsets.all(17),
        decoration: BoxDecoration(
          color: surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: border),
        ),
        child: Row(
          children: [
            Container(
              width: 43,
              height: 43,
              decoration: BoxDecoration(
                color: levelColor.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(13),
              ),
              child: Icon(
                Icons.trending_up_rounded,
                color: levelColor,
                size: 21,
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Your progress',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  SizedBox(height: 3),
                  Text(
                    'Keep going to complete this level',
                    style: TextStyle(color: secondary, fontSize: 9),
                  ),
                ],
              ),
            ),
            Text(
              '$completedCount/${visibleLessons.length}',
              style: TextStyle(
                color: levelColor,
                fontSize: 15,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
      child: Row(
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your lessons',
                  style: TextStyle(
                    color: text,
                    fontSize: 19,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.4,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  'Continue where you left off',
                  style: TextStyle(color: secondary, fontSize: 9),
                ),
              ],
            ),
          ),
          Text(
            '${visibleLessons.length} lessons',
            style: TextStyle(
              color: levelColor,
              fontSize: 9,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }

  SliverPadding _lessonSliver(bool desktop, double maxWidth) {
    if (visibleLessons.isEmpty) {
      return SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        sliver: SliverToBoxAdapter(child: _emptyState()),
      );
    }

    if (!desktop) {
      return SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        sliver: SliverList.builder(
          itemCount: visibleLessons.length,
          itemBuilder: (_, index) {
            return _lessonCard(visibleLessons[index], index);
          },
        ),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      sliver: SliverGrid(
        delegate: SliverChildBuilderDelegate((_, index) {
          return _lessonCard(visibleLessons[index], index);
        }, childCount: visibleLessons.length),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 14,
          mainAxisSpacing: 14,
          childAspectRatio: 2.65,
        ),
      ),
    );
  }

  Widget _lessonCard(Lesson lesson, int index) {
    final completed = completedLessons.contains(lesson.id);
    final premiumLocked = index >= 3 && !PremiumGuard.isPremium;
    final locked = lesson.locked || premiumLocked;

    final accent = completed
        ? green
        : locked
        ? secondary
        : languageColor;

    Future<void> handleTap() async {
      if (lesson.locked) return;

      if (premiumLocked) {
        await Navigator.of(context)
            .push(MaterialPageRoute(builder: (_) => const PremiumPage()));

        if (!mounted) return;

        setState(() {});
        return;
      }

      await _openLesson(lesson);
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: completed ? green.withValues(alpha: 0.35) : border,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: handleTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              children: [
                _lessonIcon(index, completed, locked, accent),
                const SizedBox(width: 13),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              lesson.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                          if (completed)
                            const Icon(
                              Icons.check_circle_rounded,
                              color: green,
                              size: 18,
                            ),
                          if (premiumLocked)
                            const Icon(
                              Icons.workspace_premium_rounded,
                              color: AppColors.xp,
                              size: 18,
                            ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Text(
                        lesson.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: secondary,
                          fontSize: 9,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 9),
                      Row(
                        children: [
                          _smallTag(
                            Icons.bolt_rounded,
                            '${lesson.xp} XP',
                            orange,
                          ),
                          const SizedBox(width: 6),
                          _smallTag(Icons.layers_rounded, lesson.level, accent),
                          if (premiumLocked) ...[
                            const SizedBox(width: 6),
                            _smallTag(Icons.lock_rounded, 'Premium', purple),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  premiumLocked
                      ? Icons.arrow_forward_ios_rounded
                      : lesson.locked
                      ? Icons.lock_outline_rounded
                      : completed
                      ? Icons.check_rounded
                      : Icons.arrow_forward_ios_rounded,
                  color: completed ? green : accent,
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _lessonIcon(int index, bool completed, bool locked, Color color) {
    return Container(
      width: 58,
      height: 58,
      decoration: BoxDecoration(
        color: completed ? green : color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(17),
      ),
      child: Center(
        child: locked
            ? const Icon(Icons.lock_rounded, color: secondary, size: 20)
            : completed
            ? const Icon(Icons.check_rounded, color: Colors.white, size: 26)
            : Text(
                '${index + 1}',
                style: TextStyle(
                  color: color,
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                ),
              ),
      ),
    );
  }

  Widget _smallTag(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(7),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 10),
          const SizedBox(width: 3),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 7,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }

  Widget _emptyState() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 45),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: border),
      ),
      child: Column(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: levelColor.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(22),
            ),
            child: Icon(Icons.menu_book_rounded, color: levelColor, size: 32),
          ),
          const SizedBox(height: 16),
          const Text(
            'No lessons available',
            style: TextStyle(
              color: text,
              fontSize: 17,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Try another language or difficulty level.',
            textAlign: TextAlign.center,
            style: TextStyle(color: secondary, fontSize: 10),
          ),
        ],
      ),
    );
  }
}
