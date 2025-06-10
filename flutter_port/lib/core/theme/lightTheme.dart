// lib/core/theme/app_theme.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // --- New Beige and Brown Palette ---
  static const Color primaryColor = Color(0xFF795548); // Brown 500 - Main Accent
  static const Color secondaryColor = Color(0xFFA1887F); // Brown 300 - Lighter Brown / Secondary Accent
  static const Color backgroundColor = Color(0xFFFAF0E6); // Linen - Light Beige Background
  static const Color surfaceColor = Color(0xFFFFFFFF); // White - For Cards and Elevated Surfaces
  
  static const Color onPrimaryColor = Colors.white; // Text on primary brown buttons
  static const Color onSecondaryColor = Colors.white; // Text on secondary brown elements
  static const Color onBackgroundColor = Color(0xFF4E342E); // Brown 800 - Dark Brown for text on beige
  static const Color onSurfaceColor = Color(0xFF3E2723); // Brown 900 - Very Dark Brown for text on white surfaces

  static const Color hoverColor = Color(0xFF6D4C41); // Brown 600 - Darker Brown for hover
  static const Color subtleBorderColor = Color(0xFFD7CCC8); // Brown 100 - for subtle borders or dividers

  static Color errorColor = Colors.red.shade700; // A darker red suitable for light themes

  static ThemeData get lightTheme { // Renamed to lightTheme for clarity
    return ThemeData(
      brightness: Brightness.light, // Changed to light
      primaryColor: primaryColor,
      scaffoldBackgroundColor: backgroundColor,
      colorScheme: ColorScheme.light( // Changed to ColorScheme.light
        primary: primaryColor,
        secondary: secondaryColor,
        background: backgroundColor,
        surface: surfaceColor,
        onPrimary: onPrimaryColor,
        onSecondary: onSecondaryColor,
        onBackground: onBackgroundColor,
        onSurface: onSurfaceColor,
        error: errorColor,
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.montserrat(
            color: onBackgroundColor, // Dark text on light background
            fontSize: 52,
            fontWeight: FontWeight.bold),
        displayMedium: GoogleFonts.montserrat(
            color: onBackgroundColor,
            fontSize: 36,
            fontWeight: FontWeight.w600),
        headlineMedium: GoogleFonts.raleway(
            color: onBackgroundColor,
            fontSize: 24,
            fontWeight: FontWeight.w500),
        headlineSmall: GoogleFonts.raleway(
            color: onBackgroundColor,
            fontSize: 20,
            fontWeight: FontWeight.w500),
        bodyLarge: GoogleFonts.openSans(
            color: onBackgroundColor,
            fontSize: 16,
            height: 1.5),
        bodyMedium: GoogleFonts.openSans(
            color: onBackgroundColor.withOpacity(0.85), // Slightly lighter dark text
            fontSize: 14,
            height: 1.5),
        labelLarge: GoogleFonts.montserrat( // For buttons
          color: onPrimaryColor, // Text on primary colored buttons
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: surfaceColor, // Could be surface or background
        elevation: 1, // Add slight elevation for light theme app bars
        iconTheme: const IconThemeData(color: onSurfaceColor), // Dark icons
        titleTextStyle: GoogleFonts.montserrat(
            color: onSurfaceColor, // Dark text
            fontSize: 20,
            fontWeight: FontWeight.w600),
        surfaceTintColor: Colors.transparent, // Prevents material 3 tinting
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor, // Brown button
          foregroundColor: onPrimaryColor, // White text
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          textStyle: GoogleFonts.montserrat(
              fontSize: 16, fontWeight: FontWeight.w600),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 2, // Default elevation
        ).copyWith(
          // Adding hover effect directly to button theme
          overlayColor: MaterialStateProperty.resolveWith<Color?>(
            (Set<MaterialState> states) {
              if (states.contains(MaterialState.hovered)) {
                return hoverColor.withOpacity(0.9); // Darker brown on hover
              }
              return null; // Defer to the widget's default.
            },
          ),
          elevation: MaterialStateProperty.resolveWith<double?>(
            (Set<MaterialState> states) {
              if (states.contains(MaterialState.hovered)) return 4; // Increase elevation on hover
              return 2; // Default elevation
            },
          ),
        )
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryColor, // Brown text/border
          side: const BorderSide(color: primaryColor, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          textStyle: GoogleFonts.montserrat(
              fontSize: 16, fontWeight: FontWeight.w600),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ).copyWith(
           overlayColor: MaterialStateProperty.resolveWith<Color?>(
            (Set<MaterialState> states) {
              if (states.contains(MaterialState.hovered)) {
                return primaryColor.withOpacity(0.08); // Subtle brown overlay
              }
              return null; 
            },
          ),
        )
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryColor, // Brown text
          textStyle: GoogleFonts.montserrat(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            // Optional: remove underline or change its style for light theme
            // decoration: TextDecoration.underline,
            // decorationColor: primaryColor,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true, // Add a fill color to text fields
        fillColor: surfaceColor.withOpacity(0.7), // Slightly off-white fill
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: subtleBorderColor), // Subtle border
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: subtleBorderColor.withOpacity(0.7)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: primaryColor, width: 1.5),
        ),
        labelStyle: GoogleFonts.openSans(color: onBackgroundColor.withOpacity(0.8)),
        hintStyle: GoogleFonts.openSans(color: onBackgroundColor.withOpacity(0.6)),
        prefixIconColor: primaryColor.withOpacity(0.8),
      ),
      cardTheme: CardTheme( // Define a default card theme
        elevation: 2,
        color: surfaceColor,
        surfaceTintColor: Colors.transparent, // Prevent M3 tinting on cards
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
          // side: BorderSide(color: subtleBorderColor, width: 0.5) // Optional subtle border for cards
        ),
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0)
      ),
      chipTheme: ChipThemeData( // Default chip theme
        backgroundColor: surfaceColor,
        disabledColor: backgroundColor.withOpacity(0.5),
        selectedColor: primaryColor,
        secondarySelectedColor: primaryColor, // For checkmark, delete icon etc.
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        labelStyle: GoogleFonts.openSans(color: onSurfaceColor, fontWeight: FontWeight.w500),
        secondaryLabelStyle: GoogleFonts.openSans(color: onPrimaryColor),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: subtleBorderColor)
        ),
        elevation: 0,
        pressElevation: 2,
      ),
      // Consider adding hoverColor usage in custom components or specific widget themes if needed
    );
  }

  // Keep the darkTheme if you want to offer a theme switcher, otherwise, you can remove it.
  // For now, let's assume you are switching to light theme as the primary.
  // static ThemeData get darkTheme { ... your previous dark theme code ... }
}