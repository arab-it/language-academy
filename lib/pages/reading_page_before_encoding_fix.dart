import 'package:flutter/material.dart';
import 'package:arab_it/core/theme/app_colors.dart';
import 'package:flutter_tts/flutter_tts.dart';

class ReadingPage extends StatefulWidget {
  const ReadingPage({super.key});

  @override
  State<ReadingPage> createState() => _ReadingPageState();
}

class _ReadingPageState extends State<ReadingPage> {
  final FlutterTts _tts = FlutterTts();

  int _selectedLanguage = 0;
  int _currentText = 0;
  bool _isPlaying = false;

  final List<String> _languages = ['English', 'Italiano', 'Ø§Ù„Ø¹Ø±Ø¨ÙŠØ©'];

  final List<ReadingText> _texts = [
    ReadingText(
      title: 'My Daily Routine',
      english: '''Every morning, I wake up early and prepare for my day.

I have breakfast, drink some water, and review my vocabulary.

After that, I continue with my daily activities.

In the evening, I spend some time reading and learning new words.

Learning a little every day helps me improve.''',
      italian: '''La mia routine quotidiana

Ogni mattina mi sveglio presto e mi preparo per la giornata.

Faccio colazione, bevo un poâ€™ dâ€™acqua e ripasso il mio vocabolario.

Dopo continuo con le mie attivitÃ  quotidiane.

La sera passo un poâ€™ di tempo a leggere e a imparare nuove parole.

Imparare un poâ€™ ogni giorno mi aiuta a migliorare.''',
      arabic: '''Ø±ÙˆØªÙŠÙ†ÙŠ Ø§Ù„ÙŠÙˆÙ…ÙŠ

ÙƒÙ„ ØµØ¨Ø§Ø­ Ø£Ø³ØªÙŠÙ‚Ø¸ Ù…Ø¨ÙƒØ±Ø§Ù‹ ÙˆØ£Ø³ØªØ¹Ø¯ Ù„ÙŠÙˆÙ…ÙŠ.

Ø£ØªÙ†Ø§ÙˆÙ„ Ø§Ù„Ø¥ÙØ·Ø§Ø± ÙˆØ£Ø´Ø±Ø¨ Ø¨Ø¹Ø¶ Ø§Ù„Ù…Ø§Ø¡ ÙˆØ£Ø±Ø§Ø¬Ø¹ Ù…ÙØ±Ø¯Ø§ØªÙŠ.

Ø¨Ø¹Ø¯ Ø°Ù„Ùƒ Ø£ØªØ§Ø¨Ø¹ Ø£Ù†Ø´Ø·ØªÙŠ Ø§Ù„ÙŠÙˆÙ…ÙŠØ©.

ÙÙŠ Ø§Ù„Ù…Ø³Ø§Ø¡ Ø£Ù‚Ø¶ÙŠ Ø¨Ø¹Ø¶ Ø§Ù„ÙˆÙ‚Øª ÙÙŠ Ø§Ù„Ù‚Ø±Ø§Ø¡Ø© ÙˆØªØ¹Ù„Ù… ÙƒÙ„Ù…Ø§Øª Ø¬Ø¯ÙŠØ¯Ø©.

Ø§Ù„ØªØ¹Ù„Ù… Ù‚Ù„ÙŠÙ„Ø§Ù‹ ÙƒÙ„ ÙŠÙˆÙ… ÙŠØ³Ø§Ø¹Ø¯Ù†ÙŠ Ø¹Ù„Ù‰ Ø§Ù„ØªØ­Ø³Ù†.''',
    ),
    ReadingText(
      title: 'A New Day',
      english: '''Today is a new day and I have a new opportunity to learn.

I do not need to be perfect.

I only need to practice, listen, read, and continue.

Every new word brings me one step closer to my goal.

I believe that consistency creates progress.''',
      italian: '''Un nuovo giorno

Oggi Ã¨ un nuovo giorno e ho una nuova opportunitÃ  per imparare.

Non devo essere perfetto.

Devo solo esercitarmi, ascoltare, leggere e continuare.

Ogni nuova parola mi porta un passo piÃ¹ vicino al mio obiettivo.

Credo che la costanza crei progresso.''',
      arabic: '''ÙŠÙˆÙ… Ø¬Ø¯ÙŠØ¯

Ø§Ù„ÙŠÙˆÙ… ÙŠÙˆÙ… Ø¬Ø¯ÙŠØ¯ ÙˆÙ„Ø¯ÙŠ ÙØ±ØµØ© Ø¬Ø¯ÙŠØ¯Ø© Ù„Ù„ØªØ¹Ù„Ù….

Ù„Ø§ Ø£Ø­ØªØ§Ø¬ Ø¥Ù„Ù‰ Ø£Ù† Ø£ÙƒÙˆÙ† Ù…Ø«Ø§Ù„ÙŠØ§Ù‹.

Ø£Ø­ØªØ§Ø¬ ÙÙ‚Ø· Ø¥Ù„Ù‰ Ø§Ù„ØªØ¯Ø±ÙŠØ¨ ÙˆØ§Ù„Ø§Ø³ØªÙ…Ø§Ø¹ ÙˆØ§Ù„Ù‚Ø±Ø§Ø¡Ø© ÙˆØ§Ù„Ø§Ø³ØªÙ…Ø±Ø§Ø±.

ÙƒÙ„ ÙƒÙ„Ù…Ø© Ø¬Ø¯ÙŠØ¯Ø© ØªÙ‚Ø±Ø¨Ù†ÙŠ Ø®Ø·ÙˆØ© Ù…Ù† Ù‡Ø¯ÙÙŠ.

Ø£Ø¤Ù…Ù† Ø£Ù† Ø§Ù„Ø§Ø³ØªÙ…Ø±Ø§Ø± ÙŠØµÙ†Ø¹ Ø§Ù„ØªÙ‚Ø¯Ù….''',
    ),
    ReadingText(
      title: 'Learning Languages',
      english: '''Learning a language takes time and practice.

Every day I can learn something new.

I listen carefully, repeat words, and read simple texts.

Mistakes are part of learning.

With patience and consistency, I can improve.''',
      italian: '''Imparare le lingue

Imparare una lingua richiede tempo e pratica.

Ogni giorno posso imparare qualcosa di nuovo.

Ascolto attentamente, ripeto le parole e leggo testi semplici.

Gli errori fanno parte dellâ€™apprendimento.

Con pazienza e costanza posso migliorare.''',
      arabic: '''ØªØ¹Ù„Ù… Ø§Ù„Ù„ØºØ§Øª

ØªØ¹Ù„Ù… Ø§Ù„Ù„ØºØ© ÙŠØ­ØªØ§Ø¬ Ø¥Ù„Ù‰ Ø§Ù„ÙˆÙ‚Øª ÙˆØ§Ù„Ù…Ù…Ø§Ø±Ø³Ø©.

ÙƒÙ„ ÙŠÙˆÙ… ÙŠÙ…ÙƒÙ†Ù†ÙŠ Ø£Ù† Ø£ØªØ¹Ù„Ù… Ø´ÙŠØ¦Ø§Ù‹ Ø¬Ø¯ÙŠØ¯Ø§Ù‹.

Ø£Ø³ØªÙ…Ø¹ Ø¨Ø¹Ù†Ø§ÙŠØ© ÙˆØ£ÙƒØ±Ø± Ø§Ù„ÙƒÙ„Ù…Ø§Øª ÙˆØ£Ù‚Ø±Ø£ Ù†ØµÙˆØµØ§Ù‹ Ø¨Ø³ÙŠØ·Ø©.

Ø§Ù„Ø£Ø®Ø·Ø§Ø¡ Ø¬Ø²Ø¡ Ù…Ù† Ø§Ù„ØªØ¹Ù„Ù….

Ø¨Ø§Ù„ØµØ¨Ø± ÙˆØ§Ù„Ø§Ø³ØªÙ…Ø±Ø§Ø± ÙŠÙ…ÙƒÙ†Ù†ÙŠ Ø£Ù† Ø£ØªØ·ÙˆØ±.''',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tts.setSpeechRate(0.42);
    _tts.setVolume(1.0);
    _tts.setPitch(1.0);
  }

  String get _currentTextContent {
    final text = _texts[_currentText];

    if (_selectedLanguage == 0) return text.english;
    if (_selectedLanguage == 1) return text.italian;
    return text.arabic;
  }

  Future<void> _speak() async {
    await _tts.stop();

    String languageCode = 'en-US';

    if (_selectedLanguage == 1) {
      languageCode = 'it-IT';
    } else if (_selectedLanguage == 2) {
      languageCode = 'ar-SA';
    }

    await _tts.setLanguage(languageCode);

    setState(() {
      _isPlaying = true;
    });

    await _tts.speak(_currentTextContent);

    setState(() {
      _isPlaying = false;
    });
  }

  Future<void> _stop() async {
    await _tts.stop();

    if (!mounted) return;

    setState(() {
      _isPlaying = false;
    });
  }

  void _changeLanguage(int index) {
    setState(() {
      _selectedLanguage = index;
    });
  }

  void _previousText() {
    if (_currentText == 0) return;

    setState(() {
      _currentText--;
    });
  }

  void _nextText() {
    if (_currentText >= _texts.length - 1) return;

    setState(() {
      _currentText++;
    });
  }

  @override
  void dispose() {
    _tts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = _selectedLanguage == 2;

    return Scaffold(
      backgroundColor: const Color(0xFF070A12),
      appBar: AppBar(
        backgroundColor: const Color(0xFF070A12),
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Reading',
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
        centerTitle: true,
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
              _languageSelector(),
              const SizedBox(height: 22),
              _readingCard(isArabic),
              const SizedBox(height: 18),
              _navigation(),
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
          colors: [Color(0xFF8B5CF6), Color(0xFF3B82F6)],
        ),
        borderRadius: BorderRadius.circular(25),
      ),
      child: const Row(
        children: [
          Icon(Icons.menu_book_rounded, color: Colors.white, size: 42),
          SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Improve your reading',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 19,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'Read, listen and practice every day.',
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Choose Language',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 46,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _languages.length,
            itemBuilder: (context, index) {
              final selected = index == _selectedLanguage;

              return GestureDetector(
                onTap: () => _changeLanguage(index),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.only(right: 10),
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  decoration: BoxDecoration(
                    color: selected
                        ? const Color(0xFF8B5CF6)
                        : const Color(0xFF111725),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Center(
                    child: Text(
                      _languages[index],
                      textDirection: index == 2
                          ? TextDirection.rtl
                          : TextDirection.ltr,
                      style: TextStyle(
                        color: selected ? Colors.white : Colors.white54,
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _readingCard(bool isArabic) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: const Color(0xFF111725),
        borderRadius: BorderRadius.circular(27),
        border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _texts[_currentText].title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 18),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.035),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Text(
              _currentTextContent,
              textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
              textAlign: isArabic ? TextAlign.right : TextAlign.left,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                height: 1.8,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 52,
                  child: ElevatedButton.icon(
                    onPressed: _isPlaying ? _stop : _speak,
                    icon: Icon(
                      _isPlaying ? Icons.stop_rounded : Icons.volume_up_rounded,
                    ),
                    label: Text(_isPlaying ? 'Stop' : 'Listen'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.cyan,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                height: 52,
                padding: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Text(
                    '${_currentText + 1}/${_texts.length}',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _navigation() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: _currentText > 0 ? _previousText : null,
            icon: const Icon(Icons.arrow_back_rounded),
            label: const Text('Previous'),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white,
              disabledForegroundColor: Colors.white24,
              side: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: _currentText < _texts.length - 1 ? _nextText : null,
            icon: const Icon(Icons.arrow_forward_rounded),
            label: const Text('Next'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF8B5CF6),
              foregroundColor: Colors.white,
              disabledBackgroundColor: Colors.white.withValues(alpha: 0.06),
              disabledForegroundColor: Colors.white24,
              elevation: 0,
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class ReadingText {
  final String title;
  final String english;
  final String italian;
  final String arabic;

  const ReadingText({
    required this.title,
    required this.english,
    required this.italian,
    required this.arabic,
  });
}





