import 'package:flutter/material.dart';
import 'package:arab_it/core/theme/app_colors.dart';

class ProgressPage extends StatelessWidget {
  const ProgressPage({super.key});

  static const Color background = Color(0xFF070A12);
  static const Color card = Color(0xFF111827);
  static const Color purple = Color(0xFF8B5CF6);
  static const Color cyan = AppColors.cyan;
  static const Color green = Color(0xFF22C55E);
  static const Color orange = Color(0xFFF59E0B);
  static const Color pink = Color(0xFFEC4899);
  static const Color blue = Color(0xFF3B82F6);
  static const Color white = Color(0xFFFFFFFF);
  static const Color muted = Color(0xFF94A3B8);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(child: _header()),
            SliverToBoxAdapter(child: _overview()),
            SliverToBoxAdapter(child: _weeklyProgress()),
            SliverToBoxAdapter(child: _activity()),
            SliverToBoxAdapter(
              child: _sectionTitle(
                'Achievements',
                'Keep learning and unlock new rewards',
              ),
            ),
            SliverToBoxAdapter(child: _achievements()),
            SliverToBoxAdapter(child: _learningStats()),
            const SliverToBoxAdapter(child: SizedBox(height: 30)),
          ],
        ),
      ),
    );
  }

  Widget _header() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
      child: Row(
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your Progress',
                  style: TextStyle(
                    color: white,
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.8,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'See how far you have come.',
                  style: TextStyle(
                    color: muted,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: card,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: white.withValues(alpha: 0.07)),
            ),
            child: const Icon(Icons.insights_rounded, color: cyan, size: 23),
          ),
        ],
      ),
    );
  }

  Widget _overview() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 25),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF1E1B4B), Color(0xFF172554), Color(0xFF111827)],
          ),
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: white.withValues(alpha: 0.06)),
        ),
        child: Column(
          children: [
            Row(
              children: [
                _bigStat('1,240', 'Total XP', purple, Icons.bolt_rounded),
                _divider(),
                _bigStat('12', 'Lessons', cyan, Icons.menu_book_rounded),
                _divider(),
                _bigStat('86%', 'Accuracy', green, Icons.track_changes_rounded),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(13),
              decoration: BoxDecoration(
                color: white.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: orange.withValues(alpha: 0.13),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.local_fire_department_rounded,
                      color: orange,
                      size: 21,
                    ),
                  ),
                  const SizedBox(width: 11),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '7 day streak',
                          style: TextStyle(
                            color: white,
                            fontSize: 12,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        SizedBox(height: 3),
                        Text(
                          'You are on fire! Keep going.',
                          style: TextStyle(
                            color: muted,
                            fontSize: 9,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Text('??', style: TextStyle(fontSize: 24)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _bigStat(String value, String label, Color color, IconData icon) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: color, size: 21),
          const SizedBox(height: 7),
          Text(
            value,
            style: const TextStyle(
              color: white,
              fontSize: 17,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: muted,
              fontSize: 8,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() {
    return Container(
      width: 1,
      height: 55,
      color: white.withValues(alpha: 0.07),
    );
  }

  Widget _weeklyProgress() {
    const values = [0.35, 0.55, 0.75, 0.45, 0.90, 0.68, 0.82];

    const days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 25),
      child: Container(
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 15),
        decoration: BoxDecoration(
          color: card,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: white.withValues(alpha: 0.055)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Weekly Progress',
              style: TextStyle(
                color: white,
                fontSize: 17,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Your learning activity this week',
              style: TextStyle(
                color: muted,
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 22),
            SizedBox(
              height: 145,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: List.generate(values.length, (index) {
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            '${(values[index] * 100).round()}%',
                            style: const TextStyle(
                              color: muted,
                              fontSize: 8,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Expanded(
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: FractionallySizedBox(
                                heightFactor: values[index],
                                child: Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      begin: Alignment.bottomCenter,
                                      end: Alignment.topCenter,
                                      colors: [
                                        Color(0xFF7C3AED),
                                        AppColors.cyan,
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(9),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            days[index],
                            style: const TextStyle(
                              color: muted,
                              fontSize: 9,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _activity() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 25),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: card,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: white.withValues(alpha: 0.055)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Learning Activity',
              style: TextStyle(
                color: white,
                fontSize: 17,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Your recent learning sessions',
              style: TextStyle(color: muted, fontSize: 10),
            ),
            const SizedBox(height: 16),
            _activityRow(
              Icons.menu_book_rounded,
              'Italian Basics',
              'Lesson completed',
              '+40 XP',
              purple,
            ),
            _activityRow(
              Icons.record_voice_over_rounded,
              'Pronunciation',
              'Practice completed',
              '+25 XP',
              cyan,
            ),
            _activityRow(
              Icons.quiz_rounded,
              'Daily Quiz',
              '8 / 10 correct',
              '+30 XP',
              orange,
            ),
          ],
        ),
      ),
    );
  }

  Widget _activityRow(
    IconData icon,
    String title,
    String subtitle,
    String xpText,
    Color color,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: white,
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: const TextStyle(color: muted, fontSize: 9),
                ),
              ],
            ),
          ),
          Text(
            xpText,
            style: TextStyle(
              color: color,
              fontSize: 10,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: white,
              fontSize: 20,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 4),
          Text(subtitle, style: const TextStyle(color: muted, fontSize: 10)),
        ],
      ),
    );
  }

  Widget _achievements() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 25),
      child: Column(
        children: [
          _achievement(
            Icons.local_fire_department_rounded,
            '7 Day Streak',
            'Learn for 7 days in a row',
            'UNLOCKED',
            orange,
            true,
          ),
          const SizedBox(height: 10),
          _achievement(
            Icons.menu_book_rounded,
            'First Lesson',
            'Complete your first lesson',
            'UNLOCKED',
            cyan,
            true,
          ),
          const SizedBox(height: 10),
          _achievement(
            Icons.bolt_rounded,
            'XP Hunter',
            'Reach 2,000 XP',
            '1,240 / 2,000 XP',
            purple,
            false,
          ),
          const SizedBox(height: 10),
          _achievement(
            Icons.emoji_events_rounded,
            'Language Master',
            'Complete 50 lessons',
            '12 / 50',
            pink,
            false,
          ),
        ],
      ),
    );
  }

  Widget _achievement(
    IconData icon,
    String title,
    String description,
    String progress,
    Color color,
    bool unlocked,
  ) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(19),
        border: Border.all(
          color: unlocked
              ? color.withValues(alpha: 0.18)
              : white.withValues(alpha: 0.055),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              gradient: unlocked
                  ? LinearGradient(
                      colors: [
                        color.withValues(alpha: 0.9),
                        color.withValues(alpha: 0.45),
                      ],
                    )
                  : null,
              color: unlocked ? null : white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(icon, color: unlocked ? white : muted, size: 23),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: white,
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(color: muted, fontSize: 9),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            decoration: BoxDecoration(
              color: unlocked
                  ? color.withValues(alpha: 0.12)
                  : white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(9),
            ),
            child: Text(
              progress,
              style: TextStyle(
                color: unlocked ? color : muted,
                fontSize: 8,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _learningStats() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: card,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: white.withValues(alpha: 0.055)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Learning Statistics',
              style: TextStyle(
                color: white,
                fontSize: 17,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 16),
            _statLine('Vocabulary', '342 words', 0.68, purple),
            _statLine('Pronunciation', '78%', 0.78, cyan),
            _statLine('Reading', '64%', 0.64, green),
            _statLine('Listening', '59%', 0.59, orange),
          ],
        ),
      ),
    );
  }

  Widget _statLine(String title, String value, double progress, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: white,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  color: color,
                  fontSize: 9,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 7),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              backgroundColor: white.withValues(alpha: 0.06),
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ],
      ),
    );
  }
}




