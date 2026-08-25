import 'package:flutter/material.dart';

import '../../database/hive_service.dart';
import '../../services/language_controller.dart';

class AuditDashboardPage extends StatefulWidget {
  const AuditDashboardPage({super.key});

  @override
  State<AuditDashboardPage> createState() => _AuditDashboardPageState();
}

class _AuditDashboardPageState extends State<AuditDashboardPage> {
  bool loading = true;

  String username = 'Learner';
  String selectedLanguage = 'Italian';
  String themeMode = 'dark';

  int xp = 0;
  int level = 1;
  int streak = 0;
  int dailyXp = 0;
  int dailyGoal = 20;

  int lessons = 0;
  int quizzes = 0;
  int readings = 0;
  int pronunciation = 0;
  int favorites = 0;

  bool isPremium = false;

  @override
  void initState() {
    super.initState();
    _loadAudit();
  }

  Future<void> _loadAudit() async {
    await HiveService.init();

    if (!mounted) return;

    setState(() {
      username = HiveService.username;
      selectedLanguage = HiveService.selectedLanguage;
      themeMode = HiveService.themeMode;

      xp = HiveService.xp;
      level = HiveService.level;
      streak = HiveService.streak;
      dailyXp = HiveService.dailyXp;
      dailyGoal = HiveService.dailyGoal;

      lessons = HiveService.completedLessons.length;
      quizzes = HiveService.completedQuizzes;
      readings = HiveService.completedReadings;
      pronunciation = HiveService.pronunciationPractices;
      favorites = HiveService.favorites.length;

      isPremium = HiveService.isPremium;

      loading = false;
    });
  }

  double get dailyProgress {
    if (dailyGoal <= 0) return 0;
    return (dailyXp / dailyGoal).clamp(0.0, 1.0);
  }

  Widget _statCard(
    String title,
    String value,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF151515),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.08),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.white),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 9),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        backgroundColor: Color(0xFF080808),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF080808),
      appBar: AppBar(
        backgroundColor: const Color(0xFF080808),
        title: const Text(
          'Audit Dashboard',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: _loadAudit,
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadAudit,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF151515),
                    Color(0xFF202020),
                  ],
                ),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white12,
                    child: Text(
                      username.isEmpty
                          ? 'L'
                          : username[0].toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Current User',
                          style: TextStyle(
                            color: Colors.white54,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          username,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    isPremium
                        ? Icons.workspace_premium
                        : Icons.person,
                    color: isPremium
                        ? Colors.amber
                        : Colors.white54,
                    size: 30,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 22),

            const Text(
              'Progress Overview',
              style: TextStyle(
                color: Colors.white,
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            GridView.count(
              crossAxisCount:
                  MediaQuery.of(context).size.width > 700
                      ? 3
                      : 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.65,
              children: [
                _statCard('XP', '$xp', Icons.bolt),
                _statCard('Level', '$level', Icons.trending_up),
                _statCard('Streak', '$streak', Icons.local_fire_department),
                _statCard('Lessons', '$lessons', Icons.menu_book),
                _statCard('Quizzes', '$quizzes', Icons.quiz),
                _statCard('Readings', '$readings', Icons.auto_stories),
                _statCard(
                  'Pronunciation',
                  '$pronunciation',
                  Icons.record_voice_over,
                ),
                _statCard(
                  'Favorites',
                  '$favorites',
                  Icons.favorite,
                ),
              ],
            ),

            const SizedBox(height: 24),

            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF151515),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Daily Goal',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 14),
                  LinearProgressIndicator(
                    value: dailyProgress,
                    minHeight: 8,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '$dailyXp / $dailyGoal XP',
                    style: const TextStyle(
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF151515),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  const Text(
                    'System Data',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _infoRow('Username', username),
                  _infoRow('Language', selectedLanguage),
                  _infoRow('Theme', themeMode),
                  _infoRow(
                    'Premium',
                    isPremium ? 'Active' : 'Inactive',
                  ),
                  _infoRow(
                    'Language Controller',
                    LanguageController.isArabic
                        ? 'Arabic'
                        : LanguageController.isItalian
                            ? 'Italian'
                            : 'English',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: const Color(0xFF151515),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: Colors.green.withValues(alpha: 0.25),
                ),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.check_circle,
                    color: Colors.green,
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Hive progress system is connected.',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

