import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';
import 'app_spacing.dart';

/// Complete ThemeData configuration for the app.
/// Light mode is the default theme.
class AppTheme {
  AppTheme._();

  // ─── Light Theme (Default) ─────────────────────────────────
  static ThemeData get light => ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: AppColors.primaryOrange,
    scaffoldBackgroundColor: Colors.transparent,
    fontFamily: GoogleFonts.outfit().fontFamily,
    colorScheme: const ColorScheme.light(
      primary: AppColors.primaryOrange,
      primaryContainer: AppColors.primaryOrangeLight,
      secondary: AppColors.secondarySlate,
      secondaryContainer: AppColors.secondarySlateDark,
      error: AppColors.error,
      surface: AppColors.lightSurface,
      onPrimary: Colors.white,
      onSecondary: Colors.black,
      onSurface: AppColors.lightTextPrimary,
      onError: Colors.white,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: true,
      iconTheme: IconThemeData(color: AppColors.lightTextPrimary),
      titleTextStyle: TextStyle(
        color: AppColors.lightTextPrimary,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.transparent,
      elevation: 0,
      selectedItemColor: AppColors.primaryOrange,
      unselectedItemColor: AppColors.lightTextTertiary,
      type: BottomNavigationBarType.fixed,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.lg,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        borderSide: const BorderSide(
          color: Color(0xFFCBD5E1),
          width: 1.0,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        borderSide: const BorderSide(
          color: Color(0xFFE2E8F0),
          width: 1.0,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        borderSide: const BorderSide(
          color: AppColors.primaryOrange,
          width: 1.5,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        borderSide: const BorderSide(
          color: AppColors.error,
          width: 1.0,
        ),
      ),
      hintStyle: TextStyle(
        color: AppColors.lightTextTertiary,
        fontSize: 14,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryOrange,
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, AppSpacing.buttonHeight),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        ),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.3,
        ),
        elevation: 0,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primaryOrange,
        textStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    cardTheme: CardThemeData(
      color: Colors.white.withValues(alpha: 0.5),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
      ),
    ),
    dividerTheme: DividerThemeData(
      color: AppColors.lightTextTertiary.withValues(alpha: 0.2),
      thickness: 1,
    ),
  );

  // ─── Dark Theme ────────────────────────────────────────────
  static ThemeData get dark => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: AppColors.primaryOrange,
    scaffoldBackgroundColor: Colors.transparent,
    fontFamily: GoogleFonts.outfit().fontFamily,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.primaryOrange,
      primaryContainer: AppColors.primaryOrangeDark,
      secondary: AppColors.secondarySlate,
      secondaryContainer: AppColors.secondarySlateDark,
      error: AppColors.error,
      surface: AppColors.darkSurface,
      onPrimary: Colors.white,
      onSecondary: Colors.black,
      onSurface: AppColors.darkTextPrimary,
      onError: Colors.white,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: true,
      iconTheme: IconThemeData(color: AppColors.darkTextPrimary),
      titleTextStyle: TextStyle(
        color: AppColors.darkTextPrimary,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.transparent,
      elevation: 0,
      selectedItemColor: AppColors.primaryOrangeLight,
      unselectedItemColor: AppColors.darkTextTertiary,
      type: BottomNavigationBarType.fixed,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white.withValues(alpha: 0.03),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.lg,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        borderSide: BorderSide(
          color: Colors.white.withValues(alpha: 0.08),
          width: 1.0,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        borderSide: BorderSide(
          color: Colors.white.withValues(alpha: 0.08),
          width: 1.0,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        borderSide: const BorderSide(
          color: AppColors.primaryOrangeLight,
          width: 1.5,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        borderSide: const BorderSide(
          color: AppColors.error,
          width: 1.0,
        ),
      ),
      hintStyle: TextStyle(
        color: AppColors.darkTextTertiary,
        fontSize: 14,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryOrange,
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, AppSpacing.buttonHeight),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        ),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.3,
        ),
        elevation: 0,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primaryOrangeLight,
        textStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    cardTheme: CardThemeData(
      color: Colors.white.withValues(alpha: 0.06),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
      ),
    ),
    dividerTheme: DividerThemeData(
      color: Colors.white.withValues(alpha: 0.08),
      thickness: 1,
    ),
  );
}
