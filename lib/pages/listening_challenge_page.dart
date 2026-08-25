import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

import '../core/listening/listening_content.dart';
import '../core/listening/listening_question.dart';

class ListeningChallengePage extends StatefulWidget {
  final String lessonId;

  const ListeningChallengePage({
    super.key,
    required this.lessonId,
  });

  @override
  State<ListeningChallengePage> createState() =>
      _ListeningChallengePageState();
}

class _ListeningChallengePageState
    extends State<ListeningChallengePage> {
  final FlutterTts _tts = FlutterTts();

  late List<ListeningQuestion> questions;

  int currentIndex = 0;
  int? selectedIndex;
  int score = 0;

  bool answered = false;
  bool isSpeaking = false;
  bool slowMode = false;

  ListeningQuestion get currentQuestion =>
      questions[currentIndex];

  String get _ttsLanguage {
    final id = widget.lessonId.toLowerCase();

    if (id.startsWith('it_')) {
      return 'it-IT';
    }

    if (id.startsWith('ar_')) {
      return 'ar-SA';
    }

    return 'en-US';
  }

  @override
  void initState() {
    super.initState();

    questions = listeningContents[widget.lessonId] ?? const [];

    _configureTts();
  }

  Future<void> _configureTts() async {
    await _tts.setVolume(1.0);
    await _tts.setPitch(1.0);

    _tts.setStartHandler(() {
      if (mounted) {
        setState(() {
          isSpeaking = true;
        });
      }
    });

    _tts.setCompletionHandler(() {
      if (mounted) {
        setState(() {
          isSpeaking = false;
        });
      }
    });

    _tts.setCancelHandler(() {
      if (mounted) {
        setState(() {
          isSpeaking = false;
        });
      }
    });

    _tts.setErrorHandler((message) {
      if (mounted) {
        setState(() {
          isSpeaking = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Audio error: $message'),
          ),
        );
      }
    });
  }

  Future<void> _speakCurrentQuestion() async {
    if (questions.isEmpty) return;

    await _tts.stop();

    if (mounted) {
      setState(() {
        isSpeaking = true;
      });
    }

    await _tts.setLanguage(_ttsLanguage);
    await _tts.setSpeechRate(slowMode ? 0.32 : 0.48);
    await _tts.setVolume(1.0);
    await _tts.setPitch(1.0);

    await _tts.speak(currentQuestion.audioText);
  }

  Future<void> _stopSpeaking() async {
    await _tts.stop();

    if (mounted) {
      setState(() {
        isSpeaking = false;
      });
    }
  }

  Future<void> _toggleSlowMode() async {
    setState(() {
      slowMode = !slowMode;
    });

    if (isSpeaking) {
      await _speakCurrentQuestion();
    }
  }

  void selectAnswer(int index) {
    if (answered) return;

    setState(() {
      selectedIndex = index;
      answered = true;

      if (index == currentQuestion.correctIndex) {
        score++;
      }
    });
  }

  Future<void> nextQuestion() async {
    await _stopSpeaking();

    if (currentIndex < questions.length - 1) {
      setState(() {
        currentIndex++;
        selectedIndex = null;
        answered = false;
      });
    } else {
      showResult();
    }
  }

  void showResult() {
    final xp = score * 20;
    final percentage =
        questions.isEmpty ? 0 : score * 100 ~/ questions.length;

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text('🎧 Listening Complete'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '$score / ${questions.length}',
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text('$percentage% Accuracy'),
              const SizedBox(height: 8),
              Text(
                '+$xp XP ⭐',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text('DONE'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _tts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Listening Challenge'),
        ),
        body: const Center(
          child: Text(
            'No listening questions found for this lesson.',
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('🎧 Listening Challenge'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Question ${currentIndex + 1} / ${questions.length}',
                style: Theme.of(context).textTheme.titleMedium,
              ),

              const SizedBox(height: 20),

              LinearProgressIndicator(
                value: (currentIndex + 1) / questions.length,
              ),

              const SizedBox(height: 32),

              Card(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Icon(
                        isSpeaking
                            ? Icons.volume_up_rounded
                            : Icons.headphones_rounded,
                        size: 64,
                      ),

                      const SizedBox(height: 20),

                      FilledButton.icon(
                        onPressed: isSpeaking
                            ? _stopSpeaking
                            : _speakCurrentQuestion,
                        icon: Icon(
                          isSpeaking
                              ? Icons.stop
                              : Icons.play_arrow,
                        ),
                        label: Text(
                          isSpeaking
                              ? 'STOP'
                              : 'PLAY AUDIO',
                        ),
                      ),

                      const SizedBox(height: 8),

                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment.center,
                        children: [
                          TextButton.icon(
                            onPressed: _speakCurrentQuestion,
                            icon: const Icon(Icons.replay),
                            label: const Text('Replay'),
                          ),
                          const SizedBox(width: 8),
                          TextButton.icon(
                            onPressed: _toggleSlowMode,
                            icon: Icon(
                              slowMode
                                  ? Icons.speed
                                  : Icons.slow_motion_video,
                            ),
                            label: Text(
                              slowMode ? 'Normal' : 'Slow',
                            ),
                          ),
                        ],
                      ),

                      if (slowMode)
                        const Text(
                          '🐢 Slow mode enabled',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              Text(
                currentQuestion.question,
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),

              const SizedBox(height: 20),

              ...List.generate(
                currentQuestion.options.length,
                (index) {
                  final isSelected = selectedIndex == index;
                  final isCorrect =
                      index == currentQuestion.correctIndex;

                  return Padding(
                    padding:
                        const EdgeInsets.only(bottom: 12),
                    child: OutlinedButton(
                      onPressed: () => selectAnswer(index),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.all(18),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              currentQuestion.options[index],
                            ),
                          ),
                          if (answered && isCorrect)
                            const Icon(
                              Icons.check_circle,
                            ),
                          if (answered &&
                              isSelected &&
                              !isCorrect)
                            const Icon(
                              Icons.cancel,
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),

              const Spacer(),

              if (answered)
                FilledButton(
                  onPressed: nextQuestion,
                  child: Text(
                    currentIndex == questions.length - 1
                        ? 'SEE RESULT'
                        : 'NEXT',
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

