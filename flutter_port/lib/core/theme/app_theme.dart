// // lib/core/theme/app_theme.dart
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart'; // Add google_fonts to pubspec.yaml

// class AppTheme {
//   static const Color primaryColor = Color(0xFF008080); // Teal
//   static const Color secondaryColor = Color(0xFF4DB6AC); // Lighter Teal / Accent
//   static const Color backgroundColor = Color(0xFF121212); // Very Dark Grey (almost black)
//   static const Color surfaceColor = Color(0xFF1E1E1E); // Slightly lighter dark grey for cards/surfaces
//   static const Color onPrimaryColor = Colors.white;
//   static const Color onBackgroundColor = Color(0xFFE0E0E0); // Light grey for text on dark background
//   static const Color onSurfaceColor = Color(0xFFE0E0E0);
//   static const Color errorColor = Colors.redAccent;
//   static const Color hoverColor = Color(0xFF00796B); // Darker Teal for hover effects

//   static ThemeData get darkTheme {
//     return ThemeData(
//       brightness: Brightness.dark,
//       primaryColor: primaryColor,
//       scaffoldBackgroundColor: backgroundColor,
//       colorScheme: const ColorScheme.dark(
//         primary: primaryColor,
//         secondary: secondaryColor,
//         background: backgroundColor,
//         surface: surfaceColor,
//         onPrimary: onPrimaryColor,
//         onSecondary: Colors.black, // Text on secondary color buttons
//         onBackground: onBackgroundColor,
//         onSurface: onSurfaceColor,
//         error: errorColor,
//       ),
//       textTheme: TextTheme(
//         displayLarge: GoogleFonts.montserrat( // For main title "Pranay Shah"
//             color: onBackgroundColor,
//             fontSize: 52,
//             fontWeight: FontWeight.bold),
//         displayMedium: GoogleFonts.montserrat( // For section titles
//             color: onBackgroundColor,
//             fontSize: 36,
//             fontWeight: FontWeight.w600),
//         headlineMedium: GoogleFonts.raleway( // For sub-taglines or important text
//             color: onBackgroundColor,
//             fontSize: 24,
//             fontWeight: FontWeight.w500),
//         headlineSmall: GoogleFonts.raleway( // For project titles, smaller headings
//             color: onBackgroundColor,
//             fontSize: 20,
//             fontWeight: FontWeight.w500),
//         bodyLarge: GoogleFonts.openSans( // For body text
//             color: onBackgroundColor,
//             fontSize: 16,
//             height: 1.5), // Line height
//         bodyMedium: GoogleFonts.openSans( // For smaller body text, captions
//             color: onBackgroundColor.withOpacity(0.85),
//             fontSize: 14,
//             height: 1.5),
//         labelLarge: GoogleFonts.montserrat( // For buttons
//           color: onPrimaryColor,
//           fontSize: 16,
//           fontWeight: FontWeight.w600,
//         ),
//       ),
//       appBarTheme: AppBarTheme(
//         backgroundColor: backgroundColor,
//         elevation: 0,
//         iconTheme: const IconThemeData(color: onBackgroundColor),
//         titleTextStyle: GoogleFonts.montserrat(
//             color: onBackgroundColor,
//             fontSize: 20,
//             fontWeight: FontWeight.w600),
//       ),
//       elevatedButtonTheme: ElevatedButtonThemeData(
//         style: ElevatedButton.styleFrom(
//           backgroundColor: primaryColor,
//           foregroundColor: onPrimaryColor,
//           padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
//           textStyle: GoogleFonts.montserrat(
//               fontSize: 16, fontWeight: FontWeight.w600),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(8),
//           ),
//         ),
//       ),
//       outlinedButtonTheme: OutlinedButtonThemeData(
//         style: OutlinedButton.styleFrom(
//           foregroundColor: primaryColor,
//           side: const BorderSide(color: primaryColor, width: 1.5),
//           padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
//           textStyle: GoogleFonts.montserrat(
//               fontSize: 16, fontWeight: FontWeight.w600),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(8),
//           ),
//         ),
//       ),
//       textButtonTheme: TextButtonThemeData(
//         style: TextButton.styleFrom(
//           foregroundColor: primaryColor,
//           textStyle: GoogleFonts.montserrat(
//             fontSize: 16,
//             fontWeight: FontWeight.w600,
//             decoration: TextDecoration.underline,
//             decorationColor: primaryColor,
//           ),
//         ),
//       ),
//       inputDecorationTheme: InputDecorationTheme(
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(8.0),
//           borderSide: const BorderSide(color: surfaceColor),
//         ),
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(8.0),
//           borderSide: BorderSide(color: onBackgroundColor.withOpacity(0.5)),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(8.0),
//           borderSide: const BorderSide(color: primaryColor, width: 1.5),
//         ),
//         labelStyle: GoogleFonts.openSans(color: onBackgroundColor.withOpacity(0.7)),
//         hintStyle: GoogleFonts.openSans(color: onBackgroundColor.withOpacity(0.5)),
//       ),
//       // Add hover effects later, potentially using custom widgets or MaterialStateProperty
//     );
//   }
// }

