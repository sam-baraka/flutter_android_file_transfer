import 'package:flutter/material.dart';

class AppTheme {
  static const primaryBlue = Color(0xFF007AFF);
  static const accentGreen = Color(0xFF34C759);
  static const warningOrange = Color(0xFFFF9500);
  static const errorRed = Color(0xFFFF3B30);

  static final lightColorScheme = ColorScheme.light(
    primary: primaryBlue,
    secondary: accentGreen,
    surface: Colors.white,
    background: const Color(0xFFF2F2F7),
    error: errorRed,
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onSurface: Colors.black,
    onBackground: Colors.black,
    onError: Colors.white,
  );

  static final darkColorScheme = ColorScheme.dark(
    primary: primaryBlue,
    secondary: accentGreen,
    surface: const Color(0xFF1C1C1E),
    background: const Color(0xFF000000),
    error: errorRed,
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onSurface: Colors.white,
    onBackground: Colors.white,
    onError: Colors.white,
  );

  static ThemeData light() {
    return ThemeData(
      colorScheme: lightColorScheme,
      useMaterial3: true,
      cardTheme: CardTheme(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: lightColorScheme.outline.withOpacity(0.1),
          ),
        ),
      ),
      listTileTheme: ListTileThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        selectedTileColor: lightColorScheme.primary.withOpacity(0.1),
      ),
    );
  }

  static ThemeData dark() {
    return ThemeData(
      colorScheme: darkColorScheme,
      useMaterial3: true,
      cardTheme: CardTheme(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: darkColorScheme.outline.withOpacity(0.1),
          ),
        ),
      ),
      listTileTheme: ListTileThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        selectedTileColor: darkColorScheme.primary.withOpacity(0.2),
      ),
    );
  }
}

// Animation Durations
class AppAnimations {
  static const Duration fast = Duration(milliseconds: 200);
  static const Duration medium = Duration(milliseconds: 300);
  static const Duration slow = Duration(milliseconds: 400);

  static final Curve easeOutCurve = Curves.easeOutCubic;
  static final Curve easeInCurve = Curves.easeInCubic;
}
