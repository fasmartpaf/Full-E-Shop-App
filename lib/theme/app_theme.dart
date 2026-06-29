import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Brand + design tokens for the "Ara" storefront.
///
/// Palette: deep indigo brand, warm coral accent for promos/CTAs,
/// teal for success states. Neutral cool-grey surfaces keep product
/// imagery the hero. Inline system (no external design system yet) —
/// swap for a connected design system later via flutter-theme-from-design.
class AppColors {
  static const brand = Color(0xFF4C3AE3); // indigo
  static const brandDark = Color(0xFF3A2BBF);
  static const accent = Color(0xFFFF6B5B); // coral – sale/CTA
  static const accentSoft = Color(0xFFFFE7E2);
  static const success = Color(0xFF12B886);
  static const warning = Color(0xFFF59F00);

  static const ink = Color(0xFF14151A);
  static const inkMuted = Color(0xFF6B7080);
  static const line = Color(0xFFE9EAF0);
  static const surface = Color(0xFFFFFFFF);
  static const canvas = Color(0xFFF6F7FB);

  // Pleasant category gradients used for image placeholders.
  static const List<List<Color>> tints = [
    [Color(0xFFEEF0FF), Color(0xFFDCE0FF)],
    [Color(0xFFFFF0EC), Color(0xFFFFDED6)],
    [Color(0xFFE7F8F1), Color(0xFFCDEFE2)],
    [Color(0xFFFFF6E0), Color(0xFFFCEBC0)],
    [Color(0xFFF1ECFF), Color(0xFFE2D6FF)],
    [Color(0xFFEAF4FF), Color(0xFFD3E8FF)],
  ];
}

class AppTheme {
  static const double radius = 18;

  static ThemeData light() {
    final scheme = const ColorScheme.light(
      primary: AppColors.brand,
      onPrimary: Colors.white,
      primaryContainer: Color(0xFFE5E2FF),
      onPrimaryContainer: AppColors.brandDark,
      secondary: AppColors.accent,
      onSecondary: Colors.white,
      secondaryContainer: AppColors.accentSoft,
      onSecondaryContainer: Color(0xFF8A2A1E),
      tertiary: AppColors.success,
      surface: AppColors.surface,
      onSurface: AppColors.ink,
      surfaceContainerHighest: Color(0xFFF0F1F6),
      outline: AppColors.line,
      error: Color(0xFFE03131),
    );

    final base = ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: AppColors.canvas,
      textTheme: GoogleFonts.manropeTextTheme().apply(
        bodyColor: AppColors.ink,
        displayColor: AppColors.ink,
      ),
    );

    return base.copyWith(
      appBarTheme: const AppBarTheme(
        centerTitle: false,
        backgroundColor: AppColors.canvas,
        foregroundColor: AppColors.ink,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleTextStyle: TextStyle(
          color: AppColors.ink,
          fontSize: 20,
          fontWeight: FontWeight.w800,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
          side: const BorderSide(color: AppColors.line),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.surface,
        selectedColor: AppColors.brand,
        side: const BorderSide(color: AppColors.line),
        labelStyle: const TextStyle(fontWeight: FontWeight.w600),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(40),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.brand,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(54),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.ink,
          minimumSize: const Size.fromHeight(54),
          side: const BorderSide(color: AppColors.line),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        hintStyle: const TextStyle(color: AppColors.inkMuted),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.line),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.line),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.brand, width: 1.6),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.line,
        thickness: 1,
        space: 1,
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.surface,
        surfaceTintColor: Colors.transparent,
      ),
    );
  }
}
