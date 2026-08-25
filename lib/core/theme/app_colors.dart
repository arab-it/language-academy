import 'package:flutter/material.dart';

/// ARAB.IT — Design System V4
///
/// Unified premium visual language for the entire application.
/// Dark-first, modern, professional and consistent.
///
/// Brand direction:
/// Violet → Indigo → Cyan
///
/// Language identity:
/// English → Blue
/// Italiano → Green
/// العربية → Emerald / Teal
class AppColors {
  AppColors._();

  // ============================================================
  // BRAND
  // ============================================================

  static const Color primary = Color(0xFF7C3AED);
  static const Color primaryLight = Color(0xFF8B5CF6);
  static const Color primaryDark = Color(0xFF5B21B6);

  static const Color secondary = Color(0xFF6366F1);
  static const Color secondaryLight = Color(0xFF818CF8);

  static const Color accent = primary;
  static const Color accentLight = primaryLight;

  // ============================================================
  // BACKGROUNDS
  // ============================================================

  static const Color background = Color(0xFF080B16);
  static const Color backgroundSecondary = Color(0xFF0B1120);
  static const Color backgroundTertiary = Color(0xFF111827);

  // ============================================================
  // SURFACES
  // ============================================================

  static const Color surface = Color(0xFF0F172A);
  static const Color surfaceVariant = Color(0xFF111827);
  static const Color surfaceElevated = Color(0xFF1E293B);

  static const Color card = Color(0xFF111827);
  static const Color cardLight = Color(0xFF172033);

  // ============================================================
  // TEXT
  // ============================================================

  static const Color textPrimary = Color(0xFFF8FAFC);

  // Compatibility token used by ExercisesPage.
  static const Color textPrimary24 = textPrimary;

  static const Color textSecondary = Color(0xFFCBD5E1);
  static const Color textMuted = Color(0xFF94A3B8);
  static const Color textDisabled = Color(0xFF64748B);

  static const Color white = textPrimary;
  static const Color black = Color(0xFF000000);

  // ============================================================
  // BORDERS
  // ============================================================

  static const Color border = Color(0xFF1E293B);
  static const Color borderLight = Color(0xFF334155);

  // ============================================================
  // SEMANTIC
  // ============================================================

