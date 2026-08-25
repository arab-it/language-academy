import 'package:flutter/material.dart';

import '../../database/hive_service.dart';

class AiCoachPage extends StatefulWidget {
  const AiCoachPage({super.key});

  @override
  State<AiCoachPage> createState() => _AiCoachPageState();
}

class _AiCoachPageState extends State<AiCoachPage> {
  String get language => HiveService.selectedLanguage;
  int get xp => HiveService.xp;
  int get level => HiveService.level;
  int get streak => HiveService.streak;

  String get recommendation {
    final lessons = HiveService.completedLessons.length;
    final quizzes = HiveService.completedQuizzes;
    final readings = HiveService.completedReadings;
    final pronunciation = HiveService.pronunciationPractices;

    if (pronunciation < 3) {
      return 'Practice pronunciation today. Speaking clearly will help you build confidence.';
    }

    if (quizzes < 3) {
      return 'Complete a few exercises and quizzes to strengthen your knowledge.';
    }

    if (readings < 3) {
      return 'Read a short text today. Reading will improve your vocabulary and understanding.';
    }

    if (lessons < 3) {
      return 'Continue your lessons and build a strong daily learning habit.';
    }

    return 'Great progress! Keep your daily routine and challenge yourself with new exercises.';
  }

  String get nextActivity {
    final pronunciation = HiveService.pronunciationPractices;
    final quizzes = HiveService.completedQuizzes;
    final readings = HiveService.completedReadings;

    if (pronunciation < 3) return 'Pronunciation';
    if (quizzes < 3) return 'Exercises & Quiz';
    if (readings < 3) return 'Reading';

    return 'Advanced Practice';
  }

  double get overallProgress {
    final lessons = HiveService.completedLessons.length;
    final quizzes = HiveService.completedQuizzes;
    final readings = HiveService.completedReadings;
    final pronunciation = HiveService.pronunciationPractices;

    final total = lessons + quizzes + readings + pronunciation;

    if (total == 0) return 0.0;

    return (total / 40).clamp(0.0, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final progress = overallProgress;

    return Scaffold(
      backgroundColor: const Color(0xFF080808),
      appBar: AppBar(
        backgroundColor: const Color(0xFF080808),
        elevation: 0,
        title: const Text(
          'AI Coach',
          style: TextStyle(
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {});
        },
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
          children: [
            _heroCard(theme),
            const SizedBox(height: 18),
            _recommendationCard(),
            const SizedBox(height: 18),
            _statsCard(),
            const SizedBox(height: 18),
            _nextActivityCard(),
            const SizedBox(height: 18),
            _progressCard(progress),
          ],
        ),
      ),
    );
  }

  Widget _heroCard(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF4C1D95),
            Color(0xFF1E1B4B),
          ],
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.14),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.auto_awesome,
              color: Colors.white,
              size: 30,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Your AI Learning Coach',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Personal plan for $language',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.78),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _recommendationCard() {
    return _card(
      icon: Icons.lightbulb_rounded,
      iconColor: const Color(0xFFF59E0B),
      title: 'Today\'s Recommendation',
      child: Text(
        recommendation,
        style: const TextStyle(
          color: Color(0xFFD1D5DB),
          height: 1.5,
          fontSize: 15,
        ),
      ),
    );
  }

  Widget _statsCard() {
    return _card(
      icon: Icons.analytics_rounded,
      iconColor: const Color(0xFF22C55E),
      title: 'Your Learning',
      child: Row(
        children: [
          _stat('Level', '$level', Icons.trending_up),
          _stat('XP', '$xp', Icons.star_rounded),
          _stat('Streak', '$streak', Icons.local_fire_department),
        ],
      ),
    );
  }

  Widget _nextActivityCard() {
    return _card(
      icon: Icons.play_circle_fill_rounded,
      iconColor: const Color(0xFF38BDF8),
      title: 'Learn Next',
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF111827),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.school_rounded,
              color: Color(0xFF38BDF8),
              size: 28,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                nextActivity,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.white54,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _progressCard(double progress) {
    return _card(
      icon: Icons.insights_rounded,
      iconColor: const Color(0xFFA78BFA),
      title: 'Learning Progress',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Overall progress',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
              Text(
                '${(progress * 100).round()}%',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 10,
              backgroundColor: Colors.white10,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'The more consistently you practice, the better your recommendations become.',
            style: TextStyle(
              color: Colors.white54,
              fontSize: 13,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _card({
    required IconData icon,
    required Color iconColor,
    required String title,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF151515),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.06),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor, size: 22),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _stat(String label, String value, IconData icon) {
    return Expanded(
      child: Column(
        children: [
          Icon(
            icon,
            color: Colors.white70,
            size: 22,
          ),
          const SizedBox(height: 7),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white54,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

