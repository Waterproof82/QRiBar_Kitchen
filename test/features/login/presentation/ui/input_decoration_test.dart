import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qribar_cocina/features/login/presentation/ui/input_decoration.dart';

void main() {
  group('InputDecorations.authInputDecoration', () {
    test('returns InputDecoration with correct properties and prefixIcon', () {
      const hint = 'Hint';
      const label = 'Label';
      const icon = Icons.email;

      final decoration = InputDecorations.authInputDecoration(
        hintText: hint,
        labelText: label,
        prefixIcon: icon,
      );

      expect(decoration.hintText, hint);
      expect(decoration.labelText, label);

      // Verifica que el labelStyle tiene color gris (Colors.grey)
      expect(decoration.labelStyle?.color, Colors.grey);

      // Verifica que el prefixIcon es un Icon con el icono esperado y color deepPurple
      expect(decoration.prefixIcon, isA<Icon>());
      final iconWidget = decoration.prefixIcon as Icon;
      expect(iconWidget.icon, icon);
      expect(iconWidget.color, Colors.deepPurple);

      // Verifica que enabledBorder y focusedBorder tienen el color esperado
      final enabledBorder = decoration.enabledBorder as UnderlineInputBorder;
      expect(enabledBorder.borderSide.color, Colors.deepPurple);

      final focusedBorder = decoration.focusedBorder as UnderlineInputBorder;
      expect(focusedBorder.borderSide.color, Colors.deepPurple);
      expect(focusedBorder.borderSide.width, 2);
    });

    test('returns InputDecoration without prefixIcon if null', () {
      const hint = 'Hint';
      const label = 'Label';

      final decoration = InputDecorations.authInputDecoration(
        hintText: hint,
        labelText: label,
      );

      expect(decoration.hintText, hint);
      expect(decoration.labelText, label);
      expect(decoration.prefixIcon, isNull);
    });
  });
}
