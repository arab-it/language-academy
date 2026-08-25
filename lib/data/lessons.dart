class Lesson {
  final String id;
  final String title;
  final String description;
  final String language;
  final String level;
  final int xp;
  final bool locked;

  const Lesson({
    required this.id,
    required this.title,
    required this.description,
    required this.language,
    required this.level,
    required this.xp,
    this.locked = false,
  });
}

final List<Lesson> lessons = [
  // =========================
  // ENGLISH - BEGINNER
  // =========================

  Lesson(
    id: 'en_b1',
    title: 'English Basics',
    description: 'Learn greetings and basic introductions.',
    language: 'English',
    level: 'Beginner',
    xp: 20,
  ),
  Lesson(
    id: 'en_b2',
    title: 'Numbers',
    description: 'Learn numbers from 1 to 100.',
    language: 'English',
    level: 'Beginner',
    xp: 20,
  ),
  Lesson(
    id: 'en_b3',
    title: 'Family',
    description: 'Learn vocabulary about family.',
    language: 'English',
    level: 'Beginner',
    xp: 25,
  ),
  Lesson(
    id: 'en_b4',
    title: 'Daily Life',
    description: 'Talk about everyday activities.',
    language: 'English',
    level: 'Beginner',
    xp: 25,
  ),
  Lesson(
    id: 'en_b5',
    title: 'Food & Drinks',
    description: 'Learn useful food and drink vocabulary.',
    language: 'English',
    level: 'Beginner',
    xp: 30,
  ),

  // =========================
  // ENGLISH - INTERMEDIATE
  // =========================
  Lesson(
    id: 'en_i1',
    title: 'Daily Conversation',
    description: 'Practice common everyday conversations.',
    language: 'English',
    level: 'Intermediate',
    xp: 35,
  ),
  Lesson(
    id: 'en_i2',
    title: 'Shopping',
    description: 'Learn useful phrases for shopping.',
    language: 'English',
    level: 'Intermediate',
    xp: 35,
  ),
  Lesson(
    id: 'en_i3',
    title: 'Travel English',
    description: 'Useful English for airports and hotels.',
    language: 'English',
    level: 'Intermediate',
    xp: 40,
  ),
  Lesson(
    id: 'en_i4',
    title: 'Work & Communication',
    description: 'Practice professional conversations.',
    language: 'English',
    level: 'Intermediate',
    xp: 40,
  ),
  Lesson(
    id: 'en_i5',
    title: 'Speaking Practice',
    description: 'Build confidence in spoken English.',
    language: 'English',
    level: 'Intermediate',
    xp: 45,
  ),

  // =========================
  // ENGLISH - ADVANCED
  // =========================
  Lesson(
    id: 'en_a1',
    title: 'Advanced Conversation',
    description: 'Practice complex conversations.',
    language: 'English',
    level: 'Advanced',
    xp: 50,
  ),
  Lesson(
    id: 'en_a2',
    title: 'Business English',
    description: 'Professional vocabulary and expressions.',
    language: 'English',
    level: 'Advanced',
    xp: 55,
  ),
  Lesson(
    id: 'en_a3',
    title: 'Advanced Vocabulary',
    description: 'Expand your vocabulary.',
    language: 'English',
    level: 'Advanced',
    xp: 55,
  ),
  Lesson(
    id: 'en_a4',
    title: 'Fluent Speaking',
    description: 'Practice natural and fluent English.',
    language: 'English',
    level: 'Advanced',
    xp: 60,
  ),
  Lesson(
    id: 'en_a5',
    title: 'Master English',
    description: 'Challenge yourself with advanced English.',
    language: 'English',
    level: 'Advanced',
    xp: 70,
  ),

  // =========================
  // ITALIAN - BEGINNER
  // =========================
  Lesson(
    id: 'it_b1',
    title: 'Italian Basics',
    description: 'Learn greetings and introductions.',
    language: 'Italian',
    level: 'Beginner',
    xp: 20,
  ),
  Lesson(
    id: 'it_b2',
    title: 'Numbers',
    description: 'Learn Italian numbers from 1 to 100.',
    language: 'Italian',
    level: 'Beginner',
    xp: 20,
  ),
  Lesson(
    id: 'it_b3',
    title: 'Family',
    description: 'Learn basic family vocabulary.',
    language: 'Italian',
    level: 'Beginner',
    xp: 25,
  ),
  Lesson(
    id: 'it_b4',
    title: 'Food',
    description: 'Learn common Italian food vocabulary.',
    language: 'Italian',
    level: 'Beginner',
    xp: 25,
  ),
  Lesson(
    id: 'it_b5',
    title: 'Daily Life',
    description: 'Talk about your everyday life.',
    language: 'Italian',
    level: 'Beginner',
    xp: 30,
  ),

  // =========================
  // ITALIAN - INTERMEDIATE
  // =========================
  Lesson(
    id: 'it_i1',
    title: 'Daily Conversation',
    description: 'Practice everyday Italian conversations.',
    language: 'Italian',
    level: 'Intermediate',
    xp: 35,
  ),
  Lesson(
    id: 'it_i2',
    title: 'Shopping',
    description: 'Useful Italian phrases for shopping.',
    language: 'Italian',
    level: 'Intermediate',
    xp: 35,
  ),
  Lesson(
    id: 'it_i3',
    title: 'Travel Italian',
    description: 'Useful phrases for travelling in Italy.',
    language: 'Italian',
    level: 'Intermediate',
    xp: 40,
  ),
  Lesson(
    id: 'it_i4',
    title: 'Restaurant',
    description: 'Order food and communicate in restaurants.',
    language: 'Italian',
    level: 'Intermediate',
    xp: 40,
  ),
  Lesson(
    id: 'it_i5',
    title: 'Speaking Practice',
    description: 'Improve your Italian speaking skills.',
    language: 'Italian',
    level: 'Intermediate',
    xp: 45,
  ),

  // =========================
  // ITALIAN - ADVANCED
  // =========================
  Lesson(
    id: 'it_a1',
    title: 'Advanced Conversation',
    description: 'Practice complex Italian conversations.',
    language: 'Italian',
    level: 'Advanced',
    xp: 50,
  ),
  Lesson(
    id: 'it_a2',
    title: 'Business Italian',
    description: 'Professional Italian vocabulary.',
    language: 'Italian',
    level: 'Advanced',
    xp: 55,
  ),
  Lesson(
    id: 'it_a3',
    title: 'Advanced Vocabulary',
    description: 'Expand your Italian vocabulary.',
    language: 'Italian',
    level: 'Advanced',
    xp: 55,
  ),
  Lesson(
    id: 'it_a4',
    title: 'Fluent Speaking',
    description: 'Practice natural Italian speech.',
    language: 'Italian',
    level: 'Advanced',
    xp: 60,
  ),
  Lesson(
    id: 'it_a5',
    title: 'Master Italian',
    description: 'Challenge yourself with advanced Italian.',
    language: 'Italian',
    level: 'Advanced',
    xp: 70,
  ),

  // =========================
  // ARABIC - BEGINNER
  // =========================
  Lesson(
    id: 'ar_b1',
    title: 'Arabic Alphabet',
    description: 'Learn the Arabic alphabet.',
    language: 'Arabic',
    level: 'Beginner',
    xp: 20,
  ),
  Lesson(
    id: 'ar_b2',
    title: 'Arabic Greetings',
    description: 'Learn basic Arabic greetings.',
    language: 'Arabic',
    level: 'Beginner',
    xp: 20,
  ),
  Lesson(
    id: 'ar_b3',
    title: 'Numbers',
    description: 'Learn basic Arabic numbers.',
    language: 'Arabic',
    level: 'Beginner',
    xp: 25,
  ),
  Lesson(
    id: 'ar_b4',
    title: 'Family',
    description: 'Learn Arabic family vocabulary.',
    language: 'Arabic',
    level: 'Beginner',
    xp: 25,
  ),
  Lesson(
    id: 'ar_b5',
    title: 'Food',
    description: 'Learn basic Arabic food vocabulary.',
    language: 'Arabic',
    level: 'Beginner',
    xp: 30,
  ),

  // =========================
  // ARABIC - INTERMEDIATE
  // =========================
  Lesson(
    id: 'ar_i1',
    title: 'Daily Conversation',
    description: 'Practice everyday Arabic conversations.',
    language: 'Arabic',
    level: 'Intermediate',
    xp: 35,
  ),
  Lesson(
    id: 'ar_i2',
    title: 'Shopping',
    description: 'Useful Arabic phrases for shopping.',
    language: 'Arabic',
    level: 'Intermediate',
    xp: 35,
  ),
  Lesson(
    id: 'ar_i3',
    title: 'Travel Arabic',
    description: 'Useful Arabic phrases for travelling.',
    language: 'Arabic',
    level: 'Intermediate',
    xp: 40,
  ),
  Lesson(
    id: 'ar_i4',
    title: 'Restaurant',
    description: 'Learn Arabic phrases for restaurants.',
    language: 'Arabic',
    level: 'Intermediate',
    xp: 40,
  ),
  Lesson(
    id: 'ar_i5',
    title: 'Speaking Practice',
    description: 'Improve your Arabic speaking skills.',
    language: 'Arabic',
    level: 'Intermediate',
    xp: 45,
  ),

  // =========================
  // ARABIC - ADVANCED
  // =========================
  Lesson(
    id: 'ar_a1',
    title: 'Advanced Conversation',
    description: 'Practice advanced Arabic conversations.',
    language: 'Arabic',
    level: 'Advanced',
    xp: 50,
  ),
  Lesson(
    id: 'ar_a2',
    title: 'Advanced Vocabulary',
    description: 'Expand your Arabic vocabulary.',
    language: 'Arabic',
    level: 'Advanced',
    xp: 55,
  ),
  Lesson(
    id: 'ar_a3',
    title: 'Business Arabic',
    description: 'Professional Arabic vocabulary.',
    language: 'Arabic',
    level: 'Advanced',
    xp: 55,
  ),
  Lesson(
    id: 'ar_a4',
    title: 'Fluent Speaking',
    description: 'Practice natural Arabic speech.',
    language: 'Arabic',
    level: 'Advanced',
    xp: 60,
  ),
  Lesson(
    id: 'ar_a5',
    title: 'Master Arabic',
    description: 'Challenge yourself with advanced Arabic.',
    language: 'Arabic',
    level: 'Advanced',
    xp: 70,
  ),
];

