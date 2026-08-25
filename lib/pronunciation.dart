import 'package:flutter/material.dart';
import 'package:arab_it/core/theme/app_colors.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class PronunciationPage extends StatefulWidget {
  const PronunciationPage({super.key});

  @override
  State<PronunciationPage> createState() => _PronunciationPageState();
}

class _PronunciationPageState extends State<PronunciationPage> {
  final FlutterTts flutterTts = FlutterTts();
  final stt.SpeechToText speech = stt.SpeechToText();

  bool isListening = false;
  bool speechAvailable = false;

  String recognizedText = '';
  String selectedLanguage = 'English';
  int selectedWord = 0;

  static const Color bg = Color(0xFF070A12);
  static const Color card = Color(0xFF111725);
  static const Color purple = Color(0xFF8B5CF6);
  static const Color cyan = AppColors.cyan;
  static const Color green = Color(0xFF22C55E);
  static const Color white = Colors.white;
  static const Color muted = Color(0xFF94A3B8);

  final Map<String, List<Map<String, String>>> words = {
    'English': [
      {
        'word': 'Hello',
        'meaning': 'A greeting',
        'example': 'Hello, how are you?',
      },
      {
        'word': 'Thank you',
        'meaning': 'Showing gratitude',
        'example': 'Thank you very much.',
      },
      {
        'word': 'Please',
        'meaning': 'A polite request',
        'example': 'Please help me.',
      },
      {
        'word': 'Good morning',
        'meaning': 'Morning greeting',
        'example': 'Good morning!',
      },
      {
        'word': 'Goodbye',
        'meaning': 'A farewell',
        'example': 'Goodbye, see you soon.',
      },
    ],
    'Italiano': [
      {
        'word': 'Ciao',
        'meaning': 'Hello / Goodbye',
        'example': 'Ciao, come stai?',
      },
      {'word': 'Grazie', 'meaning': 'Thank you', 'example': 'Grazie mille.'},
      {
        'word': 'Per favore',
        'meaning': 'Please',
        'example': 'Un caffÃ¨, per favore.',
      },
      {
        'word': 'Buongiorno',
        'meaning': 'Good morning',
        'example': 'Buongiorno a tutti.',
      },
      {
        'word': 'Arrivederci',
        'meaning': 'Goodbye',
        'example': 'Arrivederci e buona giornata.',
      },
    ],
    'Ø§Ù„Ø¹Ø±Ø¨ÙŠØ©': [
      {'word': 'Ù…Ø±Ø­Ø¨Ø§', 'meaning': 'Hello', 'example': 'Ù…Ø±Ø­Ø¨Ø§ØŒ ÙƒÙŠÙ Ø­Ø§Ù„ÙƒØŸ'},
      {'word': 'Ø´ÙƒØ±Ø§', 'meaning': 'Thank you', 'example': 'Ø´ÙƒØ±Ø§ Ø¬Ø²ÙŠÙ„Ø§.'},
      {'word': 'Ù…Ù† ÙØ¶Ù„Ùƒ', 'meaning': 'Please', 'example': 'Ù…Ù† ÙØ¶Ù„Ùƒ Ø³Ø§Ø¹Ø¯Ù†ÙŠ.'},
      {
        'word': 'ØµØ¨Ø§Ø­ Ø§Ù„Ø®ÙŠØ±',
        'meaning': 'Good morning',
        'example': 'ØµØ¨Ø§Ø­ Ø§Ù„Ø®ÙŠØ± Ù„Ù„Ø¬Ù…ÙŠØ¹.',
      },
      {
        'word': 'Ù…Ø±Ø­Ø¨Ø§',
        'meaning': 'Goodbye',
        'example': 'Ù…Ø¹ Ø§Ù„Ø³Ù„Ø§Ù…Ø©ØŒ Ø£Ø±Ø§Ùƒ Ù‚Ø±ÙŠØ¨Ø§.',
      },
    ],
  };

  @override
  void initState() {
    super.initState();

    flutterTts.setSpeechRate(0.45);
    flutterTts.setVolume(1.0);
    flutterTts.setPitch(1.0);
  }

  Future<void> _speak(String text) async {
    String languageCode = 'en-US';

    if (selectedLanguage == 'Italiano') {
      languageCode = 'it-IT';
    } else if (selectedLanguage == 'Ø§Ù„Ø¹Ø±Ø¨ÙŠØ©') {
      languageCode = 'ar-SA';
    }

    await flutterTts.stop();
    await flutterTts.setLanguage(languageCode);
    await flutterTts.speak(text);
  }

  Future<void> _listen() async {
    final available = await speech.initialize(
      onStatus: (status) {
        if (!mounted) return;

        setState(() {
          isListening = status == 'listening';
        });
      },
      onError: (error) {
        if (!mounted) return;

        setState(() {
          isListening = false;
        });
      },
    );

    speechAvailable = available;

    if (!available) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Speech recognition is not available.')),
      );

