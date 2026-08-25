import 'package:flutter/material.dart';

import '../database/hive_service.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  List<String> favorites = [];

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  void _loadFavorites() {
    setState(() {
      favorites = HiveService.favorites;
    });
  }

  Future<void> _removeFavorite(String word) async {
    await HiveService.removeFavorite(word);
    _loadFavorites();

    if (!mounted) return;

    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('$word removed from Favorites')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Favorites',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: favorites.isEmpty
          ? _buildEmptyState()
          : ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Text(
                  '${favorites.length} saved words',
                  style: TextStyle(color: Colors.grey[500], fontSize: 14),
                ),
                const SizedBox(height: 15),
                ...favorites.map(_buildWordCard),
              ],
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: const Color(0xFFCD212A).withValues(alpha: 0.10),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.star_border_rounded,
                size: 50,
                color: Color(0xFFCD212A),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'No Favorites Yet',
              style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Save words while learning and they will appear here.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[500], fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWordCard(String word) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: const Color(0xFF008C45).withValues(alpha: 0.10),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.translate_rounded, color: Color(0xFF008C45)),
        ),
        title: Text(
          word,
          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
        ),
        subtitle: const Text('Favorite word'),
        trailing: IconButton(
          icon: const Icon(Icons.star, color: Color(0xFFCD212A)),
          onPressed: () => _removeFavorite(word),
        ),
      ),
    );
  }
}

