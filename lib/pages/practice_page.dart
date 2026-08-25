import 'reading_page.dart';
import 'package:flutter/material.dart';
import 'package:arab_it/core/theme/app_colors.dart';

import 'quiz_page.dart';
import 'speech_training_page.dart' as speech_training;
import 'listening_page.dart';
import 'daily_challenge_page.dart';

class PracticePage extends StatelessWidget {
  const PracticePage({super.key});

  static const Color bg = Color(0xFF070A12);
  static const Color card = Color(0xFF111725);
  static const Color purple = Color(0xFF8B5CF6);
  static const Color blue = Color(0xFF3B82F6);
  static const Color cyan = AppColors.cyan;
  static const Color orange = Color(0xFFF97316);
  static const Color pink = Color(0xFFEC4899);
  static const Color white = Color(0xFFFFFFFF);
  static const Color muted = Color(0xFF94A3B8);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF090B16), Color(0xFF07121D), Color(0xFF0B0715)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 35),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _header(),
                const SizedBox(height: 25),
                _welcomeCard(),
                const SizedBox(height: 28),
                const Text(
                  'Practice Skills',
                  style: TextStyle(
                    color: white,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Choose a skill and start practicing',
                  style: TextStyle(color: muted, fontSize: 12),
                ),
                const SizedBox(height: 16),
                _skillCard(
                  context,
                  icon: Icons.record_voice_over_rounded,
                  title: 'Speaking',
                  subtitle: 'Improve your pronunciation',
                  colors: const [Color(0xFF7C2D12), Color(0xFFEA580C)],
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const speech_training.PronunciationPage(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),
                _skillCard(
                  context,
                  icon: Icons.headphones_rounded,
                  title: 'Listening',
                  subtitle: 'Train your listening skills',
                  colors: const [Color(0xFF164E63), Color(0xFF0891B2)],
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ListeningPage(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),
                _skillCard(
                  context,
                  icon: Icons.menu_book_rounded,
                  title: 'Reading',
                  subtitle: 'Read and understand more',
                  colors: const [Color(0xFF1E3A8A), Color(0xFF2563EB)],
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ReadingPage(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),
                _skillCard(
                  context,
                  icon: Icons.quiz_rounded,
                  title: 'Quiz',
                  subtitle: 'Complete a quick challenge today',
                  colors: const [Color(0xFF581C87), Color(0xFFA855F7)],
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const QuizPage()),
                    );
                  },
                ),
                const SizedBox(height: 28),
                _dailyChallenge(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _header() {
    return const Row(
      children: [
        Icon(Icons.auto_awesome_rounded, color: cyan, size: 30),
        SizedBox(width: 12),
        Text(
          'Practice',
          style: TextStyle(
            color: white,
            fontSize: 25,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }

  Widget _welcomeCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF42208A), Color(0xFF173A78), Color(0xFF07556A)],
        ),
        boxShadow: [
          BoxShadow(
            color: purple.withValues(alpha: 0.16),
            blurRadius: 30,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Ready to practice?',
            style: TextStyle(
              color: white,
              fontSize: 26,
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Complete a short practice session every day and improve your language skills.',
            style: TextStyle(
              color: Color(0xC7FFFFFF),
              fontSize: 13,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _skillCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required List<Color> colors,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: colors,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  color: white.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(17),
                ),
                child: Icon(icon, color: white, size: 27),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: white,
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: Color(0xB3FFFFFF),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                color: white,
                size: 17,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _dailyChallenge(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: white.withValues(alpha: 0.07)),
      ),
      child: Row(
        children: [
          Container(
            width: 55,
            height: 55,
            decoration: BoxDecoration(
              color: orange.withValues(alpha: 0.14),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.local_fire_department_rounded,
              color: orange,
              size: 28,
            ),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Daily Challenge',
                  style: TextStyle(
                    color: white,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Complete a quick challenge today',
                  style: TextStyle(color: muted, fontSize: 11),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const DailyChallengePage(),
                ),
              );
            },
            icon: const Icon(
              Icons.arrow_forward_rounded,
              color: white,
            ),
          ),
        ],
      ),
    );
  }

}















