import 'package:flutter/material.dart';

import 'shared/settings_provider.dart';

/// Design tokens ported from React index.css
class AppColors {
  AppColors._();

  static const Color background = Color(0xFF000000);
  static const Color surface = Color(0xFF050505);
  static const Color surfaceContainer = Color(0xFF0D0D0D);
  static const Color surfaceContainerLow = Color(0xFF121212);
  static const Color surfaceContainerLowest = Color(0xFF161616);
  static const Color surfaceContainerHigh = Color(0xFF1F1F1F);
  static const Color surfaceContainerHighest = Color(0xFF2D2D2D);

  static const Color onSurface = Color(0xFFFFFFFF);
  static const Color onSurfaceVariant = Color(0xFFA1A1AA);
  static const Color outlineVariant = Color(0xFF27272A);

  static const Color border = Color(0x1AFFFFFF);
  static const Color borderSubtle = Color(0x0DFFFFFF);
  static const Color borderHover = Color(0x0AFFFFFF);
  static const Color borderQuote = Color(0x05FFFFFF);
  static const Color overlayDark = Color(0x66121212);

  static const Color primary = Color(0xFFDC2626);
  static const Color primaryForeground = Color(0xFFFFFFFF);

  static const Color emerald = Color(0xFF10B981);
  static const Color emeraldContainer = Color(0xFF064E3B);
  static const Color orange = Color(0xFFF97316);
  static const Color indigo = Color(0xFF6366F1);
  static const Color zinc900 = Color(0xFF18181B);
  static const Color zinc800 = Color(0xFF27272A);
  static const Color zinc700 = Color(0xFF3F3F46);
  static const Color zinc600 = Color(0xFF52525B);
  static const Color zinc500 = Color(0xFF71717A);
  static const Color zinc400 = Color(0xFFA1A1AA);
  static const Color zinc300 = Color(0xFFD4D4D8);

  static const Color glassTint = Color(0x401F1F1F);
  static const Color glassBorder = Color(0x29FFFFFF);
  static const Color glassGlow = Color(0x15FFFFFF);

  static const Map<ThemeColor, Color> themeColors = {
    ThemeColor.red: Color(0xFFDC2626),
    ThemeColor.blue: Color(0xFF3B82F6),
    ThemeColor.emerald: Color(0xFF10B981),
    ThemeColor.violet: Color(0xFF8B5CF6),
    ThemeColor.amber: Color(0xFFF59E0B),
  };

  static const Map<ThemeColor, String> themeColorLabels = {
    ThemeColor.red: 'Crimson',
    ThemeColor.blue: 'Ocean',
    ThemeColor.emerald: 'Emerald',
    ThemeColor.violet: 'Amethyst',
    ThemeColor.amber: 'Amber',
  };

  static Color getPrimary(ThemeColor themeColor) {
    return themeColors[themeColor] ?? primary;
  }
}

class AppTheme {
  AppTheme._();

  static const double m3xs = 0.571;
  static const double m2xs = 0.643;
  static const double m2sm = 0.714;
  static const double m1sm = 0.786;
  static const double mxs = 0.857;
  static const double m13 = 0.929;
  static const double mbase = 1.0;
  static const double m15 = 1.071;
  static const double mlg = 1.143;
  static const double mxl = 1.286;
  static const double m2xl = 1.429;
  static const double m22 = 1.571;
  static const double m3xl = 1.714;
  static const double m26 = 1.857;
  static const double m28 = 2.0;

  static double _baseFontSize(TextSize textSize) {
    switch (textSize) {
      case TextSize.sm:
        return 12;
      case TextSize.md:
        return 14;
      case TextSize.lg:
        return 16;
    }
  }

  static TextStyle scaled({
    TextSize textSize = TextSize.md,
    required double multiplier,
    FontWeight? weight,
    Color? color,
    double? letterSpacing,
    double? height,
    TextDecoration? decoration,
  }) {
    return TextStyle(
      fontSize: _baseFontSize(textSize) * multiplier,
      fontWeight: weight,
      color: color,
      letterSpacing: letterSpacing,
      height: height,
      decoration: decoration,
    );
  }

