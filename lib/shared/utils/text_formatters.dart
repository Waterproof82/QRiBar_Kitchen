import 'package:flutter/services.dart';

/// A final class that capitalizes the first letter of a string and
/// converts the rest to lowercase, used as a [TextInputFormatter].
///
/// This formatter ensures that text input adheres to a specific casing style,
/// typically for names or titles.
final class UpperCaseTextFormatter extends TextInputFormatter {
  /// Creates a constant instance of [UpperCaseTextFormatter].
  const UpperCaseTextFormatter();

  @override
  /// Formats the text input value, capitalizing the first letter
  /// and converting the rest to lowercase.
  ///
  /// [oldValue]: The previous [TextEditingValue].
  /// [newValue]: The new [TextEditingValue] proposed by the user.
  /// Returns a new [TextEditingValue] with the formatted text.
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return TextEditingValue(
      text: _capitalize(newValue.text),
      selection: newValue.selection,
    );
  }

  /// Capitalizes the first letter of the input [text] and
  /// converts the rest to lowercase.
  ///
  /// Leading and trailing whitespace is trimmed.
  /// Returns an empty string if the trimmed input is empty.
  String _capitalize(String text) {
    final String trimmed = text.trim();
    if (trimmed.isEmpty) {
      return '';
    }
    // Capitalize the first character and convert the rest to lowercase.
    return trimmed[0].toUpperCase() + trimmed.substring(1).toLowerCase();
  }
}
