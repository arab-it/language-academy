import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

import '../database/hive_service.dart';
import '../core/premium_guard.dart';

class PronunciationPage extends StatefulWidget {
  const PronunciationPage({super.key});

  @override
  State<PronunciationPage> createState() => _PronunciationPageState();
}

class _PronunciationPageState extends State<PronunciationPage> {
  final FlutterTts _tts = FlutterTts();

  final TextEditingController _controller = TextEditingController(
    text: 'Hello',
  );

  String _language = 'en-US';

  Future<void> _speak() async {
    await HiveService.init();

    if (!mounted) return;

    if (!PremiumGuard.check(context)) {
      return;
    }

    final text = _controller.text.trim();

    if (text.isEmpty) return;

    await _tts.setLanguage(_language);
    await _tts.setSpeechRate(0.45);
    await _tts.setVolume(1.0);
    await _tts.setPitch(1.0);
    await _tts.speak(text);

    await HiveService.addPronunciationPractice();
  }

  @override
  void dispose() {
    _controller.dispose();
    _tts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pronunciation')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Enter a word or sentence',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            DropdownButtonFormField<String>(
              initialValue: _language,
              decoration: const InputDecoration(
                labelText: 'Language',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'en-US', child: Text('English')),
                DropdownMenuItem(value: 'it-IT', child: Text('Italiano')),
                DropdownMenuItem(value: 'ar-SA', child: Text('Ø§Ù„Ø¹Ø±Ø¨ÙŠØ©')),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _language = value;
                  });
                }
              },
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton.icon(
                onPressed: _speak,
                icon: const Icon(Icons.volume_up),
                label: const Text('Listen'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}