  static ThemeData darkTheme({
    ThemeColor themeColor = ThemeColor.red,
    TextSize textSize = TextSize.md,
  }) {
    final primary = AppColors.getPrimary(themeColor);
    final base = _baseFontSize(textSize);

    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.dark(
        background: AppColors.background,
        surface: AppColors.surface,
        primary: primary,
        onPrimary: AppColors.primaryForeground,
        secondary: AppColors.emerald,
        tertiary: AppColors.indigo,
        surfaceContainer: AppColors.surfaceContainer,
        surfaceContainerLow: AppColors.surfaceContainerLow,
        surfaceContainerLowest: AppColors.surfaceContainerLowest,
        surfaceContainerHigh: AppColors.surfaceContainerHigh,
        surfaceContainerHighest: AppColors.surfaceContainerHighest,
        onSurface: AppColors.onSurface,
        onSurfaceVariant: AppColors.onSurfaceVariant,
        outline: AppColors.outlineVariant,
        outlineVariant: AppColors.outlineVariant,
      ),
      scaffoldBackgroundColor: AppColors.background,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.onSurface,
        elevation: 0,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        color: AppColors.surfaceContainerHigh,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: AppColors.border),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceContainer,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: primary),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        hintStyle: const TextStyle(color: AppColors.onSurfaceVariant),
      ),
      textTheme: TextTheme(
        displayLarge: TextStyle(
          fontSize: base * 2.286,
          fontWeight: FontWeight.bold,
          color: AppColors.onSurface,
        ),
        displayMedium: TextStyle(
          fontSize: base * 2.0,
          fontWeight: FontWeight.bold,
          color: AppColors.onSurface,
        ),
        displaySmall: TextStyle(
          fontSize: base * 1.714,
          fontWeight: FontWeight.bold,
          color: AppColors.onSurface,
        ),
        headlineLarge: TextStyle(
          fontSize: base * 1.429,
          fontWeight: FontWeight.w600,
          color: AppColors.onSurface,
        ),
        headlineMedium: TextStyle(
          fontSize: base * 1.286,
          fontWeight: FontWeight.w600,
          color: AppColors.onSurface,
        ),
        headlineSmall: TextStyle(
          fontSize: base * 1.143,
          fontWeight: FontWeight.w600,
          color: AppColors.onSurface,
        ),
        titleLarge: TextStyle(
          fontSize: base * 1.143,
          fontWeight: FontWeight.w600,
          color: AppColors.onSurface,
        ),
        titleMedium: TextStyle(
          fontSize: base,
          fontWeight: FontWeight.w500,
          color: AppColors.onSurface,
        ),
        titleSmall: TextStyle(
          fontSize: base * 0.857,
          fontWeight: FontWeight.w500,
          color: AppColors.onSurface,
        ),
        bodyLarge: TextStyle(
          fontSize: base * 1.143,
          color: AppColors.onSurface,
        ),
        bodyMedium: TextStyle(fontSize: base, color: AppColors.onSurface),
        bodySmall: TextStyle(
          fontSize: base * 0.857,
          color: AppColors.onSurfaceVariant,
        ),
        labelLarge: TextStyle(
          fontSize: base,
          fontWeight: FontWeight.w500,
          color: AppColors.onSurface,
        ),
        labelMedium: TextStyle(
          fontSize: base * 0.857,
          fontWeight: FontWeight.w500,
          color: AppColors.onSurface,
        ),
        labelSmall: TextStyle(
          fontSize: base * 0.786,
          fontWeight: FontWeight.w500,
          color: AppColors.onSurfaceVariant,
        ),
      ),
      iconTheme: const IconThemeData(color: AppColors.onSurface, size: 20),
      dividerTheme: const DividerThemeData(
        color: AppColors.outlineVariant,
        thickness: 1,
        space: 1,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.surface,
        selectedItemColor: primary,
        unselectedItemColor: AppColors.onSurfaceVariant,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
    );
  }

  static const TextStyle labelTiny = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w500,
    color: AppColors.onSurfaceVariant,
  );

  static const TextStyle labelMicro = TextStyle(
    fontSize: 9,
    fontWeight: FontWeight.w800,
    color: AppColors.onSurface,
  );

  static LinearGradient backgroundGradient(ThemeColor themeColor) {
    final primary = AppColors.getPrimary(themeColor);
    return LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        primary.withOpacity(0.04),
        AppColors.indigo.withOpacity(0.03),
        AppColors.emerald.withOpacity(0.02),
        Colors.transparent,
      ],
      stops: const [0.0, 0.3, 0.6, 1.0],
    );
  }
}
