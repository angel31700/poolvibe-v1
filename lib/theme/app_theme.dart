import 'package:flutter/material.dart';

/// PoolVibe brand colors and theme.
/// Deep water blues + clean white + accent teal.
abstract class AppColors {
  static const deepBlue   = Color(0xFF0A1628); // primary background
  static const poolBlue   = Color(0xFF1A3A5C); // card / surface
  static const waterTeal  = Color(0xFF00C4CC); // primary accent
  static const sunYellow  = Color(0xFFFFD700); // warning / confidence
  static const alertRed   = Color(0xFFFF4444); // danger / flag
  static const successGreen = Color(0xFF2ECC71);
  static const white      = Color(0xFFFFFFFF);
  static const textPrimary   = Color(0xFFFFFFFF);
  static const textSecondary = Color(0xFFB0C4D8);
  static const cardSurface   = Color(0xFF1E3A5F);
  static const inputFill     = Color(0xFF152D4A);
}

abstract class AppTheme {
  static final light = _buildTheme(Brightness.light);
  static final dark  = _buildTheme(Brightness.dark);

  static ThemeData _buildTheme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: ColorScheme(
        brightness: brightness,
        primary: AppColors.waterTeal,
        onPrimary: AppColors.deepBlue,
        secondary: AppColors.sunYellow,
        onSecondary: AppColors.deepBlue,
        error: AppColors.alertRed,
        onError: AppColors.white,
        surface: isDark ? AppColors.poolBlue : const Color(0xFFF5F9FF),
        onSurface: isDark ? AppColors.textPrimary : AppColors.deepBlue,
      ),
      scaffoldBackgroundColor: isDark ? AppColors.deepBlue : const Color(0xFFF0F6FF),
      cardColor: isDark ? AppColors.cardSurface : AppColors.white,
      appBarTheme: AppBarTheme(
        backgroundColor: isDark ? AppColors.deepBlue : AppColors.white,
        foregroundColor: isDark ? AppColors.white : AppColors.deepBlue,
        elevation: 0,
        centerTitle: true,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.waterTeal,
          foregroundColor: AppColors.deepBlue,
          minimumSize: const Size.fromHeight(52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark ? AppColors.inputFill : const Color(0xFFEAF4FF),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.waterTeal, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        hintStyle: TextStyle(
          color: isDark ? AppColors.textSecondary : Colors.grey,
        ),
      ),
      textTheme: TextTheme(
        headlineLarge: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w800,
          color: isDark ? AppColors.white : AppColors.deepBlue,
          letterSpacing: -0.5,
        ),
        headlineMedium: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: isDark ? AppColors.white : AppColors.deepBlue,
        ),
        titleLarge: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: isDark ? AppColors.white : AppColors.deepBlue,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          color: isDark ? AppColors.textPrimary : AppColors.deepBlue,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          color: isDark ? AppColors.textSecondary : Colors.grey.shade700,
        ),
      ),
    );
  }
}
