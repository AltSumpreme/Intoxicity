import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color primary = Color(0xFFB11226);
  static const Color accent = Color(0xFFFF4D6D);
  static const Color blush = Color(0xFFFFF5F5);
  static const Color dark = Color(0xFF1E1E1E);

  static ThemeData get lightTheme => ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: primary, primary: primary, secondary: accent),
    scaffoldBackgroundColor: blush,
    textTheme: GoogleFonts.playfairDisplayTextTheme().copyWith(
      bodyMedium: GoogleFonts.inter(color: Colors.black87),
    ),
    cardTheme: const CardThemeData(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(28))),
    ),
    useMaterial3: true,
  );

  static ThemeData get darkTheme => ThemeData(
    colorScheme: ColorScheme.fromSeed(
      brightness: Brightness.dark,
      seedColor: primary,
      primary: const Color(0xFFC7354A),
      secondary: const Color(0xFFFF7992),
    ),
    scaffoldBackgroundColor: dark,
    textTheme: GoogleFonts.playfairDisplayTextTheme(ThemeData.dark().textTheme).copyWith(
      bodyMedium: GoogleFonts.inter(color: Colors.white70),
    ),
    useMaterial3: true,
  );
}
