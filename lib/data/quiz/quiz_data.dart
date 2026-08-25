import 'italian_quiz.dart';
import 'english_quiz.dart';
import 'arabic_quiz.dart';
import '../../models/quiz_question.dart';

class QuizData {
  QuizData._();

  static List<QuizQuestion> get allQuestions {
    return [...italianQuiz, ...englishQuiz, ...arabicQuiz];
  }

  static List<QuizQuestion> questionsForLanguage(String language) {
    return allQuestions
        .where(
          (question) =>
              question.language.toLowerCase() == language.toLowerCase(),
        )
        .toList();
  }

  static List<QuizQuestion> questionsForLevel(String language, String level) {
    return allQuestions
        .where(
          (question) =>
              question.language.toLowerCase() == language.toLowerCase() &&
              question.level.toLowerCase() == level.toLowerCase(),
        )
        .toList();
  }

  static List<QuizQuestion> randomQuestions({
    required String language,
    required String level,
    int count = 10,
  }) {
    final questions = questionsForLevel(language, level);

    questions.shuffle();

    if (questions.length <= count) {
      return questions;
    }

    return questions.take(count).toList();
  }
}
