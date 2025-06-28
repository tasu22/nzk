import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Simple in-memory favourites store (for demo; replace with persistent storage for real app)
class FavouritesStore {
  static final Set<String> _favourites = {};
  static bool _initialized = false;

  static Future<void> init() async {
    if (_initialized) return;
    final prefs = await SharedPreferences.getInstance();
    final favList = prefs.getStringList('favourites') ?? [];
    _favourites.clear();
    _favourites.addAll(favList);
    _initialized = true;
  }

  static Future<void> toggle(String title) async {
    await init();
    if (_favourites.contains(title)) {
      _favourites.remove(title);
    } else {
      _favourites.add(title);
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('favourites', _favourites.toList());
  }

  static Future<bool> isFavourite(String title) async {
    await init();
    return _favourites.contains(title);
  }

  static Future<List<String>> getFavourites() async {
    await init();
    return _favourites.toList();
  }
}

class SongDetailPage extends StatefulWidget {
  final String title;
  final String content;
  const SongDetailPage({super.key, required this.title, required this.content});

  @override
  State<SongDetailPage> createState() => _SongDetailPageState();
}

class _SongDetailPageState extends State<SongDetailPage> {
  bool isFavourite = false;
  bool loadingFav = true;

  @override
  void initState() {
    super.initState();
    _loadFavourite();
  }

  Future<void> _loadFavourite() async {
    final fav = await FavouritesStore.isFavourite(widget.title);
    setState(() {
      isFavourite = fav;
      loadingFav = false;
    });
  }

  List<Widget> _parseContent(String content) {
    // ...existing code...
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
              margin: const EdgeInsets.only(bottom: 12, left: 20),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFC19976), width: 1),
              ),
              child: Text(
                trimmed,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontStyle: FontStyle.italic,
                  color: Color(0xFFC19976),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          );
        } else {
          widgets.add(
            Container(
              margin: const EdgeInsets.only(bottom: 12),
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      width: 4,
                      margin: const EdgeInsets.only(right: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFC19976),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        trimmed,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white,
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
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: false,
        actions: [
          loadingFav
              ? const SizedBox.shrink()
              : IconButton(
                  icon: Icon(
                    isFavourite
                        ? CupertinoIcons.heart_fill
                        : CupertinoIcons.heart,
                    color: isFavourite ? Colors.red : const Color(0xFFC19976),
                  ),
                  tooltip: isFavourite
                      ? 'Remove from favourites'
                      : 'Add to favourites',
                  onPressed: () async {
                    HapticFeedback.heavyImpact();
                    setState(() {
                      loadingFav = true;
                    });
                    await FavouritesStore.toggle(widget.title);
                    final fav = await FavouritesStore.isFavourite(widget.title);
                    setState(() {
                      isFavourite = fav;
                      loadingFav = false;
                    });
                  },
                ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _parseContent(widget.content),
        ),
      ),
    );
  }
}
