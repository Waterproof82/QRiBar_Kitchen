import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qribar_cocina/app/enums/snack_bar_enum.dart';

void main() {
  group('SnackBarType', () {
    test('retorna iconos correctos por tipo', () {
      expect(SnackBarType.success.icon, Icons.check_circle_outline);
      expect(SnackBarType.error.icon, Icons.error_outline);
      expect(SnackBarType.warning.icon, Icons.warning_amber_rounded);
      expect(SnackBarType.info.icon, Icons.info_outline);
    });

    test('retorna colores correctos por tipo', () {
      expect(SnackBarType.success.color, Colors.green);
      expect(SnackBarType.error.color, Colors.red);
      expect(SnackBarType.warning.color, Colors.orange);
      expect(SnackBarType.info.color, Colors.blue);
    });
  });
}
