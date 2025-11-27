import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get light => ThemeData(
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF3B82F6),
      secondary: Color(0xFF6366F1),
      surface: Color(0xFF121212),
      onSurface: Colors.white,
    ),
    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: Colors.white70),
      titleLarge: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
    ),
    cardTheme: CardThemeData(
      color: const Color(0xFF1E1E2A),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
  );

  static ThemeData get dark => light;
}
