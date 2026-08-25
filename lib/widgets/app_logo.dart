import 'package:flutter/material.dart';
import 'package:arab_it/core/theme/app_colors.dart';
import '../theme/app_colors.dart';


class AppLogo extends StatelessWidget {
  final double iconSize;
  final double textSize;
  final bool showText;
  final bool compact;

  const AppLogo({
    super.key,
    this.iconSize = 42,
    this.textSize = 22,
    this.showText = true,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: iconSize,
          height: iconSize,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              iconSize * 0.28,
            ),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.primary,
                AppColors.cyan,
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.25),
                blurRadius: 18,
                offset: const Offset(0, 7),
              ),
            ],
          ),
          child: Icon(
            Icons.translate_rounded,
            color: Colors.white,
            size: iconSize * 0.52,
          ),
        ),

        if (showText) ...[
          SizedBox(width: compact ? 9 : 12),
          Text(
            'ARAB.IT',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: textSize,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.6,
            ),
          ),
        ],
      ],
    );
  }
}






