import 'package:flutter/material.dart';
import 'package:google_mlkit_translation/google_mlkit_translation.dart';
import 'package:flutter_tts/flutter_tts.dart';

import '../services/translation_history_service.dart';
import 'translation_history_page.dart';

class TranslatePage extends StatefulWidget {
  const TranslatePage({super.key});

  @override
  State<TranslatePage> createState() => _TranslatePageState();
}

class _TranslatePageState extends State<TranslatePage> {
  final TextEditingController _inputController = TextEditingController();
  final TextEditingController _outputController = TextEditingController();
  final FlutterTts _tts = FlutterTts();

  String sourceLanguage = 'English';
  String targetLanguage = 'Italian';

  bool isTranslating = false;

  final Map<String, TranslateLanguage> languages = {
    'English': TranslateLanguage.english,
    'Italian': TranslateLanguage.italian,
    'Arabic': TranslateLanguage.arabic,
  };

  @override
  void initState() {
    super.initState();
    TranslationHistoryService.load();
  }

  @override
  void dispose() {
    _inputController.dispose();
    _outputController.dispose();
    _tts.stop();
    super.dispose();
  }

  Future<void> _saveToHistory(String translatedText) async {
    await TranslationHistoryService.add(
      sourceLanguage: sourceLanguage,
      targetLanguage: targetLanguage,
      originalText: _inputController.text.trim(),
      translatedText: translatedText.trim(),
    );
  }

