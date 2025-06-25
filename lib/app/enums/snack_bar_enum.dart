import 'package:flutter/material.dart';

class _SnackBarInfo {
  final IconData icon;
  final Color color;

  const _SnackBarInfo(this.icon, this.color);
}

enum SnackBarType {
  success,
  error,
  warning,
  info;

  static const Map<SnackBarType, _SnackBarInfo> _infoMap = {
    SnackBarType.success: _SnackBarInfo(Icons.check_circle_outline, Colors.green),
    SnackBarType.error: _SnackBarInfo(Icons.error_outline, Colors.red),
    SnackBarType.warning: _SnackBarInfo(Icons.warning_amber_rounded, Colors.orange),
    SnackBarType.info: _SnackBarInfo(Icons.info_outline, Colors.blue),
  };

  IconData get icon => _infoMap[this]!.icon;
  Color get color => _infoMap[this]!.color;
}
