import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../state/app_state.dart';

class SongDetailPage extends StatefulWidget {
  final String title;
  final String content;
  const SongDetailPage({super.key, required this.title, required this.content});

  @override
  State<SongDetailPage> createState() => _SongDetailPageState();
}

class _SongDetailPageState extends State<SongDetailPage> {
  @override
  void initState() {
    super.initState();
  }

  List<Widget> _parseContent(String content, BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    String text = content.replaceAll('<br/>', '\n');
    text = text.replaceFirst(RegExp(r'<h1><b>.*?</b></h1>\n?'), '');
    final blocks = <Map<String, String>>[];
    int last = 0;
    final chorusRegex = RegExp(r'<i>([\s\S]*?)<\/i>', multiLine: true);
    final matches = chorusRegex.allMatches(text);
    for (final match in matches) {
      if (match.start > last) {
        String stanza = text.substring(last, match.start);
        blocks.add({'type': 'stanza', 'text': stanza});
      }
      String chorus = match.group(1) ?? '';
      blocks.add({'type': 'chorus', 'text': chorus});
      last = match.end;
    }
    if (last < text.length) {
      String stanza = text.substring(last);
      blocks.add({'type': 'stanza', 'text': stanza});
    }
    List<Widget> widgets = [];
    for (final block in blocks) {
      String blockText = block['text'] ?? '';
      blockText = blockText.replaceAll(RegExp(r'<font[^>]*>'), '');
      blockText = blockText.replaceAll('</font>', '');
      blockText = blockText.replaceAll(RegExp(r'<[^>]*>'), '');
      final paragraphs = blockText.split(RegExp(r'\n{2,}'));
      for (var para in paragraphs) {
        String trimmed = para.trim();
        trimmed = trimmed.replaceFirst(RegExp(r'^(\d+)(\s*[-.–]?\s*)'), '');
        if (trimmed.isEmpty) continue;
        if (block['type'] == 'chorus') {
          trimmed = trimmed.replaceFirst(
            RegExp(r'^CHORUS:?\s*', caseSensitive: false),
            '',
          );
          widgets.add(
            Container(
              margin: const EdgeInsets.symmetric(vertical: 16),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: colorScheme.primary.withValues(alpha: 0.2),
                ),
              ),
              child: Column(
                children: [
                  Text(
                    'KIITIKIO',
                    style: textTheme.labelSmall?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2.0,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    trimmed,
                    textAlign: TextAlign.center,
                    style: textTheme.bodyLarge?.copyWith(
                      fontSize: 18,
                      fontStyle: FontStyle.italic,
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w600,
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          widgets.add(
            Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      width: 4,
                      margin: const EdgeInsets.only(right: 16),
                      decoration: BoxDecoration(
                        color: colorScheme.onSurface.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        trimmed,
                        style: textTheme.bodyLarge?.copyWith(
                          fontSize: 18,
                          height: 1.8,
                          color: colorScheme.onSurface.withValues(alpha: 0.9),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      }
    }
    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            floating: true,
            expandedHeight: 120.0,
            backgroundColor: theme.scaffoldBackgroundColor,
            surfaceTintColor: Colors.transparent,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: colorScheme.onSurface),
              onPressed: () => Navigator.of(context).pop(),
            ),
            actions: [
              Consumer<AppState>(
                builder: (context, appState, child) {
                  final isFavourite = appState.favourites.contains(
                    widget.title,
                  );
                  return IconButton(
                    icon: Icon(
                      isFavourite
                          ? CupertinoIcons.heart_fill
                          : CupertinoIcons.heart,
                      color: isFavourite ? Colors.red : colorScheme.primary,
                    ),
                    tooltip: isFavourite
                        ? 'Ondoa kwenye vipendwa'
                        : 'Weka kwenye vipendwa',
                    onPressed: () async {
                      HapticFeedback.mediumImpact();
                      await appState.toggleFavourite(widget.title);
                    },
                  );
                },
              ),
              const SizedBox(width: 8),
            ],
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(
                left: 60, // Increased to avoid back button overlap
                bottom: 16,
                right: 16,
              ),
              title: Text(
                widget.title.toUpperCase(),
                style: textTheme.titleMedium?.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.primary,
                  letterSpacing: -0.5,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              centerTitle: false,
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 48),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _parseContent(widget.content, context),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
