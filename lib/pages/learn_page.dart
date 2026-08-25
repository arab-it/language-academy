import 'package:flutter/material.dart';
import 'package:arab_it/core/theme/app_colors.dart';

class LearnPage extends StatelessWidget {
  const LearnPage({super.key});

  static const Color background = Color(0xFF070A12);
  static const Color card = Color(0xFF111827);
  static const Color purple = Color(0xFF8B5CF6);
  static const Color cyan = AppColors.cyan;
  static const Color green = Color(0xFF22C55E);
  static const Color orange = Color(0xFFF59E0B);
  static const Color pink = Color(0xFFEC4899);
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

            SliverToBoxAdapter(child: _searchBar()),

            SliverToBoxAdapter(child: _continueLearning()),

            SliverToBoxAdapter(
              child: _sectionTitle('Learn', 'Choose your learning path'),
            ),

            SliverToBoxAdapter(child: _learningGrid()),

            SliverToBoxAdapter(
              child: _sectionTitle(
                'Your Courses',
                'Build your language skills',
              ),
            ),

            SliverToBoxAdapter(child: _courses()),

            const SliverToBoxAdapter(child: SizedBox(height: 30)),
          ],
        ),
      ),
    );
  }

  Widget _header() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    Text(
                      'Good day',
                      style: TextStyle(
                        color: muted,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: 6),
                    Text('ðŸ‘‹', style: TextStyle(fontSize: 15)),
                  ],
                ),
                const SizedBox(height: 5),
                const Text(
                  'Ready to learn?',
                  style: TextStyle(
                    color: white,
                    fontSize: 27,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.7,
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
            child: const Icon(
              Icons.notifications_none_rounded,
              color: white,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  Widget _searchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 18),
      child: Container(
        height: 54,
        decoration: BoxDecoration(
          color: card,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: white.withValues(alpha: 0.06)),
        ),
        child: Row(
          children: [
            const SizedBox(width: 17),
            const Icon(Icons.search_rounded, color: muted, size: 22),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'Search lessons, words...',
                style: TextStyle(
                  color: muted,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Container(
              width: 38,
              height: 38,
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                color: purple.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.tune_rounded, color: purple, size: 19),
            ),
          ],
        ),
      ),
    );
  }

  Widget _continueLearning() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF7C3AED), Color(0xFF4F46E5), Color(0xFF2563EB)],
          ),
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: purple.withValues(alpha: 0.22),
              blurRadius: 30,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: white.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text(
                    'CONTINUE',
                    style: TextStyle(
                      color: white,
                      fontSize: 9,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1,
                    ),
                  ),
                ),
                const Spacer(),
                const Text(
                  '25%',
                  style: TextStyle(
                    color: white,
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 15),

            const Text(
              'Italian Basics',
              style: TextStyle(
                color: white,
                fontSize: 22,
                fontWeight: FontWeight.w900,
              ),
            ),

            const SizedBox(height: 5),

            const Text(
              'Lesson 3 â€¢ Greetings & Introductions',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: 17),

            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: LinearProgressIndicator(
                value: 0.25,
                minHeight: 7,
                backgroundColor: white.withValues(alpha: 0.15),
                valueColor: const AlwaysStoppedAnimation<Color>(white),
              ),
            ),

            const SizedBox(height: 17),

            Row(
              children: [
                const Icon(
                  Icons.timer_outlined,
                  color: Colors.white70,
                  size: 17,
                ),
                const SizedBox(width: 6),
                const Text(
                  '8 min left',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: white,
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: const Row(
                    children: [
                      Text(
                        'Continue',
                        style: TextStyle(
                          color: Color(0xFF4F46E5),
                          fontSize: 12,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      SizedBox(width: 5),
                      Icon(
                        Icons.arrow_forward_rounded,
                        color: Color(0xFF4F46E5),
                        size: 16,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
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
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: muted,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const Text(
            'See all',
            style: TextStyle(
              color: cyan,
              fontSize: 11,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  Widget _learningGrid() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
      child: GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.45,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          _learningCard(
            icon: Icons.menu_book_rounded,
            title: 'Lessons',
            subtitle: 'Structured courses',
            color: purple,
          ),
          _learningCard(
            icon: Icons.translate_rounded,
            title: 'Vocabulary',
            subtitle: 'Learn new words',
            color: cyan,
          ),
          _learningCard(
            icon: Icons.record_voice_over_rounded,
            title: 'Pronunciation',
            subtitle: 'Speak naturally',
            color: green,
          ),
          _learningCard(
            icon: Icons.auto_stories_rounded,
            title: 'Reading',
            subtitle: 'Read & understand',
            color: orange,
          ),
          _learningCard(
            icon: Icons.headphones_rounded,
            title: 'Listening',
            subtitle: 'Train your ear',
            color: pink,
          ),
          _learningCard(
            icon: Icons.quiz_rounded,
            title: 'Quiz',
            subtitle: 'Test yourself',
            color: Color(0xFF3B82F6),
          ),
        ],
      ),
    );
  }

  Widget _learningCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(21),
        border: Border.all(color: white.withValues(alpha: 0.055)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 39,
            height: 39,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.13),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 20),
          ),

          const Spacer(),

          Text(
            title,
            style: const TextStyle(
              color: white,
              fontSize: 13,
              fontWeight: FontWeight.w800,
            ),
          ),

          const SizedBox(height: 3),

          Text(
            subtitle,
            style: const TextStyle(
              color: muted,
              fontSize: 9.5,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _courses() {
    return SizedBox(
      height: 175,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        children: [
          _courseCard(
            language: 'Italiano',
            title: 'Italian Beginner',
            lessons: '24 lessons',
            progress: 0.32,
            flag: 'ðŸ‡®ðŸ‡¹',
            colors: const [AppColors.italian, AppColors.error],
          ),
          _courseCard(
            language: 'English',
            title: 'English Starter',
            lessons: '30 lessons',
            progress: 0.18,
            flag: 'ðŸ‡¬ðŸ‡§',
            colors: const [Color(0xFF2563EB), Color(0xFF7C3AED)],
          ),
          _courseCard(
            language: 'Ø§Ù„Ø¹Ø±Ø¨ÙŠØ©',
            title: 'Arabic Basics',
            lessons: '20 lessons',
            progress: 0.08,
            flag: 'ðŸ‡¸ðŸ‡¦',
            colors: const [Color(0xFF16A34A), Color(0xFF059669)],
          ),
        ],
      ),
    );
  }

  Widget _courseCard({
    required String language,
    required String title,
    required String lessons,
    required double progress,
    required String flag,
    required List<Color> colors,
  }) {
    return Container(
      width: 275,
      margin: const EdgeInsets.only(right: 13),
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [colors.first.withValues(alpha: 0.22), card],
        ),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: white.withValues(alpha: 0.06)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(flag, style: const TextStyle(fontSize: 25)),
              const SizedBox(width: 9),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    language,
                    style: const TextStyle(
                      color: white,
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Text(
                    lessons,
                    style: const TextStyle(color: muted, fontSize: 9),
                  ),
                ],
              ),
              const Spacer(),
              const Icon(Icons.more_horiz_rounded, color: muted),
            ],
          ),

          const Spacer(),

          Text(
            title,
            style: const TextStyle(
              color: white,
              fontSize: 16,
              fontWeight: FontWeight.w900,
            ),
          ),

          const SizedBox(height: 10),

          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 5,
                    backgroundColor: white.withValues(alpha: 0.08),
                    valueColor: AlwaysStoppedAnimation<Color>(colors.first),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                '${(progress * 100).round()}%',
                style: const TextStyle(
                  color: white,
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}





