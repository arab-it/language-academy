import 'dart:async';

import 'package:flutter/material.dart';
import 'package:arab_it/core/theme/app_colors.dart';

import '../database/hive_service.dart';
import '../core/premium_guard.dart';
import '../data/quiz/quiz_data.dart';
import '../data/lesson_content.dart';
import '../models/quiz_question.dart';
import '../services/language_controller.dart';
import '../services/smart_review_service.dart';
import '../core/ai_mistakes/mistake_service.dart';
import 'premium_page.dart';

class QuizPage extends StatefulWidget {
  final String? lessonId;
  final String? lessonTitle;
  final String? language;

  const QuizPage({
    super.key,
    this.lessonId,
    this.lessonTitle,
    this.language,
  });

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  static const Color bg = Color(0xFF070A12);
  static const Color card = Color(0xFF111725);
  static const Color purple = Color(0xFF8B5CF6);
  static const Color blue = Color(0xFF3B82F6);
  static const Color cyan = AppColors.cyan;
  static const Color green = Color(0xFF22C55E);
  static const Color red = Color(0xFFEF4444);
  static const Color yellow = Color(0xFFFACC15);
  static const Color white = Colors.white;
  static const Color muted = Color(0xFF94A3B8);

  int currentQuestion = 0;
  int score = 0;
  int? selectedAnswer;
  bool answered = false;
  bool savingResult = false;

  List<QuizQuestion> get _questions {
    var language = widget.language ?? LanguageController.current;

    language = language.trim();

    if (language.isEmpty) {
      language = 'English';
    }

    final lower = language.toLowerCase();

    if (lower == 'italiano' || lower == 'italian') {
      language = 'Italian';
    } else if (
        lower == 'arabic' ||
        lower == 'العربية' ||
        lower.contains('arab')) {
      language = 'Arabic';
    } else {
      language = 'English';
    }

    // ============================================================
    // LESSON QUIZ
    // ============================================================
    if (widget.lessonId != null && widget.lessonId!.trim().isNotEmpty) {
      final lesson = lessonContents[widget.lessonId!];

      if (lesson != null) {
        return lesson.questions
            .map(
              (q) => QuizQuestion(
                language: language,
                level: widget.lessonId!.split('_').length > 1
                    ? widget.lessonId!.split('_')[1]
                    : 'b1',
                category: 'lesson',
                question: q.question,
                answers: List<String>.from(q.options),
                correctAnswer: q.correctIndex,
                points: 10,
              ),
            )
            .toList();
      }
    }

    // ============================================================
    // GENERAL LANGUAGE QUIZ
    // ============================================================
    final questions = QuizData.questionsForLanguage(language);

    return List<QuizQuestion>.from(questions);
  }

  bool get _isArabic {
    final language =
        (widget.language ?? LanguageController.current).toLowerCase();

    return language == 'arabic' ||
        language == 'العربية' ||
        language.contains('arab');
  }

  String _t({
    required String en,
    required String it,
    required String ar,
  }) {
    final language =
        (widget.language ?? LanguageController.current).toLowerCase();

    if (language == 'italiano' || language == 'italian') {
      return it;
    }

    if (language == 'arabic' ||
        language == 'العربية' ||
        language.contains('arab')) {
      return ar;
    }

    return en;
  }

  @override
  void initState() {
    super.initState();
    LanguageController.language.addListener(_languageChanged);
  }

  void _languageChanged() {
    if (!mounted) return;

    setState(() {
      currentQuestion = 0;
      score = 0;
      selectedAnswer = null;
      answered = false;
      savingResult = false;
    });
  }

  void _selectAnswer(int index) {
    if (answered || _questions.isEmpty) {
      return;
    }

    final question = _questions[currentQuestion];
    final isCorrect = index == question.correctAnswer;

    setState(() {
      selectedAnswer = index;
      answered = true;

      if (isCorrect) {
        score++;
      }
    });

    unawaited(
      SmartReviewService.recordAnswer(
        question.question,
        correct: isCorrect,
      ),
    );

    if (!isCorrect) {
      unawaited(
        MistakeService.addMistake(
          language: widget.language ?? LanguageController.current,
          category: question.category,
          question: question.question,
          wrongAnswer: question.answers[index],
          correctAnswer: question.answers[question.correctAnswer],
          source: 'quiz',
        ),
      );
    }
  }

  Future<void> _nextQuestion() async {
    if (!answered || savingResult) {
      return;
    }

    if (currentQuestion < _questions.length - 1) {
      setState(() {
        currentQuestion++;
        selectedAnswer = null;
        answered = false;
      });

      return;
    }

    await _showResult();
  }

