import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GlassThemeExtension extends ThemeExtension<GlassThemeExtension> {
  final Color glassBgColor;
  final Color glassBorderColor;
  final double glassBlur;

  const GlassThemeExtension({
    required this.glassBgColor,
    required this.glassBorderColor,
    required this.glassBlur,
  });

  @override
  ThemeExtension<GlassThemeExtension> copyWith({
    Color? glassBgColor,
    Color? glassBorderColor,
    double? glassBlur,
  }) {
    return GlassThemeExtension(
      glassBgColor: glassBgColor ?? this.glassBgColor,
      glassBorderColor: glassBorderColor ?? this.glassBorderColor,
      glassBlur: glassBlur ?? this.glassBlur,
    );
  }

  @override
  ThemeExtension<GlassThemeExtension> lerp(
      covariant ThemeExtension<GlassThemeExtension>? other, double t) {
    if (other is! GlassThemeExtension) {
      return this;
    }
    return GlassThemeExtension(
      glassBgColor: Color.lerp(glassBgColor, other.glassBgColor, t)!,
      glassBorderColor:
          Color.lerp(glassBorderColor, other.glassBorderColor, t)!,
      glassBlur: lerpDouble(glassBlur, other.glassBlur, t) ?? glassBlur,
    );
  }
}

class AppTheme {
  // Estandarización de Radios de Borde (Border Radius)
  static const double borderRadiusLarge = 24.0;
  static const double borderRadiusMedium = 16.0;
  static const double borderRadiusSmall = 12.0;

  static ThemeData getTheme(
      {required bool isDark, required Color primaryColor}) {
    final brightness = isDark ? Brightness.dark : Brightness.light;

    // Backgrounds
    final backgroundColor =
        isDark ? const Color(0xFF0a120d) : const Color(0xFFF5F8F7);
    final surfaceColor = isDark ? const Color(0xFF102217) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF0a120d);
    final textMuted = isDark ? Colors.white60 : const Color(0xFF475569);

    // Glassmorphism properties
    final glassBg = isDark
        ? surfaceColor.withValues(alpha: 0.7)
        : Colors.white.withValues(alpha: 0.6);
    final glassBorder = isDark
        ? Colors.white.withValues(alpha: 0.05)
        : Colors.black.withValues(alpha: 0.05);

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      scaffoldBackgroundColor: backgroundColor,
      colorScheme: ColorScheme(
        brightness: brightness,
        primary: primaryColor,
        onPrimary: isDark ? const Color(0xFF0a120d) : Colors.white,
        secondary: primaryColor.withValues(alpha: 0.8),
        onSecondary: Colors.white,
        error: Colors.redAccent,
        onError: Colors.white,
        surface: surfaceColor,
        onSurface: textColor,
        surfaceContainerHighest:
            isDark ? const Color(0xFF1c2433) : const Color(0xFFEef2f0),
      ),
      extensions: [
        GlassThemeExtension(
          glassBgColor: glassBg,
          glassBorderColor: glassBorder,
          glassBlur: 15.0,
        ),
      ],
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.manrope(
          color: textColor,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      cardTheme: CardThemeData(
        color: surfaceColor,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      textTheme: GoogleFonts.manropeTextTheme(TextTheme(
        displayLarge: TextStyle(
            color: textColor, fontSize: 32, fontWeight: FontWeight.bold),
        displayMedium: TextStyle(
            color: textColor, fontSize: 28, fontWeight: FontWeight.bold),
        headlineLarge: TextStyle(
            color: textColor, fontSize: 24, fontWeight: FontWeight.w800),
        headlineMedium: TextStyle(
            color: textColor, fontSize: 20, fontWeight: FontWeight.w600),
        titleLarge: TextStyle(
            color: textColor, fontSize: 18, fontWeight: FontWeight.w500),
        titleMedium: TextStyle(color: textColor, fontSize: 16),
        bodyLarge: TextStyle(color: textColor, fontSize: 16),
        bodyMedium: TextStyle(color: textMuted, fontSize: 14),
        bodySmall: TextStyle(color: textMuted, fontSize: 12),
      )),
    );
  }
}
