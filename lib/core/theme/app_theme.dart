import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: Colors.white,
      colorScheme: const ColorScheme.light(
        primary: Color(0xFFFFB3FA), // O şık pembe
        secondary: Color(0xFFD5F0E6), // Nane yeşili
        surface: Colors.white,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: const Color(0xFF121421), // Figma'daki derin lacivert
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFF9575CD),
        secondary: Color(0xFF2D2A4A),
        surface: const Color(0xFF1C1C2D),
      ),
    );
  }
}