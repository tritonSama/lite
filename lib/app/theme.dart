import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ── Brand colours ──────────────────────────────────────────────────────────────
class HBColors {
  HBColors._();

  static const Color primary = Color(0xFF0096C7);       // Cyan
  static const Color primaryLight = Color(0xFF4DBBDF);
  static const Color primaryDark = Color(0xFF006A8C);

  static const Color secondary = Color(0xFFD4AF37);     // Gold
  static const Color secondaryLight = Color(0xFFE2C86F);
  static const Color secondaryDark = Color(0xFF947A26);

  static const Color tertiary = Color(0xFF5300FF);      // Purple/Magenta
  static const Color tertiaryLight = Color(0xFF834DFF);

  static const Color neutral = Color(0xFF0C0F1D);       // Deep Dark Background
  static const Color neutralLight = Color(0xFF1E2336);
  static const Color neutralLighter = Color(0xFF2C324A);

  static const Color error = Color(0xFFE74C3C);
  static const Color warning = Color(0xFFD4AF37);
  static const Color success = Color(0xFF0096C7);
  static const Color info = Color(0xFF5300FF);

  // Light Mode Specific
  static const Color surfaceLight = Color(0xFFF4F6F9);
  static const Color surfaceVariantLight = Color(0xFFE9EDF2);
  static const Color onSurfaceLight = Color(0xFF0C0F1D);
  static const Color onSurfaceVariantLight = Color(0xFF646B81);
  static const Color dividerLight = Color(0xFFDDE1E7);

  // Dark Mode Specific
  static const Color surfaceDark = Color(0xFF0C0F1D);
  static const Color surfaceVariantDark = Color(0xFF16192B);
  static const Color onSurfaceDark = Color(0xFFE9EDF2);
  static const Color onSurfaceVariantDark = Color(0xFFA1A8C3);
  static const Color dividerDark = Color(0xFF2C324A);
}

// ── Text styles ───────────────────────────────────────────────────────────────
class HBTextStyles {
  HBTextStyles._();

  // Helper to get Google Fonts based on role
  static TextStyle getDisplayFont(TextStyle base) => GoogleFonts.spaceGrotesk(textStyle: base);
  static TextStyle getBodyFont(TextStyle base) => GoogleFonts.inter(textStyle: base);
  static TextStyle getMonoFont(TextStyle base) => GoogleFonts.jetBrainsMono(textStyle: base);

  static TextStyle displayLarge(Color color) => getDisplayFont(TextStyle(
    fontSize: 32, fontWeight: FontWeight.w700, letterSpacing: -0.5,
    color: color,
  ));
  static TextStyle displayMedium(Color color) => getDisplayFont(TextStyle(
    fontSize: 26, fontWeight: FontWeight.w600, letterSpacing: -0.25,
    color: color,
  ));
  static TextStyle headlineLarge(Color color) => getDisplayFont(TextStyle(
    fontSize: 22, fontWeight: FontWeight.w600,
    color: color,
  ));
  static TextStyle headlineMedium(Color color) => getDisplayFont(TextStyle(
    fontSize: 18, fontWeight: FontWeight.w600,
    color: color,
  ));
  static TextStyle titleLarge(Color color) => getDisplayFont(TextStyle(
    fontSize: 16, fontWeight: FontWeight.w600,
    color: color,
  ));
  static TextStyle titleMedium(Color color) => getDisplayFont(TextStyle(
    fontSize: 14, fontWeight: FontWeight.w500,
    color: color,
  ));

  static TextStyle bodyLarge(Color color) => getBodyFont(TextStyle(
    fontSize: 16, fontWeight: FontWeight.w400,
    color: color,
  ));
  static TextStyle bodyMedium(Color color) => getBodyFont(TextStyle(
    fontSize: 14, fontWeight: FontWeight.w400,
    color: color,
  ));
  static TextStyle bodySmall(Color color) => getBodyFont(TextStyle(
    fontSize: 12, fontWeight: FontWeight.w400,
    color: color,
  ));

  static TextStyle labelLarge(Color color) => getMonoFont(TextStyle(
    fontSize: 14, fontWeight: FontWeight.w600, letterSpacing: 0.1,
    color: color,
  ));
  static TextStyle labelSmall(Color color) => getMonoFont(TextStyle(
    fontSize: 11, fontWeight: FontWeight.w500, letterSpacing: 0.5,
    color: color,
  ));
}

// ── Spacing ───────────────────────────────────────────────────────────────────
class HBSpacing {
  HBSpacing._();
  static const double xs  = 4.0;
  static const double sm  = 8.0;
  static const double md  = 16.0;
  static const double lg  = 24.0;
  static const double xl  = 32.0;
  static const double xxl = 48.0;
}

