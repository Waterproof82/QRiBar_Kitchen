import 'package:flutter/material.dart';

/// A final class containing information (icon and color) for a specific snack bar type.

final class _SnackBarInfo {
  final IconData icon;
  final Color color;

  const _SnackBarInfo(this.icon, this.color);
}

/// Defines the types of snack bars used in the application,
/// each with an associated icon and color.

enum SnackBarTypeEnum {
  /// Represents a success message.
  success,

  /// Represents an error message.
  error,

  /// Represents a warning message.
  warning,

  /// Represents an informational message.
  info;

  /// A static map that associates each [SnackBarTypeEnum] with its corresponding [_SnackBarInfo].
  /// This provides a lookup for the icon and color properties.
  static const Map<SnackBarTypeEnum, _SnackBarInfo> _infoMap = {
    SnackBarTypeEnum.success: _SnackBarInfo(
      Icons.check_circle_outline,
      Colors.green,
    ),
    SnackBarTypeEnum.error: _SnackBarInfo(Icons.error_outline, Colors.red),
    SnackBarTypeEnum.warning: _SnackBarInfo(
      Icons.warning_amber_rounded,
      Colors.orange,
    ),
    SnackBarTypeEnum.info: _SnackBarInfo(Icons.info_outline, Colors.blue),
  };

  /// Returns the [IconData] associated with this [SnackBarTypeEnum].
  ///
  /// Uses the [_infoMap] to retrieve the icon.
  IconData get icon => _infoMap[this]!.icon;

  /// Returns the [Color] associated with this [SnackBarTypeEnum].
  ///
  /// Uses the [_infoMap] to retrieve the color.
  Color get color => _infoMap[this]!.color;
}
