import 'package:flutter/material.dart';
import 'package:arab_it/core/theme/app_colors.dart';

import '../services/progress_service.dart';

class AchievementsPage extends StatefulWidget {
  const AchievementsPage({super.key});

  @override
  State<AchievementsPage> createState() => _AchievementsPageState();
}

class _AchievementsPageState extends State<AchievementsPage> {
  static const Color bg = Color(0xFF070A12);
  static const Color card = Color(0xFF111725);
  static const Color purple = Color(0xFF8B5CF6);
  static const Color cyan = AppColors.cyan;
  static const Color green = Color(0xFF22C55E);
  static const Color orange = Color(0xFFF97316);
  static const Color gold = Color(0xFFFFC107);
  static const Color white = Colors.white;
  static const Color muted = Color(0xFF94A3B8);

  int xp = 0;
  int lessons = 0;
  int streak = 0;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
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
          'Achievements',
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator(color: purple))
          : RefreshIndicator(
              color: purple,
              onRefresh: _loadData,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                padding: const EdgeInsets.fromLTRB(18, 10, 18, 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _header(),
                    const SizedBox(height: 24),
                    _summary(),
                    const SizedBox(height: 24),
                    const Text(
                      'Your Achievements',
                      style: TextStyle(
                        color: white,
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _achievement(
                      icon: Icons.flag_rounded,
                      title: 'First Step',
                      description: 'Complete your first lesson.',
                      current: lessons,
                      target: 1,
                      color: green,
                    ),
                    _achievement(
                      icon: Icons.menu_book_rounded,
                      title: 'Getting Started',
                      description: 'Complete 5 lessons.',
                      current: lessons,
                      target: 5,
                      color: cyan,
                    ),
                    _achievement(
                      icon: Icons.school_rounded,
                      title: 'Dedicated Learner',
                      description: 'Complete 10 lessons.',
                      current: lessons,
                      target: 10,
                      color: purple,
                    ),
                    _achievement(
                      icon: Icons.auto_stories_rounded,
                      title: 'Language Master',
                      description: 'Complete 15 lessons.',
                      current: lessons,
                      target: 15,
                      color: gold,
                    ),
                    _achievement(
                      icon: Icons.bolt_rounded,
                      title: 'XP Hunter',
                      description: 'Earn 100 XP.',
                      current: xp,
                      target: 100,
                      color: orange,
                    ),
                    _achievement(
                      icon: Icons.diamond_rounded,
                      title: 'XP Champion',
                      description: 'Earn 500 XP.',
                      current: xp,
                      target: 500,
                      color: cyan,
                    ),
                    _achievement(
                      icon: Icons.local_fire_department_rounded,
                      title: '3 Day Streak',
                      description: 'Study for 3 consecutive days.',
                      current: streak,
                      target: 3,
                      color: orange,
                    ),
                    _achievement(
                      icon: Icons.whatshot_rounded,
                      title: '7 Day Streak',
                      description: 'Study for 7 consecutive days.',
                      current: streak,
                      target: 7,
                      color: gold,
                    ),
                    _achievement(
                      icon: Icons.workspace_premium_rounded,
                      title: '30 Day Streak',
                      description: 'Study for 30 consecutive days.',
                      current: streak,
                      target: 30,
                      color: purple,
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _header() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF312E81), Color(0xFF6D28D9), Color(0xFF9D174D)],
        ),
      ),
      child: const Row(
        children: [
          Text('ðŸ†', style: TextStyle(fontSize: 48)),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Keep going!',
                  style: TextStyle(
                    color: white,
                    fontSize: 23,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Unlock achievements as you learn and practice.',
                  style: TextStyle(
                    color: Color(0xCCFFFFFF),
                    fontSize: 11,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _summary() {
    final total = 9;

    int unlocked = 0;

    final values = [
      lessons >= 1,
      lessons >= 5,
      lessons >= 10,
      lessons >= 15,
      xp >= 100,
      xp >= 500,
      streak >= 3,
      streak >= 7,
      streak >= 30,
    ];

    for (final value in values) {
      if (value) unlocked++;
    }

    final progress = unlocked / total;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
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
                  'Achievement Progress',
                  style: TextStyle(
                    color: white,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Text(
                '$unlocked / $total',
                style: const TextStyle(
                  color: gold,
                  fontSize: 15,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 9,
              backgroundColor: white.withValues(alpha: 0.07),
              valueColor: const AlwaysStoppedAnimation<Color>(gold),
            ),
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              '${(progress * 100).round()}% unlocked',
              style: const TextStyle(color: muted, fontSize: 10),
            ),
          ),
        ],
      ),
    );
  }

  Widget _achievement({
    required IconData icon,
    required String title,
    required String description,
    required int current,
    required int target,
    required Color color,
  }) {
    final unlocked = current >= target;
    final progress = (current / target).clamp(0.0, 1.0);

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: unlocked ? color.withValues(alpha: 0.10) : card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: unlocked
              ? color.withValues(alpha: 0.35)
              : white.withValues(alpha: 0.06),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: unlocked
                  ? color.withValues(alpha: 0.18)
                  : white.withValues(alpha: 0.05),
              shape: BoxShape.circle,
            ),
            child: Icon(
              unlocked ? icon : Icons.lock_outline_rounded,
              color: unlocked ? color : muted,
              size: 27,
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                          color: unlocked ? white : muted,
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    if (unlocked)
                      Icon(Icons.check_circle_rounded, color: color, size: 19),
                  ],
                ),

                const SizedBox(height: 4),

                Text(
                  description,
                  style: const TextStyle(color: muted, fontSize: 10),
                ),

                const SizedBox(height: 9),

                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 5,
                    backgroundColor: white.withValues(alpha: 0.06),
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  '$current / $target',
                  style: TextStyle(
                    color: unlocked ? color : muted,
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}




