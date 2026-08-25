import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:arab_it/core/theme/app_colors.dart';

import 'auth_page.dart';
import 'main_navigation.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const _AuthLoadingPage();
        }

        if (snapshot.hasError) {
          return const AuthPage();
        }

        final user = snapshot.data;

        if (user != null) {
          return const MainNavigation();
        }

        return const AuthPage();
      },
    );
  }
}

class _AuthLoadingPage extends StatelessWidget {
  const _AuthLoadingPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF070A12),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 82,
              height: 82,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: const LinearGradient(
                  colors: [Color(0xFF7C3AED), AppColors.cyan],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x407C3AED),
                    blurRadius: 30,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Container(
                margin: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: const Color(0xFF090B12),
                  borderRadius: BorderRadius.circular(19),
                ),
                child: const Center(
                  child: Text(
                    'A',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Arab.it',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Preparing your learning experience...',
              style: TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
            ),
            const SizedBox(height: 24),
            const SizedBox(
              width: 26,
              height: 26,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: Color(0xFF8B5CF6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}




