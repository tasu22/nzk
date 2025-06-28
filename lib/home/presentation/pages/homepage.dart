import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart' show HapticFeedback, rootBundle;
import 'package:shared_preferences/shared_preferences.dart';
import 'favourites_page.dart';
import 'song_detail_page.dart';
import '../components/song_card.dart';
import '../components/modern_search_bar.dart';
import '../components/pick_of_the_day.dart';
import 'settings_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  _HomePageState();

  List<dynamic> songs = [];
  List<dynamic> filteredSongs = [];
  bool isLoading = true;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadSongs();
  }

  Future<void> loadSongs() async {
    final prefs = await SharedPreferences.getInstance();
    String? cachedJson = prefs.getString('songs_cache');
    if (cachedJson != null) {
      // Load from cache
      setState(() {
        songs = json.decode(cachedJson);
        filteredSongs = songs;
        isLoading = false;
      });
      // Also update cache in background in case asset changed
      _updateSongsCache(prefs);
    } else {
      // Load from asset and cache it
      final String jsonString = await rootBundle.loadString(
        'assets/json/swahili.json',
      );
      setState(() {
        songs = json.decode(jsonString);
        filteredSongs = songs;
        isLoading = false;
      });
      await prefs.setString('songs_cache', jsonString);
    }
  }

  Future<void> _updateSongsCache(SharedPreferences prefs) async {
    final String jsonString = await rootBundle.loadString(
      'assets/json/swahili.json',
    );
    await prefs.setString('songs_cache', jsonString);
  }

  void _onSearchChanged() {
    final query = _searchController.text.trim().toLowerCase();
    if (songs.isEmpty) return;
    if (query.isEmpty) {
      setState(() {
        filteredSongs = List.from(songs);
      });
    } else {
      setState(() {
        filteredSongs = songs.where((song) {
          final title = (song['title'] ?? '').toString().toLowerCase();
          final number = song['number'].toString();
          return title.contains(query) || number.contains(query);
        }).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nyimbo za kristo', style: TextStyle(fontSize: 30)),
        centerTitle: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: CircleAvatar(
              backgroundColor: Color(0xFFC19976),
              child: IconButton(
                icon: const Icon(CupertinoIcons.settings, color: Colors.white),
                tooltip: 'Settings',
                onPressed: () {
                  HapticFeedback.mediumImpact();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SettingsPage(),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: ModernSearchBar(
                          controller: _searchController,
                          onChanged: (_) => _onSearchChanged(),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(
                          CupertinoIcons.heart,
                          color: Color(0xFFC19976),
                        ),
                        tooltip: 'Favourites',
                        onPressed: () {
                          HapticFeedback.mediumImpact();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const FavouritesPage(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: CustomScrollView(
                    slivers: [
                      SliverToBoxAdapter(
                        child: PickOfTheDay(
                          songs: songs,
                          onTap: (song) {
                            final String rawTitle = song['title'] ?? '';
                            final String displayTitle = rawTitle.replaceFirst(
                              RegExp(r'^\d{1,4}\s*-\s*'),
                              '',
                            );
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
                        ),
                      ),
                      SliverList(
                        delegate: SliverChildBuilderDelegate((context, index) {
                          final song = filteredSongs[index];
                          final String rawTitle = song['title'] ?? '';
                          final String displayTitle = rawTitle.replaceFirst(
                            RegExp(r'^\d{1,4}\s*-\s*'),
                            '',
                          );
                          return SongCard(
                            number: song['number'],
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
                        }, childCount: filteredSongs.length),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
