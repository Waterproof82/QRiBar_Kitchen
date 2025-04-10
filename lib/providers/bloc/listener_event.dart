part of 'listener_bloc.dart';

@freezed
class ListenerEvent with _$ListenerEvent {
  const factory ListenerEvent.startListening() = _StartListening;
  //const factory ListenerEvent.productosUpdated(List<Product> productos) = _ProductosUpdated;
  // const factory ListenerEvent.categoriaAdded(List<CategoriaProducto> categoria) = _CategoriaAdded;
  // const factory ListenerEvent.categoriaChanged(List<CategoriaProducto> categoria) = _CategoriaChanged;
  const factory ListenerEvent.pedidosUpdated(List<Pedido> pedidos) = _PedidosUpdated;
  const factory ListenerEvent.pedidoRemoved(List<Pedido> pedido) = _PedidoRemoved;
  const factory ListenerEvent.updateEstadoPedido({
    required String idBar,
    required String mesa,
    required String idPedido,
    required String nuevoEstado,
  }) = _UpdateEstadoPedido;
  const factory ListenerEvent.updateEnMarchaPedido({
    required String idBar,
    required String mesa,
    required String idPedido,
    required bool enMarcha,
  }) = _UpdateEnMarchaPedido;
  const factory ListenerEvent.errorOccurred(String message) = _ErrorOccurred;
}