  static const Color success = Color(0xFF22C55E);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF38BDF8);

  // ============================================================
  // GAMIFICATION
  // ============================================================

  static const Color xp = Color(0xFFFBBF24);
  static const Color streak = Color(0xFFF97316);
  static const Color progress = primary;

  // ============================================================
  // PREMIUM
  // ============================================================

  static const Color premium = Color(0xFFF5C451);
  static const Color premiumDark = Color(0xFFD49A18);

  // ============================================================
  // LANGUAGE COLORS
  // ============================================================

  /// English — blue
  static const Color english = Color(0xFF3B82F6);

  /// Italiano — Italian green
  static const Color italian = Color(0xFF16A34A);

  /// Arabic — emerald / teal
  static const Color arabic = Color(0xFF10B981);

  // ============================================================
  // GLASS / EFFECTS
  // ============================================================

  static const Color lightGlass = Color(0xCCFFFFFF);

  static const Color glowPurple = Color(0x337C3AED);
  static const Color glowBlue = Color(0x336366F1);

  // ============================================================
  // DARK THEME API
  // ============================================================

  static const Color darkBackground = background;
  static const Color darkSurface = surface;
  static const Color darkSurfaceSecondary = backgroundSecondary;

  static const Color darkBorder = border;

  static const Color darkText = textPrimary;
  static const Color darkTextSecondary = textSecondary;
  static const Color darkTextMuted = textMuted;

  // ============================================================
  // LIGHT THEME
  // ============================================================

  static const Color lightBackground = Color(0xFFF8FAFC);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceSecondary = Color(0xFFF1F5F9);
  static const Color lightBorder = Color(0xFFE2E8F0);

  static const Color lightText = Color(0xFF0F172A);
  static const Color lightTextSecondary = Color(0xFF334155);
  static const Color lightTextMuted = Color(0xFF64748B);

  // ============================================================
  // COMPATIBILITY ALIASES
  // ============================================================

  static const Color blue = english;
  static const Color blueLight = Color(0xFF60A5FA);

  static const Color cyan = Color(0xFF06B6D4);
  static const Color cyanLight = Color(0xFF22D3EE);

  static const Color violet = primary;
  static const Color violetLight = primaryLight;
  static const Color violetDark = primaryDark;

  static const Color gradientPurple = primaryDark;
  static const Color gradientBlue = secondary;

  static const Color gradientPurpleBright = primary;
  static const Color gradientBlueBright = secondaryLight;

  static const Color sage = Color(0xFF6FAF8F);
  static const Color sageLight = Color(0xFFA7D8BE);
  static const Color sageDark = Color(0xFF3F765D);

  static const Color green = Color(0xFF22C55E);
  static const Color greenLight = Color(0xFF4ADE80);
  static const Color greenDark = Color(0xFF15803D);

  static const Color orange = Color(0xFFF97316);
  static const Color orangeLight = Color(0xFFFDBA74);
  static const Color orangeDark = Color(0xFFC2410C);

  static const Color redDark = Color(0xFFB91C1C);
  static const Color pink = Color(0xFFEC4899);

  static const Color speaking = Color(0xFF06B6D4);

  static const Color aiCoachPrimary = primary;
  static const Color aiCoachSecondary = secondary;
  static const Color aiCoachAccent = cyan;

  // ============================================================
  // TRANSPARENT
  // ============================================================

  static const Color transparent = Colors.transparent;
  // Home Page semantic gradient tokens
  static const Color homeHeroPurple = Color(0xFF17113B);
  static const Color homeHeroBlue = Color(0xFF31206B);
  static const Color homeHeroCyan = Color(0xFF075B68);

  static const Color homeDarkPurple = Color(0xFF26104F);
  static const Color homeDarkBlue = Color(0xFF172554);
  static const Color homeDarkCyan = Color(0xFF07556A);

  static const Color homeSuccessDark = Color(0xFF064E3B);
  static const Color homeSuccess = Color(0xFF059669);

  static const Color homeErrorDark = Color(0xFF7F1D1D);
  static const Color homeError = Color(0xFFDC2626);

  static const Color homeBlueDark = Color(0xFF1E3A8A);
  static const Color homeBlue = Color(0xFF2563EB);

  static const Color homePremiumPurple = Color(0xFF4C1D95);
  static const Color homePremiumPink = Color(0xFFDB2777);
  static const Color homePremiumGreen = Color(0xFF10B981);
  static const Color homePremiumYellow = Color(0xFFFFD166);
  static const Color homePremiumGreenLight = Color(0xFF86EFAC);

  static const Color homeWarmOrange = Color(0xFF7C2D12);
  static const Color homeDeepCyan = Color(0xFF164E63);

  static const Color homeDeepPurple = Color(0xFF171B3A);
  static const Color homeDeepBlue = Color(0xFF202A55);
  static const Color homeDeepCyanBlue = Color(0xFF102E3D);

  static const Color homeDeepPurpleBlue = Color(0xFF31206B);
  static const Color homeDeepBlueCyan = Color(0xFF123B61);

  static const Color homeAchievementGreenDark = Color(0xFF14532D);
  static const Color homeAchievementGreen = Color(0xFF166534);
  static const Color homeAchievementBlue = Color(0xFF172554);
  static const Color homeAchievementIndigo = Color(0xFF312E81);

  // ===== DASHBOARD HOME COLORS =====

  static const Color dashboardHeroPurple = Color(0xFF211447);
  static const Color dashboardHeroDark = Color(0xFF17152F);
  static const Color dashboardHeroBlue = Color(0xFF0F172A);

  static const Color dashboardGlowPurple = Color(0x408B5CF6);
  static const Color dashboardGlowOrange = Color(0x40FF6B35);

  static const Color dashboardGold = Color(0xFFFFC857);
  static const Color dashboardOrange = Color(0xFFFF6B35);
  static const Color dashboardGoldLight = Color(0xFFFFB347);

  static const Color dashboardTextSoft = Color(0xFFB8B2CC);
  static const Color dashboardTextMuted = Color(0xFFB8C3D8);
  static const Color dashboardTextFaint = Color(0xFFD6D1E5);

  static const Color dashboardStreakOrange = Color(0xFFFB923C);

  static const Color dashboardCardPurple = Color(0xFF2B145C);
  static const Color dashboardCardBlue = Color(0xFF182F68);
  static const Color dashboardCardBackground = Color(0xFF0A1224);

  static const Color dashboardGreenDark = Color(0xFF123D32);
  static const Color dashboardCyanDark = Color(0xFF102A2A);

  static const Color dashboardGreen = Color(0xFF22C55E);
  static const Color dashboardCyan = Color(0xFF06B6D4);

  static const Color dashboardGreenAlt = Color(0xFF10B981);
  static const Color dashboardCyanAlt = Color(0xFF06B6D4);

  static const Color dashboardDeepGreen = Color(0xFF102B2A);
  static const Color dashboardDeepTeal = Color(0xFF112D3D);

  static const Color dashboardDeepCyan = Color(0xFF21164A);
  static const Color dashboardDeepBlue = Color(0xFF172554);
  static const Color dashboardDeepIndigo = Color(0xFF111827);

  static const Color dashboardProgressGreen = Color(0xFF22C55E);
  static const Color dashboardProgressCyan = Color(0xFF06B6D4);
static const Color dashboardGlowPurpleSoft = Color(0x268B5CF6);
static const Color dashboardGlowOrangeSoft = Color(0x26FF6B35);
static const Color dashboardPurpleLight = Color(0xFFC4B5FD);
static const Color dashboardPurpleAccent = Color(0xFF40358F);
static const Color dashboardPurpleSoft = Color(0xFFA78BFA);
static const Color dashboardOrangeStrong = Color(0xFFF97316);
static const Color dashboardTextDim = Color(0xFF9690AA);

  // ===== END DASHBOARD HOME COLORS =====
}



