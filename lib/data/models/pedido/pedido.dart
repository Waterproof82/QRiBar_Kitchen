import 'package:freezed_annotation/freezed_annotation.dart';

import '../modifier/modifier.dart';

part 'pedido.freezed.dart';
part 'pedido.g.dart';

@freezed
class Pedido with _$Pedido {
  const factory Pedido({
    required int cantidad,
    String? categoriaProducto,
    required String fecha,
    required String hora,
    String? titulo,
    double? precioProducto,
    required String mesa,
    required int numPedido,
    required String idProducto,
    required String estadoLinea,
    String? nota,
    @Default(1) num orden,
    @Default('barra') String envio,
    DateTime? fechaHora,
    required String id,
    @Default(false) bool enMarcha,
    List<Modifier>? modifiers,
    bool? racion,
  }) = _Pedido;

  factory Pedido.fromJson(Map<String, dynamic> json) => _$PedidoFromJson(json);
}