// ── Radius ────────────────────────────────────────────────────────────────────
class HBRadius {
  HBRadius._();
  static const double sm  = 4.0; // Sharper corners for tactical look
  static const double md  = 8.0; // Sharper corners for tactical look
  static const double lg  = 12.0;
  static const double xl  = 16.0;
  static const double full = 999.0;
}

// ── Glow Effects (Shadows) ────────────────────────────────────────────────────
List<BoxShadow> getNeonGlow(Color color) {
  return [
    BoxShadow(
      color: color.withOpacity(0.5),
      blurRadius: 12,
      spreadRadius: 2,
    ),
    BoxShadow(
      color: color.withOpacity(0.2),
      blurRadius: 24,
      spreadRadius: 4,
    )
  ];
}

// ── MaterialTheme (Light) ─────────────────────────────────────────────────────
ThemeData hbLightTheme() {
  final colorScheme = ColorScheme.fromSeed(
    seedColor: HBColors.primary,
    brightness: Brightness.light,
    primary: HBColors.primary,
    secondary: HBColors.secondary,
    tertiary: HBColors.tertiary,
    error: HBColors.error,
    surface: HBColors.surfaceLight,
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    scaffoldBackgroundColor: HBColors.surfaceLight,

    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: HBColors.onSurfaceLight,
      elevation: 0,
      scrolledUnderElevation: 1,
      centerTitle: false,
      titleTextStyle: HBTextStyles.headlineMedium(HBColors.onSurfaceLight),
    ),

    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: Colors.white,
      indicatorColor: HBColors.primary.withOpacity(0.2),
      labelTextStyle: WidgetStateProperty.all(HBTextStyles.labelSmall(HBColors.onSurfaceVariantLight)),
    ),

    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(HBRadius.md),
        side: const BorderSide(color: HBColors.dividerLight),
      ),
      margin: EdgeInsets.zero,
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: HBColors.primary,
        foregroundColor: Colors.white,
        elevation: 8,
        shadowColor: HBColors.primary.withOpacity(0.5),
        padding: const EdgeInsets.symmetric(
          horizontal: HBSpacing.lg, vertical: HBSpacing.md,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(HBRadius.sm),
        ),
        textStyle: HBTextStyles.labelLarge(Colors.white),
      ).copyWith(
        shadowColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.hovered) || states.contains(WidgetState.pressed)) {
             return HBColors.primary;
          }
          return HBColors.primary.withOpacity(0.5);
        }),
        elevation: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.hovered) || states.contains(WidgetState.pressed)) {
             return 16.0;
          }
          return 8.0;
        }),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: HBColors.primary,
        side: const BorderSide(color: HBColors.primary),
        padding: const EdgeInsets.symmetric(
          horizontal: HBSpacing.lg, vertical: HBSpacing.md,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(HBRadius.sm),
        ),
        textStyle: HBTextStyles.labelLarge(HBColors.primary),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(HBRadius.md),
        borderSide: const BorderSide(color: HBColors.dividerLight),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(HBRadius.md),
        borderSide: const BorderSide(color: HBColors.dividerLight),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(HBRadius.md),
        borderSide: const BorderSide(color: HBColors.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(HBRadius.md),
        borderSide: const BorderSide(color: HBColors.error),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: HBSpacing.md, vertical: HBSpacing.md,
      ),
      labelStyle: HBTextStyles.bodyMedium(HBColors.onSurfaceLight),
      hintStyle: HBTextStyles.bodyMedium(HBColors.onSurfaceVariantLight),
    ),

    chipTheme: ChipThemeData(
      backgroundColor: HBColors.surfaceVariantLight,
      selectedColor: HBColors.primary.withOpacity(0.2),
      labelStyle: HBTextStyles.labelSmall(HBColors.onSurfaceLight),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(HBRadius.sm),
        side: const BorderSide(color: HBColors.dividerLight),
      ),
    ),

    dividerTheme: const DividerThemeData(
      color: HBColors.dividerLight,
      thickness: 1,
      space: 1,
    ),

    textTheme: TextTheme(
      displayLarge:  HBTextStyles.displayLarge(HBColors.onSurfaceLight),
      displayMedium: HBTextStyles.displayMedium(HBColors.onSurfaceLight),
      headlineLarge: HBTextStyles.headlineLarge(HBColors.onSurfaceLight),
      headlineMedium: HBTextStyles.headlineMedium(HBColors.onSurfaceLight),
      titleLarge:    HBTextStyles.titleLarge(HBColors.onSurfaceLight),
      titleMedium:   HBTextStyles.titleMedium(HBColors.onSurfaceLight),
      bodyLarge:     HBTextStyles.bodyLarge(HBColors.onSurfaceLight),
      bodyMedium:    HBTextStyles.bodyMedium(HBColors.onSurfaceLight),
      bodySmall:     HBTextStyles.bodySmall(HBColors.onSurfaceVariantLight),
      labelLarge:    HBTextStyles.labelLarge(HBColors.onSurfaceLight),
      labelSmall:    HBTextStyles.labelSmall(HBColors.onSurfaceVariantLight),
    ),
  );
}

