import 'package:flutter/material.dart';

class VintoraTheme {
  static const bg = Color(0xFFFAF7F2);
  static const surface = Color(0xFFFFFFFF);
  static const edge = Color(0xFFE8DFD5);
  static const accent = Color(0xFF854D0E); // Deep amber brown
  static const accentLight = Color(0xFFCA8A04);
  static const ink = Color(0xFF2E1C0A);
  static const muted = Color(0xFF78716C);

  static ThemeData get themeData {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: bg,
      fontFamily: 'AppFont',
      primaryColor: accent,
      colorScheme: const ColorScheme.light(
        primary: accent,
        surface: surface,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: surface,
        elevation: 0,
        foregroundColor: ink,
        iconTheme: IconThemeData(color: ink),
      ),
    );
  }
}
