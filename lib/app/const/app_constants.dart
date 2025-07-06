import 'package:flutter/material.dart';

/// A final class containing application-wide constants.
final class AppConstants {
  /// Prevents the class from being instantiated.
  /// All members are static and accessed directly via the class name.
  const AppConstants._();

  /// Regular expression pattern for email validation.
  static const String emailPattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

  /// A list of predefined time ranges with associated text and colors.
  /// Each map contains:
  /// - 'texto': A string describing the time range (e.g., '0-10 min').
  /// - 'color': A [Color] associated with that time range.
  static const List<Map<String, dynamic>> tiempos = [
    {
      'texto': '0-10 min',
      'color': Color.fromARGB(0, 255, 255, 255),
    }, // Consider using a fully opaque color if it's meant to be visible
    {'texto': '10-20 min', 'color': Color.fromARGB(255, 255, 193, 7)},
    {'texto': '20-30 min', 'color': Color.fromRGBO(242, 132, 64, 1)},
    {'texto': '+ 30 min', 'color': Color.fromARGB(255, 255, 0, 0)},
  ];
}
