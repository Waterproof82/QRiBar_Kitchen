import 'package:flutter/services.dart';

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return TextEditingValue(
      text: capitalize(newValue.text),
      selection: newValue.selection,
    );
  }
}

String capitalize(String text) {
  final trimmed = text.trim();
  if (trimmed.isEmpty) return '';
  return trimmed[0].toUpperCase() + trimmed.substring(1).toLowerCase();
}
