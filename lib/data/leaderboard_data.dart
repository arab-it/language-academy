import '../database/hive_service.dart';
import '../models/leaderboard_user.dart';

class LeaderboardData {
  static List<LeaderboardUser> get users {
    return [
      const LeaderboardUser(
        name: 'Alex',
        points: 2450,
        level: 12,
        streak: 24,
        avatar: 'ðŸ‘¨ðŸ»',
      ),
      const LeaderboardUser(
        name: 'Sofia',
        points: 2180,
        level: 11,
        streak: 18,
        avatar: 'ðŸ‘©ðŸ»',
      ),
      const LeaderboardUser(
        name: 'Marco',
        points: 1920,
        level: 10,
        streak: 15,
        avatar: 'ðŸ‘¨ðŸ»',
      ),
      const LeaderboardUser(
        name: 'Emma',
        points: 1750,
        level: 9,
        streak: 12,
        avatar: 'ðŸ‘©ðŸ¼',
      ),
      const LeaderboardUser(
        name: 'Luca',
        points: 1540,
        level: 8,
        streak: 10,
        avatar: 'ðŸ‘¨ðŸ¼',
      ),
      LeaderboardUser(
        name: HiveService.username,
        points: HiveService.points,
        level: HiveService.level,
        streak: HiveService.streak,
        avatar: 'ðŸ§‘ðŸ»',
      ),
    ];
  }

  static List<LeaderboardUser> get sortedUsers {
    final list = List<LeaderboardUser>.from(users);

    list.sort((a, b) => b.points.compareTo(a.points));

    return list;
  }
}

