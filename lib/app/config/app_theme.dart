import 'package:flutter/material.dart';

final ThemeData appTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.green,
    brightness: Brightness.light,
  ),
  scaffoldBackgroundColor: Colors.grey[50],
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.green[700],
    foregroundColor: Colors.white,
    elevation: 0,
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 20,
    ),
  ),
  textTheme: TextTheme(
    headlineLarge: TextStyle(
      fontFamily: 'Roboto',
      fontWeight: FontWeight.bold,
      fontSize: 32,
      color: Colors.green[900],
    ),
    bodyMedium: TextStyle(
      fontFamily: 'Roboto',
      fontSize: 16,
      color: Colors.blueGrey[900],
    ),
    labelLarge: TextStyle(
      fontFamily: 'Roboto',
      fontWeight: FontWeight.w500,
      fontSize: 14,
      color: Colors.green[700],
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.green),
    ),
  ),
);
