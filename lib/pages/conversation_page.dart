import 'package:flutter/material.dart';

import '../database/hive_service.dart';

class ConversationPage extends StatefulWidget {
  const ConversationPage({super.key});

  @override
  State<ConversationPage> createState() => _ConversationPageState();
}

class _ConversationPageState extends State<ConversationPage> {
  String? selectedTopic;
  int questionIndex = 0;
  int xpEarned = 0;

  final TextEditingController answerController = TextEditingController();

  final List<Map<String, dynamic>> topics = [
    {
      'title': 'Hotel',
      'subtitle': 'Practice checking into a hotel',
      'icon': Icons.hotel_rounded,
      'color': const Color(0xFF008C45),
    },
    {
      'title': 'Restaurant',
      'subtitle': 'Practice ordering food',
      'icon': Icons.restaurant_rounded,
      'color': const Color(0xFFCD212A),
    },
    {
      'title': 'Airport',
      'subtitle': 'Practice airport conversations',
      'icon': Icons.flight_rounded,
      'color': Colors.blue,
    },
    {
      'title': 'Shopping',
      'subtitle': 'Practice shopping conversations',
      'icon': Icons.shopping_bag_rounded,
      'color': Colors.orange,
    },
    {
      'title': 'Job Interview',
      'subtitle': 'Practice interview questions',
      'icon': Icons.work_rounded,
      'color': Colors.purple,
    },
    {
      'title': 'Everyday Conversation',
      'subtitle': 'Practice daily conversations',
      'icon': Icons.chat_rounded,
      'color': Colors.teal,
    },
  ];

  final Map<String, List<String>> questions = {
    'Hotel': [
      'Hello! Welcome to our hotel. Do you have a reservation?',
      'How many nights would you like to stay?',
      'Would you like a single or double room?',
      'Can I see your passport, please?',
      'Here is your room key. Enjoy your stay!',
    ],
    'Restaurant': [
      'Hello! Welcome. What would you like to order?',
      'Would you like something to drink?',
      'Are you ready to order your main course?',
      'Would you like dessert?',
      'How was your meal?',
    ],
    'Airport': [
      'Good morning. Where are you travelling today?',
      'May I see your passport and boarding pass?',
      'Do you have any bags to check in?',
      'What is the purpose of your trip?',
      'Have a pleasant flight!',
    ],
    'Shopping': [
      'Hello! Can I help you find something?',
      'What size are you looking for?',
      'Would you like to try it on?',
      'How would you like to pay?',
      'Would you like a shopping bag?',
    ],
    'Job Interview': [
      'Tell me about yourself.',
      'Why do you want this job?',
      'What are your strengths?',
      'What is one weakness you are working on?',
      'Why should we hire you?',
    ],
    'Everyday Conversation': [
      'Hello! How are you today?',
      'What did you do today?',
      'What do you like doing in your free time?',
      'What are your plans for tomorrow?',
      'It was nice talking with you!',
    ],
  };

  @override
  void dispose() {
    answerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (selectedTopic != null) {
      return _buildConversation();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Conversation Practice',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'Choose a situation',
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Practice real-life conversations.',
            style: TextStyle(color: Colors.grey[400], fontSize: 15),
          ),
          const SizedBox(height: 25),
          ...topics.map(_topicCard),
        ],
      ),
    );
  }

  Widget _topicCard(Map<String, dynamic> topic) {
    final Color color = topic['color'] as Color;

    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          setState(() {
            selectedTopic = topic['title'] as String;
            questionIndex = 0;
            xpEarned = 0;
            answerController.clear();
          });
        },
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            children: [
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(17),
                ),
                child: Icon(topic['icon'] as IconData, color: color, size: 29),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      topic['title'] as String,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      topic['subtitle'] as String,
                      style: TextStyle(color: Colors.grey[400], fontSize: 13),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios_rounded, size: 17),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildConversation() {
    final list = questions[selectedTopic]!;
    final currentQuestion = list[questionIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text(selectedTopic!),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            setState(() {
              selectedTopic = null;
              questionIndex = 0;
              answerController.clear();
            });
          },
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Row(
            children: [
              Expanded(
                child: LinearProgressIndicator(
                  value: (questionIndex + 1) / list.length,
                  minHeight: 8,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '${questionIndex + 1}/${list.length}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),

          const SizedBox(height: 25),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: const Color(0xFF008C45).withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(22),
            ),
            child: Column(
              children: [
                const Icon(
                  Icons.smart_toy_rounded,
                  size: 48,
                  color: Color(0xFF008C45),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Language Tutor',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 15),
                Text(
                  currentQuestion,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 18, height: 1.4),
                ),
              ],
            ),
          ),

          const SizedBox(height: 25),

          TextField(
            controller: answerController,
            minLines: 3,
            maxLines: 5,
            decoration: InputDecoration(
              hintText: 'Type your answer in English...',
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide.none,
              ),
            ),
          ),

          const SizedBox(height: 15),

          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton.icon(
              onPressed: _submitAnswer,
              icon: const Icon(Icons.send_rounded),
              label: Text(
                questionIndex == list.length - 1
                    ? 'Finish Conversation'
                    : 'Submit & Next',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          const SizedBox(height: 18),

          Center(
            child: Text(
              '+5  for each answer',
              style: TextStyle(color: Colors.grey[500], fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _submitAnswer() async {
    if (answerController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please write an answer first.')),
      );
      return;
    }

    await HiveService.addXp(5);
    xpEarned += 5;

    if (!mounted) return;

    final list = questions[selectedTopic]!;

    if (questionIndex < list.length - 1) {
      setState(() {
        questionIndex++;
        answerController.clear();
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('+5  Ã¢â‚¬â€ Great job!')));
    } else {
      _showCompletedDialog();
    }
  }

  void _showCompletedDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.emoji_events, color: Color(0xFFCD212A)),
              SizedBox(width: 10),
              Text('Conversation Complete!'),
            ],
          ),
          content: Text(
            'Excellent work! You completed the $selectedTopic conversation and earned $xpEarned .',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  selectedTopic = null;
                  questionIndex = 0;
                  xpEarned = 0;
                  answerController.clear();
                });
              },
              child: const Text('Done'),
            ),
          ],
        );
      },
    );
  }
}