  Future<void> _saveResult() async {
    if (savingResult) return;

    setState(() {
      savingResult = true;
    });

    try {
      await HiveService.addCompletedQuiz(score);
    } finally {
      if (mounted) {
        setState(() {
          savingResult = false;
        });
      }
    }
  }

  Future<void> _showResult() async {
    await _saveResult();

    if (!mounted) return;

    final total = _questions.length;
    final percentage =
        total == 0 ? 0 : ((score / total) * 100).round();

    final message = percentage >= 90
        ? _t(
            en: 'Excellent work! You are mastering this material.',
            it: 'Ottimo lavoro! Stai padroneggiando questo materiale.',
            ar: 'عمل ممتاز! أنت تتقن هذه المادة.',
          )
        : percentage >= 70
            ? _t(
                en: 'Great job! Keep practicing to become even stronger.',
                it: 'Ottimo! Continua a esercitarti per migliorare ancora.',
                ar: 'عمل رائع! واصل التدريب لتصبح أفضل.',
              )
            : percentage >= 50
                ? _t(
                    en: 'Good effort. Review your mistakes and try again.',
                    it: 'Buon lavoro. Ripassa gli errori e prova di nuovo.',
                    ar: 'جهد جيد. راجع أخطاءك وحاول مرة أخرى.',
                  )
                : _t(
                    en: 'Keep learning. Your mistakes are now saved for review.',
                    it: 'Continua a imparare. I tuoi errori sono stati salvati.',
                    ar: 'استمر في التعلم. تم حفظ أخطائك للمراجعة.',
                  );

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return AlertDialog(
          backgroundColor: card,
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          contentPadding: const EdgeInsets.fromLTRB(24, 26, 24, 10),
          title: Column(
            children: [
              Container(
                width: 82,
                height: 82,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      purple,
                      blue,
                    ],
                  ),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.emoji_events_rounded,
                  color: yellow,
                  size: 42,
                ),
              ),
              const SizedBox(height: 18),
              Text(
                _t(
                  en: 'Quiz Complete!',
                  it: 'Quiz completato!',
                  ar: 'اكتمل الاختبار!',
                ),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: white,
                  fontSize: 23,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 4),
              Text(
                '$score / $total',
                style: const TextStyle(
                  color: cyan,
                  fontSize: 42,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Text(
                '$percentage%',
                style: const TextStyle(
                  color: muted,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: muted,
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 18),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 13,
                ),
                decoration: BoxDecoration(
                  color: green.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: green.withValues(alpha: 0.20),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.star_rounded,
                      color: yellow,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        '+${score * 10} XP',
                        style: const TextStyle(
                          color: green,
                          fontSize: 17,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actionsPadding: const EdgeInsets.fromLTRB(18, 8, 18, 18),
          actions: [
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _restartQuiz();
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: white,
                      side: BorderSide(
                        color: Colors.white.withValues(alpha: 0.12),
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: Text(
                      _t(
                        en: 'Retry Quiz',
                        it: 'Riprova',
                        ar: 'إعادة الاختبار',
                      ),
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: purple,
                      foregroundColor: white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(
                        vertical: 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: Text(
                      _t(
                        en: 'Done',
                        it: 'Fine',
                        ar: 'تم',
                      ),
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  void _restartQuiz() {
    setState(() {
      currentQuestion = 0;
      score = 0;
      selectedAnswer = null;
      answered = false;
      savingResult = false;
    });
  }

  @override
  void dispose() {
    LanguageController.language.removeListener(_languageChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!PremiumGuard.isPremium) {
      return _premiumPage();
    }

    final questions = _questions;

    if (questions.isEmpty) {
      return _emptyQuizPage();
    }

    if (currentQuestion >= questions.length) {
      currentQuestion = 0;
    }

    final question = questions[currentQuestion];

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        foregroundColor: white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          _t(
            en: 'Quiz',
            it: 'Quiz',
            ar: 'اختبار',
          ),
          style: const TextStyle(
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(18, 8, 18, 20),
                child: Column(
                  children: [
                    _progressHeader(questions.length),
                    const SizedBox(height: 18),
                    _questionCard(question),
                    if (answered) ...[
                      const SizedBox(height: 14),
                      _feedbackCard(question),
                    ],
                  ],
                ),
              ),
            ),
            _bottomAction(questions.length),
          ],
        ),
      ),
    );
  }

  Widget _progressHeader(int total) {
    final progress = (currentQuestion + 1) / total;
    final percentage = (progress * 100).round();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            purple,
            blue,
          ],
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Row(
            textDirection:
                _isArabic ? TextDirection.rtl : TextDirection.ltr,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: white.withValues(alpha: 0.13),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.quiz_rounded,
                  color: white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: _isArabic
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.lessonTitle ??
                          _t(
                            en: 'Language Quiz',
                            it: 'Quiz di lingua',
                            ar: 'اختبار اللغة',
                          ),
                      textAlign:
                          _isArabic ? TextAlign.right : TextAlign.left,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: white,
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '$percentage% ${_t(en: 'complete', it: 'completato', ar: 'مكتمل')}',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 17),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 9,
              backgroundColor: white.withValues(alpha: 0.18),
              valueColor:
                  const AlwaysStoppedAnimation<Color>(white),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            textDirection:
                _isArabic ? TextDirection.rtl : TextDirection.ltr,
            children: [
              Text(
                _t(
                  en: 'Question ${currentQuestion + 1}',
                  it: 'Domanda ${currentQuestion + 1}',
                  ar: 'السؤال ${currentQuestion + 1}',
                ),
                style: const TextStyle(
                  color: white,
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                '$total',
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _questionCard(QuizQuestion question) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: white.withValues(alpha: 0.06),
        ),
      ),
      child: Column(
        crossAxisAlignment:
            _isArabic ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Row(
            textDirection:
                _isArabic ? TextDirection.rtl : TextDirection.ltr,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: cyan.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  question.category,
                  style: const TextStyle(
                    color: cyan,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                '${question.points} XP',
                style: const TextStyle(
                  color: yellow,
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Text(
            question.question,
            textDirection:
                _isArabic ? TextDirection.rtl : TextDirection.ltr,
            textAlign:
                _isArabic ? TextAlign.right : TextAlign.left,
            style: const TextStyle(
              color: white,
              fontSize: 21,
              height: 1.4,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 22),
          ...List.generate(
            question.answers.length,
            (index) => _answerTile(
              index,
              question.answers[index],
              question.correctAnswer,
            ),
          ),
        ],
      ),
    );
  }

  Widget _answerTile(
    int index,
    String answer,
    int correct,
  ) {
    final isSelected = selectedAnswer == index;
    final isCorrect = index == correct;

    Color background = white.withValues(alpha: 0.035);
    Color border = white.withValues(alpha: 0.07);
    Color letterBackground = white.withValues(alpha: 0.08);
    IconData? icon;
    Color? iconColor;

    if (answered) {
      if (isCorrect) {
        background = green.withValues(alpha: 0.14);
        border = green.withValues(alpha: 0.65);
        letterBackground = green.withValues(alpha: 0.20);
        icon = Icons.check_circle_rounded;
        iconColor = green;
      } else if (isSelected) {
        background = red.withValues(alpha: 0.14);
        border = red.withValues(alpha: 0.65);
        letterBackground = red.withValues(alpha: 0.20);
        icon = Icons.cancel_rounded;
        iconColor = red;
      } else {
        background = white.withValues(alpha: 0.018);
        border = white.withValues(alpha: 0.04);
      }
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: answered ? null : () => _selectAnswer(index),
        borderRadius: BorderRadius.circular(17),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 15,
          ),
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(17),
            border: Border.all(
              color: border,
              width: answered && (isCorrect || isSelected) ? 1.4 : 1,
            ),
          ),
          child: Row(
            textDirection:
                _isArabic ? TextDirection.rtl : TextDirection.ltr,
            children: [
              Container(
                width: 34,
                height: 34,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: letterBackground,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  String.fromCharCode(65 + index),
                  style: const TextStyle(
                    color: white,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  answer,
                  textDirection:
                      _isArabic ? TextDirection.rtl : TextDirection.ltr,
                  textAlign:
                      _isArabic ? TextAlign.right : TextAlign.left,
                  style: TextStyle(
                    color: answered && !isCorrect && !isSelected
                        ? muted
                        : white,
                    fontSize: 15,
                    height: 1.35,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              if (icon != null) ...[
                const SizedBox(width: 8),
                Icon(
                  icon,
                  color: iconColor,
                  size: 22,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _feedbackCard(QuizQuestion question) {
    final correct = selectedAnswer == question.correctAnswer;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      width: double.infinity,
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: correct
            ? green.withValues(alpha: 0.10)
            : red.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: correct
              ? green.withValues(alpha: 0.25)
              : red.withValues(alpha: 0.25),
        ),
      ),
      child: Row(
        textDirection:
            _isArabic ? TextDirection.rtl : TextDirection.ltr,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            correct
                ? Icons.check_circle_rounded
                : Icons.info_rounded,
            color: correct ? green : red,
            size: 25,
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: _isArabic
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Text(
                  correct
                      ? _t(
                          en: 'Correct!',
                          it: 'Corretto!',
                          ar: 'إجابة صحيحة!',
                        )
                      : _t(
                          en: 'Not quite',
                          it: 'Non proprio',
                          ar: 'ليست الإجابة الصحيحة',
                        ),
                  textAlign:
                      _isArabic ? TextAlign.right : TextAlign.left,
                  style: TextStyle(
                    color: correct ? green : red,
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 5),
                if (!correct)
                  Text(
                    '${_t(en: 'Correct answer:', it: 'Risposta corretta:', ar: 'الإجابة الصحيحة:')} ${question.answers[question.correctAnswer]}',
                    textAlign:
                        _isArabic ? TextAlign.right : TextAlign.left,
                    style: const TextStyle(
                      color: white,
                      fontSize: 13,
                      height: 1.4,
                      fontWeight: FontWeight.w700,
                    ),
                  )
                else
                  Text(
                    _t(
                      en: 'Excellent! Keep going.',
                      it: 'Ottimo! Continua così.',
                      ar: 'ممتاز! واصل التقدم.',
                    ),
                    textAlign:
                        _isArabic ? TextAlign.right : TextAlign.left,
                    style: const TextStyle(
                      color: white,
                      fontSize: 13,
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

  Widget _bottomAction(int total) {
    final last = currentQuestion == total - 1;

    return Container(
      padding: const EdgeInsets.fromLTRB(18, 12, 18, 18),
      decoration: BoxDecoration(
        color: bg,
        border: Border(
          top: BorderSide(
            color: white.withValues(alpha: 0.06),
          ),
        ),
      ),
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton.icon(
          onPressed:
              answered && !savingResult ? _nextQuestion : null,
          icon: Icon(
            last
                ? Icons.emoji_events_rounded
                : Icons.arrow_forward_rounded,
          ),
          label: Text(
            _t(
              en: last ? 'Finish Quiz' : 'Next Question',
              it: last ? 'Termina quiz' : 'Domanda successiva',
              ar: last ? 'إنهاء الاختبار' : 'السؤال التالي',
            ),
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w900,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: purple,
            foregroundColor: white,
            disabledBackgroundColor: white.withValues(alpha: 0.06),
            disabledForegroundColor: white.withValues(alpha: 0.25),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(17),
            ),
          ),
        ),
      ),
    );
  }

  Widget _premiumPage() {
    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        foregroundColor: white,
        elevation: 0,
        title: Text(
          _t(
            en: 'Premium Quiz',
            it: 'Quiz Premium',
            ar: 'اختبار بريميوم',
          ),
          style: const TextStyle(
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(26),
            decoration: BoxDecoration(
              color: card,
              borderRadius: BorderRadius.circular(28),
              border: Border.all(
                color: purple.withValues(alpha: 0.28),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 76,
                  height: 76,
                  decoration: BoxDecoration(
                    color: purple.withValues(alpha: 0.14),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.workspace_premium_rounded,
                    color: yellow,
                    size: 40,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  _t(
                    en: 'Unlock Premium Quiz',
                    it: 'Sblocca Quiz Premium',
                    ar: 'افتح اختبار بريميوم',
                  ),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: white,
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  _t(
                    en: 'Unlock unlimited quizzes and test your language skills without limits.',
                    it: 'Sblocca quiz illimitati e metti alla prova le tue abilità linguistiche senza limiti.',
                    ar: 'افتح اختبارات غير محدودة واختبر مهاراتك اللغوية بدون حدود.',
                  ),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: muted,
                    fontSize: 13,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const PremiumPage(),
                        ),
                      );

                      if (!mounted) return;

                      setState(() {});
                    },
                    icon: const Icon(
                      Icons.workspace_premium_rounded,
                    ),
                    label: Text(
                      _t(
                        en: 'Open Premium',
                        it: 'Apri Premium',
                        ar: 'فتح بريميوم',
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: purple,
                      foregroundColor: white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(17),
                      ),
                      textStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _emptyQuizPage() {
    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        foregroundColor: white,
        elevation: 0,
        title: Text(
          widget.lessonTitle ??
              _t(
                en: 'Quiz',
                it: 'Quiz',
                ar: 'اختبار',
              ),
          style: const TextStyle(
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(26),
            decoration: BoxDecoration(
              color: card,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.quiz_outlined,
                  color: muted,
                  size: 54,
                ),
                const SizedBox(height: 18),
                Text(
                  _t(
                    en: 'No quiz available',
                    it: 'Nessun quiz disponibile',
                    ar: 'لا يوجد اختبار متاح',
                  ),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: white,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _t(
                    en: 'There are no questions available for this language yet.',
                    it: 'Non ci sono ancora domande disponibili per questa lingua.',
                    ar: 'لا توجد أسئلة متاحة لهذه اللغة حتى الآن.',
                  ),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: muted,
                    fontSize: 13,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}





