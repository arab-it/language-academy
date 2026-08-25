import 'package:flutter/material.dart';

import '../core/ai_mistakes/mistake_service.dart';

class MistakePracticePage extends StatefulWidget {
  const MistakePracticePage({super.key});

  @override
  State<MistakePracticePage> createState() => _MistakePracticePageState();
}

class _MistakePracticePageState extends State<MistakePracticePage> {
  int currentIndex = 0;
  bool showAnswer = false;

  List<StudentMistake> get mistakes => MistakeService.activeMistakes;

  @override
  Widget build(BuildContext context) {
    final items = mistakes;

    if (items.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Practice Mistakes',
            style: TextStyle(fontWeight: FontWeight.w800),
          ),
        ),
        body: const Center(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Text(
              'Great job! You have no mistakes to review.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      );
    }

    if (currentIndex >= items.length) {
      currentIndex = 0;
    }

    final mistake = items[currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Practice Mistakes',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${currentIndex + 1} / ${items.length}',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                ),
              ),

              const SizedBox(height: 14),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  color: Theme.of(context).colorScheme.surface,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      mistake.category,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w800,
                      ),
                    ),

                    const SizedBox(height: 14),

                    Text(
                      mistake.question,
                      style: const TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.w900,
                      ),
                    ),

                    const SizedBox(height: 24),

                    if (!showAnswer)
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              showAnswer = true;
                            });
                          },
                          child: const Text(
                            'Show Correct Answer',
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),

                    if (showAnswer) ...[
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          color: Colors.green.withValues(alpha: 0.12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Correct answer',
                              style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 7),
                            Text(
                              mistake.correctAnswer,
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 12),

                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          color: Colors.red.withValues(alpha: 0.10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Your previous answer',
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 7),
                            Text(
                              mistake.wrongAnswer,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(height: 18),

              if (showAnswer)
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      await MistakeService.markImproved(mistake.id);

                      if (!mounted) return;

                      setState(() {
                        showAnswer = false;

                        if (currentIndex >= mistakes.length - 1) {
                          currentIndex = 0;
                        } else {
                          currentIndex++;
                        }
                      });
                    },
                    icon: const Icon(Icons.check_circle_outline_rounded),
                    label: const Text(
                      'I Understand — Next',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
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
}

