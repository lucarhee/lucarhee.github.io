import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Brand colors
  static const Color primary = Color(0xFF8B5CF6);       // Purple
  static const Color secondary = Color(0xFF06B6D4);     // Cyan
  static const Color accent = Color(0xFFF59E0B);        // Amber
  static const Color success = Color(0xFF10B981);       // Emerald

  // Gradient
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF8B5CF6), Color(0xFF06B6D4)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient heroGradient = LinearGradient(
    colors: [Color(0xFF0f0f23), Color(0xFF1a1a3e), Color(0xFF0f1a2e)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Tag colors by index
  static const List<Color> tagColors = [
    Color(0xFF8B5CF6),
    Color(0xFF06B6D4),
    Color(0xFFF59E0B),
    Color(0xFF10B981),
    Color(0xFFEF4444),
    Color(0xFFEC4899),
  ];

  static Color tagColor(String tag) {
    final idx = tag.codeUnits.fold(0, (a, b) => a + b) % tagColors.length;
    return tagColors[idx];
  }

  // ── DARK THEME ──────────────────────────────────────────────────────────────
  static ThemeData get dark {
    const background = Color(0xFF0B0B1A);
    const surface = Color(0xFF13132A);
    const card = Color(0xFF1C1C38);
    const onBackground = Color(0xFFF1F5F9);
    const onSurface = Color(0xFFCBD5E1);
    const border = Color(0xFF2D2D52);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: primary,
        secondary: secondary,
        surface: surface,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: onSurface,
      ),
      scaffoldBackgroundColor: background,
      cardColor: card,
      dividerColor: border,
      textTheme: GoogleFonts.interTextTheme(
        ThemeData.dark().textTheme,
      ).copyWith(
        displayLarge: GoogleFonts.poppins(
          fontSize: 56,
          fontWeight: FontWeight.w700,
          color: onBackground,
          height: 1.1,
        ),
        displayMedium: GoogleFonts.poppins(
          fontSize: 40,
          fontWeight: FontWeight.w700,
          color: onBackground,
        ),
        headlineLarge: GoogleFonts.poppins(
          fontSize: 32,
          fontWeight: FontWeight.w600,
          color: onBackground,
        ),
        headlineMedium: GoogleFonts.poppins(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: onBackground,
        ),
        titleLarge: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: onBackground,
        ),
        bodyLarge: GoogleFonts.inter(
          fontSize: 16,
          color: onSurface,
          height: 1.7,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 14,
          color: onSurface,
          height: 1.6,
        ),
        labelLarge: GoogleFonts.inter(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: onSurface,
          letterSpacing: 0.3,
        ),
        labelMedium: GoogleFonts.inter(
          fontSize: 12,
          color: onSurface.withOpacity(0.7),
          letterSpacing: 0.5,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: background.withOpacity(0.9),
        elevation: 0,
        scrolledUnderElevation: 0,
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: onBackground,
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: card,
        labelStyle: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        side: const BorderSide(color: border),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      ),
    );
  }

  // ── LIGHT THEME ─────────────────────────────────────────────────────────────
  static ThemeData get light {
    const background = Color(0xFFF8F9FF);
    const surface = Color(0xFFFFFFFF);
    const card = Color(0xFFFFFFFF);
    const onBackground = Color(0xFF0F172A);
    const onSurface = Color(0xFF475569);
    const border = Color(0xFFE2E8F0);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: primary,
        secondary: secondary,
        surface: surface,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: onSurface,
      ),
      scaffoldBackgroundColor: background,
      cardColor: card,
      dividerColor: border,
      textTheme: GoogleFonts.interTextTheme(
        ThemeData.light().textTheme,
      ).copyWith(
        displayLarge: GoogleFonts.poppins(
          fontSize: 56,
          fontWeight: FontWeight.w700,
          color: onBackground,
          height: 1.1,
        ),
        displayMedium: GoogleFonts.poppins(
          fontSize: 40,
          fontWeight: FontWeight.w700,
          color: onBackground,
        ),
        headlineLarge: GoogleFonts.poppins(
          fontSize: 32,
          fontWeight: FontWeight.w600,
          color: onBackground,
        ),
        headlineMedium: GoogleFonts.poppins(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: onBackground,
        ),
        titleLarge: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: onBackground,
        ),
        bodyLarge: GoogleFonts.inter(
          fontSize: 16,
          color: onSurface,
          height: 1.7,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 14,
          color: onSurface,
          height: 1.6,
        ),
        labelLarge: GoogleFonts.inter(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: onSurface,
          letterSpacing: 0.3,
        ),
        labelMedium: GoogleFonts.inter(
          fontSize: 12,
          color: onSurface.withOpacity(0.7),
          letterSpacing: 0.5,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: background.withOpacity(0.9),
        elevation: 0,
        scrolledUnderElevation: 0,
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: onBackground,
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: const Color(0xFFF1F5F9),
        labelStyle: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        side: const BorderSide(color: border),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      ),
    );
  }
}
