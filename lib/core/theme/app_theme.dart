import 'package:flutter/material.dart';

class AppTheme {
  // Color Palette 1: Dark Blue Theme (ONLY for dark theme)
  static const Color _darkBluePrimary = Color(0xFF070F2B);
  static const Color _darkBlueSecondary = Color(0xFF1B1A55);
  static const Color _darkBlueAccent = Color(0xFF535C91);
  static const Color _darkBlueLight = Color(0xFF9290C3);

  // Color Palette 2: Light Pastel Theme (ONLY for light theme)
  static const Color _pastelPrimary = Color(0xFFCFF1EF); // CFF1EF
  static const Color _pastelSecondary = Color(0xFFFFFFFF); // FFFFFF
  static const Color _pastelAccent = Color(0xFFFBCFFC); // FBCFFC
  static const Color _pastelHighlight = Color(0xFFBE79DF); // BE79DF
  static const Color _pastelGreen = Color(
    0xFF4CAF50,
  ); // Kullanıcının verdiği yeşil

  /// Meditasyon “Oturumu bitir” — temadan açık yüzey (light/dark).
  static const Color meditationEndButtonBackgroundLight = _pastelPrimary;
  static const Color meditationEndButtonForegroundLight = _darkBluePrimary;
  static const Color meditationEndButtonBackgroundDark = _darkBlueLight;
  static const Color meditationEndButtonForegroundDark = _darkBluePrimary;

  // ——— Meditasyon sayfası (tümü aşağıdaki paletten türetilir) ———
  static const Color meditationPageBackgroundLight = _pastelSecondary;
  static const Color meditationPageBackgroundDark = _darkBluePrimary;
  static const Color meditationTextPrimaryLight = _darkBluePrimary;
  static const Color meditationTextPrimaryDark = _pastelSecondary;
  static const Color meditationTextMutedLight = _darkBlueAccent;
  static const Color meditationTextMutedDark = _darkBlueLight;
  static const Color meditationCardSurfaceLight = _pastelSecondary;
  static const Color meditationCardSurfaceDark = _darkBlueSecondary;
  static const Color meditationBreathCoreLight = _pastelPrimary;
  static const Color meditationBreathCoreDark = _darkBlueSecondary;
  static const Color meditationBreathGlowBase = _pastelAccent;
  static const Color meditationBreathRing = _pastelHighlight;
  static const Color meditationBreathRingAlt = _pastelAccent;
  static const Color meditationBreathLeafLight = _pastelSecondary;
  static const Color meditationBreathLeafDark = _pastelPrimary;
  static const Color meditationTimerSeparator = _darkBlueAccent;
  static const Color meditationVibrationCircleLight = _pastelPrimary;
  static const Color meditationVibrationCircleDark = _darkBlueAccent;
  static const Color meditationSwitchTrackActive = _pastelGreen;
  static const Color meditationSwitchThumb = _pastelSecondary;
  static const Color meditationSoundChipSelectedLight = _pastelAccent;
  static const Color meditationSoundChipSelectedDark = _darkBlueAccent;
  static const Color meditationSoundChipUnselectedLight = _pastelPrimary;
  static const Color meditationSoundChipUnselectedDark = _darkBlueSecondary;
  static const Color meditationSoundChipBorder = _pastelHighlight;
  static const Color meditationSoundIconSelectedLight = _darkBluePrimary;
  static const Color meditationSoundIconSelectedDark = _pastelSecondary;
  static const Color meditationSoundIconUnselectedLight = _darkBlueAccent;
  static const Color meditationSoundIconUnselectedDark = _darkBlueLight;

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: _pastelSecondary,
      colorScheme: const ColorScheme.light(
        primary: _pastelAccent, // Pembe renk
        secondary: _pastelPrimary,
        tertiary: _pastelHighlight,
        surface: _pastelSecondary,
        background: _pastelSecondary,
        error: Color(0xFFE53935),
        onPrimary: _darkBluePrimary,
        onSecondary: _darkBluePrimary,
        onSurface: _darkBluePrimary,
        onBackground: _darkBluePrimary,
        onTertiary: _darkBluePrimary,
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: _darkBluePrimary,
        ),
        displayMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w600,
          color: _darkBluePrimary,
        ),
        headlineLarge: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: _darkBluePrimary,
        ),
        headlineMedium: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w500,
          color: _darkBluePrimary,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: _darkBluePrimary,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: _darkBluePrimary,
        ),
        labelLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: _darkBluePrimary,
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: _pastelSecondary,
        foregroundColor: _darkBluePrimary,
        elevation: 0,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: _darkBluePrimary,
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: _pastelHighlight.withOpacity(0.2),
        selectedItemColor: _pastelHighlight,
        unselectedItemColor: _pastelPrimary,
        selectedLabelStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.normal,
        ),
      ),
      cardTheme: CardThemeData(
        color: _pastelHighlight.withOpacity(0.1),
        elevation: 4,
        shadowColor: _pastelAccent.withOpacity(0.3),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _pastelGreen,
          foregroundColor: _pastelSecondary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: _pastelAccent,
        foregroundColor: _darkBluePrimary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: _darkBluePrimary,
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFFBE79DF), // Mor renk
        secondary: _darkBlueSecondary,
        surface: _darkBlueSecondary,
        background: _darkBluePrimary,
        error: Color(0xFFEF5350),
        onPrimary: _pastelSecondary,
        onSecondary: _pastelSecondary,
        onSurface: _pastelSecondary,
        onBackground: _pastelSecondary,
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: _pastelSecondary,
        ),
        displayMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w600,
          color: _pastelSecondary,
        ),
        headlineLarge: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: _pastelSecondary,
        ),
        headlineMedium: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w500,
          color: _pastelSecondary,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: _pastelSecondary,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: _pastelSecondary,
        ),
        labelLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: _pastelSecondary,
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: _darkBlueSecondary,
        foregroundColor: _pastelSecondary,
        elevation: 0,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: _pastelSecondary,
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: _darkBlueSecondary,
        selectedItemColor: _darkBlueAccent,
        unselectedItemColor: _darkBlueLight,
        selectedLabelStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.normal,
        ),
      ),
      cardTheme: CardThemeData(
        color: _darkBlueSecondary,
        elevation: 4,
        shadowColor: Colors.black.withOpacity(0.3),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFFBE79DF), // Mor renk
          foregroundColor: _pastelSecondary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: Color(0xFFBE79DF), // Mor renk
        foregroundColor: _pastelSecondary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}
