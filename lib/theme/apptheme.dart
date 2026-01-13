import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Premium Dark Palette
  static const Color backgroundColor = Color(0xFF121212); // Deep Charcoal/Black
  static const Color textColor = Color(
    0xFFE0E0E0,
  ); // Soft White for readability
  static const Color headerColor = Color(0xFFD4AF37); // Muted Gold for headers
  static const Color accentColor = Color(0xFFD4AF37); // Gold accent

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: backgroundColor,
      primaryColor: backgroundColor,
      colorScheme: const ColorScheme.dark(
        primary: headerColor,
        secondary: headerColor,
        surface: backgroundColor,
        onPrimary: backgroundColor,
        onSurface: textColor,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: backgroundColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: headerColor),
        titleTextStyle: GoogleFonts.montserrat(
          color: headerColor,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      iconTheme: const IconThemeData(color: headerColor),
      // Consistent Premium Typography
      textTheme: TextTheme(
        displayLarge: GoogleFonts.montserrat(color: headerColor),
        displayMedium: GoogleFonts.montserrat(color: headerColor),
        displaySmall: GoogleFonts.montserrat(color: headerColor),
        headlineMedium: GoogleFonts.montserrat(color: headerColor),
        headlineSmall: GoogleFonts.montserrat(color: headerColor),
        titleLarge: GoogleFonts.montserrat(
          color: headerColor,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: GoogleFonts.lexend(color: textColor),
        bodyMedium: GoogleFonts.lexend(color: textColor),
        bodySmall: GoogleFonts.lexend(color: textColor.withValues(alpha: 0.7)),
        labelLarge: GoogleFonts.lexend(color: textColor),
      ),
      inputDecorationTheme: InputDecorationTheme(
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: accentColor),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: accentColor),
        ),
        labelStyle: GoogleFonts.lexend(color: textColor),
        hintStyle: GoogleFonts.lexend(color: textColor.withValues(alpha: 0.5)),
      ),
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: accentColor,
        selectionColor: Color(0x33D4AF37), // Gold with low opacity
        selectionHandleColor: accentColor,
      ),
    );
  }
}
