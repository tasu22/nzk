import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// -----------------------------------------------------------------
// App Logo Extension
// -----------------------------------------------------------------
class AppLogo extends ThemeExtension<AppLogo> {
  final String logoPath;

  const AppLogo({required this.logoPath});

  @override
  AppLogo copyWith({String? logoPath}) {
    return AppLogo(logoPath: logoPath ?? this.logoPath);
  }

  @override
  AppLogo lerp(ThemeExtension<AppLogo>? other, double t) {
    if (other is! AppLogo) {
      return this;
    }
    // No meaningful interpolation for strings/path, so we just swap at 50%
    return t < 0.5 ? this : other;
  }
}

class AppTheme {
  // Premium Dark Palette
  static const Color darkBackgroundColor = Color(
    0xFF121212,
  ); // Deep Charcoal/Black
  static const Color darkTextColor = Color(0xFFE0E0E0); // Soft White

  // Premium Light Palette
  static const Color lightBackgroundColor = Color(
    0xFFF9F9F9,
  ); // Soft White/Paper
  static const Color lightSurfaceColor = Color(0xFFFFFFFF);
  static const Color lightTextColor = Color(0xFF1E1E1E); // Matte Black

  // Shared
  static const Color primaryGold = Color(0xFFD4AF37); // Muted Gold
  static const String logoLight = 'assets/images/iconlight.png';
  static const String logoDark = 'assets/images/icondark.png';

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      extensions: const [AppLogo(logoPath: logoLight)],
      scaffoldBackgroundColor: lightBackgroundColor,
      primaryColor: lightBackgroundColor,
      colorScheme: const ColorScheme.light(
        primary: primaryGold,
        secondary: primaryGold,
        surface: lightSurfaceColor,
        onPrimary: lightBackgroundColor,
        onSurface: lightTextColor,
        // UI Elements
        outline: Color(0xFFE6E1D6),
        outlineVariant: Color(0xFFF0EBE0),
        shadow: Color(0x0F1C1608), // Much softer, warm shadow
        surfaceContainer: Color(
          0xFFFFF9E6,
        ), // Distinct Pale Gold for gradient start
        surfaceContainerLow: Color(0xFFFFFFFF), // Pure White for gradient end
        onSurfaceVariant: Color(0xFF8D8D8D),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: lightBackgroundColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: primaryGold),
        titleTextStyle: GoogleFonts.playfair(
          color: primaryGold,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: lightBackgroundColor,
        selectedItemColor: primaryGold,
        unselectedItemColor: lightTextColor.withValues(alpha: 0.5),
      ),
      iconTheme: const IconThemeData(color: primaryGold),
      // Consistent Premium Typography
      textTheme: TextTheme(
        displayLarge: GoogleFonts.playfair(color: primaryGold),
        displayMedium: GoogleFonts.playfair(color: primaryGold),
        displaySmall: GoogleFonts.playfair(color: primaryGold),
        headlineMedium: GoogleFonts.playfair(color: primaryGold),
        headlineSmall: GoogleFonts.playfair(color: primaryGold),
        titleLarge: GoogleFonts.playfair(
          color: primaryGold,
          fontWeight: FontWeight.w600,
        ),
        titleMedium: GoogleFonts.playfair(
          color: primaryGold,
          fontWeight: FontWeight.w600,
        ),
        titleSmall: GoogleFonts.playfair(
          color: primaryGold,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: GoogleFonts.lexend(color: lightTextColor),
        bodyMedium: GoogleFonts.lexend(color: lightTextColor),
        bodySmall: GoogleFonts.lexend(
          color: lightTextColor.withValues(alpha: 0.7),
        ),
        labelLarge: GoogleFonts.lexend(color: lightTextColor),
        labelMedium: GoogleFonts.lexend(color: lightTextColor),
        labelSmall: GoogleFonts.lexend(color: lightTextColor),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.transparent,
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: primaryGold),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: primaryGold, width: 2),
        ),
        labelStyle: GoogleFonts.lexend(color: lightTextColor),
        hintStyle: GoogleFonts.lexend(
          color: lightTextColor.withValues(alpha: 0.5),
        ),
      ),
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: primaryGold,
        selectionColor: Color(0x33D4AF37), // Gold with low opacity
        selectionHandleColor: primaryGold,
      ),
      dividerTheme: DividerThemeData(
        color: lightTextColor.withValues(alpha: 0.1),
        thickness: 1,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      extensions: const [AppLogo(logoPath: logoDark)],
      scaffoldBackgroundColor: darkBackgroundColor,
      primaryColor: darkBackgroundColor,
      colorScheme: const ColorScheme.dark(
        primary: primaryGold,
        secondary: primaryGold,
        surface: darkBackgroundColor,
        onPrimary: darkBackgroundColor,
        onSurface: darkTextColor,
        // UI Elements
        outline: Color(0x1FFFFFFF),
        outlineVariant: Color(0x0DFFFFFF),
        shadow: Color(0x4D000000), // Stronger shadow
        surfaceContainer: Color(0xFF1E1E1E),
        surfaceContainerLow: Color(0x0DFFFFFF),
        onSurfaceVariant: Color(0xB3E0E0E0),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: darkBackgroundColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: primaryGold),
        titleTextStyle: GoogleFonts.playfair(
          color: primaryGold,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: darkBackgroundColor,
        selectedItemColor: primaryGold,
        unselectedItemColor: darkTextColor.withValues(alpha: 0.5),
      ),
      iconTheme: const IconThemeData(color: primaryGold),
      // Consistent Premium Typography
      textTheme: TextTheme(
        displayLarge: GoogleFonts.playfair(color: primaryGold),
        displayMedium: GoogleFonts.playfair(color: primaryGold),
        displaySmall: GoogleFonts.playfair(color: primaryGold),
        headlineMedium: GoogleFonts.playfair(color: primaryGold),
        headlineSmall: GoogleFonts.playfair(color: primaryGold),
        titleLarge: GoogleFonts.playfair(
          color: primaryGold,
          fontWeight: FontWeight.w600,
        ),
        titleMedium: GoogleFonts.playfair(
          color: primaryGold,
          fontWeight: FontWeight.w600,
        ),
        titleSmall: GoogleFonts.playfair(
          color: primaryGold,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: GoogleFonts.lexend(color: darkTextColor),
        bodyMedium: GoogleFonts.lexend(color: darkTextColor),
        bodySmall: GoogleFonts.lexend(
          color: darkTextColor.withValues(alpha: 0.7),
        ),
        labelLarge: GoogleFonts.lexend(color: darkTextColor),
        labelMedium: GoogleFonts.lexend(color: darkTextColor),
        labelSmall: GoogleFonts.lexend(color: darkTextColor),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.transparent,
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: primaryGold),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: primaryGold, width: 2),
        ),
        labelStyle: GoogleFonts.lexend(color: darkTextColor),
        hintStyle: GoogleFonts.lexend(
          color: darkTextColor.withValues(alpha: 0.5),
        ),
      ),
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: primaryGold,
        selectionColor: Color(0x33D4AF37), // Gold with low opacity
        selectionHandleColor: primaryGold,
      ),
      dividerTheme: DividerThemeData(
        color: darkTextColor.withValues(alpha: 0.1),
        thickness: 1,
      ),
    );
  }
}
