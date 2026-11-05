import 'package:flutter/material.dart';

class AppTheme {
  static const Color green = Color(0xFF1DB954);

  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF121212),
        colorScheme: const ColorScheme.dark(
          primary: green,
          onPrimary: Colors.black,
          surface: Color(0xFF121212),
          surfaceContainerHighest: Color(0xFF282828),
        ),
      );

  static ThemeData get light => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFF6F6F6),
        colorScheme: const ColorScheme.light(
          primary: green,
          onPrimary: Colors.black,
          surface: Color(0xFFF6F6F6),
          surfaceContainerHighest: Color(0xFFE6E6E6),
        ),
      );
}
