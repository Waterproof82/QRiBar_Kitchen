import 'package:flutter/material.dart';

/// A final class containing the custom color palette for the application.
final class AppColors {
  /// Prevents the class from being instantiated.
  /// All members are static and accessed directly via the class name.
  const AppColors._();

  // Defines the primary green color palette for the application.
  static const Color primary = Color(0xFF4CAF50);
  static const Color primaryDark = Color(0xFF388E3C);
  static const Color primaryDarker = Color(0xFF1B5E20);

  // Defines background and surface colors, along with their contrasting text/icon colors.
  static const Color background = Color(0xFFFAFAFA);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color onBackground = Color(0xFF263238);

  // Defines colors specifically for text and labels within the UI.
  static const Color textBody = Color(0xFF263238);
  static const Color textLabel = Color(0xFF388E3C);
  static const Color textHint = Color(0xFF616161);

  // Defines colors used for UI elements like borders and error states.
  static const Color focusedBorder = Color(0xFF4CAF50);
  static const Color error = Color(0xFFD32F2F);

  // Defines additional utility and accent colors used throughout the application.
  static const Color secondary = Color(0xFFFFA000);
  static const Color complementary = Color(0xFFBF360C);
  static const Color onSurface = Color(0xFF000000);
  static const Color black = Color(0xFF000000);
  static const Color blackSoft = Color.fromRGBO(0, 0, 0, 0.87);
  static const Color blackSoft2 = Color.fromRGBO(0, 0, 0, 0.6);
  static const Color greySoft = Color(0xFF757575);
  static const Color greyBackGround = Color(0xFFF6F6F6);

  // Transparent color for overlays, spacing, etc.
  static const Color transparent = Colors.transparent;
}
