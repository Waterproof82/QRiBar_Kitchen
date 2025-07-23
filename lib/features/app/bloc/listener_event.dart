part of 'listener_bloc.dart';

@freezed
sealed class ListenerEvent with _$ListenerEvent {
  const factory ListenerEvent.startListening() = _StartListening;

  const factory ListenerEvent.productos(List<Product> productos) = _Productos;

  const factory ListenerEvent.pedidos(List<Pedido> pedidos) = _Pedidos;

  const factory ListenerEvent.categorias(List<CategoriaProducto> categorias) =
      _Categorias;

  const factory ListenerEvent.updateEstadoPedido({
    required String mesa,
    required String idPedido,
    required String nuevoEstado,
  }) = _UpdateEstadoPedido;

  const factory ListenerEvent.updateEnMarchaPedido({
    required String mesa,
    required String idPedido,
    required bool enMarcha,
  }) = _UpdateEnMarchaPedido;

  const factory ListenerEvent.streamError(RepositoryError error) = _StreamError;
}
