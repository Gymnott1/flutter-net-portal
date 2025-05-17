import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Enhanced Flutter theme with improved light and dark modes
/// Features better color cohesion, refined component styles, and additional theme elements

// --- Core Color Palettes ---
class AppColors {
  // Light Theme
  static const primaryLight = Color(0xFFC76723); // Amazon Orange
  static const secondaryLight = Color(0xFF232F3E); // Amazon Dark Blue
  static const accentLight = Color(0xFF037EC0); // Complementary Blue
  static const errorLight = Color(0xFFD32F2F); // Error Red
  static const successLight = Color(0xFF388E3C); // Success Green
  static const warningLight = Color(0xFFFFA000); // Warning Amber
  static const infoLight = Color(0xFF1976D2); // Info Blue

  // Backgrounds & Surfaces (Light)
  static const scaffoldLight = Color(
    0xFFFAFAFA,
  ); // Off-white for less eye strain
  static const cardLight = Colors.white;
  static const textFieldLight = Color(0xFFF5F5F5);
  static const dividerLight = Color(0xFFE0E0E0);

  // Text Colors (Light)
  static const textPrimaryLight = Color(0xFF212121);
  static const textSecondaryLight = Color(0xFF757575);
  static const textTertiaryLight = Color(0xFF9E9E9E);
  static const onPrimaryLight = Colors.white;

  // Dark Theme
  static const primaryDark = Color(0xFFFFAB40); // Lighter Orange for dark theme
  static const secondaryDark = Color(0xFF1A2433); // Deeper blue for dark mode
  static const accentDark = Color(0xFF4FC3F7); // Light Blue accent
  static const errorDark = Color(0xFFEF5350); // Brighter Error
  static const successDark = Color(0xFF66BB6A); // Brighter Success
  static const warningDark = Color(0xFFFFD54F); // Brighter Warning
  static const infoDark = Color(0xFF42A5F5); // Brighter Info

  // Backgrounds & Surfaces (Dark)
  static const scaffoldDark = Color(0xFF121212); // Material dark background
  static const cardDark = Color(0xFF1D1D1D); // Slightly lighter than scaffold
  static const textFieldDark = Color(
    0xFF2C2C2C,
  ); // Lighter input fields for contrast
  static const dividerDark = Color(0xFF424242); // Dark dividers

  // Text Colors (Dark)
  static const textPrimaryDark = Color(
    0xFFECECEC,
  ); // Not pure white for less eye strain
  static const textSecondaryDark = Color(0xFFB0B0B0);
  static const textTertiaryDark = Color(0xFF787878);
  static const onPrimaryDark = Color(0xFF121212); // Dark text on light buttons

  static const lowerLoginText = Color(0xFF121212);
}

// Common spacing & dimensions
class AppDimensions {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;

  static const double buttonHeight = 52.0;
  static const double buttonRadius = 8.0;
  static const double cardRadius = 12.0;
  static const double textFieldRadius = 8.0;
}

class AppTheme {
  static TextTheme _buildTextTheme(
    TextTheme base,
    Color primaryTextColor,
    Color secondaryTextColor,
  ) {
    return base.copyWith(
      displayLarge: GoogleFonts.roboto(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        letterSpacing: -0.5,
        color: primaryTextColor,
      ),
      displayMedium: GoogleFonts.roboto(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.25,
        color: primaryTextColor,
      ),
      displaySmall: GoogleFonts.roboto(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: primaryTextColor,
      ),
      headlineMedium: GoogleFonts.roboto(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: primaryTextColor,
      ),
      headlineSmall: GoogleFonts.roboto(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: primaryTextColor,
      ),
      titleLarge: GoogleFonts.roboto(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: primaryTextColor,
      ),
      titleMedium: GoogleFonts.roboto(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: primaryTextColor,
      ),
      titleSmall: GoogleFonts.roboto(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: secondaryTextColor,
      ),
      bodyLarge: GoogleFonts.roboto(fontSize: 16, color: primaryTextColor),
      bodyMedium: GoogleFonts.roboto(fontSize: 14, color: primaryTextColor),
      bodySmall: GoogleFonts.roboto(fontSize: 12, color: secondaryTextColor),
      labelLarge: GoogleFonts.roboto(fontSize: 14, fontWeight: FontWeight.w600),
    );
  }

