import 'package:flutter/material.dart';
import 'package:arab_it/core/theme/app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  static const display = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 32,
    fontWeight: FontWeight.w800,
    height: 1.15,
  );

  static const headline = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 26,
    fontWeight: FontWeight.w800,
    height: 1.2,
  );

  static const title = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 21,
    fontWeight: FontWeight.w700,
  );

  static const subtitle = TextStyle(
    color: AppColors.textSecondary,
    fontSize: 15,
    fontWeight: FontWeight.w500,
  );

  static const body = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 16,
    fontWeight: FontWeight.w500,
    height: 1.45,
  );

  static const bodySecondary = TextStyle(
    color: AppColors.textSecondary,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.4,
  );

  static const button = TextStyle(
    color: AppColors.white,
    fontSize: 15,
    fontWeight: FontWeight.w700,
  );

  static const caption = TextStyle(
    color: AppColors.textMuted,
    fontSize: 12,
    fontWeight: FontWeight.w600,
  );
}




