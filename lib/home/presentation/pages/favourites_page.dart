import 'dart:ui';
import 'package:flutter/material.dart';
import 'homepage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart' show HapticFeedback;
import 'package:provider/provider.dart';
import '../../../state/app_state.dart';
import 'song_detail_page.dart';
import '../components/song_card.dart';

class FavouritesPage extends StatefulWidget {
  const FavouritesPage({super.key});

  @override
  FavouritesPageState createState() => FavouritesPageState();
}

class FavouritesPageState extends State<FavouritesPage> {
  bool isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {}); // Rebuild to filter
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Consumer<AppState>(
        builder: (context, appState, child) {
          final allFavourites = appState.favourites.toList();
          final allSongs = appState.songs;

          // Filter logic
          List<String> filteredFavourites = allFavourites;
          if (_searchController.text.isNotEmpty) {
            final query = _searchController.text.toLowerCase();
            filteredFavourites = allFavourites.where((title) {
              // We need the number too probably, or just title?
              // Favourites stores TITLES only?
              // wait, AppState says: `final Set<String> _favourites = {};`. It stores titles.
              // Does it verify number? In `homepage.dart`, we filter by title OR number.
              // We need to look up the song to check number.
              final song = allSongs.firstWhere((s) {
                final rawTitle = (s['title'] ?? '').toString();
                final displayTitle = rawTitle.replaceFirst(
                  RegExp(r'^\d{1,4}\s*-\s*'),
                  '',
                );
                return displayTitle.trim() == title.trim();
              }, orElse: () => null);

              if (song != null) {
                final songTitle = (song['title'] ?? '')
                    .toString()
                    .toLowerCase();
                final songNumber = song['number'].toString();
                return songTitle.contains(query) || songNumber.contains(query);
              }
              return title.toLowerCase().contains(query);
            }).toList();
          }

          return Stack(
            children: [
              CustomScrollView(
                slivers: [
                  SliverAppBar(
                    floating: true,
                    pinned: true,
                    backgroundColor: theme.scaffoldBackgroundColor,
                    elevation: 0,
                    leading: IconButton(
                      icon: Icon(Icons.arrow_back, color: colorScheme.primary),
                      onPressed: () => Navigator.pop(context),
                    ),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Nyimbo',
                          style: textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurface.withValues(alpha: 0.7),
                            letterSpacing: 0.5,
                          ),
                        ),
                        Text(
                          'Pendwa',
                          style: textTheme.headlineMedium?.copyWith(
                            color: colorScheme.primary,
                            fontWeight: FontWeight.bold,
                            height: 1.1,
                          ),
                        ),
                      ],
                    ),
                    centerTitle: false,
                  ),

                  // If searching and no results in favourites
                  if (filteredFavourites.isEmpty &&
                      _searchController.text.isNotEmpty)
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              CupertinoIcons.search,
                              size: 64,
                              color: colorScheme.onSurface.withValues(
                                alpha: 0.2,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Haikupo kwenye Vipendwa',
                              style: textTheme.titleMedium?.copyWith(
                                color: colorScheme.onSurface,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Jaribu kutafuta kwenye nyimbo zote',
                              style: textTheme.bodyMedium?.copyWith(
                                color: colorScheme.onSurface.withValues(
                                  alpha: 0.5,
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                            FilledButton.icon(
                              onPressed: () {
                                HapticFeedback.mediumImpact();
                                // Navigate to Homepage with search query
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => HomePage(
                                      initialSearchQuery:
                                          _searchController.text,
                                    ),
                                  ),
                                  (route) => false,
                                );
                              },
                              icon: const Icon(CupertinoIcons.search),
                              label: const Text('Tafuta Nyumbani'),
                              style: FilledButton.styleFrom(
                                backgroundColor: colorScheme.primary,
                                foregroundColor: colorScheme.onPrimary,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  else if (filteredFavourites.isEmpty)
                    // Empty Favourites State (Original)
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(32),
                              decoration: BoxDecoration(
                                color: colorScheme.primary.withValues(
                                  alpha: 0.05,
                                ),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: colorScheme.primary.withValues(
                                    alpha: 0.1,
                                  ),
                                  width: 1,
                                ),
                              ),
                              child: Icon(
                                CupertinoIcons.heart,
                                size: 64,
                                color: colorScheme.primary.withValues(
                                  alpha: 0.8,
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                            Text(
                              'Hakuna Vipendwa',
                              style: textTheme.headlineSmall?.copyWith(
                                color: colorScheme.onSurface,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Nyimbo unazozipenda zitaonekana hapa',
                              textAlign: TextAlign.center,
                              style: textTheme.bodyMedium?.copyWith(
                                color: colorScheme.onSurface.withValues(
                                  alpha: 0.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    // List of filtered favourites
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(0, 16, 0, 100),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate((context, index) {
                          final title = filteredFavourites[index];
                          final song = allSongs.firstWhere((s) {
                            final rawTitle = (s['title'] ?? '').toString();
                            final displayTitle = rawTitle.replaceFirst(
                              RegExp(r'^\d{1,4}\s*-\s*'),
                              '',
                            );
                            return displayTitle.trim() == title.trim();
                          }, orElse: () => null);

                          if (song == null) return const SizedBox.shrink();

                          final rawTitle = (song['title'] ?? '').toString();
                          final displayTitle = rawTitle.replaceFirst(
                            RegExp(r'^\d{1,4}\s*-\s*'),
                            '',
                          );

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: SongCard(
                              number: song['number'] ?? 0,
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
                            ),
                          );
                        }, childCount: filteredFavourites.length),
                      ),
                    ),
                ],
              ),

              // Floating Search Bar
              Positioned(
                bottom: 32,
                left: 24,
                right: 24,
                child: _buildFloatingSearchBar(context),
              ),
            ],
          );
        },
      ),
    );
  }

  // Same search bar widgets as HomePage
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
          color: theme.colorScheme.surface.withValues(alpha: 0.7),
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
            color: Theme.of(context).colorScheme.primary,
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
                decoration: InputDecoration(
                  hintText: 'Search favourites...',
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
}
