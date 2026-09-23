import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // === PRIMARY PALETTE - Warm Botanical ===
  static const Color primaryPurple = Color(0xFF8C52FF);
  static const Color primaryPressed = Color(0xFF6D38DB);
  static const Color primaryLight = Color(0xFFF1EBFC);

  // === NEW: Warm Accent Colors ===
  static const Color amberGold = Color(0xFFF59E0B);
  static const Color amberGoldLight = Color(0xFFFEF3C7);
  static const Color sageGreen = Color(0xFF10B981);
  static const Color sageGreenLight = Color(0xFFD1FAE5);
  static const Color blushPink = Color(0xFFFDF2F8);

  // === LEGACY MAPPINGS (for compatibility) ===
  static const Color backgroundColor = Color(0xFFFFFBF7); // Warm white
  static const Color darkBackground = Color(0xFF1A1625); // Deep plum
  static const Color darkSurface = Color(0xFF252033);
  static const Color darkSurfaceHigh = Color(0xFF30263F);
  static const Color blush = Color(0xFFFDF2F8); // Soft blush
  static const Color coral = Color(0xFFFF6F73);

  static const Color accentOrange = Color(0xFFFF9F43);
  static const Color accentRed = Color(0xFFFF6B6B);
  static const Color accentGreen = Color(0xFF10B981);
  static const Color accentBlue = Color(0xFF42A5F5);

  // === TEXT COLORS - Warmer tones ===
  static const Color textDark = Color(0xFF1F1B2E);
  static const Color textGrey = Color(0xFF6B5B7A);
  static const Color white = Colors.white;

  static const double cardRadius = 24;
  static const double controlRadius = 16;

  static bool useGoogleFonts = true;

  static bool isDark(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  static Color bg(BuildContext context) {
    return Theme.of(context).scaffoldBackgroundColor;
  }

  static Color surface(BuildContext context) {
    return Theme.of(context).colorScheme.surface;
  }

  static Color surfaceHigh(BuildContext context) {
    return isDark(context) ? darkSurfaceHigh : white;
  }

  static Color textPrimary(BuildContext context) {
    return Theme.of(context).colorScheme.onSurface;
  }

  static Color textSecondary(BuildContext context) {
    return Theme.of(context).colorScheme.onSurfaceVariant;
  }

  static Color border(BuildContext context) {
    return isDark(context)
        ? Colors.white.withOpacity(0.08)
        : textGrey.withOpacity(0.10);
  }

  static Color mutedFill(BuildContext context) {
    return isDark(context)
        ? Colors.white.withOpacity(0.06)
        : primaryLight.withOpacity(0.45);
  }

  static Color shadow(BuildContext context) {
    return isDark(context)
        ? Colors.black.withOpacity(0.28)
        : primaryPurple.withOpacity(0.08);
  }

  static LinearGradient screenGradient(BuildContext context) {
    if (isDark(context)) {
      return const LinearGradient(
        colors: [Color(0xFF1A1625), Color(0xFF251F2E), Color(0xFF1A1625)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );
    }
    return const LinearGradient(
      colors: [Color(0xFFFFFBF7), Color(0xFFFFF5F0), Color(0xFFFFF0E8)],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );
  }

  // === NEW: Premium Gradients ===
  static LinearGradient get premiumGradient => const LinearGradient(
        colors: [Color(0xFF8B5CF6), Color(0xFF6366F1)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );

  static LinearGradient get amberGradient => const LinearGradient(
        colors: [Color(0xFFF59E0B), Color(0xFFFBBF24)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );

  static LinearGradient get warmCardGradient => LinearGradient(
        colors: [
          primaryPurple.withOpacity(0.08),
          amberGold.withOpacity(0.05),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );

  static TextStyle _outfit({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    double? letterSpacing,
    double? height,
  }) {
    final style = TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      letterSpacing: letterSpacing,
      height: height,
    );
    return useGoogleFonts ? GoogleFonts.outfit(textStyle: style) : style;
  }

  static TextStyle _beVietnamPro({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    double? height,
  }) {
    final style = TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      height: height,
    );
    return useGoogleFonts ? GoogleFonts.beVietnamPro(textStyle: style) : style;
  }

  static TextTheme _textTheme(Color primaryText, Color secondaryText) {
    return TextTheme(
      displayLarge: _outfit(
        fontSize: 30,
        fontWeight: FontWeight.w800,
        color: primaryText,
        letterSpacing: -0.2,
        height: 1.08,
      ),
      displayMedium: _outfit(
        fontSize: 24,
        fontWeight: FontWeight.w800,
        color: primaryText,
        letterSpacing: -0.1,
        height: 1.15,
      ),
      titleLarge: _outfit(
        fontSize: 22,
        fontWeight: FontWeight.w800,
        color: primaryText,
        height: 1.18,
      ),
      titleMedium: _outfit(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: primaryText,
        height: 1.25,
      ),
      titleSmall: _outfit(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: primaryText,
        height: 1.25,
      ),
      bodyLarge: _beVietnamPro(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: primaryText,
        height: 1.5,
      ),
      bodyMedium: _beVietnamPro(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: secondaryText,
        height: 1.45,
      ),
      labelLarge: _outfit(
        fontSize: 15,
        fontWeight: FontWeight.w800,
        color: white,
        height: 1.1,
      ),
      labelMedium: _outfit(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        color: secondaryText,
        height: 1.1,
      ),
    );
  }

  static ThemeData _buildTheme({
    required Brightness brightness,
    required Color background,
    required Color surface,
    required Color surfaceVariant,
    required Color onSurface,
    required Color onSurfaceVariant,
  }) {
    final scheme = ColorScheme.fromSeed(
      seedColor: primaryPurple,
      brightness: brightness,
    ).copyWith(
      primary: primaryPurple,
      onPrimary: white,
      secondary: coral,
      onSecondary: white,
      surface: surface,
      onSurface: onSurface,
      surfaceContainerHighest: surfaceVariant,
      onSurfaceVariant: onSurfaceVariant,
      error: accentRed,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      scaffoldBackgroundColor: background,
      colorScheme: scheme,
      fontFamily: useGoogleFonts ? GoogleFonts.beVietnamPro().fontFamily : null,
      textTheme: _textTheme(onSurface, onSurfaceVariant),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: onSurface),
        titleTextStyle: _outfit(
          color: onSurface,
          fontSize: 18,
          fontWeight: FontWeight.w800,
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: surface,
        surfaceTintColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryPurple,
          foregroundColor: white,
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(controlRadius),
          ),
          textStyle: _outfit(
            fontSize: 15,
            fontWeight: FontWeight.w800,
          ),
          elevation: 0,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryPurple,
          minimumSize: const Size(double.infinity, 54),
          side: const BorderSide(color: primaryPurple, width: 1.4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(controlRadius),
          ),
          textStyle: _outfit(
            fontSize: 15,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryPurple,
          textStyle: _outfit(
            fontSize: 14,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: brightness == Brightness.dark
            ? Colors.white.withOpacity(0.06)
            : primaryLight.withOpacity(0.36),
        labelStyle: _beVietnamPro(
          color: onSurfaceVariant,
          fontSize: 13,
        ),
        hintStyle: _beVietnamPro(
          fontSize: 14,
          color: onSurfaceVariant.withOpacity(0.78),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(controlRadius),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(controlRadius),
          borderSide: BorderSide(
            color: brightness == Brightness.dark
                ? Colors.white.withOpacity(0.08)
                : textGrey.withOpacity(0.08),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(controlRadius),
          borderSide: const BorderSide(color: primaryPurple, width: 2.0),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: brightness == Brightness.dark
            ? Colors.white.withOpacity(0.06)
            : primaryLight.withOpacity(0.5),
        selectedColor: primaryPurple,
        labelStyle: _beVietnamPro(
          color: onSurfaceVariant,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
        side: BorderSide.none,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primaryPurple,
        foregroundColor: white,
        elevation: 0,
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return primaryPurple;
          return Colors.transparent;
        }),
        side: BorderSide(color: onSurfaceVariant.withOpacity(0.45), width: 1.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return primaryPurple;
          return onSurfaceVariant;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return primaryPurple.withOpacity(0.28);
          }
          return onSurfaceVariant.withOpacity(0.16);
        }),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor:
            brightness == Brightness.dark ? darkSurfaceHigh : textDark,
        contentTextStyle: _beVietnamPro(
          color: white,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }

  static ThemeData get lightTheme {
    return _buildTheme(
      brightness: Brightness.light,
      background: backgroundColor,
      surface: white,
      surfaceVariant: const Color(0xFFF1EEF7),
      onSurface: textDark,
      onSurfaceVariant: textGrey,
    );
  }

  static ThemeData get darkTheme {
    return _buildTheme(
      brightness: Brightness.dark,
      background: darkBackground,
      surface: darkSurface,
      surfaceVariant: darkSurfaceHigh,
      onSurface: const Color(0xFFF7F1FA),
      onSurfaceVariant: const Color(0xFFBAB4C3),
    );
  }
}
