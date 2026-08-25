import 'package:flutter/material.dart';
import 'package:arab_it/core/theme/app_colors.dart';

import '../services/progress_service.dart';

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({super.key});

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  static const Color bg = Color(0xFF070A12);
  static const Color card = Color(0xFF111725);
  static const Color purple = Color(0xFF8B5CF6);
  static const Color cyan = AppColors.cyan;
  static const Color green = Color(0xFF22C55E);
  static const Color orange = Color(0xFFF97316);
  static const Color white = Colors.white;
  static const Color muted = Color(0xFF94A3B8);

  int xp = 0;
  int lessons = 0;
  int streak = 0;
  bool loading = true;

  static const int totalLessons = 15;

  @override
  void initState() {
    super.initState();
    _loadStatistics();
  }

  Future<void> _loadStatistics() async {
    final results = await Future.wait([
      ProgressService.getXP(),
      ProgressService.getLessonsCompleted(),
      ProgressService.getStreak(),
    ]);

    if (!mounted) return;

    setState(() {
      xp = results[0];
      lessons = results[1];
      streak = results[2];
      loading = false;
    });
  }

  double get lessonProgress {
    if (totalLessons == 0) return 0;
    return (lessons / totalLessons).clamp(0.0, 1.0);
  }

  int get level => (xp ~/ 500) + 1;

  int get currentLevelXP => xp % 500;

  double get levelProgress => currentLevelXP / 500;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        foregroundColor: white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Statistics',
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
      ),
      body: SafeArea(
        child: loading
            ? const Center(child: CircularProgressIndicator(color: purple))
            : RefreshIndicator(
                color: purple,
                onRefresh: _loadStatistics,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(
                    parent: BouncingScrollPhysics(),
                  ),
                  padding: const EdgeInsets.fromLTRB(18, 10, 18, 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _levelCard(),

                      const SizedBox(height: 20),

                      const Text(
                        'Your Statistics',
                        style: TextStyle(
                          color: white,
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                        ),
                      ),

                      const SizedBox(height: 12),

                      _statsGrid(),

                      const SizedBox(height: 22),

                      const Text(
                        'Learning Progress',
                        style: TextStyle(
                          color: white,
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                        ),
                      ),

                      const SizedBox(height: 12),

                      _progressCard(),

                      const SizedBox(height: 22),

                      _streakCard(),

                      const SizedBox(height: 22),

                      _infoCard(),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget _levelCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF4C1D95), Color(0xFF3730A3), Color(0xFF075985)],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  color: white.withValues(alpha: 0.13),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.auto_awesome_rounded,
                  color: white,
                  size: 29,
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Current Level',
                      style: TextStyle(color: Color(0xB3FFFFFF), fontSize: 11),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'Level $level',
                      style: const TextStyle(
                        color: white,
                        fontSize: 25,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '$xp XP',
                style: const TextStyle(
                  color: white,
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: levelProgress,
              minHeight: 9,
              backgroundColor: white.withValues(alpha: 0.12),
              valueColor: const AlwaysStoppedAnimation<Color>(white),
            ),
          ),

          const SizedBox(height: 9),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$currentLevelXP / 500 XP',
                style: const TextStyle(color: Color(0xB3FFFFFF), fontSize: 10),
              ),
              Text(
                '${500 - currentLevelXP} XP to Level ${level + 1}',
                style: const TextStyle(color: Color(0xB3FFFFFF), fontSize: 10),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statsGrid() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.45,
      children: [
        _statCard(
          icon: Icons.bolt_rounded,
          title: 'Total XP',
          value: '$xp',
          color: cyan,
        ),
        _statCard(
          icon: Icons.menu_book_rounded,
          title: 'Lessons',
          value: '$lessons',
          color: purple,
        ),
        _statCard(
          icon: Icons.local_fire_department_rounded,
          title: 'Day Streak',
          value: '$streak',
          color: orange,
        ),
        _statCard(
          icon: Icons.emoji_events_rounded,
          title: 'Level',
          value: '$level',
          color: green,
        ),
      ],
    );
  }

  Widget _statCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: white.withValues(alpha: 0.06)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              color: white,
              fontSize: 21,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 2),
          Text(title, style: const TextStyle(color: muted, fontSize: 10)),
        ],
      ),
    );
  }

  Widget _progressCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: white.withValues(alpha: 0.06)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Lessons completed',
                  style: TextStyle(
                    color: white,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Text(
                '$lessons / $totalLessons',
                style: const TextStyle(
                  color: green,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: lessonProgress,
              minHeight: 10,
              backgroundColor: white.withValues(alpha: 0.07),
              valueColor: const AlwaysStoppedAnimation<Color>(green),
            ),
          ),

          const SizedBox(height: 10),

          Align(
            alignment: Alignment.centerRight,
            child: Text(
              '${(lessonProgress * 100).round()}% completed',
              style: const TextStyle(color: muted, fontSize: 10),
            ),
          ),
        ],
      ),
    );
  }

  Widget _streakCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: const LinearGradient(
          colors: [Color(0xFF431407), Color(0xFF7C2D12)],
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: white.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Text('ðŸ”¥', style: TextStyle(fontSize: 28)),
            ),
          ),

          const SizedBox(width: 15),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Learning Streak',
                  style: TextStyle(
                    color: white,
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  streak == 0
                      ? 'Start learning today!'
                      : 'You have studied for $streak consecutive days.',
                  style: const TextStyle(
                    color: Color(0xB3FFFFFF),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),

          Text(
            '$streak',
            style: const TextStyle(
              color: white,
              fontSize: 28,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Row(
        children: [
          Icon(Icons.info_outline_rounded, color: cyan, size: 22),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'Complete lessons and practice regularly to earn XP, increase your level and build your learning streak.',
              style: TextStyle(color: muted, fontSize: 11, height: 1.5),
            ),
          ),
        ],
      ),
    );
  }
}




