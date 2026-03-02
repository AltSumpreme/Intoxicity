import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color primary = Color(0xFFB11226);
  static const Color accent = Color(0xFFFF4D6D);
  static const Color blush = Color(0xFFFFF5F5);
  static const Color dark = Color(0xFF1E1E1E);

  static ThemeData get lightTheme => ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: primary,
      primary: primary,
      secondary: accent,
      surface: Colors.white.withValues(alpha: 0.85),
      brightness: Brightness.light,
    ),
    scaffoldBackgroundColor: blush,
    appBarTheme: AppBarTheme(
      backgroundColor: blush,
      elevation: 0,
      scrolledUnderElevation: 0,
      foregroundColor: primary,
      titleTextStyle: GoogleFonts.playfairDisplay(fontSize: 26, fontWeight: FontWeight.w600, color: primary),
    ),
    textTheme: TextTheme(
      displaySmall: GoogleFonts.playfairDisplay(fontSize: 44, height: 1.1, fontWeight: FontWeight.w600, color: const Color(0xFF2D1B1F)),
      headlineSmall: GoogleFonts.playfairDisplay(fontSize: 30, fontWeight: FontWeight.w600, color: const Color(0xFF34181D)),
      titleLarge: GoogleFonts.cormorantGaramond(fontSize: 28, fontWeight: FontWeight.w700, color: const Color(0xFF34181D)),
      bodyLarge: GoogleFonts.inter(fontSize: 16, height: 1.55, color: const Color(0xFF4A3438)),
      bodyMedium: GoogleFonts.inter(fontSize: 14, color: const Color(0xFF5F4A4E)),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      contentPadding: EdgeInsets.all(22),
    ),
    useMaterial3: true,
  );

  static ThemeData get darkTheme => ThemeData(
    colorScheme: ColorScheme.fromSeed(
      brightness: Brightness.dark,
      seedColor: primary,
      primary: const Color(0xFFC93E52),
      secondary: const Color(0xFFFF7D96),
      surface: const Color(0xFF2A2628),
    ),
    scaffoldBackgroundColor: dark,
    textTheme: TextTheme(
      displaySmall: GoogleFonts.playfairDisplay(fontSize: 44, height: 1.1, fontWeight: FontWeight.w600, color: const Color(0xFFFDEFF1)),
      headlineSmall: GoogleFonts.playfairDisplay(fontSize: 30, fontWeight: FontWeight.w600, color: const Color(0xFFFCE5E9)),
      titleLarge: GoogleFonts.cormorantGaramond(fontSize: 28, fontWeight: FontWeight.w700, color: Colors.white),
      bodyLarge: GoogleFonts.inter(fontSize: 16, height: 1.55, color: const Color(0xFFD6C1C5)),
      bodyMedium: GoogleFonts.inter(fontSize: 14, color: const Color(0xFFBDA4A9)),
    ),
    useMaterial3: true,
  );
}
