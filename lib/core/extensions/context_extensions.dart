import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Convenient extensions on BuildContext for common operations.
extension ContextExtensions on BuildContext {
  /// Access ThemeData.
  ThemeData get theme => Theme.of(this);

  /// Access ColorScheme.
  ColorScheme get colorScheme => theme.colorScheme;

  /// Access MediaQuery size.
  Size get screenSize => MediaQuery.of(this).size;

  /// Access screen width.
  double get screenWidth => screenSize.width;

  /// Access screen height.
  double get screenHeight => screenSize.height;

  /// Check if current theme is dark.
  bool get isDark => theme.brightness == Brightness.dark;

  /// Get primary text color based on theme.
  Color get textPrimary =>
      isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;

  /// Get secondary text color based on theme.
  Color get textSecondary =>
      isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

  /// Get tertiary text color based on theme.
  Color get textTertiary =>
      isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary;

  /// Show a snackbar.
  void showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: isError ? AppColors.error : null,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  /// Bottom safe area padding.
  double get bottomPadding => MediaQuery.of(this).padding.bottom;

  /// Space to reserve at the bottom of scrollable content on the main tab
  /// screens so the last item isn't hidden behind the floating bottom nav bar.
  /// (nav height 68 + 12 margin + breathing room + device safe-area inset)
  double get bottomNavInset => 96 + bottomPadding;

  /// Bottom offset for a [FloatingActionButton] so it floats clear of the
  /// floating bottom navigation bar.
  double get fabBottomInset => 72 + bottomPadding;

  /// Top safe area padding.
  double get topPadding => MediaQuery.of(this).padding.top;
}
