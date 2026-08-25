import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';
import 'database/hive_service.dart';
import 'services/theme_controller.dart';
import 'services/smart_review_service.dart';
import 'pages/auth_gate.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await HiveService.init();
  await SmartReviewService.init();
  await ThemeController.load();

  runApp(const ArabItApp());
}

class ArabItApp extends StatelessWidget {
  const ArabItApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeController.mode,
      builder: (context, themeMode, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Arab.it',
          themeMode: themeMode,

          theme: AppTheme.light,
          darkTheme: AppTheme.dark,

          home: const AuthGate(),
        );
      },
    );
  }
}

