import 'package:flutter/material.dart';
import 'package:arab_it/core/theme/app_colors.dart';

import 'app_colors.dart';

/// Arab.it Design System
///
/// Shared visual constants for cards, borders, glass effects and shadows.
/// Keep reusable decoration logic here instead of inside UI screens.
class AppDecorations {
  AppDecorations._();

  // ============================================================
  // RADIUS
  // ============================================================

  static const double radiusSmall = 12;
  static const double radiusMedium = 18;
  static const double radiusLarge = 24;
  static const double radiusXLarge = 30;

  // ============================================================
  // BORDERS
  // ============================================================

  static Border darkBorder({
    double opacity = 0.08,
  }) {
    return Border.all(
      color: AppColors.white.withValues(alpha: opacity),
      width: 1,
    );
  }

  static Border brandBorder({
    double opacity = 0.25,
  }) {
    return Border.all(
      color: AppColors.violetLight.withValues(alpha: opacity),
      width: 1,
    );
  }

  static Border glassBorder({
    double opacity = 0.10,
  }) {
    return Border.all(
      color: AppColors.white.withValues(alpha: opacity),
      width: 1,
    );
  }

  // ============================================================
  // DARK CARDS
  // ============================================================

  static BoxDecoration darkCard({
    double radius = radiusLarge,
  }) {
    return BoxDecoration(
      color: AppColors.darkSurfaceSecondary,
      borderRadius: BorderRadius.circular(radius),
      border: darkBorder(),
    );
  }

  static BoxDecoration darkCardElevated({
    double radius = radiusLarge,
  }) {
    return BoxDecoration(
      color: AppColors.darkSurfaceSecondary,
      borderRadius: BorderRadius.circular(radius),
      border: darkBorder(),
      boxShadow: [
        BoxShadow(
          color: AppColors.black.withValues(alpha: 0.20),
          blurRadius: 30,
          offset: const Offset(0, 12),
        ),
      ],
    );
  }

  // ============================================================
  // BRAND CARD
  // ============================================================

  static BoxDecoration brandCard({
    double radius = radiusXLarge,
  }) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(radius),
      gradient: const LinearGradient(begin: Alignment.topLeft,end: Alignment.bottomRight,colors: [AppColors.violetDark, AppColors.primary, AppColors.cyan]),
      border: brandBorder(),
      boxShadow: [
        BoxShadow(
          color: AppColors.violetLight.withValues(alpha: 0.10),
          blurRadius: 30,
          offset: const Offset(0, 12),
        ),
      ],
    );
  }

  // ============================================================
  // SOFT CARD
  // ============================================================

  static BoxDecoration softCard({
    double radius = radiusMedium,
  }) {
    return BoxDecoration(
      color: AppColors.darkSurfaceSecondary,
      borderRadius: BorderRadius.circular(radius),
      border: darkBorder(opacity: 0.06),
    );
  }

  // ============================================================
  // GLASS
  // ============================================================

  static BoxDecoration glass({
    double radius = radiusMedium,
  }) {
    return BoxDecoration(
      color: AppColors.white.withValues(alpha: 0.055),
      borderRadius: BorderRadius.circular(radius),
      border: glassBorder(),
    );
  }

  // ============================================================
  // INPUT
  // ============================================================

  static BoxDecoration input({
    double radius = radiusMedium,
  }) {
    return BoxDecoration(
      color: AppColors.darkSurfaceSecondary,
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(
        color: AppColors.darkBorder,
      ),
    );
  }

  // ============================================================
  // ICON CONTAINER
  // ============================================================

  static BoxDecoration iconContainer({
    required Color color,
    double radius = 17,
    double opacity = 0.12,
  }) {
    return BoxDecoration(
      color: color.withValues(alpha: opacity),
      borderRadius: BorderRadius.circular(radius),
    );
  }

  // ============================================================
  // BUTTON
  // ============================================================

  static BoxDecoration button({
    double radius = radiusMedium,
  }) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(radius),
      boxShadow: [
        BoxShadow(
          color: AppColors.violetLight.withValues(alpha: 0.18),
          blurRadius: 18,
          offset: const Offset(0, 8),
        ),
      ],
    );
  }
}







