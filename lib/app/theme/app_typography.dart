import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTypography {
  static const String headingFont = 'Manrope';
  static const String bodyFont = 'Inter';

  static TextStyle get h1 => GoogleFonts.getFont(
        headingFont,
        fontSize: 32,
        fontWeight: FontWeight.bold,
        letterSpacing: -0.5,
      );

  static TextStyle get h2 => GoogleFonts.getFont(
        headingFont,
        fontSize: 24,
        fontWeight: FontWeight.bold,
        letterSpacing: -0.5,
      );

  static TextStyle get h3 => GoogleFonts.getFont(
        headingFont,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      );

  static TextStyle get bodyLarge => GoogleFonts.getFont(
        bodyFont,
        fontSize: 16,
        fontWeight: FontWeight.normal,
      );

  static TextStyle get bodyMedium => GoogleFonts.getFont(
        bodyFont,
        fontSize: 14,
        fontWeight: FontWeight.normal,
      );

  static TextStyle get caption => GoogleFonts.getFont(
        bodyFont,
        fontSize: 12,
        fontWeight: FontWeight.normal,
      );
}