// ── MaterialTheme (Dark) ──────────────────────────────────────────────────────
ThemeData hbDarkTheme() {
  final colorScheme = ColorScheme.fromSeed(
    seedColor: HBColors.primary,
    brightness: Brightness.dark,
    primary: HBColors.primary,
    secondary: HBColors.secondary,
    tertiary: HBColors.tertiary,
    error: HBColors.error,
    surface: HBColors.surfaceDark,
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    scaffoldBackgroundColor: HBColors.neutral,

    appBarTheme: AppBarTheme(
      backgroundColor: HBColors.neutralLight,
      foregroundColor: HBColors.onSurfaceDark,
      elevation: 0,
      scrolledUnderElevation: 1,
      centerTitle: false,
      titleTextStyle: HBTextStyles.headlineMedium(HBColors.onSurfaceDark),
    ),

    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: HBColors.neutralLight,
      indicatorColor: HBColors.primary.withOpacity(0.3),
      labelTextStyle: WidgetStateProperty.all(HBTextStyles.labelSmall(HBColors.onSurfaceVariantDark)),
    ),

    cardTheme: CardThemeData(
      color: HBColors.surfaceVariantDark,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(HBRadius.md),
        side: const BorderSide(color: HBColors.dividerDark),
      ),
      margin: EdgeInsets.zero,
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: HBColors.primary,
        foregroundColor: Colors.white,
        elevation: 8,
        shadowColor: HBColors.primary.withOpacity(0.5),
        padding: const EdgeInsets.symmetric(
          horizontal: HBSpacing.lg, vertical: HBSpacing.md,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(HBRadius.sm),
        ),
        textStyle: HBTextStyles.labelLarge(Colors.white),
      ).copyWith(
        shadowColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.hovered) || states.contains(WidgetState.pressed)) {
             return HBColors.primary;
          }
          return HBColors.primary.withOpacity(0.5);
        }),
        elevation: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.hovered) || states.contains(WidgetState.pressed)) {
             return 16.0; // Acts as a stronger glow
          }
          return 8.0; // Base glow
        }),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: HBColors.primaryLight,
        side: const BorderSide(color: HBColors.primaryLight),
        padding: const EdgeInsets.symmetric(
          horizontal: HBSpacing.lg, vertical: HBSpacing.md,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(HBRadius.sm),
        ),
        textStyle: HBTextStyles.labelLarge(HBColors.primaryLight),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: HBColors.surfaceVariantDark,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(HBRadius.md),
        borderSide: const BorderSide(color: HBColors.dividerDark),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(HBRadius.md),
        borderSide: const BorderSide(color: HBColors.dividerDark),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(HBRadius.md),
        borderSide: const BorderSide(color: HBColors.primaryLight, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(HBRadius.md),
        borderSide: const BorderSide(color: HBColors.error),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: HBSpacing.md, vertical: HBSpacing.md,
      ),
      labelStyle: HBTextStyles.bodyMedium(HBColors.onSurfaceDark),
      hintStyle: HBTextStyles.bodyMedium(HBColors.onSurfaceVariantDark),
    ),

    chipTheme: ChipThemeData(
      backgroundColor: HBColors.dividerDark,
      selectedColor: HBColors.primary.withOpacity(0.3),
      labelStyle: HBTextStyles.labelSmall(HBColors.onSurfaceDark),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(HBRadius.sm),
        side: const BorderSide(color: HBColors.dividerDark),
      ),
    ),

    dividerTheme: const DividerThemeData(
      color: HBColors.dividerDark,
      thickness: 1,
      space: 1,
    ),

    textTheme: TextTheme(
      displayLarge:  HBTextStyles.displayLarge(HBColors.onSurfaceDark),
      displayMedium: HBTextStyles.displayMedium(HBColors.onSurfaceDark),
      headlineLarge: HBTextStyles.headlineLarge(HBColors.onSurfaceDark),
      headlineMedium: HBTextStyles.headlineMedium(HBColors.onSurfaceDark),
      titleLarge:    HBTextStyles.titleLarge(HBColors.onSurfaceDark),
      titleMedium:   HBTextStyles.titleMedium(HBColors.onSurfaceDark),
      bodyLarge:     HBTextStyles.bodyLarge(HBColors.onSurfaceDark),
      bodyMedium:    HBTextStyles.bodyMedium(HBColors.onSurfaceDark),
      bodySmall:     HBTextStyles.bodySmall(HBColors.onSurfaceVariantDark),
      labelLarge:    HBTextStyles.labelLarge(HBColors.onSurfaceDark),
      labelSmall:    HBTextStyles.labelSmall(HBColors.onSurfaceVariantDark),
    ),
  );
}
