import 'package:flutter_test/flutter_test.dart';
import 'package:qribar_cocina/data/models/modifier/modifier.dart';

void main() {
  group('Modifier', () {
    test('constructor por defecto debe asignar valores por defecto', () {
      const modifier = Modifier();
      expect(modifier.name, '');
      expect(modifier.increment, 0.0);
      expect(modifier.mainProduct, '');
    });

    test('fromJson y toJson deben serializar correctamente', () {
      final json = {
        'name': 'Extra queso',
        'increment': 1.5,
        'mainProduct': 'Pizza Margarita',
      };

      final modifier = Modifier.fromJson(json);
      expect(modifier.name, 'Extra queso');
      expect(modifier.increment, 1.5);
      expect(modifier.mainProduct, 'Pizza Margarita');

      final serialized = modifier.toJson();
      expect(serialized, json);
    });

    test('fromMap debe manejar nulls y tipos correctamente', () {
      final map = {
        'name': 'Sin cebolla',
        'increment': 0.0,
        'mainProduct': 'Hamburguesa',
      };

      final modifier = ModifierMapper.fromMap(map);
      expect(modifier.name, 'Sin cebolla');
      expect(modifier.increment, 0.0);
      expect(modifier.mainProduct, 'Hamburguesa');
    });

    test('fromMap con valores faltantes debe usar valores por defecto', () {
      final map = <String, dynamic>{};

      final modifier = ModifierMapper.fromMap(map);
      expect(modifier.name, '');
      expect(modifier.increment, 0.0);
      expect(modifier.mainProduct, '');
    });

    test('fromMap debe convertir num a double en increment', () {
      final map = {
        'name': 'Extra salsa',
        'increment': 2, // tipo int
        'mainProduct': 'Taco',
      };

      final modifier = ModifierMapper.fromMap(map);
      expect(modifier.increment, 2.0); // debe convertir a double
    });
  });
}
