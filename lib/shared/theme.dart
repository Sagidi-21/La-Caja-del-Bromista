import 'package:flutter/material.dart';

class AppTheme {
  // Colores Premium (Fase MVP - Coincidentes con HTML)
  static const Color background = Color(0xFF0E0E0E);
  static const Color surface = Color(0xFF1A1919);
  static const Color primaryNeon = Color(0xFFDDFFAE); 
  static const Color secondaryNeon = Color(0xFFD873FF);
  static const Color tertiaryNeon = Color(0xFFFF7E3F);
  static const Color textBody = Colors.white;

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: background,
      primaryColor: primaryNeon,
      colorScheme: const ColorScheme.dark(
        primary: primaryNeon,
        secondary: secondaryNeon,
        tertiary: tertiaryNeon,
        surface: surface,
      ),
      fontFamily: 'Manrope', // Siguiendo la fuente del HTML
      textTheme: const TextTheme(
        headlineMedium: TextStyle(
          color: primaryNeon,
          fontWeight: FontWeight.bold,
          letterSpacing: -1,
        ),
        bodyLarge: TextStyle(color: textBody),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: surface,
          foregroundColor: primaryNeon,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: Colors.white10),
          ),
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        ),
      ),
    );
  }
}
