import 'package:flutter/material.dart';

/// App-wide color palette supporting light and dark themes.
/// Uses a deep purple/indigo + electric cyan palette with
/// glassmorphism-optimized transparency values.
class AppColors {
  AppColors._();

  // ─── Primary Palette ───────────────────────────────────────
  static const Color primaryOrange = Color(0xFFFF6B00); // Vibrant Neon Orange
  static const Color primaryOrangeLight = Color(0xFFFF983F); // Soft Vibrant Orange
  static const Color primaryOrangeDark = Color(0xFFE65100); // Deep Vibrant Orange

  // ─── Secondary / Accent ────────────────────────────────────
  static const Color secondarySlate = Color(0xFF64748B); // Modern Slate
  static const Color secondarySlateDark = Color(0xFF0F172A); // Deep Slate
  static const Color accentTeal = Color(0xFF14B8A6); // Vibrant Teal

  // ─── Semantic Colors ───────────────────────────────────────
  static const Color success = Color(0xFF10B981); // Mint Green
  static const Color warning = Color(0xFFF59E0B); // Amber Gold
  static const Color error = Color(0xFFEF4444); // Rose Red
  static const Color info = Color(0xFF3B82F6); // Bright Blue

  // ─── Light Mode ────────────────────────────────────────────
  static const Color lightBackground = Color(0xFFF8FAFC); // Slate-50 Background
  static const Color lightBackgroundEnd = Color(0xFFE2E8F0); // Slate-200 Soft End
  static const Color lightSurface = Color(0xFFFFFFFF); // Clean White
  static const Color lightTextPrimary = Color(0xFF0F172A); // Slate-900 Primary Text
  static const Color lightTextSecondary = Color(0xFF475569); // Slate-600 Secondary Text
  static const Color lightTextTertiary = Color(0xFF94A3B8); // Slate-400 Subtle Text

  static Color lightGlassFill = Colors.white.withValues(alpha: 0.55);
  static Color lightGlassBorder = Colors.white.withValues(alpha: 0.70);
  static Color lightGlassShadow = Colors.black.withValues(alpha: 0.04);

  // ─── Dark Mode ─────────────────────────────────────────────
  static const Color darkBackground = Color(0xFF020617); // Deep Slate 950
  static const Color darkBackgroundEnd = Color(0xFF0F172A); // Slate 900
  static const Color darkSurface = Color(0xFF1E293B); // Slate 800 Surface
  static const Color darkTextPrimary = Color(0xFFF8FAFC); // Crisp White Text
  static const Color darkTextSecondary = Color(0xFFCBD5E1); // Light Gray Text
  static const Color darkTextTertiary = Color(0xFF94A3B8); // Muted Gray Text

  static Color darkGlassFill = Colors.white.withValues(alpha: 0.06);
  static Color darkGlassBorder = Colors.white.withValues(alpha: 0.12);
  static Color darkGlassShadow = Colors.black.withValues(alpha: 0.20);

  // ─── Gradient Presets ──────────────────────────────────────
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryOrange, primaryOrangeDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient lightBackgroundGradient = LinearGradient(
    colors: [lightBackground, lightBackgroundEnd, Color(0xFFF1F5F9)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient darkBackgroundGradient = LinearGradient(
    colors: [darkBackground, darkBackgroundEnd],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [primaryOrange, accentTeal],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
