import 'package:flutter/material.dart';

// ── Brand colours ──────────────────────────────────────────────────────────────
class HBColors {
  HBColors._();

  static const Color primary = Color(0xFF1B6CA8);       // deep sky blue
  static const Color primaryLight = Color(0xFF4D9FD6);
  static const Color primaryDark = Color(0xFF0D4A7A);

  static const Color secondary = Color(0xFF27AE60);     // community green
  static const Color secondaryLight = Color(0xFF52D68A);
  static const Color secondaryDark = Color(0xFF1A7A42);

  static const Color accent = Color(0xFFF39C12);        // bounty amber
  static const Color accentLight = Color(0xFFF8C471);

  static const Color error = Color(0xFFE74C3C);
  static const Color warning = Color(0xFFF39C12);
  static const Color success = Color(0xFF27AE60);
  static const Color info = Color(0xFF1B6CA8);

  static const Color surface = Color(0xFFF8F9FA);
  static const Color surfaceVariant = Color(0xFFECF0F1);
  static const Color onSurface = Color(0xFF2C3E50);
  static const Color onSurfaceVariant = Color(0xFF7F8C8D);

  static const Color divider = Color(0xFFDDE1E7);
}

// ── Text styles ───────────────────────────────────────────────────────────────
class HBTextStyles {
  HBTextStyles._();

  static const TextStyle displayLarge = TextStyle(
    fontSize: 32, fontWeight: FontWeight.w700, letterSpacing: -0.5,
    color: HBColors.onSurface,
  );
  static const TextStyle displayMedium = TextStyle(
    fontSize: 26, fontWeight: FontWeight.w600, letterSpacing: -0.25,
    color: HBColors.onSurface,
  );
  static const TextStyle headlineLarge = TextStyle(
    fontSize: 22, fontWeight: FontWeight.w600,
    color: HBColors.onSurface,
  );
  static const TextStyle headlineMedium = TextStyle(
    fontSize: 18, fontWeight: FontWeight.w600,
    color: HBColors.onSurface,
  );
  static const TextStyle titleLarge = TextStyle(
    fontSize: 16, fontWeight: FontWeight.w600,
    color: HBColors.onSurface,
  );
  static const TextStyle titleMedium = TextStyle(
    fontSize: 14, fontWeight: FontWeight.w500,
    color: HBColors.onSurface,
  );
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16, fontWeight: FontWeight.w400,
    color: HBColors.onSurface,
  );
  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14, fontWeight: FontWeight.w400,
    color: HBColors.onSurface,
  );
  static const TextStyle bodySmall = TextStyle(
    fontSize: 12, fontWeight: FontWeight.w400,
    color: HBColors.onSurfaceVariant,
  );
  static const TextStyle labelLarge = TextStyle(
    fontSize: 14, fontWeight: FontWeight.w600, letterSpacing: 0.1,
    color: HBColors.onSurface,
  );
  static const TextStyle labelSmall = TextStyle(
    fontSize: 11, fontWeight: FontWeight.w500, letterSpacing: 0.5,
    color: HBColors.onSurfaceVariant,
  );
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
  static const double sm  = 8.0;
  static const double md  = 12.0;
  static const double lg  = 16.0;
  static const double xl  = 24.0;
  static const double full = 999.0;
}

// ── MaterialTheme ─────────────────────────────────────────────────────────────
ThemeData hbTheme() {
  final colorScheme = ColorScheme.fromSeed(
    seedColor: HBColors.primary,
    brightness: Brightness.light,
    primary: HBColors.primary,
    secondary: HBColors.secondary,
    error: HBColors.error,
    surface: HBColors.surface,
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    scaffoldBackgroundColor: HBColors.surface,

    // App bar
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: HBColors.onSurface,
      elevation: 0,
      scrolledUnderElevation: 1,
      centerTitle: false,
      titleTextStyle: HBTextStyles.headlineMedium,
    ),

    // Bottom nav
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: Colors.white,
      indicatorColor: HBColors.primaryLight.withOpacity(0.2),
      labelTextStyle: WidgetStateProperty.all(HBTextStyles.labelSmall),
    ),

    // Cards
    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(HBRadius.md),
        side: BorderSide(color: HBColors.divider),
      ),
      margin: EdgeInsets.zero,
    ),

    // Elevated buttons
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: HBColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(
          horizontal: HBSpacing.lg, vertical: HBSpacing.md,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(HBRadius.md),
        ),
        textStyle: HBTextStyles.labelLarge,
      ),
    ),

    // Outlined buttons
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: HBColors.primary,
        side: const BorderSide(color: HBColors.primary),
        padding: const EdgeInsets.symmetric(
          horizontal: HBSpacing.lg, vertical: HBSpacing.md,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(HBRadius.md),
        ),
        textStyle: HBTextStyles.labelLarge,
      ),
    ),

    // Text fields
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(HBRadius.md),
        borderSide: BorderSide(color: HBColors.divider),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(HBRadius.md),
        borderSide: BorderSide(color: HBColors.divider),
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
      labelStyle: HBTextStyles.bodyMedium,
      hintStyle: HBTextStyles.bodyMedium.copyWith(color: HBColors.onSurfaceVariant),
    ),

    // Chips
    chipTheme: ChipThemeData(
      backgroundColor: HBColors.surfaceVariant,
      selectedColor: HBColors.primaryLight.withOpacity(0.2),
      labelStyle: HBTextStyles.labelSmall,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(HBRadius.full),
      ),
    ),

    // Divider
    dividerTheme: const DividerThemeData(
      color: HBColors.divider,
      thickness: 1,
      space: 1,
    ),

    // Text
    textTheme: TextTheme(
      displayLarge:  HBTextStyles.displayLarge,
      displayMedium: HBTextStyles.displayMedium,
      headlineLarge: HBTextStyles.headlineLarge,
      headlineMedium: HBTextStyles.headlineMedium,
      titleLarge:    HBTextStyles.titleLarge,
      titleMedium:   HBTextStyles.titleMedium,
      bodyLarge:     HBTextStyles.bodyLarge,
      bodyMedium:    HBTextStyles.bodyMedium,
      bodySmall:     HBTextStyles.bodySmall,
      labelLarge:    HBTextStyles.labelLarge,
      labelSmall:    HBTextStyles.labelSmall,
    ),
  );
}
