import 'package:flutter/material.dart';
import 'package:arab_it/core/theme/app_colors.dart';

import 'lessons_page.dart';
import 'dashboard_home.dart';
import 'practice_page.dart';
import 'exercises_page.dart';
import 'translate_page.dart';
import 'ai_tutor_page.dart';
import 'profile_page.dart';
import 'audit/audit_dashboard_page.dart';

import '../theme/app_colors.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  late final List<Widget> _pages;

  static const _items = [
    _NavItem(
      icon: Icons.home_outlined,
      activeIcon: Icons.home_rounded,
      label: 'Home',
    ),
    _NavItem(
      icon: Icons.menu_book_outlined,
      activeIcon: Icons.menu_book_rounded,
      label: 'Lessons',
    ),
    _NavItem(
      icon: Icons.auto_awesome_outlined,
      activeIcon: Icons.auto_awesome_rounded,
      label: 'Practice',
    ),
    _NavItem(
      icon: Icons.assignment_outlined,
      activeIcon: Icons.assignment_rounded,
      label: 'Exercises',
    ),
    _NavItem(
      icon: Icons.translate_outlined,
      activeIcon: Icons.translate_rounded,
      label: 'Translate',
    ),
    _NavItem(
      icon: Icons.smart_toy_outlined,
      activeIcon: Icons.smart_toy_rounded,
      label: 'AI Tutor',
    ),
    _NavItem(
      icon: Icons.person_outline_rounded,
      activeIcon: Icons.person_rounded,
      label: 'Profile',
    ),
    _NavItem(
      icon: Icons.analytics_outlined,
      activeIcon: Icons.analytics_rounded,
      label: 'Audit',
    ),
  ];

  @override
  void initState() {
    super.initState();

    _pages = <Widget>[
      HomePage(),
      LessonsPage(),
      PracticePage(),
      ExercisesPage(),
      TranslatePage(),
      AiTutorPage(),
      ProfilePage(),
      AuditDashboardPage(),
    ];
  }

  void _selectPage(int index) {
    if (_currentIndex == index) return;

    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    if (width >= 1100) {
      return _buildDesktop();
    }

    if (width >= 700) {
      return _buildTablet();
    }

    return _buildMobile();
  }

  // ============================================================
  // DESKTOP
  // ============================================================

  Widget _buildDesktop() {
    return Scaffold(
      body: Row(
        children: [
          _buildSidebar(compact: false),
          Expanded(
            child: _content(),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // TABLET
  // ============================================================

  Widget _buildTablet() {
    return Scaffold(
      body: Row(
        children: [
          _buildSidebar(compact: true),
          Expanded(
            child: _content(),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // MOBILE
  // ============================================================

  Widget _buildMobile() {
    return Scaffold(
      extendBody: true,
      body: _content(),
      bottomNavigationBar: _buildMobileBar(),
    );
  }

  // ============================================================
  // CONTENT
  // ============================================================

  Widget _content() {
    return IndexedStack(
      index: _currentIndex,
      children: _pages,
    );
  }

  // ============================================================
  // DESKTOP / TABLET SIDEBAR
  // ============================================================

  Widget _buildSidebar({
    required bool compact,
  }) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      width: compact ? 82 : 258,
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border(
          right: BorderSide(
            color: colors.onSurface.withValues(alpha: 0.07),
          ),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            compact ? 12 : 18,
            20,
            compact ? 12 : 18,
            18,
          ),
          child: Column(
            children: [
              _buildBrand(compact),
              SizedBox(height: compact ? 28 : 36),

              Expanded(
                child: ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  itemCount: _items.length,
                  separatorBuilder: (_, _) =>
                      const SizedBox(height: 7),
                  itemBuilder: (_, index) {
                    return _sidebarItem(
                      index: index,
                      item: _items[index],
                      compact: compact,
                    );
                  },
                ),
              ),

              _buildSidebarFooter(compact),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBrand(bool compact) {
    final colors = Theme.of(context).colorScheme;

    final logo = Container(
      width: compact ? 48 : 48,
      height: 48,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary,
            AppColors.primaryLight,
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.28),
            blurRadius: 22,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: const Icon(
        Icons.auto_awesome_rounded,
        color: Colors.white,
        size: 24,
      ),
    );

    if (compact) {
      return Center(child: logo);
    }

    return Row(
      children: [
        logo,
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'ARAB.IT',
                style: TextStyle(
                  color: colors.onSurface,
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.1,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Language Learning',
                style: TextStyle(
                  color: colors.onSurface.withValues(alpha: 0.45),
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _sidebarItem({
    required int index,
    required _NavItem item,
    required bool compact,
  }) {
    final colors = Theme.of(context).colorScheme;
    final selected = _currentIndex == index;

    return Tooltip(
      message: compact ? item.label : '',
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(17),
        child: InkWell(
          onTap: () => _selectPage(index),
          borderRadius: BorderRadius.circular(17),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOutCubic,
            height: 54,
            padding: EdgeInsets.symmetric(
              horizontal: compact ? 0 : 13,
            ),
            decoration: BoxDecoration(
              color: selected
                  ? colors.primary.withValues(alpha: 0.12)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(17),
            ),
            child: Stack(
              children: [
                Row(
                  mainAxisAlignment: compact
                      ? MainAxisAlignment.center
                      : MainAxisAlignment.start,
                  children: [
                    AnimatedScale(
                      scale: selected ? 1.06 : 1,
                      duration: const Duration(milliseconds: 180),
                      child: Icon(
                        selected ? item.activeIcon : item.icon,
                        color: selected
                            ? colors.primary
                            : colors.onSurface.withValues(alpha: 0.50),
                        size: 22,
                      ),
                    ),
                    if (!compact) ...[
                      const SizedBox(width: 13),
                      Expanded(
                        child: Text(
                          item.label,
                          style: TextStyle(
                            color: selected
                                ? colors.onSurface
                                : colors.onSurface
                                    .withValues(alpha: 0.58),
                            fontSize: 13,
                            fontWeight: selected
                                ? FontWeight.w800
                                : FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                if (selected && !compact)
                  Positioned(
                    right: 0,
                    top: 16,
                    child: Container(
                      width: 4,
                      height: 22,
                      decoration: BoxDecoration(
                        color: colors.primary,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSidebarFooter(bool compact) {
    final colors = Theme.of(context).colorScheme;

    if (compact) {
      return Icon(
        Icons.verified_rounded,
        color: colors.primary.withValues(alpha: 0.8),
        size: 19,
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colors.onSurface.withValues(alpha: 0.035),
        borderRadius: BorderRadius.circular(17),
        border: Border.all(
          color: colors.onSurface.withValues(alpha: 0.06),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.verified_rounded,
            color: colors.primary,
            size: 17,
          ),
          const SizedBox(width: 8),
          Text(
            'ARAB.IT 2026',
            style: TextStyle(
              color: colors.onSurface,
              fontSize: 10,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // MOBILE NAVIGATION
  // ============================================================

  Widget _buildMobileBar() {
    final colors = Theme.of(context).colorScheme;

    const mobileIndexes = [
      0, // Home
      1, // Lessons
      2, // Practice
      3, // Exercises
    ];

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
        child: Container(
          height: 74,
          decoration: BoxDecoration(
            color: colors.surface.withValues(alpha: 0.97),
            borderRadius: BorderRadius.circular(25),
            border: Border.all(
              color: colors.onSurface.withValues(alpha: 0.08),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.20),
                blurRadius: 30,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Row(
            children: [
              for (final index in mobileIndexes)
                Expanded(
                  child: _mobileItem(
                    index: index,
                    item: _items[index],
                  ),
                ),

              Expanded(
                child: _mobileMoreItem(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _mobileItem({
    required int index,
    required _NavItem item,
  }) {
    final colors = Theme.of(context).colorScheme;
    final selected = _currentIndex == index;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => _selectPage(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        margin: const EdgeInsets.symmetric(
          horizontal: 3,
          vertical: 7,
        ),
        decoration: BoxDecoration(
          color: selected
              ? colors.primary.withValues(alpha: 0.12)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedScale(
              scale: selected ? 1.08 : 1,
              duration: const Duration(milliseconds: 180),
              child: Icon(
                selected ? item.activeIcon : item.icon,
                color: selected
                    ? colors.primary
                    : colors.onSurface.withValues(alpha: 0.50),
                size: 21,
              ),
            ),
            const SizedBox(height: 4),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 180),
              style: TextStyle(
                color: selected
                    ? colors.onSurface
                    : colors.onSurface.withValues(alpha: 0.50),
                fontSize: 9,
                fontWeight:
                    selected ? FontWeight.w800 : FontWeight.w600,
              ),
              child: Text(
                item.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _mobileMoreItem() {
    final colors = Theme.of(context).colorScheme;

    final moreSelected =
        _currentIndex == 4 ||
        _currentIndex == 5 ||
        _currentIndex == 6 ||
        _currentIndex == 7;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _showMoreMenu,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        margin: const EdgeInsets.symmetric(
          horizontal: 3,
          vertical: 7,
        ),
        decoration: BoxDecoration(
          color: moreSelected
              ? colors.primary.withValues(alpha: 0.12)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedScale(
              scale: moreSelected ? 1.08 : 1,
              duration: const Duration(milliseconds: 180),
              child: Icon(
                Icons.more_horiz_rounded,
                color: moreSelected
                    ? colors.primary
                    : colors.onSurface.withValues(alpha: 0.50),
                size: 23,
              ),
            ),
            const SizedBox(height: 4),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 180),
              style: TextStyle(
                color: moreSelected
                    ? colors.onSurface
                    : colors.onSurface.withValues(alpha: 0.50),
                fontSize: 9,
                fontWeight:
                    moreSelected ? FontWeight.w800 : FontWeight.w600,
              ),
              child: const Text(
                'More',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showMoreMenu() {
    final colors = Theme.of(context).colorScheme;

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: colors.surface,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(28),
        ),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _moreSheetItem(
                  context: sheetContext,
                  index: 4,
                  icon: Icons.translate_rounded,
                  label: 'Translate',
                ),
                _moreSheetItem(
                  context: sheetContext,
                  index: 5,
                  icon: Icons.smart_toy_rounded,
                  label: 'AI Tutor',
                ),
                _moreSheetItem(
                  context: sheetContext,
                  index: 6,
                  icon: Icons.person_rounded,
                  label: 'Profile',
                ),
                _moreSheetItem(
                  context: sheetContext,
                  index: 7,
                  icon: Icons.analytics_rounded,
                  label: 'Audit',
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _moreSheetItem({
    required BuildContext context,
    required int index,
    required IconData icon,
    required String label,
  }) {
    final colors = Theme.of(context).colorScheme;
    final selected = _currentIndex == index;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 3,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      leading: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: selected
              ? colors.primary.withValues(alpha: 0.12)
              : colors.onSurface.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(13),
        ),
        child: Icon(
          icon,
          color: selected
              ? colors.primary
              : colors.onSurface.withValues(alpha: 0.65),
        ),
      ),
      title: Text(
        label,
        style: TextStyle(
          color: colors.onSurface,
          fontWeight: selected
              ? FontWeight.w800
              : FontWeight.w600,
        ),
      ),
      trailing: selected
          ? Icon(
              Icons.check_circle_rounded,
              color: colors.primary,
            )
          : Icon(
              Icons.chevron_right_rounded,
              color: colors.onSurface.withValues(alpha: 0.35),
            ),
      onTap: () {
        Navigator.of(context).pop();
        _selectPage(index);
      },
    );
  }
}

class _NavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;

  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
}














