import 'package:flutter/material.dart';

class AppTheme {
  static const Color primary = Colors.teal;
  static const Color background = Colors.white;
  static const Color textDark = Color(0xFF333333);
  static const Color textLight = Color(0xFF7B8D9E);

  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: background,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        surface: background,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: background,
        foregroundColor: primary,
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: primary),
      ),
      textTheme: const TextTheme(
        titleLarge: TextStyle(color: textDark, fontWeight: FontWeight.bold),
        bodyLarge: TextStyle(color: textDark),
        bodyMedium: TextStyle(color: textLight),
      ),
      cardTheme: const CardThemeData(
        color: background,
        elevation: 0,
        margin: EdgeInsets.symmetric(vertical: 8),
      ),
    );
  }
}
