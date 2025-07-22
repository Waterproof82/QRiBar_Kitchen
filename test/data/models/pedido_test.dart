import 'package:flutter_test/flutter_test.dart';
import 'package:qribar_cocina/data/models/pedido/pedido.dart';

void main() {
  group('Pedido', () {
    test('constructor debe crear correctamente un Pedido con datos requeridos', () {
      const pedido = Pedido(
        cantidad: 2,
        fecha: '2025-06-25',
        hora: '12:30',
        mesa: '5A',
        numPedido: 101,
        idProducto: 'prod_001',
        estadoLinea: 'pendiente',
        id: 'ped_001',
      );

      expect(pedido.cantidad, 2);
      expect(pedido.fecha, '2025-06-25');
      expect(pedido.hora, '12:30');
      expect(pedido.mesa, '5A');
      expect(pedido.numPedido, 101);
      expect(pedido.idProducto, 'prod_001');
      expect(pedido.estadoLinea, 'pendiente');
      expect(pedido.id, 'ped_001');
      expect(pedido.orden, 1);
      expect(pedido.envio, 'barra');
      expect(pedido.enMarcha, false);
      expect(pedido.modifiers, isNull);
    });

    test('fromJson y toJson deben funcionar correctamente', () {
      final json = {
        'cantidad': 1,
        'categoriaProducto': 'Bebidas',
        'fecha': '2025-06-25',
        'hora': '13:00',
        'titulo': 'Agua Mineral',
        'precioProducto': 1.5,
        'mesa': '3B',
        'numPedido': 202,
        'idProducto': 'prod_002',
        'estadoLinea': 'servido',
        'nota': 'sin hielo',
        'orden': 2,
        'envio': 'cocina',
        'fechaHora': '2025-06-25T13:00:00.000',
        'id': 'ped_002',
        'enMarcha': true,
        'modifiers': [
          {
            'name': 'Limón',
            'increment': 0.5,
            'mainProduct': 'Agua Mineral',
          }
        ],
        'racion': true,
      };

      final pedido = Pedido.fromJson(json);

      expect(pedido.categoriaProducto, 'Bebidas');
      expect(pedido.precioProducto, 1.5);
      expect(pedido.estadoLinea, 'servido');
      expect(pedido.orden, 2);
      expect(pedido.envio, 'cocina');
      expect(pedido.enMarcha, true);
      expect(pedido.fechaHora, DateTime.parse('2025-06-25T13:00:00.000'));
      expect(pedido.modifiers?.first.name, 'Limón');
      expect(pedido.racion, true);

      final serialized = pedido.toJson();
      expect(serialized['titulo'], 'Agua Mineral');
      expect(serialized['modifiers'], isA<List>());
    });

    test('modifiers debe permitir null o lista vacía', () {
      const pedido1 = Pedido(
        cantidad: 1,
        fecha: '2025-06-25',
        hora: '14:00',
        mesa: '2C',
        numPedido: 303,
        idProducto: 'prod_003',
        estadoLinea: 'en espera',
        id: 'ped_003',
      );

      final pedido2 = pedido1.copyWith(modifiers: []);

      expect(pedido1.modifiers, isNull);
      expect(pedido2.modifiers, isEmpty);
    });
  });
}
