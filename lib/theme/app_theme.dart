import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const teal = Color(0xFF00BFA5);
  static const tealDark = Color(0xFF00897B);
  static const tealLight = Color(0xFFB2DFDB);
  static const tealGlow = Color(0x2900BFA5);
  static const tealSurface = Color(0xFFE0F7FA);

  static const slate = Color(0xFF1A2A2A);
  static const slateDeep = Color(0xFF111D1D);
  static const slateMid = Color(0xFF263238);

  static const white = Color(0xFFFFFFFF);
  static const offWhite = Color(0xFFF4FAFA);
  static const muted = Color(0xFF607D7D);
  static const border = Color(0x2900BFA5);

  static const blue = Color(0xFF1565C0);
  static const blueLight = Color(0xFFE3F2FD);
  static const orange = Color(0xFFE65100);
  static const orangeLight = Color(0xFFFFF3E0);
  static const green = Color(0xFF2E7D32);
  static const greenLight = Color(0xFFE8F5E9);

  static const cardBorder = Color(0x0D000000);
  static const divider = Color(0x0F000000);

  static const cooledBlue = Color(0xFF4FC3F7);
  static const cooledSurface = Color(0xFFE3F2FD);

  // Status
  static const available = Color(0xFF00BFA5);
  static const occupied = Color(0xFFB0BEC5);
  static const myLocker = Color(0xFF00BFA5);
}

class AppTheme {
  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.teal,
        brightness: Brightness.light,
        primary: AppColors.teal,
        secondary: AppColors.tealDark,
        surface: AppColors.offWhite,
      ),
      scaffoldBackgroundColor: AppColors.offWhite,
      textTheme: _buildTextTheme(),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.offWhite,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleTextStyle: GoogleFonts.syne(
          fontSize: 20,
          fontWeight: FontWeight.w800,
          color: AppColors.slate,
        ),
        iconTheme: const IconThemeData(color: AppColors.slate),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.teal,
          foregroundColor: Colors.white,
          elevation: 0,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: GoogleFonts.dmSans(
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.slate,
          side: const BorderSide(color: AppColors.border),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: AppColors.cardBorder),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: AppColors.teal.withOpacity(0.2)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.teal, width: 2),
        ),
        labelStyle: GoogleFonts.dmSans(color: AppColors.muted),
        hintStyle: GoogleFonts.dmSans(color: AppColors.muted),
      ),
    );
  }

  static TextTheme _buildTextTheme() {
    return TextTheme(
      displayLarge: GoogleFonts.syne(
        fontSize: 48,
        fontWeight: FontWeight.w800,
        color: AppColors.slate,
      ),
      displayMedium: GoogleFonts.syne(
        fontSize: 36,
        fontWeight: FontWeight.w800,
        color: AppColors.slate,
      ),
      displaySmall: GoogleFonts.syne(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: AppColors.slate,
      ),
      headlineLarge: GoogleFonts.syne(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: AppColors.slate,
      ),
      headlineMedium: GoogleFonts.syne(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: AppColors.slate,
      ),
      headlineSmall: GoogleFonts.syne(
        fontSize: 17,
        fontWeight: FontWeight.w700,
        color: AppColors.slate,
      ),
      titleLarge: GoogleFonts.dmSans(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.slate,
      ),
      titleMedium: GoogleFonts.dmSans(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.slate,
      ),
      titleSmall: GoogleFonts.dmSans(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: AppColors.muted,
      ),
      bodyLarge: GoogleFonts.dmSans(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        color: AppColors.slate,
      ),
      bodyMedium: GoogleFonts.dmSans(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppColors.slate,
      ),
      bodySmall: GoogleFonts.dmSans(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: AppColors.muted,
      ),
      labelLarge: GoogleFonts.dmSans(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: AppColors.slate,
      ),
      labelSmall: GoogleFonts.dmSans(
        fontSize: 10,
        fontWeight: FontWeight.w600,
        color: AppColors.muted,
        letterSpacing: 1.5,
      ),
    );
  }
}
