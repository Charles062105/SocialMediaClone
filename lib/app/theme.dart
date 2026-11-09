import 'package:flutter/material.dart';

/// Provides the shared monochrome TIKTOKTOK theme.
abstract final class AppTheme {
  /// Creates the light application theme.
  static ThemeData get light {
    const black = Color(0xFF111111);
    const red = Color(0xFFE53935);
    final scheme = ColorScheme.fromSeed(
      seedColor: black,
      brightness: Brightness.light,
    ).copyWith(primary: black, secondary: red, tertiary: Colors.blue);
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: const Color(0xFFF5F5F5),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFFF5F5F5),
        foregroundColor: black,
        elevation: 0,
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 2,
        shadowColor: const Color(0x14000000),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFFF3F3F3),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: black, width: 1.5),
        ),
      ),
    );
  }
}
