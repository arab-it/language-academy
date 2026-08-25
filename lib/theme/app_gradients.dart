import 'package:flutter/material.dart';
import 'package:arab_it/core/theme/app_colors.dart';

import 'app_colors.dart';

/// Arab.it Design System
///
/// Central source for all application gradients.
/// Keep gradient definitions here instead of inside UI screens.
class AppGradients {
  AppGradients._();

  // ============================================================
  // BRAND
  // ============================================================

  static const brand = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      AppColors.violet,
      AppColors.violetLight,
      AppColors.cyan,
    ],
  );

  static const brandSoft = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF24134F),
      Color(0xFF171B3A),
      Color(0xFF102A32),
    ],
  );

  // ============================================================
  // LANGUAGE
  // ============================================================

  static const english = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      AppColors.english,
      Color(0xFF38BDF8),
    ],
  );

  static const italian = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      AppColors.italian,
      AppColors.greenLight,
    ],
  );

  static const arabic = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      AppColors.arabic,
      AppColors.orange,
    ],
  );

  // ============================================================
  // FEATURES
  // ============================================================

  static const vocabulary = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      AppColors.violetLight,
      Color(0xFFA78BFA),
    ],
  );

  static const listening = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      AppColors.cyan,
      AppColors.cyanLight,
    ],
  );

  static const speaking = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      AppColors.greenDark,
      AppColors.greenLight,
    ],
  );

  static const reading = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      AppColors.blue,
      AppColors.blueLight,
    ],
  );

  static const practice = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      AppColors.orange,
      AppColors.orangeLight,
    ],
  );

  // ============================================================
  // AI COACH
  // ============================================================

  static const aiCoach = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      AppColors.aiCoachPrimary,
      AppColors.aiCoachSecondary,
      AppColors.aiCoachAccent,
    ],
  );

  // ============================================================
  // SPECIAL
  // ============================================================

  static const premium = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      AppColors.violet,
      AppColors.pink,
    ],
  );

  static const success = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      AppColors.greenDark,
      AppColors.green,
    ],
  );

  static const warning = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      AppColors.orangeDark,
      AppColors.orange,
    ],
  );

  static const danger = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      AppColors.redDark,
      AppColors.pink,
    ],
  );
}