// lib/core/theme/app_theme.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // --- New Light & Airy Theme with Teal Accent ---
  static const Color primaryColor = Color(0xFF00897B); // A vibrant Teal (slightly different from 008080)
  static const Color primaryColorDark = Color(0xFF00695C); // Darker Teal for hovers/shades
  static const Color primaryColorLight = Color(0xFF4DB6AC); // Lighter Teal

  static const Color accentColorBrown = Color(0xFF6D4C41); // Brown for text or secondary accents

  static const Color backgroundColor = Color(0xFFFDFDFD); // Very light, almost white background
  static const Color surfaceColor = Color(0xFFFFFFFF); // Pure White for Cards/Surfaces
  
  static const Color onPrimaryColor = Colors.white;      // Text on primary teal buttons
  static const Color onBackgroundColor = Color(0xFF3A3A3A); // Dark Grey for text on light background
  static const Color onSurfaceColor = Color(0xFF212121);    // Very Dark Grey for text on white surfaces

  static const Color subtleBorderColor = Color(0xFFECEFF1); // Light grey for subtle borders (Blue Grey 50)
  static const Color lightTextColor = Color(0xFF78909C); // Medium grey for less important text (Blue Grey 300)

  static Color errorColor = Colors.red.shade500;

  static ThemeData get portfolioLightTheme {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: backgroundColor,
      // Using colorScheme for more fine-grained control in Material 3
      colorScheme: ColorScheme.light(
        primary: primaryColor,
        onPrimary: onPrimaryColor,
        primaryContainer: primaryColorLight, // A container color related to primary
        onPrimaryContainer: primaryColorDark,
        secondary: accentColorBrown, // Using brown as a secondary accent
        onSecondary: Colors.white,
        secondaryContainer: Color(0xFFD7CCC8), // Light brown for containers
        onSecondaryContainer: accentColorBrown,
        tertiary: primaryColorLight, // Can use another accent if needed
        onTertiary: primaryColorDark,
        error: errorColor,
        onError: Colors.white,
        background: backgroundColor,
        onBackground: onBackgroundColor,
        surface: surfaceColor,
        onSurface: onSurfaceColor,
        surfaceVariant: backgroundColor, // For slightly different surfaces
        onSurfaceVariant: onBackgroundColor,
        outline: subtleBorderColor,
        shadow: Colors.black.withOpacity(0.1),
        surfaceTint: Colors.transparent, // Important for M3 to avoid tinting cards
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.playfairDisplay( // Elegant serif for main headings
            color: onBackgroundColor,
            fontSize: 52,
            fontWeight: FontWeight.w700, // Can be bold or regular for Playfair
            letterSpacing: 0.5),
        displayMedium: GoogleFonts.playfairDisplay(
            color: onBackgroundColor,
            fontSize: 38,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.25),
        headlineMedium: GoogleFonts.raleway( // Clean sans-serif for other headings
            color: onSurfaceColor,
            fontSize: 24,
            fontWeight: FontWeight.w700), // Bolder for emphasis
        headlineSmall: GoogleFonts.raleway(
            color: onSurfaceColor,
            fontSize: 20,
            fontWeight: FontWeight.w600),
        bodyLarge: GoogleFonts.lato( // Clear sans-serif for body
            color: onBackgroundColor,
            fontSize: 17, // Slightly larger body text
            height: 1.65, // More line spacing
            fontWeight: FontWeight.w400),
        bodyMedium: GoogleFonts.lato(
            color: lightTextColor,
            fontSize: 15,
            height: 1.6,
            fontWeight: FontWeight.w400),
        labelLarge: GoogleFonts.raleway( // For buttons
          color: onPrimaryColor,
          fontSize: 16,
          fontWeight: FontWeight.bold, // Bolder button text
          letterSpacing: 0.8
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: backgroundColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: primaryColor),
        titleTextStyle: GoogleFonts.raleway(
            color: onBackgroundColor,
            fontSize: 18,
            fontWeight: FontWeight.w600),
        surfaceTintColor: Colors.transparent,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: onPrimaryColor,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
          textStyle: GoogleFonts.raleway(
              fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 0.8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30), // More rounded buttons
          ),
          elevation: 3, // Default elevation
          shadowColor: primaryColor.withOpacity(0.4),
        ).copyWith(
          elevation: MaterialStateProperty.resolveWith<double?>(
            (Set<MaterialState> states) {
              if (states.contains(MaterialState.hovered)) return 8; // Increased elevation
              if (states.contains(MaterialState.pressed)) return 2;
              return 4;
            },
          ),
          backgroundColor: MaterialStateProperty.resolveWith<Color?>(
            (Set<MaterialState> states) {
              if (states.contains(MaterialState.hovered)) return primaryColorDark;
              return primaryColor;
            },
          ),
          // Add a subtle scale transform on hover/press
          // transform: MaterialStateProperty.resolveWith<Matrix4?>(
          //   (Set<MaterialState> states) {
          //     if (states.contains(MaterialState.hovered)) {
          //       return Matrix4.translationValues(0, -2, 0)..scale(1.02);
          //     }
          //     if (states.contains(MaterialState.pressed)) {
          //       return Matrix4.translationValues(0, 1, 0)..scale(0.98);
          //     }
          //     return Matrix4.identity();
          //   },
          // ),
        )
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryColor,
          side: BorderSide(color: primaryColor.withOpacity(0.7), width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
          textStyle: GoogleFonts.raleway(
              fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 0.8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ).copyWith(
           backgroundColor: MaterialStateProperty.resolveWith<Color?>(
            (Set<MaterialState> states) {
              if (states.contains(MaterialState.hovered)) {
                return primaryColor.withOpacity(0.05); // Subtle fill on hover
              }
              return Colors.transparent;
            },
          ),
          side: MaterialStateProperty.resolveWith<BorderSide?>(
            (Set<MaterialState> states) {
              if (states.contains(MaterialState.hovered)) {
                 return const BorderSide(color: primaryColor, width: 2);
              }
              return BorderSide(color: primaryColor.withOpacity(0.7), width: 1.5);
            },
          ),
        )
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceColor.withOpacity(0.8), // Slightly transparent white fill
        hintStyle: GoogleFonts.lato(color: lightTextColor.withOpacity(0.7), fontSize: 15),
        labelStyle: GoogleFonts.lato(color: onSurfaceColor.withOpacity(0.8), fontSize: 16, fontWeight: FontWeight.w500),
        contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18), // Increased padding
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0), // More rounded fields
          borderSide: BorderSide(color: subtleBorderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: subtleBorderColor.withOpacity(0.6)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        prefixIconColor: primaryColor.withOpacity(0.7),
      ),
      cardTheme: CardTheme(
        elevation: 1, // Very subtle elevation for cards
        color: surfaceColor,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 0)
      ),
      chipTheme: ChipThemeData(
        backgroundColor: primaryColor.withOpacity(0.08),
        labelStyle: GoogleFonts.lato(color: primaryColorDark, fontWeight: FontWeight.w600, fontSize: 13),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10), // More padding
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: primaryColor.withOpacity(0.2)), // Subtle border
        ),
        iconTheme: IconThemeData(color: primaryColorDark, size: 18), // Larger icon
      ),
      tooltipTheme: TooltipThemeData(
        preferBelow: false,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        textStyle: GoogleFonts.lato(color: onPrimaryColor, fontSize: 13),
        decoration: BoxDecoration(
          color: primaryColorDark.withOpacity(0.95), // Slightly more opaque
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}