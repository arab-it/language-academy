import 'package:flutter/material.dart';
import 'package:arab_it/core/theme/app_colors.dart';
import 'package:flutter_tts/flutter_tts.dart';

import '../data/exercise_data.dart';
import '../models/exercise_question.dart';
import '../services/language_controller.dart';

class ExercisesPage extends StatefulWidget {
  final String? language;

  const ExercisesPage({
    super.key,
    this.language,
  });

  @override
  State<ExercisesPage> createState() => _ExercisesPageState();
}

class _ExercisesPageState extends State<ExercisesPage> {
  final FlutterTts _tts = FlutterTts();
  static const Color bg = AppColors.background;
  static const Color card = AppColors.surface;
  static const Color purple = AppColors.primary;
  static const Color cyan = AppColors.cyan;
  static const Color green = AppColors.primaryLight;
  static const Color red = AppColors.error;
  static const Color orange = AppColors.warning;
  static const Color white = AppColors.textPrimary;
  static const Color muted = AppColors.textSecondary;

  int current = 0;
  int score = 0;

  String selectedLevel = 'Beginner';
  String? selectedAnswer;
  bool answered = false;
  bool testStarted = false;

  List<ExerciseQuestion> get questions {
    final language =
        widget.language ?? LanguageController.current;

    return ExerciseData.forLanguageAndLevel(
      language,
      selectedLevel,
    );
  }

  bool get isArabic {
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
    final language = LanguageController.current;

    if (language == 'Italiano') {
      return it;
    }

    if (isArabic) {
      return ar;
    }

    return en;
  }

  @override
  void initState() {
    super.initState();

    _tts.awaitSpeakCompletion(true);

    LanguageController.language.addListener(_languageChanged);
  }

