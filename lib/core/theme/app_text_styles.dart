import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Typography system using Google Fonts "Outfit".
/// Provides consistent text styles across the app.
class AppTextStyles {
  AppTextStyles._();

  static String get _fontFamily => GoogleFonts.outfit().fontFamily!;

  // ─── Display ───────────────────────────────────────────────
  static TextStyle get display => TextStyle(
    fontFamily: _fontFamily,
    fontSize: 32,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
    height: 1.2,
  );

  // ─── Headings ──────────────────────────────────────────────
  static TextStyle get h1 => TextStyle(
    fontFamily: _fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.3,
    height: 1.3,
  );

  static TextStyle get h2 => TextStyle(
    fontFamily: _fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.2,
    height: 1.3,
  );

  static TextStyle get h3 => TextStyle(
    fontFamily: _fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 1.4,
  );

  // ─── Body ──────────────────────────────────────────────────
  static TextStyle get bodyLarge => TextStyle(
    fontFamily: _fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  static TextStyle get body => TextStyle(
    fontFamily: _fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  static TextStyle get bodySmall => TextStyle(
    fontFamily: _fontFamily,
    fontSize: 13,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  // ─── Caption & Labels ─────────────────────────────────────
  static TextStyle get caption => TextStyle(
    fontFamily: _fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.4,
    letterSpacing: 0.2,
  );

  static TextStyle get overline => TextStyle(
    fontFamily: _fontFamily,
    fontSize: 10,
    fontWeight: FontWeight.w600,
    height: 1.4,
    letterSpacing: 1.5,
  );

  // ─── Button ────────────────────────────────────────────────
  static TextStyle get button => TextStyle(
    fontFamily: _fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.2,
    letterSpacing: 0.3,
  );

  static TextStyle get buttonSmall => TextStyle(
    fontFamily: _fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.2,
    letterSpacing: 0.3,
  );

  // ─── Input ─────────────────────────────────────────────────
  static TextStyle get input => TextStyle(
    fontFamily: _fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.4,
  );

  static TextStyle get inputLabel => TextStyle(
    fontFamily: _fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.4,
    letterSpacing: 0.1,
  );
}
