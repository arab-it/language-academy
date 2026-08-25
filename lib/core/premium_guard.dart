import 'package:flutter/material.dart';

import '../database/hive_service.dart';
import '../pages/premium_page.dart';

class PremiumGuard {
  const PremiumGuard._();

  /// Central Premium status.
  static bool get isPremium => HiveService.isPremium;

  /// Opens the premium page for Free users.
  /// Returns true when access is allowed.
  static bool check(BuildContext context) {
    if (HiveService.isPremium) {
      return true;
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const PremiumPage(),
      ),
    );

    return false;
  }

  /// Runs an action only for Premium users.
  /// Free users are redirected to PremiumPage.
  static void run(
    BuildContext context,
    VoidCallback action,
  ) {
    if (!check(context)) {
      return;
    }

    action();
  }
}


