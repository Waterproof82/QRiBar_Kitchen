import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qribar_cocina/app/enums/snack_bar_enum.dart';

void main() {
  group('SnackBarType', () {
    test('retorna iconos correctos por tipo', () {
      expect(SnackBarTypeEnum.success.icon, Icons.check_circle_outline);
      expect(SnackBarTypeEnum.error.icon, Icons.error_outline);
      expect(SnackBarTypeEnum.warning.icon, Icons.warning_amber_rounded);
      expect(SnackBarTypeEnum.info.icon, Icons.info_outline);
    });

    test('retorna colores correctos por tipo', () {
      expect(SnackBarTypeEnum.success.color, Colors.green);
      expect(SnackBarTypeEnum.error.color, Colors.red);
      expect(SnackBarTypeEnum.warning.color, Colors.orange);
      expect(SnackBarTypeEnum.info.color, Colors.blue);
    });
  });
}