  Future<void> _translate() async {
    final text = _inputController.text.trim();

    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Enter some text first.'),
        ),
      );
      return;
    }

    if (sourceLanguage == targetLanguage) {
      _outputController.text = text;

      await _saveToHistory(text);

      return;
    }

    setState(() {
      isTranslating = true;
    });

    try {
      final source = languages[sourceLanguage]!;
      final target = languages[targetLanguage]!;

      final translator = OnDeviceTranslator(
        sourceLanguage: source,
        targetLanguage: target,
      );

      final result = await translator.translateText(text);

      await translator.close();

      await _saveToHistory(result);

      if (!mounted) return;

      setState(() {
        _outputController.text = result;
      });
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Translation failed: $e'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isTranslating = false;
        });
      }
    }
  }

  Future<void> _speak(String text, String language) async {
    if (text.trim().isEmpty) return;

    String locale;

    switch (language) {
      case 'Italian':
        locale = 'it-IT';
        break;
      case 'Arabic':
        locale = 'ar-SA';
        break;
      default:
        locale = 'en-US';
    }

    await _tts.setLanguage(locale);
    await _tts.setSpeechRate(0.45);
    await _tts.setPitch(1.0);
    await _tts.speak(text);
  }

  void _swapLanguages() {
    if (sourceLanguage == targetLanguage) return;

    final oldSource = sourceLanguage;

    setState(() {
      sourceLanguage = targetLanguage;
      targetLanguage = oldSource;

      final oldInput = _inputController.text;
      _inputController.text = _outputController.text;
      _outputController.text = oldInput;
    });
  }

  void _clear() {
    _inputController.clear();
    _outputController.clear();
  }

  @override
  Widget build(BuildContext context) {
    const background = Color(0xFF080808);
    const card = Color(0xFF151515);
    const green = Color(0xFF008C45);

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: background,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Translate',
          style: TextStyle(
            fontWeight: FontWeight.w800,
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Translation History',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const TranslationHistoryPage(),
                ),
              );
            },
            icon: const Icon(Icons.history_rounded),
          ),
          IconButton(
            tooltip: 'Clear',
            onPressed: _clear,
            icon: const Icon(Icons.delete_outline_rounded),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: card,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _languageButton(
                      sourceLanguage,
                      true,
                      green,
                    ),
                  ),
                  IconButton(
                    onPressed: _swapLanguages,
                    icon: const Icon(
                      Icons.swap_horiz_rounded,
                      color: green,
                      size: 28,
                    ),
                  ),
                  Expanded(
                    child: _languageButton(
                      targetLanguage,
                      false,
                      green,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            _textCard(
              title: sourceLanguage,
              controller: _inputController,
              card: card,
              language: sourceLanguage,
              showSpeak: true,
            ),

            const SizedBox(height: 14),

            SizedBox(
              height: 54,
              child: ElevatedButton.icon(
                onPressed: isTranslating ? null : _translate,
                style: ElevatedButton.styleFrom(
                  backgroundColor: green,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor:
                      green.withValues(alpha: 0.4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                icon: isTranslating
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.translate_rounded),
                label: Text(
                  isTranslating ? 'Translating...' : 'Translate',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 14),

            _textCard(
              title: targetLanguage,
              controller: _outputController,
              card: card,
              language: targetLanguage,
              showSpeak: true,
              readOnly: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _languageButton(
    String language,
    bool source,
    Color green,
  ) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () {
        _showLanguagePicker(source);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 12,
        ),
        decoration: BoxDecoration(
          color: green.withValues(alpha: 0.10),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _shortCode(language),
              style: TextStyle(
                color: green,
                fontWeight: FontWeight.w900,
                fontSize: 13,
              ),
            ),
            const SizedBox(width: 7),
            Flexible(
              child: Text(
                language,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(width: 4),
            const Icon(
              Icons.keyboard_arrow_down_rounded,
              color: Colors.white54,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }

  Widget _textCard({
    required String title,
    required TextEditingController controller,
    required Color card,
    required String language,
    required bool showSpeak,
    bool readOnly = false,
  }) {
    final isArabic = language == 'Arabic';

    return Container(
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 12),
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.05),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                _shortCode(language),
                style: const TextStyle(
                  color: Color(0xFF008C45),
                  fontWeight: FontWeight.w900,
                  fontSize: 12,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white70,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              if (showSpeak)
                IconButton(
                  onPressed: () {
                    _speak(controller.text, language);
                  },
                  icon: const Icon(
                    Icons.volume_up_rounded,
                    color: Colors.white54,
                  ),
                ),
            ],
          ),
          TextField(
            controller: controller,
            readOnly: readOnly,
            minLines: 5,
            maxLines: 8,
            textDirection:
                isArabic ? TextDirection.rtl : TextDirection.ltr,
            textAlign:
                isArabic ? TextAlign.right : TextAlign.left,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              height: 1.5,
              fontWeight: FontWeight.w600,
            ),
            decoration: InputDecoration(
              hintText: isArabic
                  ? 'Ø§ÙƒØªØ¨ Ø§Ù„Ù†Øµ Ù‡Ù†Ø§...'
                  : 'Write something...',
              hintStyle: const TextStyle(
                color: Colors.white24,
              ),
              border: InputBorder.none,
            ),
          ),
        ],
      ),
    );
  }

  String _shortCode(String language) {
    switch (language) {
      case 'Italian':
        return 'IT';
      case 'Arabic':
        return 'AR';
      default:
        return 'EN';
    }
  }

  void _showLanguagePicker(bool source) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF151515),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Select language',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 16),
                ...languages.keys.map(
                  (language) => ListTile(
                    leading: Text(
                      _shortCode(language),
                      style: const TextStyle(
                        color: Color(0xFF008C45),
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    title: Text(
                      language,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    trailing: (source
                                ? sourceLanguage
                                : targetLanguage) ==
                            language
                        ? const Icon(
                            Icons.check_circle_rounded,
                            color: Color(0xFF008C45),
                          )
                        : null,
                    onTap: () {
                      if (source) {
                        if (language == targetLanguage) {
                          targetLanguage = sourceLanguage;
                        }
                        sourceLanguage = language;
                      } else {
                        if (language == sourceLanguage) {
                          sourceLanguage = targetLanguage;
                        }
                        targetLanguage = language;
                      }

                      setState(() {});
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

