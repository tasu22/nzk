import 'dart:convert';
import 'dart:math';
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
  // Theme Mode
  // -----------------------------------------------------------------
  ThemeMode _themeMode = ThemeMode.dark;
  ThemeMode get themeMode => _themeMode;

  // -----------------------------------------------------------------
  // Daily Pick (Cached)
  // -----------------------------------------------------------------
  Map<String, dynamic>? _dailyPick;
  Map<String, dynamic>? get dailyPick => _dailyPick;

  void _updateDailyPick() {
    if (_songs.isEmpty) {
      _dailyPick = null;
      return;
    }
    // Use a fixed epoch to ensure continuous rotation without repeats until full cycle
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final epoch = DateTime(2024, 1, 1);
    final daysSinceEpoch = today.difference(epoch).inDays;

    // Deterministic shuffle
    final randomSeed = Random(2024);
    final List<int> indices = List.generate(_songs.length, (i) => i);
    indices.shuffle(randomSeed);

    final cycleIndex =
        (daysSinceEpoch % _songs.length + _songs.length) % _songs.length;
    _dailyPick = _songs[indices[cycleIndex]];
  }

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

    // Calculate daily pick once songs are available
    _updateDailyPick();

    // Load favourites
    final favList = prefs.getStringList('favourites') ?? [];
    _favourites.clear();
    _favourites.addAll(favList);
    // Load the "Song of the Day" flag
    _showSongOfTheDay = prefs.getBool('show_wimbo_wa_siku') ?? true;

    // Load Theme Mode
    final themeIndex = prefs.getInt('theme_mode');
    if (themeIndex != null) {
      _themeMode = ThemeMode.values[themeIndex];
    } else {
      _themeMode = ThemeMode.dark; // Default to dark
    }

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
    _updateDailyPick(); // Update pick when songs change
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

  /// Set the Theme Mode.
  Future<void> setThemeMode(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    _themeMode = mode;
    await prefs.setInt('theme_mode', mode.index);
    notifyListeners();
  }
}
