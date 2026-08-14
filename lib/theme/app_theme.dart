import 'package:flutter/material.dart';

class AppTheme {
  static const Color primary = Colors.teal;
  static const Color background = Colors.white;
  static const Color textDark = Color(0xFF333333);
  static const Color textLight = Color(0xFF7B8D9E);

  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      primarySwatch: Colors.blue,
    );
  }
}
