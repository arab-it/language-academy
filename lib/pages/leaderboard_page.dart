import 'package:flutter/material.dart';
import 'package:arab_it/core/theme/app_colors.dart';

class LeaderboardPage extends StatelessWidget {
  const LeaderboardPage({super.key});

  static const Color bg = Color(0xFF070A12);
  static const Color card = Color(0xFF111725);
  static const Color purple = Color(0xFF8B5CF6);
  static const Color cyan = AppColors.cyan;
  static const Color white = Colors.white;
  static const Color muted = Color(0xFF94A3B8);

  static const List<Map<String, dynamic>> users = [
    {'name': 'Alex', 'xp': 2450},
    {'name': 'Sara', 'xp': 2180},
    {'name': 'Marco', 'xp': 1960},
    {'name': 'You', 'xp': 0},
  ];

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
          'Leaderboard',
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(18, 12, 18, 30),
          children: [
            _header(),
            const SizedBox(height: 22),
            ...List.generate(
              users.length,
              (index) => _userCard(
                index,
                users[index]['name'] as String,
                users[index]['xp'] as int,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _header() {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF4C1D95), Color(0xFF075985)],
        ),
        borderRadius: BorderRadius.circular(26),
      ),
      child: const Column(
        children: [
          Icon(
            Icons.emoji_events_rounded,
            color: Color(0xFFFFC107),
            size: 48,
          ),
          SizedBox(height: 10),
          Text(
            'Weekly Leaderboard',
            style: TextStyle(
              color: white,
              fontSize: 21,
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(height: 6),
          Text(
            'Keep learning and climb the rankings.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xB3FFFFFF),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _userCard(int index, String name, int xp) {
    final rank = index + 1;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: index == 0
              ? const Color(0xFFFFC107)
              : white.withValues(alpha: 0.06),
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 38,
            child: Text(
              '#$rank',
              style: TextStyle(
                color: index == 0 ? const Color(0xFFFFC107) : muted,
                fontSize: 15,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: purple.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              index == 0
                  ? Icons.emoji_events_rounded
                  : Icons.person_rounded,
              color: index == 0 ? const Color(0xFFFFC107) : cyan,
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Text(
              name,
              style: const TextStyle(
                color: white,
                fontSize: 15,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          Text(
            '$xp XP',
            style: const TextStyle(
              color: cyan,
              fontSize: 14,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}




