import 'package:flutter/material.dart';
import 'package:arab_it/core/theme/app_colors.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';

import '../database/hive_service.dart';

class SavedTranslationsPage extends StatefulWidget {
  const SavedTranslationsPage({super.key});

  @override
  State<SavedTranslationsPage> createState() => _SavedTranslationsPageState();
}

class _SavedTranslationsPageState extends State<SavedTranslationsPage> {
  final TextEditingController _searchController = TextEditingController();

  String query = '';
  final FlutterTts _tts = FlutterTts();

  @override
  void initState() {
    super.initState();

    _searchController.addListener(() {
      setState(() {
        query = _searchController.text.trim().toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _tts.stop();
    super.dispose();
  }

  List<String> get translations {
    final items = HiveService.savedTranslations;

    if (query.isEmpty) {
      return items;
    }

    return items.where((item) => item.toLowerCase().contains(query)).toList();
  }

  Future<void> _remove(String value) async {
    await HiveService.removeSavedTranslation(value);

    if (!mounted) return;

    setState(() {});
  }

  Future<void> _clearAll() async {
    if (HiveService.savedTranslations.isEmpty) {
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Clear saved translations?'),
          content: const Text('All saved translations will be removed.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('Clear All'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) return;

    final items = List<String>.from(HiveService.savedTranslations);

    for (final item in items) {
      await HiveService.removeSavedTranslation(item);
    }

    if (!mounted) return;

    setState(() {});
  }

  Future<void> _copy(String value) async {
    await Clipboard.setData(ClipboardData(text: value));

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Saved translation copied'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _speak(String value) async {
    if (value.trim().isEmpty) return;

    await _tts.setSpeechRate(0.45);
    await _tts.setVolume(1.0);
    await _tts.speak(value);
  }

  @override
  Widget build(BuildContext context) {
    const card = Color(0xFF151824);
    const cyan = AppColors.cyan;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Saved Translations',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        actions: [
          if (HiveService.savedTranslations.isNotEmpty)
            IconButton(
              tooltip: 'Clear all',
              onPressed: _clearAll,
              icon: const Icon(Icons.delete_sweep_rounded),
            ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search saved translations...',
                prefixIcon: const Icon(Icons.search_rounded, color: cyan),
                filled: true,
                fillColor: card,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: translations.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.star_border_rounded,
                          size: 58,
                          color: Colors.white24,
                        ),
                        SizedBox(height: 12),
                        Text(
                          'No saved translations',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          'Save a translation from Translate.',
                          style: TextStyle(color: Colors.white38, fontSize: 12),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 30),
                    itemCount: translations.length,
                    itemBuilder: (context, index) {
                      final value = translations[index];

                      return Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: card,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: Colors.amber.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: const Icon(
                                Icons.star_rounded,
                                color: Colors.amber,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: SelectableText(
                                value,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            IconButton(
                              tooltip: 'Listen',
                              onPressed: () => _speak(value),
                              icon: const Icon(
                                Icons.volume_up_rounded,
                                color: Colors.white54,
                              ),
                            ),
                            IconButton(
                              tooltip: 'Copy',
                              onPressed: () => _copy(value),
                              icon: const Icon(
                                Icons.copy_rounded,
                                color: Colors.white54,
                              ),
                            ),
                            IconButton(
                              tooltip: 'Delete',
                              onPressed: () => _remove(value),
                              icon: const Icon(
                                Icons.delete_outline_rounded,
                                color: Colors.white54,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}




