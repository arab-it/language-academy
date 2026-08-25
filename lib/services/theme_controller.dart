import 'package:flutter/material.dart';

import '../database/hive_service.dart';

class ThemeController {
  static final ValueNotifier<ThemeMode> mode = ValueNotifier<ThemeMode>(
    ThemeMode.dark,
  );

  static Future<void> load() async {
    final saved = HiveService.themeMode;

    mode.value = switch (saved) {
      'light' => ThemeMode.light,
      'system' => ThemeMode.system,
      _ => ThemeMode.dark,
    };
  }

  static Future<void> setMode(ThemeMode newMode) async {
    mode.value = newMode;

    final value = switch (newMode) {
      ThemeMode.light => 'light',
      ThemeMode.system => 'system',
      ThemeMode.dark => 'dark',
    };

    await HiveService.setThemeMode(value);
  }

  static bool get isDark => mode.value == ThemeMode.dark;
}