  // Shared button style builder
  static ButtonStyle _buildButtonStyle({
    required Color backgroundColor,
    required Color foregroundColor,
    Color? borderColor,
    double height = 40.0,
    double? minimumWidth,
  }) {
    return ButtonStyle(
      backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
        if (states.contains(MaterialState.disabled)) {
          return backgroundColor.withOpacity(0.3);
        }
        if (states.contains(MaterialState.pressed)) {
          return backgroundColor.withOpacity(0.8);
        }
        return backgroundColor;
      }),
      foregroundColor: MaterialStateProperty.resolveWith<Color>((states) {
        if (states.contains(MaterialState.disabled)) {
          return foregroundColor.withOpacity(0.5);
        }
        return foregroundColor;
      }),
      overlayColor: MaterialStateProperty.resolveWith<Color>((states) {
        return foregroundColor.withOpacity(0.1);
      }),
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.buttonRadius),
          side:
              borderColor != null
                  ? BorderSide(color: borderColor, width: 1.5)
                  : BorderSide.none,
        ),
      ),
      minimumSize: MaterialStateProperty.all<Size>(
        Size(minimumWidth ?? 0, height),
      ),
      padding: MaterialStateProperty.all<EdgeInsets>(
        const EdgeInsets.symmetric(horizontal: AppDimensions.lg),
      ),
      elevation: MaterialStateProperty.resolveWith<double>((states) {
        if (states.contains(MaterialState.disabled)) return 0;
        if (states.contains(MaterialState.pressed)) return 1;
        return 2;
      }),
    );
  }

  static ThemeData get lightTheme {
    final base = ThemeData.light();
    final textTheme = _buildTextTheme(
      base.textTheme,
      AppColors.textPrimaryLight,
      AppColors.textSecondaryLight,
    );

    return ThemeData(
      brightness: Brightness.light,
      primaryColor: AppColors.primaryLight,
      primaryColorDark: AppColors.primaryLight.withOpacity(0.8),
      primaryColorLight: AppColors.primaryLight.withOpacity(0.4),
      canvasColor: AppColors.scaffoldLight,
      scaffoldBackgroundColor: AppColors.scaffoldLight,
      cardColor: AppColors.cardLight,
      dividerColor: AppColors.dividerLight,
      focusColor: AppColors.primaryLight.withOpacity(0.12),
      hoverColor: AppColors.primaryLight.withOpacity(0.06),
      splashColor: AppColors.primaryLight.withOpacity(0.15),
      fontFamily: GoogleFonts.roboto().fontFamily,

      // AppBar
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.primaryLight,
        elevation: 0,
        centerTitle: false,
        iconTheme: const IconThemeData(color: AppColors.onPrimaryLight),
        titleTextStyle: GoogleFonts.roboto(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.onPrimaryLight,
        ),
        toolbarHeight: 56,
        shadowColor: AppColors.secondaryLight.withOpacity(0.15),
      ),

      // Buttons
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: _buildButtonStyle(
          backgroundColor: AppColors.primaryLight,
          foregroundColor: AppColors.onPrimaryLight,
          //borderColor: AppColors.primaryLight,
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: _buildButtonStyle(
          backgroundColor: Colors.transparent,
          foregroundColor: AppColors.primaryLight,
          //borderColor: AppColors.primaryLight,
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          foregroundColor: MaterialStateProperty.all<Color>(
            AppColors.primaryLight,
          ),
          textStyle: MaterialStateProperty.all<TextStyle>(
            GoogleFonts.roboto(fontWeight: FontWeight.w600),
          ),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimensions.sm),
            ),
          ),
          overlayColor: MaterialStateProperty.all<Color>(
            AppColors.primaryLight.withOpacity(0.1),
          ),
        ),
      ),

      // Card
      cardTheme: CardTheme(
        color: AppColors.cardLight,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
        ),
        shadowColor: AppColors.secondaryLight.withOpacity(0.1),
      ),

      // Inputs
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.textFieldLight,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.md,
          vertical: AppDimensions.md,
        ),
        hintStyle: GoogleFonts.roboto(
          color: AppColors.textTertiaryLight,
          fontSize: 14,
        ),
        labelStyle: GoogleFonts.roboto(
          color: AppColors.textSecondaryLight,
          fontSize: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.textFieldRadius),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.textFieldRadius),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.textFieldRadius),
          borderSide: const BorderSide(
            color: AppColors.primaryLight,
            width: 1.5,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.textFieldRadius),
          borderSide: const BorderSide(color: AppColors.errorLight, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.textFieldRadius),
          borderSide: const BorderSide(color: AppColors.errorLight, width: 1.5),
        ),
        prefixIconColor: AppColors.textSecondaryLight,
        suffixIconColor: AppColors.textSecondaryLight,
      ),

      // Checkbox & Toggle
      checkboxTheme: CheckboxThemeData(
        fillColor: MaterialStateProperty.resolveWith<Color>((states) {
          if (states.contains(MaterialState.disabled)) {
            return AppColors.textTertiaryLight;
          }
          if (states.contains(MaterialState.selected)) {
            return AppColors.primaryLight;
          }
          return Colors.transparent;
        }),
        side: const BorderSide(width: 1.5, color: AppColors.textSecondaryLight),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
      ),

      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith<Color>((states) {
          if (states.contains(MaterialState.disabled)) {
            return AppColors.textTertiaryLight;
          }
          if (states.contains(MaterialState.selected)) {
            return AppColors.primaryLight;
          }
          return Colors.white;
        }),
        trackColor: MaterialStateProperty.resolveWith<Color>((states) {
          if (states.contains(MaterialState.disabled)) {
            return AppColors.dividerLight;
          }
          if (states.contains(MaterialState.selected)) {
            return AppColors.primaryLight.withOpacity(0.4);
          }
          return AppColors.textTertiaryLight;
        }),
      ),

      // Chip
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.primaryLight.withOpacity(0.08),
        disabledColor: AppColors.dividerLight,
        selectedColor: AppColors.primaryLight.withOpacity(0.2),
        labelStyle: GoogleFonts.roboto(
          fontSize: 12,
          color: AppColors.textPrimaryLight,
        ),
        secondaryLabelStyle: GoogleFonts.roboto(
          fontSize: 12,
          color: AppColors.primaryLight,
          fontWeight: FontWeight.w500,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.md,
          vertical: AppDimensions.xs,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.sm),
        ),
      ),

      // Dialogs & Bottom Sheets
      dialogTheme: DialogTheme(
        backgroundColor: AppColors.cardLight,
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.lg),
        ),
      ),

      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.cardLight,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(AppDimensions.xl),
            topRight: Radius.circular(AppDimensions.xl),
          ),
        ),
      ),

      // Progress Indicators
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.primaryLight,
        linearTrackColor: AppColors.dividerLight,
        refreshBackgroundColor: AppColors.dividerLight,
      ),

      // Color Scheme
      colorScheme: ColorScheme.light(
        primary: AppColors.primaryLight,
        primaryContainer: AppColors.primaryLight.withOpacity(0.15),
        onPrimaryContainer: AppColors.primaryLight.withOpacity(0.8),
        secondary: AppColors.secondaryLight,
        secondaryContainer: AppColors.secondaryLight.withOpacity(0.1),
        onSecondaryContainer: AppColors.secondaryLight,
        tertiary: AppColors.accentLight,
        tertiaryContainer: AppColors.accentLight.withOpacity(0.1),
        onTertiaryContainer: AppColors.accentLight,
        error: AppColors.errorLight,
        errorContainer: AppColors.errorLight.withOpacity(0.1),
        onErrorContainer: AppColors.errorLight,
        surface: AppColors.cardLight,
        background: AppColors.scaffoldLight,
        onBackground: AppColors.textPrimaryLight,
        onSurface: AppColors.textPrimaryLight,
        onPrimary: AppColors.onPrimaryLight,
        onSecondary: Colors.white,
        onError: Colors.white,
      ),

      textTheme: textTheme,
    );
  }

  static ThemeData get darkTheme {
    final base = ThemeData.dark();
    final textTheme = _buildTextTheme(
      base.textTheme,
      AppColors.textPrimaryDark,
      AppColors.textSecondaryDark,
    );

    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: AppColors.primaryDark,
      primaryColorDark: AppColors.primaryDark.withOpacity(0.8),
      primaryColorLight: AppColors.primaryDark.withOpacity(0.4),
      canvasColor: AppColors.scaffoldDark,
      scaffoldBackgroundColor: AppColors.scaffoldDark,
      cardColor: AppColors.cardDark,
      dividerColor: AppColors.dividerDark,
      focusColor: AppColors.primaryDark.withOpacity(0.12),
      hoverColor: AppColors.primaryDark.withOpacity(0.06),
      splashColor: AppColors.primaryDark.withOpacity(0.15),
      fontFamily: GoogleFonts.roboto().fontFamily,

      // AppBar
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.secondaryDark,
        elevation: 0,
        centerTitle: false,
        iconTheme: const IconThemeData(color: AppColors.textPrimaryDark),
        titleTextStyle: GoogleFonts.roboto(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimaryDark,
        ),
        toolbarHeight: 56,
        shadowColor: Colors.black.withOpacity(0.2),
      ),

      // Buttons
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: _buildButtonStyle(
          backgroundColor: AppColors.primaryDark,
          height: AppDimensions.buttonHeight,
          foregroundColor: AppColors.onPrimaryDark,
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: _buildButtonStyle(
          backgroundColor: Colors.transparent,
          foregroundColor: AppColors.primaryDark,
          //borderColor: AppColors.primaryDark,
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          foregroundColor: MaterialStateProperty.all<Color>(
            AppColors.primaryDark,
          ),
          textStyle: MaterialStateProperty.all<TextStyle>(
            GoogleFonts.roboto(fontWeight: FontWeight.w600),
          ),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimensions.sm),
            ),
          ),
          overlayColor: MaterialStateProperty.all<Color>(
            AppColors.primaryDark.withOpacity(0.15),
          ),
        ),
      ),

      // Card
      cardTheme: CardTheme(
        color: AppColors.cardDark,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
        ),
        shadowColor: Colors.black.withOpacity(0.3),
      ),

      // Inputs
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.textFieldDark,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.md,
          vertical: AppDimensions.md,
        ),
        hintStyle: GoogleFonts.roboto(
          color: AppColors.textTertiaryDark,
          fontSize: 14,
        ),
        labelStyle: GoogleFonts.roboto(
          color: AppColors.textSecondaryDark,
          fontSize: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.textFieldRadius),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.textFieldRadius),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.textFieldRadius),
          borderSide: const BorderSide(
            color: AppColors.primaryDark,
            width: 1.5,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.textFieldRadius),
          borderSide: const BorderSide(color: AppColors.errorDark, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.textFieldRadius),
          borderSide: const BorderSide(color: AppColors.errorDark, width: 1.5),
        ),
        prefixIconColor: AppColors.textSecondaryDark,
        suffixIconColor: AppColors.textSecondaryDark,
      ),

      // Checkbox & Toggle
      checkboxTheme: CheckboxThemeData(
        fillColor: MaterialStateProperty.resolveWith<Color>((states) {
          if (states.contains(MaterialState.disabled)) {
            return AppColors.textTertiaryDark;
          }
          if (states.contains(MaterialState.selected)) {
            return AppColors.primaryDark;
          }
          return Colors.transparent;
        }),
        side: const BorderSide(width: 1.5, color: AppColors.textSecondaryDark),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
      ),

      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith<Color>((states) {
          if (states.contains(MaterialState.disabled)) {
            return AppColors.textTertiaryDark;
          }
          if (states.contains(MaterialState.selected)) {
            return AppColors.primaryDark;
          }
          return Colors.white;
        }),
        trackColor: MaterialStateProperty.resolveWith<Color>((states) {
          if (states.contains(MaterialState.disabled)) {
            return AppColors.dividerDark;
          }
          if (states.contains(MaterialState.selected)) {
            return AppColors.primaryDark.withOpacity(0.4);
          }
          return AppColors.textTertiaryDark;
        }),
      ),

      // Chip
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.primaryDark.withOpacity(0.12),
        disabledColor: AppColors.dividerDark,
        selectedColor: AppColors.primaryDark.withOpacity(0.25),
        labelStyle: GoogleFonts.roboto(
          fontSize: 12,
          color: AppColors.textPrimaryDark,
        ),
        secondaryLabelStyle: GoogleFonts.roboto(
          fontSize: 12,
          color: AppColors.primaryDark,
          fontWeight: FontWeight.w500,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.md,
          vertical: AppDimensions.xs,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.sm),
        ),
      ),

      // Dialogs & Bottom Sheets
      dialogTheme: DialogTheme(
        backgroundColor: AppColors.cardDark,
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.lg),
        ),
      ),

      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.cardDark,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(AppDimensions.xl),
            topRight: Radius.circular(AppDimensions.xl),
          ),
        ),
      ),

      // Progress Indicators
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.primaryDark,
        linearTrackColor: AppColors.dividerDark,
        refreshBackgroundColor: AppColors.dividerDark,
      ),

      // Color Scheme
      colorScheme: ColorScheme.dark(
        primary: AppColors.primaryDark,
        primaryContainer: AppColors.primaryDark.withOpacity(0.15),
        onPrimaryContainer: AppColors.primaryDark,
        secondary: AppColors.secondaryDark,
        secondaryContainer: AppColors.secondaryDark.withOpacity(0.1),
        onSecondaryContainer: AppColors.textPrimaryDark,
        tertiary: AppColors.accentDark,
        tertiaryContainer: AppColors.accentDark.withOpacity(0.1),
        onTertiaryContainer: AppColors.accentDark,
        error: AppColors.errorDark,
        errorContainer: AppColors.errorDark.withOpacity(0.1),
        onErrorContainer: AppColors.errorDark,
        surface: AppColors.cardDark,
        background: AppColors.scaffoldDark,
        onBackground: AppColors.textPrimaryDark,
        onSurface: AppColors.textPrimaryDark,
        onPrimary: AppColors.onPrimaryDark,
        onSecondary: AppColors.textPrimaryDark,
        onError: Colors.black,
      ),

      textTheme: textTheme,
    );
  }
}
