import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart' show HapticFeedback, rootBundle;
import 'package:shared_preferences/shared_preferences.dart';
import 'favourites_page.dart';
import 'song_detail_page.dart';
import '../components/song_card.dart';
import '../components/pick_of_the_day.dart';
import 'settings_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  List<dynamic> songs = [];
  List<dynamic> filteredSongs = [];
  bool isLoading = true;
  bool isSearching = false;
  bool showPickOfTheDay = true;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadSongs();
  }

  Future<void> loadSongs() async {
    final prefs = await SharedPreferences.getInstance();
    final bool showWimbo = prefs.getBool('show_wimbo_wa_siku') ?? true;

    String? cachedJson = prefs.getString('songs_cache');
    if (cachedJson != null) {
      if (mounted) {
        setState(() {
          songs = json.decode(cachedJson);
          filteredSongs = songs;
          showPickOfTheDay = showWimbo;
          isLoading = false;
        });
      }
      _updateSongsCache(prefs);
    } else {
      final String jsonString = await rootBundle.loadString(
        'assets/json/swahili.json',
      );
      if (mounted) {
        setState(() {
          songs = json.decode(jsonString);
          filteredSongs = songs;
          showPickOfTheDay = showWimbo;
          isLoading = false;
        });
      }
      await prefs.setString('songs_cache', jsonString);
    }
  }

  Future<void> _updateSongsCache(SharedPreferences prefs) async {
    try {
      final String jsonString = await rootBundle.loadString(
        'assets/json/swahili.json',
      );
      await prefs.setString('songs_cache', jsonString);
    } catch (_) {}
  }

  void _onSearchChanged(String query) {
    final lowerQuery = query.trim().toLowerCase();
    if (songs.isEmpty) return;
    if (lowerQuery.isEmpty) {
      setState(() {
        filteredSongs = List.from(songs);
      });
    } else {
      setState(() {
        filteredSongs = songs.where((song) {
          final title = (song['title'] ?? '').toString().toLowerCase();
          final number = song['number'].toString();
          return title.contains(lowerQuery) || number.contains(lowerQuery);
        }).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // ... theme vars ...
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      extendBody: true,
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                CustomScrollView(
                  slivers: [
                    // ... SliverAppBar ...
                    SliverAppBar(
                      floating: true,
                      snap: true,
                      backgroundColor: theme.scaffoldBackgroundColor.withValues(
                        alpha: 0.9,
                      ),
                      surfaceTintColor: Colors.transparent,
                      elevation: 0,
                      automaticallyImplyLeading: false,
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Mpendwa',
                            style: textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurface.withValues(
                                alpha: 0.7,
                              ),
                              letterSpacing: 0.5,
                            ),
                          ),
                          Text(
                            'Msabato',
                            style: textTheme.headlineMedium?.copyWith(
                              color: colorScheme.primary,
                              fontWeight: FontWeight.bold,
                              height: 1.1,
                            ),
                          ),
                        ],
                      ),
                      centerTitle: false,
                      actions: [
                        IconButton(
                          icon: Icon(
                            CupertinoIcons.heart,
                            color: colorScheme.primary,
                          ),
                          tooltip: 'Favourites',
                          onPressed: () {
                            HapticFeedback.mediumImpact();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const FavouritesPage(),
                              ),
                            );
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: IconButton(
                            icon: Icon(
                              CupertinoIcons.settings,
                              color: colorScheme.primary,
                            ),
                            tooltip: 'Settings',
                            onPressed: () async {
                              HapticFeedback.mediumImpact();
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const SettingsPage(),
                                ),
                              );
                              // Always reload to reflect any setting changes (like Song of the Day toggle)
                              loadSongs();
                            },
                          ),
                        ),
                      ],
                    ),
                    if (showPickOfTheDay)
                      SliverToBoxAdapter(
                        child: PickOfTheDay(
                          songs: songs,
                          onTap: _navigateToSong,
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
                            _navigateToSong(song);
                          },
                        );
                      }, childCount: filteredSongs.length),
                    ),
                    const SliverPadding(padding: EdgeInsets.only(bottom: 100)),
                  ],
                ),
                Positioned(
                  bottom: 32,
                  left: 24,
                  right: 24,
                  child: _buildFloatingSearchBar(context),
                ),
              ],
            ),
    );
  }

  Widget _buildFloatingSearchBar(BuildContext context) {
    final theme = Theme.of(context);

    return Align(
      alignment: Alignment.bottomRight,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        curve: Curves.fastOutSlowIn,
        width: isSearching ? MediaQuery.of(context).size.width - 48 : 56,
        height: 56,
        decoration: BoxDecoration(
          color: theme.colorScheme.surface.withValues(
            alpha: 0.7,
          ), // Glassy for both
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.1),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: Material(
              color: Colors.transparent,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (child, animation) {
                  return FadeTransition(opacity: animation, child: child);
                },
                child: isSearching
                    ? _buildExpandedSearch(context)
                    : _buildCollapsedSearch(context),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCollapsedSearch(BuildContext context) {
    return InkWell(
      key: const ValueKey('collapsed'),
      onTap: () {
        HapticFeedback.selectionClick();
        setState(() {
          isSearching = true;
        });
      },
      child: SizedBox(
        width: 56,
        height: 56,
        child: Center(
          child: Icon(
            CupertinoIcons.search,
            color: Theme.of(context).colorScheme.primary, // Gold icon
            size: 26,
          ),
        ),
      ),
    );
  }

  Widget _buildExpandedSearch(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SingleChildScrollView(
      key: const ValueKey('expanded'),
      scrollDirection: Axis.horizontal,
      physics: const NeverScrollableScrollPhysics(),
      child: Container(
        width: MediaQuery.of(context).size.width - 48,
        height: 56,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            Icon(CupertinoIcons.search, color: colorScheme.primary, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                controller: _searchController,
                autofocus: true,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurface,
                ),
                cursorColor: colorScheme.primary,
                onChanged: _onSearchChanged,
                decoration: InputDecoration(
                  hintText: 'Search number or title...',
                  hintStyle: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                  isDense: true,
                ),
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.close,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                size: 20,
              ),
              onPressed: () {
                HapticFeedback.mediumImpact();
                _searchController.clear();
                _onSearchChanged('');
                setState(() {
                  isSearching = false;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToSong(dynamic song) {
    final String rawTitle = song['title'] ?? '';
    final String displayTitle = rawTitle.replaceFirst(
      RegExp(r'^\d{1,4}\s*-\s*'),
      '',
    );
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            SongDetailPage(title: displayTitle, content: song['content']),
      ),
    );
  }
}
