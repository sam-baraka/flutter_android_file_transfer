import 'package:flutter/material.dart';

class AppTheme {
  // Primary Colors
  static const primaryCyan = Color(0xFF00BCD4);
  static const accentOrange = Color(0xFFFF9800);
  static const energeticRed = Color(0xFFFF4081);
  static const sunshineYellow = Color(0xFFFFEB3B);
  static const playfulPink = Color(0xFFE91E63);

  // Supporting Colors
  static const lightCyan = Color(0xFFB2EBF2);
  static const lightOrange = Color(0xFFFFE0B2);
  static const lightPink = Color(0xFFF8BBD0);
  static const darkCyan = Color(0xFF006064);
  static const darkOrange = Color(0xFFE65100);

  static final lightColorScheme = ColorScheme.light(
    primary: primaryCyan,
    secondary: playfulPink,
    tertiary: accentOrange,
    error: energeticRed,
    surface: Colors.white,
    background: const Color(0xFFF5F8FA),
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onTertiary: Colors.white,
    onSurface: const Color(0xFF1A1A1A),
    onBackground: const Color(0xFF1A1A1A),
    onError: Colors.white,
    surfaceVariant: lightCyan,
    secondaryContainer: lightPink,
    tertiaryContainer: lightOrange,
  );

  static final darkColorScheme = ColorScheme.dark(
    primary: primaryCyan,
    secondary: playfulPink,
    tertiary: accentOrange,
    error: energeticRed,
    surface: const Color(0xFF1A1A1A),
    background: const Color(0xFF121212),
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onTertiary: Colors.white,
    onSurface: Colors.white,
    onBackground: Colors.white,
    onError: Colors.white,
    surfaceVariant: darkCyan,
    secondaryContainer: playfulPink.withOpacity(0.2),
    tertiaryContainer: darkOrange.withOpacity(0.2),
  );

  static ThemeData light() {
    return ThemeData(
      colorScheme: lightColorScheme,
      useMaterial3: true,
      cardTheme: CardTheme(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: lightColorScheme.outline.withOpacity(0.1),
          ),
        ),
      ),
      listTileTheme: ListTileThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        selectedTileColor: lightColorScheme.primary.withOpacity(0.1),
      ),
      iconTheme: IconThemeData(
        color: lightColorScheme.primary,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: lightColorScheme.secondary,
        foregroundColor: lightColorScheme.onSecondary,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: lightColorScheme.primary,
          foregroundColor: lightColorScheme.onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 16,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: lightColorScheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: lightColorScheme.surface,
        foregroundColor: lightColorScheme.onSurface,
        elevation: 0,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: lightColorScheme.surfaceVariant,
        selectedColor: lightColorScheme.primary,
        labelStyle: const TextStyle(fontSize: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
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
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: darkColorScheme.outline.withOpacity(0.1),
          ),
        ),
      ),
      listTileTheme: ListTileThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        selectedTileColor: darkColorScheme.primary.withOpacity(0.2),
      ),
      iconTheme: IconThemeData(
        color: darkColorScheme.primary,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: darkColorScheme.secondary,
        foregroundColor: darkColorScheme.onSecondary,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: darkColorScheme.primary,
          foregroundColor: darkColorScheme.onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 16,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: darkColorScheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: darkColorScheme.surface,
        foregroundColor: darkColorScheme.onSurface,
        elevation: 0,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: darkColorScheme.surfaceVariant,
        selectedColor: darkColorScheme.primary,
        labelStyle: const TextStyle(fontSize: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
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
  static final Curve bounceOut = Curves.bounceOut;
  static final Curve elasticOut = Curves.elasticOut;
}
