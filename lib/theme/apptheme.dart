import 'package:flutter/material.dart';

class AppTheme {
  static const Color backgroundColor = Color(0xFF082C38);
  static const Color textColor = Color(0xFFC19976);
  static const Color accentColor = Colors.white;

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: backgroundColor,
      primaryColor: backgroundColor,
      fontFamily: 'Playfair',
      appBarTheme: AppBarTheme(
        backgroundColor: backgroundColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: accentColor),
        titleTextStyle: const TextStyle(
          color: textColor,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          fontFamily: 'Playfair',
        ),
      ),
      iconTheme: const IconThemeData(color: accentColor),
      textTheme: const TextTheme(
        displayLarge: TextStyle(color: textColor, fontFamily: 'Playfair'),
        displayMedium: TextStyle(color: textColor, fontFamily: 'Playfair'),
        displaySmall: TextStyle(color: textColor, fontFamily: 'Playfair'),
        headlineMedium: TextStyle(color: textColor, fontFamily: 'Playfair'),
        headlineSmall: TextStyle(color: textColor, fontFamily: 'Playfair'),
        titleLarge: TextStyle(color: textColor, fontFamily: 'Playfair'),
        bodyLarge: TextStyle(color: textColor, fontFamily: 'Playfair'),
        bodyMedium: TextStyle(color: textColor, fontFamily: 'Playfair'),
        bodySmall: TextStyle(color: textColor, fontFamily: 'Playfair'),
        labelLarge: TextStyle(color: textColor, fontFamily: 'Playfair'),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: accentColor),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: accentColor),
        ),
        labelStyle: TextStyle(color: textColor, fontFamily: 'Playfair'),
        hintStyle: TextStyle(color: Colors.white60, fontFamily: 'Playfair'),
      ),
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: accentColor,
        selectionColor: Colors.white24,
        selectionHandleColor: accentColor,
      ),
    );
  }
}