  void _languageChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _tts.stop();
    LanguageController.language.removeListener(_languageChanged);
    super.dispose();
  }

  Future<void> _speak(String text, String language) async {
    if (text.trim().isEmpty) {
      return;
    }

    String locale;

    switch (language.toLowerCase()) {
      case 'italian':
      case 'italiano':
        locale = 'it-IT';
        break;

      case 'arabic':
      case 'العربية':
        locale = 'ar-SA';
        break;

      default:
        locale = 'en-US';
    }

    await _tts.stop();
    await _tts.setLanguage(locale);
    await _tts.setSpeechRate(0.45);
    await _tts.setVolume(1.0);
    await _tts.setPitch(1.0);
    await _tts.speak(text);
  }

  void _startTest() {
    if (questions.isEmpty) {
      return;
    }

    setState(() {
      current = 0;
      score = 0;
      selectedAnswer = null;
      answered = false;
      testStarted = true;
    });
  }

  void _selectAnswer(String answer) {
    if (answered) {
      return;
    }

    final question = questions[current];
    final correct = answer.trim().toLowerCase() ==
        question.correctAnswer.trim().toLowerCase();

    setState(() {
      selectedAnswer = answer;
      answered = true;

      if (correct) {
        score += question.points;
      }
    });
  }

  void _next() {
    if (!answered) {
      return;
    }

    if (current < questions.length - 1) {
      setState(() {
        current++;
        selectedAnswer = null;
        answered = false;
      });
    } else {
      _showResult();
    }
  }

  void _restart() {
    setState(() {
      current = 0;
      score = 0;
      selectedAnswer = null;
      answered = false;
      testStarted = false;
    });
  }

  void _showResult() {
    final total = questions.fold<int>(
      0,
      (sum, question) => sum + question.points,
    );

    final percentage =
        total == 0 ? 0 : ((score / total) * 100).round();

    String message;

    if (percentage >= 90) {
      message = _t(
        en: 'Excellent work!',
        it: 'Ottimo lavoro!',
        ar: 'عمل ممتاز!',
      );
    } else if (percentage >= 70) {
      message = _t(
        en: 'Very good!',
        it: 'Molto bene!',
        ar: 'جيد جدًا!',
      );
    } else if (percentage >= 50) {
      message = _t(
        en: 'Good effort. Keep practicing!',
        it: 'Buon tentativo. Continua a esercitarti!',
        ar: 'محاولة جيدة. استمر في التدريب!',
      );
    } else {
      message = _t(
        en: 'Keep practicing and try again!',
        it: 'Continua a esercitarti e riprova!',
        ar: 'استمر في التدريب وحاول مرة أخرى!',
      );
    }

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        backgroundColor: card,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        title: Column(
          children: [
            const Icon(
              Icons.emoji_events_rounded,
              color: orange,
              size: 58,
            ),
            const SizedBox(height: 12),
            Text(
              _t(
                en: 'Test Complete!',
                it: 'Test completato!',
                ar: 'اكتمل الاختبار!',
              ),
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: white,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '$score / $total',
              style: const TextStyle(
                color: cyan,
                fontSize: 38,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              '$percentage%',
              style: const TextStyle(
                color: muted,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: white,
                fontSize: 15,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              _t(
                en: 'This result is separate from XP and progress.',
                it: 'Questo risultato è separato da XP e progressi.',
                ar: 'هذه النتيجة منفصلة عن نقاط XP والتقدم.',
              ),
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: muted,
                fontSize: 12,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _restart();
            },
            child: Text(
              _t(
                en: 'Try Again',
                it: 'Riprova',
                ar: 'حاول مرة أخرى',
              ),
              style: const TextStyle(
                color: purple,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              _t(
                en: 'Done',
                it: 'Fine',
                ar: 'تم',
              ),
              style: const TextStyle(
                color: cyan,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!testStarted) {
      return _buildLevelSelection();
    }

    if (questions.isEmpty) {
      return _buildEmpty();
    }

    final question = questions[current];

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        foregroundColor: white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          _t(
            en: 'Exercises',
            it: 'Esercizi',
            ar: 'تمارين',
          ),
          style: const TextStyle(
            fontWeight: FontWeight.w900,
          ),
        ),
        actions: [
          IconButton(
            onPressed: _restart,
            icon: const Icon(Icons.close_rounded),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(18, 10, 18, 30),
          child: Column(
            children: [
              _header(),
              const SizedBox(height: 18),
              _questionCard(question),
              const SizedBox(height: 18),
              _nextButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmpty() {
    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        foregroundColor: white,
        title: Text(
          _t(
            en: 'Exercises',
            it: 'Esercizi',
            ar: 'تمارين',
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Text(
            _t(
              en: 'No exercises are available for this level yet.',
              it: 'Non ci sono ancora esercizi per questo livello.',
              ar: 'لا توجد تمارين لهذا المستوى حتى الآن.',
            ),
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: white,
              fontSize: 17,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLevelSelection() {
    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        foregroundColor: white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          _t(
            en: 'Exercises',
            it: 'Esercizi',
            ar: 'تمارين',
          ),
          style: const TextStyle(
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(18, 18, 18, 30),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      purple,
                      AppColors.english,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(26),
                ),
                child: Column(
                  children: [
                    const Icon(
                      Icons.assignment_rounded,
                      color: white,
                      size: 52,
                    ),
                    const SizedBox(height: 14),
                    Text(
                      _t(
                        en: 'Choose your level',
                        it: 'Scegli il tuo livello',
                        ar: 'اختر مستواك',
                      ),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: white,
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _t(
                        en: 'Choose the difficulty that matches your knowledge.',
                        it: 'Scegli la difficoltà adatta al tuo livello.',
                        ar: 'اختر مستوى الصعوبة المناسب لمعرفتك.',
                      ),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),

              _levelCard(
                level: 'Beginner',
                icon: Icons.school_rounded,
                color: green,
                title: _t(
                  en: 'Beginner',
                  it: 'Principiante',
                  ar: 'مبتدئ',
                ),
                description: _t(
                  en: 'Basic vocabulary and simple grammar.',
                  it: 'Vocabolario base e grammatica semplice.',
                  ar: 'مفردات أساسية وقواعد بسيطة.',
                ),
              ),

              const SizedBox(height: 14),

              _levelCard(
                level: 'Intermediate',
                icon: Icons.trending_up_rounded,
                color: orange,
                title: _t(
                  en: 'Intermediate',
                  it: 'Intermedio',
                  ar: 'متوسط',
                ),
                description: _t(
                  en: 'More difficult grammar and translation.',
                  it: 'Grammatica e traduzione più difficili.',
                  ar: 'قواعد وترجمة أكثر صعوبة.',
                ),
              ),

              const SizedBox(height: 14),

              _levelCard(
                level: 'Advanced',
                icon: Icons.workspace_premium_rounded,
                color: red,
                title: _t(
                  en: 'Advanced',
                  it: 'Avanzato',
                  ar: 'متقدم',
                ),
                description: _t(
                  en: 'Challenging grammar, reading and vocabulary.',
                  it: 'Grammatica, lettura e vocabolario avanzati.',
                  ar: 'قواعد وقراءة ومفردات متقدمة.',
                ),
              ),

              const SizedBox(height: 22),

              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: _startTest,
                  icon: const Icon(
                    Icons.play_arrow_rounded,
                  ),
                  label: Text(
                    _t(
                      en: 'Start Test',
                      it: 'Inizia test',
                      ar: 'ابدأ الاختبار',
                    ),
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: purple,
                    foregroundColor: white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(17),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _levelCard({
    required String level,
    required IconData icon,
    required Color color,
    required String title,
    required String description,
  }) {
    final selected = selectedLevel == level;

    return InkWell(
      onTap: () {
        setState(() {
          selectedLevel = level;
        });
      },
      borderRadius: BorderRadius.circular(22),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: selected
              ? color.withValues(alpha: 0.13)
              : card,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: selected
                ? color
                : AppColors.textPrimary.withValues(alpha: 0.07),
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                icon,
                color: color,
                size: 27,
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: white,
                      fontSize: 17,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    description,
                    style: const TextStyle(
                      color: muted,
                      fontSize: 12,
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              selected
                  ? Icons.check_circle_rounded
                  : Icons.arrow_forward_ios_rounded,
              color: selected ? color : muted,
              size: selected ? 25 : 17,
            ),
          ],
        ),
      ),
    );
  }

  Widget _header() {
    final progress = (current + 1) / questions.length;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            purple,
            AppColors.english,
          ],
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Row(
            textDirection:
                isArabic ? TextDirection.rtl : TextDirection.ltr,
            children: [
              const Icon(
                Icons.assignment_rounded,
                color: white,
                size: 30,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  '$selectedLevel Test',
                  textAlign:
                      isArabic ? TextAlign.right : TextAlign.left,
                  style: const TextStyle(
                    color: white,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: AppColors.textPrimary24,
              valueColor:
                  const AlwaysStoppedAnimation<Color>(white),
            ),
          ),
          const SizedBox(height: 10),
          Align(
            alignment:
                isArabic
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
            child: Text(
              '${current + 1} / ${questions.length}',
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _questionCard(ExerciseQuestion question) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppColors.textPrimary.withValues(alpha: 0.06),
        ),
      ),
      child: Column(
        crossAxisAlignment:
            isArabic
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
        children: [
          Text(
            _typeName(question.type),
            textDirection:
                isArabic ? TextDirection.rtl : TextDirection.ltr,
            style: const TextStyle(
              color: cyan,
              fontSize: 13,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            textDirection:
                isArabic ? TextDirection.rtl : TextDirection.ltr,
            children: [
              Expanded(
                child: Text(
                  question.question,
                  textDirection:
                      isArabic ? TextDirection.rtl : TextDirection.ltr,
                  textAlign:
                      isArabic ? TextAlign.right : TextAlign.left,
                  style: const TextStyle(
                    color: white,
                    fontSize: 20,
                    height: 1.35,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Material(
                color: cyan.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(14),
                child: InkWell(
                  onTap: () => _speak(
                    question.question,
                    question.language,
                  ),
                  borderRadius: BorderRadius.circular(14),
                  child: const Padding(
                    padding: EdgeInsets.all(11),
                    child: Icon(
                      Icons.volume_up_rounded,
                      color: cyan,
                      size: 24,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),
          if (question.type == ExerciseType.fillBlank)
            _fillBlankOptions(question)
          else
            ...question.options.map(
              (option) => _answerTile(
                option,
                question.correctAnswer,
              ),
            ),

          if (answered) ...[
            const SizedBox(height: 14),
            _answerFeedback(question),
          ],
        ],
      ),
    );
  }

  String _typeName(ExerciseType type) {
    switch (type) {
      case ExerciseType.multipleChoice:
        return _t(
          en: 'MULTIPLE CHOICE',
          it: 'SCELTA MULTIPLA',
          ar: 'اختيار من متعدد',
        );
      case ExerciseType.fillBlank:
        return _t(
          en: 'FILL IN THE BLANK',
          it: 'COMPLETA LA FRASE',
          ar: 'أكمل الفراغ',
        );
      case ExerciseType.translate:
        return _t(
          en: 'TRANSLATE',
          it: 'TRADUCI',
          ar: 'ترجمة',
        );
      case ExerciseType.matchWords:
        return _t(
          en: 'MATCH WORDS',
          it: 'ABBINA LE PAROLE',
          ar: 'طابق الكلمات',
        );
      case ExerciseType.wordOrder:
        return _t(
          en: 'WORD ORDER',
          it: 'ORDINA LE PAROLE',
          ar: 'رتب الكلمات',
        );
      case ExerciseType.reading:
        return _t(
          en: 'READING',
          it: 'LETTURA',
          ar: 'قراءة',
        );
    }
  }

  Widget _fillBlankOptions(ExerciseQuestion question) {
    return Column(
      children: [
        TextField(
          enabled: !answered,
          onChanged: (value) {
            selectedAnswer = value.trim();
          },
          textDirection:
              isArabic ? TextDirection.rtl : TextDirection.ltr,
          style: const TextStyle(
            color: white,
            fontWeight: FontWeight.w700,
          ),
          decoration: InputDecoration(
            hintText: _t(
              en: 'Type your answer...',
              it: 'Scrivi la risposta...',
              ar: 'اكتب إجابتك...',
            ),
            hintStyle: const TextStyle(color: muted),
            filled: true,
            fillColor: AppColors.textPrimary.withValues(alpha: 0.04),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: answered
                ? null
                : () {
                    final answer =
                        selectedAnswer?.trim() ?? '';

                    if (answer.isEmpty) {
                      return;
                    }

                    _selectAnswer(answer);
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: purple,
              foregroundColor: white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            child: Text(
              _t(
                en: 'Check Answer',
                it: 'Controlla risposta',
                ar: 'تحقق من الإجابة',
              ),
              style: const TextStyle(
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _answerTile(
    String answer,
    String correct,
  ) {
    final isSelected = selectedAnswer == answer;
    final isCorrect = answer == correct;

    Color background =
        AppColors.textPrimary.withValues(alpha: 0.035);

    Color border =
        AppColors.textPrimary.withValues(alpha: 0.07);

    IconData? icon;

    if (answered) {
      if (isCorrect) {
        background = green.withValues(alpha: 0.15);
        border = green;
        icon = Icons.check_circle_rounded;
      } else if (isSelected) {
        background = red.withValues(alpha: 0.15);
        border = red;
        icon = Icons.cancel_rounded;
      }
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: () => _selectAnswer(answer),
        borderRadius: BorderRadius.circular(17),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(17),
            border: Border.all(color: border),
          ),
          child: Row(
            textDirection:
                isArabic ? TextDirection.rtl : TextDirection.ltr,
            children: [
              Expanded(
                child: Text(
                  answer,
                  textDirection:
                      isArabic
                          ? TextDirection.rtl
                          : TextDirection.ltr,
                  textAlign:
                      isArabic
                          ? TextAlign.right
                          : TextAlign.left,
                  style: const TextStyle(
                    color: white,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              if (icon != null)
                Icon(
                  icon,
                  color: isCorrect ? green : red,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _answerFeedback(ExerciseQuestion question) {
    final correct = selectedAnswer == question.correctAnswer;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: (correct ? green : red).withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: (correct ? green : red).withValues(alpha: 0.35),
        ),
      ),
      child: Column(
        crossAxisAlignment:
            isArabic
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
        children: [
          Row(
            textDirection:
                isArabic ? TextDirection.rtl : TextDirection.ltr,
            children: [
              Icon(
                correct
                    ? Icons.check_circle_rounded
                    : Icons.info_rounded,
                color: correct ? green : red,
                size: 22,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  correct
                      ? _t(
                          en: 'Correct!',
                          it: 'Corretto!',
                          ar: 'إجابة صحيحة!',
                        )
                      : _t(
                          en: 'Not quite',
                          it: 'Non è corretto',
                          ar: 'إجابة غير صحيحة',
                        ),
                  textAlign:
                      isArabic
                          ? TextAlign.right
                          : TextAlign.left,
                  style: TextStyle(
                    color: correct ? green : red,
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
          if (!correct) ...[
            const SizedBox(height: 10),
            Text(
              _t(
                en: 'Correct answer: ${question.correctAnswer}',
                it: 'Risposta corretta: ${question.correctAnswer}',
                ar: 'الإجابة الصحيحة: ${question.correctAnswer}',
              ),
              textDirection:
                  isArabic
                      ? TextDirection.rtl
                      : TextDirection.ltr,
              textAlign:
                  isArabic
                      ? TextAlign.right
                      : TextAlign.left,
              style: const TextStyle(
                color: white,
                fontSize: 14,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
          if (question.explanation != null &&
              question.explanation!.trim().isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              question.explanation!,
              textDirection:
                  isArabic
                      ? TextDirection.rtl
                      : TextDirection.ltr,
              textAlign:
                  isArabic
                      ? TextAlign.right
                      : TextAlign.left,
              style: const TextStyle(
                color: muted,
                fontSize: 13,
                height: 1.4,
              ),
            ),
          ],
        ],
      ),
    );
  }
  Widget _nextButton() {
    final last = current == questions.length - 1;

    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton.icon(
        onPressed: answered ? _next : null,
        icon: Icon(
          last
              ? Icons.assignment_turned_in_rounded
              : Icons.arrow_forward_rounded,
        ),
        label: Text(
          _t(
            en: last ? 'Finish Test' : 'Next Task',
            it: last ? 'Termina test' : 'Prossimo esercizio',
            ar: last ? 'إنهاء الاختبار' : 'المهمة التالية',
          ),
          style: const TextStyle(
            fontWeight: FontWeight.w900,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: purple,
          foregroundColor: white,
          disabledBackgroundColor:
              AppColors.textPrimary.withValues(alpha: 0.06),
          disabledForegroundColor: AppColors.textPrimary24,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(17),
          ),
        ),
      ),
    );
  }
}










