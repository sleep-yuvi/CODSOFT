import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quote_of_the_day_app/screens/favorites_screen.dart';
import 'package:quote_of_the_day_app/widgets/quote_card.dart';
import 'package:quote_of_the_day_app/models/quote.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:share_plus/share_plus.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Quote> quotes = [];
  Quote? quote;

  @override
  void initState() {
    super.initState();
    loadQuotes();
  }

  Future<void> loadQuotes() async {
    final String response = await rootBundle.loadString('assets/quotes.json');
    final List<dynamic> data = jsonDecode(response);
    quotes = data.map((item) => Quote.fromMap(item)).toList();
    loadRandomQuote();
  }

  void loadRandomQuote() {
    if (quotes.isNotEmpty) {
      setState(() {
        quote = (quotes.toList()..shuffle()).first;
      });
    }
  }

  void addToFavorites() async {
    if (quote == null) return;

    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList('favorites') ?? [];

    final encodedQuote = jsonEncode(quote!.toMap());

    if (!favorites.contains(encodedQuote)) {
      favorites.add(encodedQuote);
      await prefs.setStringList('favorites', favorites);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Added to favorites')),
      );
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Already in favorites')),
      );
    }
  }

  void shareQuote() {
    if (quote != null) {
      Share.share('"${quote!.text}"\n\n- ${quote!.author}');
    }
  }

  void copyQuote() {
    if (quote != null) {
      Clipboard.setData(ClipboardData(text: '"${quote!.text}" - ${quote!.author}'));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Quote copied to clipboard')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quote of the Day'),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const FavoritesScreen()),
              );
            },
          ),
        ],
      ),
      body: quote == null
          ? const Center(child: CircularProgressIndicator())
          : QuoteCard(
              quote: quote!,
              onFavorite: addToFavorites,
              onShare: shareQuote,
              onCopy: copyQuote,
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: loadRandomQuote,
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
