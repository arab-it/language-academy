import 'package:flutter/material.dart';
import 'package:arab_it/core/theme/app_colors.dart';

import '../../database/hive_service.dart';
import '../../pages/exercises_page.dart';
import '../../pages/lessons_page.dart';
import '../../pages/practice_page.dart';
import '../../pages/pronunciation_page.dart';
import '../../pages/reading_page.dart';
import '../../pages/smart_review_page.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_decorations.dart';
import '../../theme/app_gradients.dart';
import 'ai_coach_service.dart';
import '../ai_mistakes/mistake_practice_page.dart';

class AICoachCard extends StatelessWidget {
  const AICoachCard({super.key});

  void _openRecommendation(
    BuildContext context,
    AiCoachRecommendation recommendation,
  ) {
    Widget? page;

    switch (recommendation.type) {
      case 'ai_mistakes':
        page = const MistakePracticePage();
        break;

      case 'smart_review':
        page = const SmartReviewPage();
        break;

      case 'daily_goal':
        page = const LessonsPage();
        break;

      case 'pronunciation':
        page = const PronunciationPage();
        break;

      case 'reading':
        page = const ReadingPage();
        break;

      case 'quiz':
        page = const ExercisesPage();
        break;

      case 'lesson':
        page = const LessonsPage();
        break;

      case 'streak':
        page = const PracticePage();
        break;

      case 'mistakes':
        page = const MistakePracticePage();
        break;

      default:
        page = const LessonsPage();
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => page!,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final recommendation = AiCoachService.getRecommendation();

    final completedLessons = HiveService.completedLessons.length;
    final quizScore = HiveService.quizScore;
    final pronunciation = HiveService.pronunciationPractices;
    final readings = HiveService.completedReadings;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          AppDecorations.radiusLarge,
        ),
        gradient: AppGradients.aiCoach,
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.20),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ======================================================
          // HEADER
          // ======================================================

          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: AppDecorations.glass(
                  radius: 14,
                ),
                child: const Icon(
                  Icons.auto_awesome,
                  color: AppColors.white,
                  size: 24,
                ),
              ),

              const SizedBox(width: 12),

              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'AI Coach',
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 19,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Your personal learning guide',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),

              const Icon(
                Icons.smart_toy_outlined,
                color: Colors.white70,
              ),
            ],
          ),

          const SizedBox(height: 18),

          // ======================================================
          // RECOMMENDATION
          // ======================================================

          Text(
            recommendation.title,
            style: const TextStyle(
              color: AppColors.white,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),

          const SizedBox(height: 7),

          Text(
            recommendation.message,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
              height: 1.45,
            ),
          ),

          const SizedBox(height: 16),

          // ======================================================
          // XP / TIME
          // ======================================================

          Row(
            children: [
              _infoChip(
                Icons.schedule_rounded,
                ' min',
              ),
              const SizedBox(width: 8),
              _infoChip(
                Icons.star_rounded,
                '+ XP',
              ),
            ],
          ),

          const SizedBox(height: 16),

          // ======================================================
          // ACTION
          // ======================================================

          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => _openRecommendation(
                context,
                recommendation,
              ),
              borderRadius: BorderRadius.circular(
                AppDecorations.radiusMedium,
              ),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 13,
                ),
                decoration: BoxDecoration(
                  color: AppColors.white.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(
                    AppDecorations.radiusMedium,
                  ),
                  border: Border.all(
                    color: AppColors.white.withValues(alpha: 0.08),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.play_arrow_rounded,
                      color: AppColors.white,
                      size: 22,
                    ),

                    const SizedBox(width: 10),

                    Expanded(
                      child: Text(
                        recommendation.action,
                        style: const TextStyle(
                          color: AppColors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),

                    const Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Colors.white70,
                      size: 15,
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // ======================================================
          // AI MISTAKES
          // ======================================================

          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const MistakePracticePage(),
                  ),
                );
              },
              borderRadius: BorderRadius.circular(
                AppDecorations.radiusMedium,
              ),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 13,
                ),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(
                    AppDecorations.radiusMedium,
                  ),
                  border: Border.all(
                    color: Colors.red.withValues(alpha: 0.20),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.psychology_rounded,
                      color: Colors.white,
                      size: 22,
                    ),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Text(
                        'Review My Mistakes',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Colors.white70,
                      size: 15,
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // ======================================================
          // LEARNING STATS
          // ======================================================

          Row(
            children: [
              _stat(
                Icons.menu_book_outlined,
                '$completedLessons',
                'Lessons',
              ),

              const SizedBox(width: 8),

              _stat(
                Icons.quiz_outlined,
                '$quizScore%',
                'Quiz',
              ),

              const SizedBox(width: 8),

              _stat(
                Icons.record_voice_over_outlined,
                '$pronunciation',
                'Practice',
              ),

              const SizedBox(width: 8),

              _stat(
                Icons.auto_stories_outlined,
                '$readings',
                'Reading',
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ============================================================
  // INFO CHIP
  // ============================================================

  Widget _infoChip(
    IconData icon,
    String text,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 11,
        vertical: 7,
      ),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: Colors.white70,
            size: 16,
          ),

          const SizedBox(width: 5),

          Text(
            text,
            style: const TextStyle(
              color: AppColors.white,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // STAT
  // ============================================================

  Widget _stat(
    IconData icon,
    String value,
    String label,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 4,
          vertical: 9,
        ),
        decoration: BoxDecoration(
          color: AppColors.white.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(13),
          border: Border.all(
            color: AppColors.white.withValues(alpha: 0.06),
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: Colors.white70,
              size: 17,
            ),

            const SizedBox(height: 4),

            Text(
              value,
              style: const TextStyle(
                color: AppColors.white,
                fontWeight: FontWeight.w800,
                fontSize: 12,
              ),
            ),

            const SizedBox(height: 2),

            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white54,
                fontSize: 8,
              ),
            ),
          ],
        ),
      ),
    );
  }
}









