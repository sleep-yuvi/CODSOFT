import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:quote_of_the_day_app/models/quote.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<Quote> favoriteQuotes = [];

  @override
  void initState() {
    super.initState();
    loadFavorites();
  }

  Future<void> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList('favorites') ?? [];

    try {
      final decoded = favorites.map((q) => Quote.fromMap(jsonDecode(q))).toList();
      if (!mounted) return;
      setState(() => favoriteQuotes = decoded);
    } catch (e) {
      debugPrint("Error decoding favorites: $e");
      if (!mounted) return;
      setState(() => favoriteQuotes = []);
    }
  }

  Future<void> removeFavorite(int index) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList('favorites') ?? [];

    final quoteToRemove = jsonEncode(favoriteQuotes[index].toMap());

    favorites.remove(quoteToRemove);
    await prefs.setStringList('favorites', favorites);

    setState(() {
      favoriteQuotes.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Favorite Quotes')),
      body: favoriteQuotes.isEmpty
          ? const Center(child: Text('No favorites yet.'))
          : ListView.builder(
              itemCount: favoriteQuotes.length,
              itemBuilder: (context, index) {
                final quote = favoriteQuotes[index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text('"${quote.text}"'),
                    subtitle: Text('- ${quote.author}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => removeFavorite(index),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
