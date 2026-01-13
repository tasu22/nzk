import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ModernSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  final String hintText;

  const ModernSearchBar({
    super.key,
    required this.controller,
    this.onChanged,
    this.hintText = 'Search by number or title',
  });

  @override
  Widget build(BuildContext context) {
    const Color headerColor = Color(0xFFD4AF37);
    const Color textColor = Color(0xFFE0E0E0);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(24),
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        style: GoogleFonts.lexend(fontSize: 16, color: textColor),
        cursorColor: headerColor,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: GoogleFonts.lexend(color: Colors.white30),
          prefixIcon: const Icon(Icons.search, color: headerColor),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 20,
          ),
          border: InputBorder.none,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(24),
            borderSide: BorderSide(color: Colors.transparent),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(24),
            borderSide: BorderSide(
              color: headerColor.withValues(alpha: 0.5),
              width: 1,
            ),
          ),
          filled: true,
          fillColor:
              Colors.transparent, // Handled by Container for consistent shape
        ),
      ),
    );
  }
}
