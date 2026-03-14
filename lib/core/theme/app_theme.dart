import 'package:flutter/material.dart';

class AppTheme {
static ThemeData get lightTheme {
return ThemeData(
useMaterial3: true,
brightness: Brightness.light,
scaffoldBackgroundColor: const Color(0xFFF8F9FA),
colorScheme: const ColorScheme.light(
primary: Color(0xFFFF6699),
secondary: Color(0xFFA5D6A7),
surface: Colors.white,
),
appBarTheme: const AppBarTheme(
backgroundColor: Color(0xFFF8F9FA),
foregroundColor: Colors.black87,
elevation: 0,
centerTitle: true,
),
);
}

static ThemeData get darkTheme {
return ThemeData(
useMaterial3: true,
brightness: Brightness.dark,
scaffoldBackgroundColor: const Color(0xFF1E1B38),
colorScheme: const ColorScheme.dark(
primary: Color(0xFF9575CD),
secondary: Color(0xFF4DB6AC),
surface: Color(0xFF2D2A4A),
),
appBarTheme: const AppBarTheme(
backgroundColor: Color(0xFF1E1B38),
foregroundColor: Colors.white,
elevation: 0,
centerTitle: true,
),
);
}
}