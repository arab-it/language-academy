import 'dart:async';

import 'package:flutter/material.dart';

import '../main_navigation.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with TickerProviderStateMixin {
  static const Color bg = Color(0xFF06080D);
  static const Color purple = Color(0xFF8B5CF6);
  static const Color cyan = Color(0xFF22D3EE);
  static const Color white = Colors.white;
  static const Color muted = Color(0xFF94A3B8);

  late final AnimationController _logoController;
  late final AnimationController _contentController;
  late final Animation<double> _logoScale;
  late final Animation<double> _logoOpacity;
  late final Animation<Offset> _contentSlide;
  late final Animation<double> _contentOpacity;

  Timer? _timer;

  @override
  void initState() {
    super.initState();

    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    );

    _contentController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _logoScale = CurvedAnimation(
      parent: _logoController,
      curve: Curves.easeOutBack,
    );

    _logoOpacity = CurvedAnimation(
      parent: _logoController,
      curve: Curves.easeOut,
    );

    _contentSlide = Tween<Offset>(
      begin: const Offset(0, 0.18),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _contentController,
        curve: Curves.easeOutCubic,
      ),
    );

    _contentOpacity = CurvedAnimation(
      parent: _contentController,
      curve: Curves.easeOut,
    );

    _start();
  }

  Future<void> _start() async {
    await _logoController.forward();

    if (!mounted) return;

    await _contentController.forward();

    _timer = Timer(
      const Duration(milliseconds: 1500),
      _goNext,
    );
  }

  void _goNext() {
    if (!mounted) return;

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 650),
        pageBuilder: (_, animation, _) => const MainNavigation(),
        transitionsBuilder: (_, animation, _, child) {
          return FadeTransition(
            opacity: CurvedAnimation(
              parent: animation,
              curve: Curves.easeOut,
            ),
            child: child,
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _logoController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      body: Stack(
        children: [
          Positioned(
            top: -180,
            left: -140,
            child: _glow(
              360,
              purple.withValues(alpha: 0.14),
            ),
          ),
          Positioned(
            right: -160,
            bottom: -170,
            child: _glow(
              390,
              cyan.withValues(alpha: 0.10),
            ),
          ),
          SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 520,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 28,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FadeTransition(
                        opacity: _logoOpacity,
                        child: ScaleTransition(
                          scale: _logoScale,
                          child: _logo(),
                        ),
                      ),
                      const SizedBox(height: 34),
                      FadeTransition(
                        opacity: _contentOpacity,
                        child: SlideTransition(
                          position: _contentSlide,
                          child: Column(
                            children: [
                              const Text(
                                'Arab.it',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: white,
                                  fontSize: 42,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: -1.8,
                                ),
                              ),
                              const SizedBox(height: 9),
                              const Text(
                                'Learn languages. Speak with confidence.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: muted,
                                  fontSize: 14,
                                  height: 1.5,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 32),
                              SizedBox(
                                width: 130,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: const LinearProgressIndicator(
                                    minHeight: 4,
                                    backgroundColor: Color(0xFF171C26),
                                    valueColor:
                                        AlwaysStoppedAnimation<Color>(
                                      purple,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 24,
            child: FadeTransition(
              opacity: _contentOpacity,
              child: const Text(
                'ARAB.IT • 2026',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF475569),
                  fontSize: 9,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _logo() {
    return Container(
      width: 112,
      height: 112,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(34),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            purple,
            Color(0xFF6366F1),
            cyan,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: purple.withValues(alpha: 0.28),
            blurRadius: 45,
            spreadRadius: 2,
          ),
        ],
      ),
      child: const Icon(
        Icons.language_rounded,
        color: white,
        size: 58,
      ),
    );
  }

  Widget _glow(double size, Color color) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
        ),
      ),
    );
  }
}


