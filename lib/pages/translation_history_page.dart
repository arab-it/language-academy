import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';

import '../models/translation_history_item.dart';
import '../services/translation_history_service.dart';

class TranslationHistoryPage extends StatefulWidget {
  const TranslationHistoryPage({super.key});

  @override
  State<TranslationHistoryPage> createState() =>
      _TranslationHistoryPageState();
}

class _TranslationHistoryPageState
    extends State<TranslationHistoryPage> {
  static const Color background = Color(0xFF080808);
  static const Color card = Color(0xFF151515);
  static const Color green = Color(0xFF008C45);
  static const Color red = Color(0xFFCD212A);

  final TextEditingController _searchController =
      TextEditingController();

  final FlutterTts _tts = FlutterTts();

  String searchQuery = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    _searchController.addListener(() {
      setState(() {
        searchQuery =
            _searchController.text.trim().toLowerCase();
      });
    });

    _loadHistory();
  }

  Future<void> _loadHistory() async {
    await TranslationHistoryService.load();

    if (!mounted) return;

    setState(() {
      isLoading = false;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _tts.stop();
    super.dispose();
  }

  List<TranslationHistoryItem> get filteredItems {
    final items = TranslationHistoryService.items;

    if (searchQuery.isEmpty) {
      return items;
    }

    return items.where((item) {
      return item.originalText
              .toLowerCase()
              .contains(searchQuery) ||
          item.translatedText
              .toLowerCase()
              .contains(searchQuery) ||
          item.sourceLanguage
              .toLowerCase()
              .contains(searchQuery) ||
          item.targetLanguage
              .toLowerCase()
              .contains(searchQuery);
    }).toList();
  }

  Future<void> _copy(String text) async {
    await Clipboard.setData(
      ClipboardData(text: text),
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Copied to clipboard'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  Future<void> _speak(
    String text,
    String language,
  ) async {
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

  Future<void> _delete(String id) async {
    await TranslationHistoryService.remove(id);

    if (!mounted) return;

    setState(() {});
  }

  Future<void> _clearAll() async {
    if (TranslationHistoryService.items.isEmpty) {
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: card,
          title: const Text(
            'Clear all history?',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
          content: const Text(
            'All saved translations will be removed.',
            style: TextStyle(
              color: Colors.white70,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.white60,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text(
                'Clear All',
                style: TextStyle(
                  color: red,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        );
      },
    );

    if (confirmed != true) return;

    await TranslationHistoryService.clear();

    if (!mounted) return;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final items = filteredItems;

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: background,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Translation History',
          style: TextStyle(
            fontWeight: FontWeight.w800,
          ),
        ),
        actions: [
          if (TranslationHistoryService.items.isNotEmpty)
            IconButton(
              tooltip: 'Clear all',
              onPressed: _clearAll,
              icon: const Icon(
                Icons.delete_sweep_rounded,
              ),
            ),
        ],
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: green,
              ),
            )
          : Column(
              children: [
                _buildSearch(),

                Expanded(
                  child: items.isEmpty
                      ? _buildEmptyState()
                      : ListView.builder(
                          padding: const EdgeInsets.fromLTRB(
                            20,
                            8,
                            20,
                            30,
                          ),
                          itemCount: items.length,
                          itemBuilder: (context, index) {
                            return _historyCard(
                              items[index],
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }

  Widget _buildSearch() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        8,
        20,
        14,
      ),
      child: TextField(
        controller: _searchController,
        style: const TextStyle(
          color: Colors.white,
        ),
        decoration: InputDecoration(
          hintText: 'Search translation history...',
          hintStyle: const TextStyle(
            color: Colors.white38,
          ),
          prefixIcon: const Icon(
            Icons.search_rounded,
            color: green,
          ),
          suffixIcon: searchQuery.isNotEmpty
              ? IconButton(
                  onPressed: () {
                    _searchController.clear();
                  },
                  icon: const Icon(
                    Icons.clear_rounded,
                    color: Colors.white54,
                  ),
                )
              : null,
          filled: true,
          fillColor: card,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _historyCard(
    TranslationHistoryItem item,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.05),
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _languageBadge(item.sourceLanguage),

              const Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 8,
                ),
                child: Icon(
                  Icons.arrow_forward_rounded,
                  color: Colors.white38,
                  size: 18,
                ),
              ),

              _languageBadge(item.targetLanguage),

              const Spacer(),

              IconButton(
                tooltip: 'Delete',
                onPressed: () {
                  _delete(item.id);
                },
                icon: const Icon(
                  Icons.delete_outline_rounded,
                  color: Colors.white38,
                  size: 21,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          Text(
            item.originalText,
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.w700,
              height: 1.4,
            ),
          ),

          const SizedBox(height: 12),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.22),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Text(
              item.translatedText,
              maxLines: 6,
              overflow: TextOverflow.ellipsis,
              textDirection:
                  item.targetLanguage == 'Arabic'
                      ? TextDirection.rtl
                      : TextDirection.ltr,
              textAlign:
                  item.targetLanguage == 'Arabic'
                      ? TextAlign.right
                      : TextAlign.left,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
                height: 1.5,
              ),
            ),
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              _actionButton(
                icon: Icons.copy_rounded,
                label: 'Copy',
                onPressed: () {
                  _copy(item.translatedText);
                },
              ),

              const SizedBox(width: 8),

              _actionButton(
                icon: Icons.volume_up_rounded,
                label: 'Replay',
                onPressed: () {
                  _speak(
                    item.translatedText,
                    item.targetLanguage,
                  );
                },
              ),

              const Spacer(),

              Text(
                _formatDate(item.createdAt),
                style: const TextStyle(
                  color: Colors.white30,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _languageBadge(String language) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 7,
      ),
      decoration: BoxDecoration(
        color: green.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        _shortCode(language),
        style: const TextStyle(
          color: green,
          fontSize: 11,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }

  Widget _actionButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return Material(
      color: Colors.white.withValues(alpha: 0.05),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 11,
            vertical: 8,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: Colors.white60,
                size: 16,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white60,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    final searching = searchQuery.isNotEmpty;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 78,
              height: 78,
              decoration: BoxDecoration(
                color: green.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Icon(
                Icons.history_rounded,
                color: green,
                size: 38,
              ),
            ),

            const SizedBox(height: 20),

            Text(
              searching
                  ? 'No translations found'
                  : 'No translation history',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              searching
                  ? 'Try another search term.'
                  : 'Your translated texts will appear here.',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white38,
                fontSize: 14,
              ),
            ),
          ],
        ),
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

  String _formatDate(DateTime date) {
    final local = date.toLocal();

    final day =
        local.day.toString().padLeft(2, '0');

    final month =
        local.month.toString().padLeft(2, '0');

    final hour =
        local.hour.toString().padLeft(2, '0');

    final minute =
        local.minute.toString().padLeft(2, '0');

    return '$day/$month $hour:$minute';
  }
}
