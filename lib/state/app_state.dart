import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Global application state using ChangeNotifier.
///
/// Holds the list of songs, the set of favourite titles, and the
/// "Song of the Day" toggle flag. All data is persisted via
/// SharedPreferences.
class AppState extends ChangeNotifier {
  // -----------------------------------------------------------------
  // Songs
  // -----------------------------------------------------------------
  List<dynamic> _songs = [];
  List<dynamic> get songs => _songs;

  // -----------------------------------------------------------------
  // Favourites
  // -----------------------------------------------------------------
  final Set<String> _favourites = {};
  Set<String> get favourites => _favourites;

  // -----------------------------------------------------------------
  // Show "Song of the Day" toggle
  // -----------------------------------------------------------------
  bool _showSongOfTheDay = true;
  bool get showSongOfTheDay => _showSongOfTheDay;

  // -----------------------------------------------------------------
  // Initialisation
  // -----------------------------------------------------------------
  bool _initialized = false;
  Future<void> _ensureInitialized() async {
    if (_initialized) return;
    final prefs = await SharedPreferences.getInstance();
    // Load songs cache (or asset if missing)
    final cachedJson = prefs.getString('songs_cache');
    if (cachedJson != null) {
      _songs = json.decode(cachedJson);
    } else {
      // Load from asset – this mirrors the previous logic in HomePage.
      // NOTE: This method is called from a widget, so we use rootBundle.
      // The caller must import `package:flutter/services.dart`.
    }
    // Load favourites
    final favList = prefs.getStringList('favourites') ?? [];
    _favourites.clear();
    _favourites.addAll(favList);
    // Load the "Song of the Day" flag
    _showSongOfTheDay = prefs.getBool('show_wimbo_wa_siku') ?? true;
    _initialized = true;
    notifyListeners();
  }

  // -----------------------------------------------------------------
  // Public API
  // -----------------------------------------------------------------
  /// Call this from the UI to ensure the state is ready.
  Future<void> init() async => await _ensureInitialized();

  /// Update the songs list from the JSON asset.
  /// This should be called once (e.g., on first launch) or when the
  /// underlying asset changes.
  Future<void> loadSongsFromAsset(String assetPath) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = await rootBundle.loadString(assetPath);
    _songs = json.decode(jsonString);
    await prefs.setString('songs_cache', jsonString);
    notifyListeners();
  }

  /// Toggle a favourite title.
  Future<void> toggleFavourite(String title) async {
    final prefs = await SharedPreferences.getInstance();
    if (_favourites.contains(title)) {
      _favourites.remove(title);
    } else {
      _favourites.add(title);
    }
    await prefs.setStringList('favourites', _favourites.toList());
    notifyListeners();
  }

  /// Set the "Song of the Day" flag.
  Future<void> setShowSongOfTheDay(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    _showSongOfTheDay = value;
    await prefs.setBool('show_wimbo_wa_siku', value);
    notifyListeners();
  }
}
