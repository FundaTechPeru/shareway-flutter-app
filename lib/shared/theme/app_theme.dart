import 'package:flutter/material.dart';

abstract final class ShareWayColors {
  static const primary = Color(0xFF0F6F73);
  static const primaryDark = Color(0xFF0A4655);
  static const primarySoft = Color(0xFFD9EEF2);
  static const accent = Color(0xFFF2A31B);
  static const success = Color(0xFF1B8B64);
  static const error = Color(0xFFC2362B);
  static const warning = Color(0xFF9A5B00);
  static const ink = Color(0xFF132329);
  static const secondaryInk = Color(0xFF475F66);
  static const muted = Color(0xFF73858B);
  static const border = Color(0xFFD5E0E3);
  static const surface = Color(0xFFF4F7F8);
  static const pale = Color(0xFFEAF0F2);
}

abstract final class AppTheme {
  static ThemeData get light {
    final scheme =
        ColorScheme.fromSeed(
          seedColor: ShareWayColors.primary,
          brightness: Brightness.light,
        ).copyWith(
          primary: ShareWayColors.primary,
          onPrimary: Colors.white,
          secondary: ShareWayColors.accent,
          error: ShareWayColors.error,
          surface: Colors.white,
        );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: ShareWayColors.surface,
      fontFamily: 'Roboto',
      appBarTheme: const AppBarTheme(
        backgroundColor: ShareWayColors.surface,
        foregroundColor: ShareWayColors.ink,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: ShareWayColors.ink,
          fontSize: 19,
          fontWeight: FontWeight.w600,
        ),
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: const BorderSide(color: ShareWayColors.border),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        height: 70,
        backgroundColor: Colors.white,
        indicatorColor: ShareWayColors.primarySoft,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return TextStyle(
            color: selected ? ShareWayColors.primaryDark : ShareWayColors.muted,
            fontSize: 11,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
          );
        }),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: ShareWayColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: ShareWayColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: ShareWayColors.primary,
            width: 1.5,
          ),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(50),
          backgroundColor: ShareWayColors.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size.fromHeight(48),
          foregroundColor: ShareWayColors.primaryDark,
          side: const BorderSide(color: ShareWayColors.border),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ),
      textTheme: const TextTheme(
        headlineSmall: TextStyle(
          color: ShareWayColors.ink,
          fontSize: 24,
          fontWeight: FontWeight.w700,
        ),
        titleLarge: TextStyle(
          color: ShareWayColors.ink,
          fontSize: 19,
          fontWeight: FontWeight.w600,
        ),
        titleMedium: TextStyle(
          color: ShareWayColors.ink,
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: TextStyle(color: ShareWayColors.ink, fontSize: 15),
        bodyMedium: TextStyle(color: ShareWayColors.secondaryInk, fontSize: 13),
        bodySmall: TextStyle(color: ShareWayColors.muted, fontSize: 12),
      ),
    );
  }
}
