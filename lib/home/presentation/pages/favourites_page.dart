import 'package:flutter/material.dart';
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
  @override
  void initState() {
    super.initState();
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
          final favourites = appState.favourites.toList();
          final allSongs = appState.songs;

          return CustomScrollView(
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
              if (favourites.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(32),
                          decoration: BoxDecoration(
                            color: colorScheme.primary.withValues(alpha: 0.05),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: colorScheme.primary.withValues(alpha: 0.1),
                              width: 1,
                            ),
                          ),
                          child: Icon(
                            CupertinoIcons.heart,
                            size: 64,
                            color: colorScheme.primary.withValues(alpha: 0.8),
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
                            color: colorScheme.onSurface.withValues(alpha: 0.5),
                          ),
                        ),
                        const SizedBox(height: 32),
                        OutlinedButton.icon(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(CupertinoIcons.search, size: 18),
                          label: const Text('Tafuta Nyimbo'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: colorScheme.primary,
                            side: BorderSide(
                              color: colorScheme.primary.withValues(alpha: 0.5),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                          ),
                        ),
                        const SizedBox(height: 64),
                      ],
                    ),
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final title = favourites[index];
                      // Find the song object by title
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
                    }, childCount: favourites.length),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