      return;
    }

    setState(() {
      isListening = true;
      recognizedText = '';
    });

    await speech.listen(
      listenOptions: stt.SpeechListenOptions(localeId: _localeId()),
      onResult: (result) {
        if (!mounted) return;

        setState(() {
          recognizedText = result.recognizedWords;
        });
      },
    );
  }

  Future<void> _stopListening() async {
    await speech.stop();

    if (!mounted) return;

    setState(() {
      isListening = false;
    });
  }

  String _localeId() {
    if (selectedLanguage == 'Italiano') {
      return 'it_IT';
    }

    if (selectedLanguage == 'Ø§Ù„Ø¹Ø±Ø¨ÙŠØ©') {
      return 'ar_SA';
    }

    return 'en_US';
  }

  void _changeLanguage(String language) {
    setState(() {
      selectedLanguage = language;
      selectedWord = 0;
      recognizedText = '';
    });
  }

  @override
  void dispose() {
    flutterTts.stop();
    speech.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentWords = words[selectedLanguage]!;
    final word = currentWords[selectedWord];

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        foregroundColor: white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Pronunciation',
          style: TextStyle(color: white, fontWeight: FontWeight.w900),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(18, 8, 18, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _header(),
              const SizedBox(height: 22),
              const Text(
                'Choose Language',
                style: TextStyle(
                  color: white,
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 12),
              _languageSelector(),
              const SizedBox(height: 22),
              _wordCard(word),
              const SizedBox(height: 20),
              _practiceResult(word),
              const SizedBox(height: 20),
              _wordList(currentWords),
              const SizedBox(height: 20),
              _tip(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _header() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF312E81), Color(0xFF0E7490)],
        ),
        borderRadius: BorderRadius.circular(25),
      ),
      child: const Row(
        children: [
          Icon(Icons.record_voice_over_rounded, color: white, size: 43),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Improve your pronunciation',
                  style: TextStyle(
                    color: white,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'Listen, speak and practice.',
                  style: TextStyle(color: Colors.white70, fontSize: 11),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _languageSelector() {
    const languages = ['English', 'Italiano', 'Ø§Ù„Ø¹Ø±Ø¨ÙŠØ©'];

    return SizedBox(
      height: 46,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: languages.length,
        itemBuilder: (context, index) {
          final language = languages[index];
          final selected = selectedLanguage == language;

          return GestureDetector(
            onTap: () => _changeLanguage(language),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(right: 9),
              padding: const EdgeInsets.symmetric(horizontal: 19),
              decoration: BoxDecoration(
                color: selected ? purple : card,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: selected
                      ? Colors.transparent
                      : white.withValues(alpha: 0.07),
                ),
              ),
              child: Center(
                child: Text(
                  language,
                  style: TextStyle(
                    color: selected ? white : muted,
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _wordCard(Map<String, String> word) {
    final isArabic = selectedLanguage == 'Ø§Ù„Ø¹Ø±Ø¨ÙŠØ©';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 25, 20, 22),
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(27),
        border: Border.all(color: white.withValues(alpha: 0.06)),
      ),
      child: Column(
        children: [
          Text(
            selectedLanguage,
            style: const TextStyle(
              color: muted,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 18),
          Text(
            word['word']!,
            textAlign: TextAlign.center,
            textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
            style: const TextStyle(
              color: white,
              fontSize: 36,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            word['meaning']!,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: cyan,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _roundButton(
                icon: Icons.volume_up_rounded,
                color: purple,
                onTap: () => _speak(word['word']!),
              ),
              const SizedBox(width: 18),
              _roundButton(
                icon: isListening ? Icons.stop_rounded : Icons.mic_rounded,
                color: isListening ? Colors.redAccent : cyan,
                onTap: isListening ? _stopListening : _listen,
              ),
            ],
          ),
          const SizedBox(height: 9),
          Text(
            isListening ? 'Listening...' : 'Listen or speak',
            style: const TextStyle(color: muted, fontSize: 10),
          ),
        ],
      ),
    );
  }

  Widget _roundButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: color,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          width: 68,
          height: 68,
          child: Icon(icon, color: white, size: 30),
        ),
      ),
    );
  }

  Widget _practiceResult(Map<String, String> word) {
    final target = word['word']!.trim().toLowerCase();
    final spoken = recognizedText.trim().toLowerCase();

    final hasResult = spoken.isNotEmpty;
    final matches = hasResult && spoken == target;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: hasResult
              ? (matches ? green : Colors.orange)
              : white.withValues(alpha: 0.06),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Speaking Practice',
            style: TextStyle(
              color: white,
              fontSize: 14,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            hasResult
                ? 'You said: $recognizedText'
                : 'Tap the microphone and say the word.',
            style: const TextStyle(color: muted, fontSize: 12),
          ),
          if (hasResult) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  matches ? Icons.check_circle_rounded : Icons.refresh_rounded,
                  color: matches ? green : Colors.orange,
                  size: 21,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    matches
                        ? 'Great! Your pronunciation was recognized.'
                        : 'Try again and speak more clearly.',
                    style: TextStyle(
                      color: matches ? green : Colors.orange,
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _wordList(List<Map<String, String>> currentWords) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Practice Words',
          style: TextStyle(
            color: white,
            fontSize: 18,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 12),
        ...List.generate(currentWords.length, (index) {
          final item = currentWords[index];
          final selected = index == selectedWord;

          return GestureDetector(
            onTap: () {
              setState(() {
                selectedWord = index;
                recognizedText = '';
              });
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: selected ? purple.withValues(alpha: 0.12) : card,
                borderRadius: BorderRadius.circular(17),
                border: Border.all(
                  color: selected ? purple : white.withValues(alpha: 0.05),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: white.withValues(alpha: 0.05),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '${index + 1}',
                        style: const TextStyle(
                          color: muted,
                          fontWeight: FontWeight.w800,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 13),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['word']!,
                          style: const TextStyle(
                            color: white,
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          item['meaning']!,
                          style: const TextStyle(color: muted, fontSize: 10),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => _speak(item['word']!),
                    icon: const Icon(Icons.volume_up_rounded, color: cyan),
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _tip() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Row(
        children: [
          Icon(
            Icons.lightbulb_outline_rounded,
            color: Color(0xFFFFC107),
            size: 27,
          ),
          SizedBox(width: 13),
          Expanded(
            child: Text(
              'Listen carefully, then repeat the word several times.',
              style: TextStyle(color: muted, fontSize: 11, height: 1.5),
            ),
          ),
        ],
      ),
    );
  }
}




