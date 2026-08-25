import 'package:flutter/material.dart';
import 'package:arab_it/core/theme/app_colors.dart';
import '../theme/app_colors.dart';
import '../core/theme/app_radius.dart';


class LanguageFlag extends StatelessWidget {
  final String language;
  final bool showName;
  final bool compact;
  final double size;

  const LanguageFlag({
    super.key,
    required this.language,
    this.showName = true,
    this.compact = false,
    this.size = 28,
  });

  String get code {
    switch (language.toLowerCase()) {
      case 'english':
      case 'en':
        return '🇬🇧';

      case 'italiano':
      case 'italian':
      case 'it':
        return '🇮🇹';

      case 'العربية':
      case 'arabic':
      case 'ar':
        return '🇸🇦';

      default:
        return '🌐';
    }
  }

  String get displayName {
    switch (language.toLowerCase()) {
      case 'english':
      case 'en':
        return 'English';

      case 'italiano':
      case 'italian':
      case 'it':
        return 'Italiano';

      case 'العربية':
      case 'arabic':
      case 'ar':
        return 'العربية';

      default:
        return language;
    }
  }

  bool get isArabic {
    final value = language.toLowerCase();

    return value == 'arabic' ||
        value == 'ar' ||
        value == 'العربية';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 8 : 10,
        vertical: compact ? 6 : 8,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(
          compact ? AppRadius.small : AppRadius.medium,
        ),
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            code,
            style: TextStyle(
              fontSize: size,
            ),
          ),

          if (showName) ...[
            SizedBox(width: compact ? 6 : 8),

            Text(
              displayName,
              textDirection:
                  isArabic ? TextDirection.rtl : TextDirection.ltr,
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: compact ? 11 : 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ],
      ),
    );
  }
}







