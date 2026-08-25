import 'package:flutter/material.dart';
import 'package:arab_it/core/theme/app_colors.dart';

import 'main_navigation.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  int selectedLanguage = 0;

  final List<Map<String, String>> languages = [
    {'code': 'EN', 'name': 'English', 'native': 'English'},
    {'code': 'IT', 'name': 'Italian', 'native': 'Italiano'},
    {'code': 'AR', 'name': 'Arabic', 'native': 'Ø§Ù„Ø¹Ø±Ø¨ÙŠØ©'},
  ];

  void _continue() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const MainNavigation()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF05070B),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      gradient: const LinearGradient(
                        colors: [Color(0xFF8B5CF6), AppColors.cyan],
                      ),
                    ),
                    child: const Center(
                      child: Text(
                        'A',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Arab.it',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 21,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),

              const Spacer(),

              Center(
                child: Container(
                  width: 170,
                  height: 170,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [Color(0xFF8B5CF6), AppColors.cyan],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF8B5CF6).withValues(alpha: 0.25),
                        blurRadius: 60,
                        spreadRadius: 8,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Container(
                      width: 156,
                      height: 156,
                      decoration: const BoxDecoration(
                        color: Color(0xFF080A12),
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.translate_rounded,
                          color: Colors.white,
                          size: 68,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 42),

              const Text(
                'Learn a language.\nOpen a new world.',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 34,
                  height: 1.12,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -1.2,
                ),
              ),

              const SizedBox(height: 14),

              const Text(
                'Build vocabulary, practice pronunciation,\nand improve every day with Arab.it.',
                style: TextStyle(
                  color: Color(0xFF94A3B8),
                  fontSize: 14,
                  height: 1.5,
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(height: 32),

              const Text(
                'Choose your learning language',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                ),
              ),

              const SizedBox(height: 13),

              Row(
                children: List.generate(languages.length, (index) {
                  final language = languages[index];
                  final selected = selectedLanguage == index;

                  return Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                        right: index == languages.length - 1 ? 0 : 9,
                      ),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedLanguage = index;
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 220),
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          decoration: BoxDecoration(
                            color: selected
                                ? const Color(0xFF8B5CF6)
                                : const Color(0xFF111725),
                            borderRadius: BorderRadius.circular(17),
                            border: Border.all(
                              color: selected
                                  ? const Color(0xFF8B5CF6)
                                  : Colors.white.withValues(alpha: 0.07),
                            ),
                          ),
                          child: Column(
                            children: [
                              Text(
                                language['code']!,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                language['native']!,
                                style: TextStyle(
                                  color: selected
                                      ? Colors.white70
                                      : const Color(0xFF64748B),
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),

              const SizedBox(height: 22),

              SizedBox(
                width: double.infinity,
                height: 57,
                child: ElevatedButton(
                  onPressed: _continue,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF080A12),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Get Started',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      SizedBox(width: 9),
                      Icon(Icons.arrow_forward_rounded, size: 20),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 12),

              const Center(
                child: Text(
                  'English  â€¢  Italiano  â€¢  Ø§Ù„Ø¹Ø±Ø¨ÙŠØ©',
                  style: TextStyle(
                    color: Color(0xFF475569),
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}




