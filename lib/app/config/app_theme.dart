import 'package:flutter/material.dart';
import 'package:qribar_cocina/app/const/app_colors.dart';
import 'package:qribar_cocina/app/const/app_fonts.dart';

/// Defines the general theme of the application using the color palette
/// and font styles from [AppColors] and [AppFonts].
final class AppTheme {
  const AppTheme._();

  /// Common border radius for UI elements.
  static const double themeRadius = 12;

  /// Returns the [ThemeData] configured for the application.
  static ThemeData theme() {
    return ThemeData(
      useMaterial3: true,

      // Color scheme configuration for light theme
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        onPrimary: AppColors.onPrimary,
        secondary: AppColors.secondary,
        onSecondary: AppColors.onPrimary,
        surface: AppColors.background,
        onSurface: AppColors.onSurface,
        error: AppColors.error,
        onError: AppColors.onPrimary,
        brightness: Brightness.light,
      ),

      // Scaffold background color
      scaffoldBackgroundColor: AppColors.background,

      // AppBar theme configuration
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.primaryDark,
        foregroundColor: AppColors.onPrimary,
        elevation: 0,
        titleTextStyle: TextStyle(
          color: AppColors.onPrimary,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
        surfaceTintColor: AppColors.background,
      ),

      // Global text theme, leveraging AppFonts definitions
      textTheme: AppFonts.textTheme,

      // Input field decoration theme
      inputDecorationTheme: InputDecorationTheme(
        floatingLabelBehavior: FloatingLabelBehavior.never,
        filled: true,
        fillColor: AppColors.greyBackGround,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(themeRadius),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(themeRadius),
          borderSide: const BorderSide(
            color: AppColors.focusedBorder,
            width: 2,
          ),
        ),
        labelStyle: AppFonts.bodyText2.copyWith(color: AppColors.textHint),
        hintStyle: AppFonts.bodyText2.copyWith(color: AppColors.textHint),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(themeRadius),
          borderSide: const BorderSide(color: AppColors.background),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(themeRadius),
          borderSide: const BorderSide(color: AppColors.error, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(themeRadius),
          borderSide: const BorderSide(color: AppColors.error),
        ),
      ),

      // ElevatedButton theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: AppColors.onPrimary,
          backgroundColor: AppColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(themeRadius),
          ),
        ),
      ),

      // OutlinedButton theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primaryDark,
          side: const BorderSide(color: AppColors.primaryDark),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(themeRadius),
          ),
        ),
      ),

      // TextButton theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(themeRadius),
          ),
        ),
      ),

      // FloatingActionButton theme
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
      ),

      // BottomNavigationBar theme
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.primaryDark,
        selectedItemColor: AppColors.onPrimary,
        unselectedItemColor: AppColors.onPrimary,
        selectedIconTheme: IconThemeData(color: AppColors.onPrimary),
        unselectedIconTheme: IconThemeData(color: AppColors.onPrimary),
        showSelectedLabels: false,
        showUnselectedLabels: false,
      ),

      // TabBar theme
      tabBarTheme: const TabBarThemeData(
        labelColor: AppColors.primaryDarker,
        unselectedLabelColor: AppColors.greySoft,
        labelStyle: AppFonts.headLine,
        unselectedLabelStyle: AppFonts.headLine,
        labelPadding: EdgeInsets.symmetric(horizontal: 16.0),
        indicatorSize: TabBarIndicatorSize.label,
        indicatorColor: AppColors.primaryDarker,
        tabAlignment: TabAlignment.center,
        indicator: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: AppColors.primaryDarker, width: 2.0),
          ),
        ),
      ),
    );
  }
}
