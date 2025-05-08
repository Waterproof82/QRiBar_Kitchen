import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Extension on [DateTime] to provide various formatting options.
///
/// This extension enhances the [DateTime] class by adding methods to format
/// dates in different ways, including ISO 8601 format, UTC format, local format,
/// custom format, and conversion to epoch and Unix timestamp.
///
/// Example Usage:
/// ```dart
/// DateTime now = DateTime.now();
/// String iso8601 = now.toIso8601; // ISO 8601 format
/// String utcFormat = now.toUtcFormat; // UTC format
/// String localFormat = now.toLocalFormat; // Local format
/// String customFormat = now.toCustomFormat(context, dateFormat: 'dd/MM/yyyy');
/// int epoch = now.toEpoch; // Epoch time
/// int unixTimestamp = now.toUnixTimestamp; // Unix timestamp
/// ```
///
/// See also:
///
///  * [DateTime], the class on which this extension is based.
///  * [DateFormat], from the intl package, used for custom date formatting.
extension DateTimeExtension on DateTime {
  /// Converts the [DateTime] to an ISO 8601 formatted string.
  String get toIso8601 => toIso8601String();

  /// Converts the [DateTime] to a UTC formatted string.
  String get toUtcFormat => toUtc().toString();

  /// Converts the [DateTime] to a string formatted with the local date and time.
  String get toLocalFormat => toLocal().toString();

  /// Converts the [DateTime] to a string formatted with a custom format.
  ///
  /// Parameters:
  /// - [context]: The [BuildContext] used to retrieve the local settings for formatting.
  /// - [dateFormat]: A string representing the pattern for the date format.
  ///   Defaults to 'yyyy-MM-dd HH:mm:ss'.
  ///
  /// Returns a string formatted according to the specified date format and the current locale.
  String toCustomFormat({
    required BuildContext context,
    String dateFormat = 'yyyy-MM-dd HH:mm:ss',
  }) {
    final locale = Localizations.localeOf(context);
    final format = DateFormat(dateFormat, locale.languageCode);
    return format.format(this);
  }

  /// Combines the current date with a specific time string (e.g., 'HH:mm:ss').
  static DateTime combineNowWithTime(String time) {
    final datePart = DateFormat('yyyy-MM-dd').format(DateTime.now()); // Extract today's date
    return DateTime.parse('$datePart $time'); // Combine date and time
  }

  /// Converts the [DateTime] to an epoch time (milliseconds since the Unix epoch).
  int get toEpoch => millisecondsSinceEpoch;

  /// Converts the [DateTime] to a Unix timestamp (seconds since the Unix epoch).
  int get toUnixTimestamp => millisecondsSinceEpoch ~/ 1000;
}
