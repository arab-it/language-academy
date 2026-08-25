import 'package:flutter/material.dart';
import 'package:arab_it/core/theme/app_colors.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_decorations.dart';

/// Arab.it reusable card component.
///
/// Keeps the existing API while using the centralized design system.
class UiCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;

  const UiCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(18),
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final decoration = BoxDecoration(
      color: theme.colorScheme.surface,
      borderRadius: BorderRadius.circular(
        AppDecorations.radiusLarge,
      ),
      border: Border.all(
        color: isDark
            ? AppColors.darkBorder
            : AppColors.lightBorder,
        width: 1,
      ),
      boxShadow: isDark
          ? [
              BoxShadow(
                color: AppColors.black.withValues(alpha: 0.14),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ]
          : [
              BoxShadow(
                color: AppColors.violet.withValues(alpha: 0.05),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
    );

    final card = Container(
      padding: padding,
      decoration: decoration,
      child: child,
    );

    if (onTap == null) {
      return card;
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(
          AppDecorations.radiusLarge,
        ),
        child: card,
      ),
    );
  }
}



