import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Visual language lifted from the "Sartorial Atelier" design system
/// (see `stitch_tailor_lesson_tracker/sartorial_atelier/DESIGN.md`): warm
/// ivory surfaces, a near-black midnight-navy primary, a terracotta
/// secondary accent, Newsreader serif headlines paired with Manrope for
/// everything operational.
///
/// Every color below is copied verbatim from that design system's token
/// list, and the token names map 1:1 onto Flutter's Material 3
/// [ColorScheme] fields.
class AppTheme {
  AppTheme._();

  static const ColorScheme _lightScheme = ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFF050E1C),
    onPrimary: Color(0xFFFFFFFF),
    primaryContainer: Color(0xFF1B2432),
    onPrimaryContainer: Color(0xFF828B9D),
    primaryFixed: Color(0xFFDAE3F6),
    primaryFixedDim: Color(0xFFBEC7DA),
    onPrimaryFixed: Color(0xFF131C2A),
    onPrimaryFixedVariant: Color(0xFF3E4757),
    secondary: Color(0xFF944927),
    onSecondary: Color(0xFFFFFFFF),
    secondaryContainer: Color(0xFFFE9E75),
    onSecondaryContainer: Color(0xFF773313),
    secondaryFixed: Color(0xFFFFDBCD),
    secondaryFixedDim: Color(0xFFFFB597),
    onSecondaryFixed: Color(0xFF360F00),
    onSecondaryFixedVariant: Color(0xFF763212),
    tertiary: Color(0xFF160C00),
    onTertiary: Color(0xFFFFFFFF),
    tertiaryContainer: Color(0xFF312000),
    onTertiaryContainer: Color(0xFFA28658),
    tertiaryFixed: Color(0xFFFFDEAA),
    tertiaryFixedDim: Color(0xFFE2C28F),
    onTertiaryFixed: Color(0xFF271900),
    onTertiaryFixedVariant: Color(0xFF59431B),
    error: Color(0xFFBA1A1A),
    onError: Color(0xFFFFFFFF),
    errorContainer: Color(0xFFFFDAD6),
    onErrorContainer: Color(0xFF93000A),
    surface: Color(0xFFFCF9F3),
    onSurface: Color(0xFF1C1C18),
    surfaceDim: Color(0xFFDCDAD4),
    surfaceBright: Color(0xFFFCF9F3),
    surfaceContainerLowest: Color(0xFFFFFFFF),
    surfaceContainerLow: Color(0xFFF6F3ED),
    surfaceContainer: Color(0xFFF0EEE8),
    surfaceContainerHigh: Color(0xFFEBE8E2),
    surfaceContainerHighest: Color(0xFFE5E2DC),
    onSurfaceVariant: Color(0xFF45474C),
    outline: Color(0xFF75777C),
    outlineVariant: Color(0xFFC5C6CC),
    inverseSurface: Color(0xFF31312D),
    onInverseSurface: Color(0xFFF3F0EA),
    inversePrimary: Color(0xFFBEC7DA),
    surfaceTint: Color(0xFF565F6F),
    shadow: Color(0xFF000000),
    scrim: Color(0xFF000000),
  );

  /// Night-time counterpart: warm espresso-brown surfaces (in the spirit of
  /// Gruvbox / Monokai rather than cold slate or pure black) with warm
  /// ivory text, and the Material Theme editor's warm accents carrying the
  /// atelier roles — gold thread for primary, the orange keyword tone in
  /// place of terracotta, and the soft purple as tertiary. The `*Fixed`
  /// roles keep their light-theme values, per Material 3.
  static const ColorScheme _darkScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFFFFCB6B),
    onPrimary: Color(0xFF2A221D),
    primaryContainer: Color(0xFF4A3C33),
    onPrimaryContainer: Color(0xFFF2E5D5),
    primaryFixed: Color(0xFFDAE3F6),
    primaryFixedDim: Color(0xFFBEC7DA),
    onPrimaryFixed: Color(0xFF131C2A),
    onPrimaryFixedVariant: Color(0xFF3E4757),
    secondary: Color(0xFFF78C6C),
    onSecondary: Color(0xFF3B1A0E),
    secondaryContainer: Color(0xFF6B3E2A),
    onSecondaryContainer: Color(0xFFFFCBB8),
    secondaryFixed: Color(0xFFFFDBCD),
    secondaryFixedDim: Color(0xFFFFB597),
    onSecondaryFixed: Color(0xFF360F00),
    onSecondaryFixedVariant: Color(0xFF763212),
    tertiary: Color(0xFFC792EA),
    onTertiary: Color(0xFF2E1A3B),
    tertiaryContainer: Color(0xFF4A3A5C),
    onTertiaryContainer: Color(0xFFEBD4FA),
    tertiaryFixed: Color(0xFFFFDEAA),
    tertiaryFixedDim: Color(0xFFE2C28F),
    onTertiaryFixed: Color(0xFF271900),
    onTertiaryFixedVariant: Color(0xFF59431B),
    error: Color(0xFFF07178),
    onError: Color(0xFF3B0A10),
    errorContainer: Color(0xFF5C2B33),
    onErrorContainer: Color(0xFFFFD6DA),
    surface: Color(0xFF2A221D),
    onSurface: Color(0xFFF2E5D5),
    surfaceDim: Color(0xFF211A16),
    surfaceBright: Color(0xFF4A3C33),
    surfaceContainerLowest: Color(0xFF211A16),
    surfaceContainerLow: Color(0xFF2F2621),
    surfaceContainer: Color(0xFF362B25),
    surfaceContainerHigh: Color(0xFF3E322B),
    surfaceContainerHighest: Color(0xFF4A3C33),
    onSurfaceVariant: Color(0xFFC9B8A6),
    outline: Color(0xFF8C7A6B),
    outlineVariant: Color(0xFF4A3C33),
    inverseSurface: Color(0xFFF2E5D5),
    onInverseSurface: Color(0xFF2A221D),
    inversePrimary: Color(0xFF8A6A1E),
    surfaceTint: Color(0xFFFFCB6B),
    shadow: Color(0xFF000000),
    scrim: Color(0xFF000000),
  );

  static ColorScheme get colorScheme => _lightScheme;

  /// Type scale from the design tokens, using the mobile-sized variants of
  /// the display/headline styles since this app targets phone-width
  /// screens.
  static TextTheme _buildTextTheme() {
    return TextTheme(
      displayLarge: GoogleFonts.newsreader(
        fontSize: 36,
        height: 44 / 36,
        fontWeight: FontWeight.w400,
        letterSpacing: -0.36,
      ),
      headlineLarge: GoogleFonts.newsreader(
        fontSize: 28,
        height: 36 / 28,
        fontWeight: FontWeight.w400,
        letterSpacing: -0.28,
      ),
      headlineMedium: GoogleFonts.newsreader(
        fontSize: 28,
        height: 36 / 28,
        fontWeight: FontWeight.w500,
        letterSpacing: -0.28,
      ),
      headlineSmall: GoogleFonts.newsreader(
        fontSize: 22,
        height: 30 / 22,
        fontWeight: FontWeight.w500,
      ),
      titleLarge: GoogleFonts.newsreader(
        fontSize: 20,
        height: 26 / 20,
        fontWeight: FontWeight.w500,
      ),
      bodyLarge: GoogleFonts.manrope(
        fontSize: 18,
        height: 28 / 18,
        fontWeight: FontWeight.w400,
      ),
      bodyMedium: GoogleFonts.manrope(
        fontSize: 15,
        height: 24 / 15,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.15,
      ),
      bodySmall: GoogleFonts.manrope(
        fontSize: 13,
        height: 20 / 13,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.13,
      ),
      labelLarge: GoogleFonts.manrope(
        fontSize: 14,
        height: 20 / 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.42,
      ),
      labelMedium: GoogleFonts.manrope(
        fontSize: 12,
        height: 16 / 12,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.48,
      ),
      labelSmall: GoogleFonts.manrope(
        fontSize: 10,
        height: 14 / 10,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.8,
      ),
    );
  }

  static ThemeData get theme => _build(_lightScheme);

  static ThemeData get darkTheme => _build(_darkScheme);

  static ThemeData _build(ColorScheme scheme) {
    final textTheme = _buildTextTheme().apply(
      bodyColor: scheme.onSurface,
      displayColor: scheme.onSurface,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: scheme.surface,
      textTheme: textTheme,
      dividerColor: scheme.outlineVariant,
      splashFactory: InkRipple.splashFactory,
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        surfaceTintColor: Colors.transparent,
        foregroundColor: scheme.primary,
        elevation: 0,
        titleTextStyle: textTheme.headlineSmall?.copyWith(color: scheme.primary),
      ),
      cardTheme: CardThemeData(
        color: scheme.brightness == Brightness.dark
            ? scheme.surfaceContainer
            : scheme.surfaceContainerLowest,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: scheme.outlineVariant.withValues(alpha: 0.5)),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onPrimary,
          textStyle: textTheme.labelLarge,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: scheme.secondary,
          textStyle: textTheme.labelLarge,
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: scheme.primary,
        foregroundColor: scheme.onPrimary,
        extendedTextStyle: textTheme.labelLarge?.copyWith(color: scheme.onPrimary),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      listTileTheme: ListTileThemeData(
        iconColor: scheme.onSurfaceVariant,
        titleTextStyle: textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w600,
          color: scheme.onSurface,
        ),
        subtitleTextStyle: textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surfaceContainerLow,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: scheme.outlineVariant),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: scheme.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: scheme.primary, width: 1.5),
        ),
        labelStyle: textTheme.bodyMedium,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: scheme.surface,
        surfaceTintColor: Colors.transparent,
        indicatorColor: Colors.transparent,
        height: 68,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return textTheme.labelSmall?.copyWith(
            color: selected ? scheme.secondary : scheme.onSurfaceVariant,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return IconThemeData(
            color: selected ? scheme.secondary : scheme.onSurfaceVariant,
          );
        }),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: scheme.brightness == Brightness.dark
            ? scheme.surfaceContainerHigh
            : scheme.surfaceContainerLowest,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        titleTextStyle: textTheme.headlineSmall?.copyWith(color: scheme.primary),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: scheme.brightness == Brightness.dark
            ? scheme.surfaceContainerHigh
            : scheme.surfaceContainerLowest,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          return states.contains(WidgetState.selected) ? scheme.secondary : scheme.outline;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          return states.contains(WidgetState.selected)
              ? scheme.secondaryContainer
              : scheme.surfaceContainerHighest;
        }),
      ),
    );
  }
}
