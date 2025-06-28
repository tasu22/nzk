import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle, HapticFeedback;
import 'song_detail_page.dart';
import '../components/song_card.dart';

class FavouritesPage extends StatefulWidget {
  const FavouritesPage({super.key});

  @override
  FavouritesPageState createState() => FavouritesPageState();
}

class FavouritesPageState extends State<FavouritesPage> {
  List<dynamic> allSongs = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadAll();
  }

  Future<void> loadAll() async {
    await FavouritesStore.init();
    final String jsonString = await rootBundle.loadString(
      'assets/json/swahili.json',
    );
    setState(() {
      allSongs = json.decode(jsonString);
      isLoading = false;
    });
  }

  List<String> favourites = [];

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return FutureBuilder<List<String>>(
      future: FavouritesStore.getFavourites(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        favourites = snapshot.data!;
        return Scaffold(
          appBar: AppBar(
            title: const Text('Favourites', style: TextStyle(fontSize: 30)),
            centerTitle: false,
          ),
          body: favourites.isEmpty
              ? const Center(
                  child: Text(
                    'H U J A W E K A  C H O C H O T E',
                    style: TextStyle(fontSize: 20, color: Colors.grey),
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: favourites.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final title = favourites[index];
                    // Find the song object by title (ignoring number prefix)
                    final song = allSongs.firstWhere((s) {
                      final rawTitle = (s['title'] ?? '').toString();
                      final displayTitle = rawTitle.replaceFirst(
                        RegExp(r'^\d{1,4}\s*-\s*'),
                        '',
                      );
                      return displayTitle.trim() == title.trim();
                    }, orElse: () => null);
                    if (song == null) {
                      return SongCard(
                        number: index + 1,
                        title: title,
                        onTap: null,
                      );
                    }
                    final rawTitle = (song['title'] ?? '').toString();
                    final displayTitle = rawTitle.replaceFirst(
                      RegExp(r'^\d{1,4}\s*-\s*'),
                      '',
                    );
                    return SongCard(
                      number: song['number'] ?? (index + 1),
                      title: displayTitle,
                      onTap: () {
                        HapticFeedback.mediumImpact();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SongDetailPage(
                              title: displayTitle,
                              content: song['content'],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
        );
      },
    );
  }
}
