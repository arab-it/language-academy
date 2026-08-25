import 'package:flutter/material.dart';
import 'package:arab_it/core/theme/app_colors.dart';

import '../database/hive_service.dart';
import '../services/language_controller.dart';
import '../pages/profile_page.dart';
import '../theme/app_colors.dart';

class AppTopBar extends StatelessWidget {
  const AppTopBar({
    super.key,
    this.showBackButton = false,
    this.onBack,
  });

  final bool showBackButton;
  final VoidCallback? onBack;

  String _languageLabel() {
    if (LanguageController.isArabic) return 'العربية';
    if (LanguageController.isItalian) return 'Italiano';
    return 'English';
  }

  String _languageFlag() {
    if (LanguageController.isArabic) return '🇸🇦';
    if (LanguageController.isItalian) return '🇮🇹';
    return '🇬🇧';
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final compact = width < 600;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.lightSurface.withValues(alpha: 0.96),
        border: const Border(
          bottom: BorderSide(
            color: AppColors.lightBorder,
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.035),
            blurRadius: 18,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: compact ? 16 : 28,
            vertical: compact ? 10 : 13,
          ),
          child: Row(
            children: [
              if (showBackButton) ...[
                _iconButton(
                  context,
                  icon: Icons.arrow_back_rounded,
                  onTap: onBack ??
                      () => Navigator.of(context).maybePop(),
                ),
                const SizedBox(width: 10),
              ],

              compact
                  ? _mobileBrand()
                  : _desktopBrand(),

              const Spacer(),

              if (!compact) ...[
                _languageButton(context),
                const SizedBox(width: 8),
                _notificationButton(context),
                const SizedBox(width: 8),
              ],

              _profileButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _desktopBrand() {
    return Row(
      children: [
        _brandMark(size: 42),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'ARAB.IT',
              style: TextStyle(
                color: AppColors.lightText,
                fontSize: 15,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.1,
              ),
            ),
            SizedBox(height: 2),
            Text(
              'Language Learning',
              style: TextStyle(
                color: AppColors.lightTextMuted,
                fontSize: 8.5,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.15,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _mobileBrand() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _brandMark(size: 38),
        const SizedBox(width: 9),
        const Text(
          'ARAB.IT',
          style: TextStyle(
            color: AppColors.lightText,
            fontSize: 15,
            fontWeight: FontWeight.w900,
            letterSpacing: 1,
          ),
        ),
      ],
    );
  }

  Widget _brandMark({required double size}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary,
            AppColors.accent,
          ],
        ),
        borderRadius: BorderRadius.circular(
          size >= 40 ? 14 : 12,
        ),
        border: Border.all(
          color: AppColors.primaryLight.withValues(alpha: 0.35),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.16),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Icon(
        Icons.auto_awesome_rounded,
        color: AppColors.white,
        size: size >= 40 ? 21 : 19,
      ),
    );
  }

  Widget _languageButton(BuildContext context) {
    return Material(
      color: AppColors.lightSurfaceSecondary,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => _showLanguagePicker(context),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 11,
            vertical: 9,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: AppColors.lightBorder,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _languageFlag(),
                style: const TextStyle(fontSize: 17),
              ),
              const SizedBox(width: 7),
              Text(
                _languageLabel(),
                style: const TextStyle(
                  color: AppColors.lightText,
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(width: 3),
              const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: AppColors.lightTextMuted,
                size: 17,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _notificationButton(BuildContext context) {
    return _iconButton(
      context,
      icon: Icons.notifications_none_rounded,
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No new notifications'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      },
    );
  }

  Widget _profileButton(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final showName = width >= 800;

    return Material(
      color: AppColors.lightSurfaceSecondary,
      borderRadius: BorderRadius.circular(15),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => const ProfilePage(),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.10),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.16),
                  ),
                ),
                child: const Icon(
                  Icons.person_rounded,
                  color: AppColors.primary,
                  size: 19,
                ),
              ),
              if (showName) ...[
                const SizedBox(width: 8),
                ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 110,
                  ),
                  child: Text(
                    HiveService.username.isEmpty
                        ? 'Learner'
                        : HiveService.username,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.lightText,
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const SizedBox(width: 3),
                const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: AppColors.lightTextMuted,
                  size: 17,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _iconButton(
    BuildContext context, {
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Material(
      color: AppColors.lightSurfaceSecondary,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: AppColors.lightBorder,
            ),
          ),
          child: const Icon(
            Icons.arrow_back_rounded,
            color: AppColors.lightTextSecondary,
            size: 21,
          ),
        ),
      ),
    );
  }

  void _showLanguagePicker(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.lightSurface,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(28),
        ),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              20,
              4,
              20,
              24,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Choose language',
                  style: TextStyle(
                    color: AppColors.lightText,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  'Select your learning interface language',
                  style: TextStyle(
                    color: AppColors.lightTextMuted,
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 18),
                _languageOption(
                  context,
                  flag: '🇬🇧',
                  title: 'English',
                  subtitle: 'English interface',
                  selected: !LanguageController.isItalian &&
                      !LanguageController.isArabic,
                ),
                _languageOption(
                  context,
                  flag: '🇮🇹',
                  title: 'Italiano',
                  subtitle: 'Interfaccia italiana',
                  selected: LanguageController.isItalian,
                ),
                _languageOption(
                  context,
                  flag: '🇸🇦',
                  title: 'العربية',
                  subtitle: 'واجهة عربية',
                  selected: LanguageController.isArabic,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _languageOption(
    BuildContext context, {
    required String flag,
    required String title,
    required String subtitle,
    required bool selected,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: selected
            ? AppColors.primary.withValues(alpha: 0.09)
            : AppColors.lightSurfaceSecondary,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(
          color: selected
              ? AppColors.primary.withValues(alpha: 0.28)
              : AppColors.lightBorder,
        ),
      ),
      child: ListTile(
        onTap: () {
          Navigator.of(context).pop();

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              behavior: SnackBarBehavior.floating,
              content: Text('$title selected'),
            ),
          );
        },
        leading: Text(
          flag,
          style: const TextStyle(fontSize: 24),
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: AppColors.lightText,
            fontSize: 13,
            fontWeight: FontWeight.w800,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(
            color: AppColors.lightTextMuted,
            fontSize: 10,
          ),
        ),
        trailing: selected
            ? const Icon(
                Icons.check_circle_rounded,
                color: AppColors.primary,
                size: 21,
              )
            : null,
      ),
    );
  }
}



