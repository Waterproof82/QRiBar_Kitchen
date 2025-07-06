import 'package:flutter/material.dart';
import 'package:qribar_cocina/app/const/app_colors.dart';

final class AppFonts {
  const AppFonts._();

  // Main text styles
  static const TextStyle headlineLarge = TextStyle(
    fontFamily: 'Roboto',
    fontWeight: FontWeight.bold,
    fontSize: 32,
    color: AppColors.primaryDarker,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 16,
    color: AppColors.onBackground,
  );

  static const TextStyle labelLarge = TextStyle(
    fontFamily: 'Roboto',
    fontWeight: FontWeight.w500,
    fontSize: 14,
    color: AppColors.primaryDark,
  );

  // Additional text styles for compatibility
  static const TextStyle headLine = TextStyle(
    fontFamily: 'Roboto',
    fontWeight: FontWeight.bold,
    fontSize: 18,
    color: AppColors.black,
  );

  static const TextStyle bodyText2 = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 14,
    color: AppColors.blackSoft,
  );

  // Complete text theme for ThemeData
  static const TextTheme textTheme = TextTheme(
    headlineLarge: headlineLarge,
    bodyMedium: bodyMedium,
    labelLarge: labelLarge,
  );
}
