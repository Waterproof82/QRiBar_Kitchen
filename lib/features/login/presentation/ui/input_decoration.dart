import 'package:flutter/material.dart';
import 'package:qribar_cocina/app/const/app_colors.dart';

/// A final class providing static utility methods for [InputDecoration].
final class InputDecorations {
  const InputDecorations._();

  /// Provides a standard [InputDecoration] for authentication forms.
  ///
  /// [hintText]: The text to display when the input is empty.
  /// [labelText]: The label text for the input field.
  /// [prefixIcon]: An optional icon to display before the input area.
  static InputDecoration authInputDecoration({
    required String hintText,
    required String labelText,
    IconData? prefixIcon,
  }) {
    return InputDecoration(
      enabledBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: AppColors.primaryDark),
      ),
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: AppColors.primaryDark, width: 2),
      ),
      hintText: hintText,
      labelText: labelText,
      labelStyle: const TextStyle(color: AppColors.textHint),
      prefixIcon: prefixIcon != null
          ? Icon(prefixIcon, color: AppColors.primaryDark)
          : null,
    );
  }
}
