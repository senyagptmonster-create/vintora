import 'package:flutter/material.dart';

class BrewColors {
  BrewColors._();

  static const Color espresso = Color(0xFF2C1810);
  static const Color mocha = Color(0xFF3E2723);
  static const Color roastAmber = Color(0xFFC87D43);
  static const Color crema = Color(0xFFE8B878);
  static const Color latteCream = Color(0xFFFBF8F5);
  static const Color warmParchment = Color(0xFFF3ECE4);
  static const Color cardSurface = Color(0xFFFFFFFF);
  static const Color borderMuted = Color(0xFFE2D6C7);

  static const Color textDark = Color(0xFF1E140E);
  static const Color textMuted = Color(0xFF7A685A);
  static const Color sageAccent = Color(0xFF5E8B7E);
}

class BrewTheme {
  BrewTheme._();

  static ThemeData themeData() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: BrewColors.latteCream,
      colorScheme: const ColorScheme.light(
        primary: BrewColors.roastAmber,
        secondary: BrewColors.crema,
        surface: BrewColors.cardSurface,
        onPrimary: Colors.white,
        onSurface: BrewColors.textDark,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: BrewColors.latteCream,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: BrewColors.espresso,
        ),
        iconTheme: IconThemeData(color: BrewColors.espresso),
      ),
      cardTheme: CardThemeData(
        color: BrewColors.cardSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: BrewColors.borderMuted),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: BrewColors.cardSurface,
        indicatorColor: BrewColors.roastAmber.withValues(alpha: 0.15),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const TextStyle(
              color: BrewColors.roastAmber,
              fontWeight: FontWeight.w700,
              fontSize: 12,
            );
          }
          return const TextStyle(
            color: BrewColors.textMuted,
            fontWeight: FontWeight.w500,
            fontSize: 12,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: BrewColors.roastAmber);
          }
          return const IconThemeData(color: BrewColors.textMuted);
        }),
      ),
    );
  }
}
