part of 'listener_bloc.dart';

@freezed
class ListenerState with _$ListenerState {
  const factory ListenerState.initial() = _Initial;
  const factory ListenerState.loading() = _Loading;
  const factory ListenerState.success() = _Success;
  const factory ListenerState.failure(String message) = _Failure;
  // const factory ListenerState.productosUpdated(List<Product> productos) = _ProductosUpdatedState;
  // const factory ListenerState.categoriaAdded(List<CategoriaProducto> categoria) = _CategoriaAddedState;
  // const factory ListenerState.categoriaChanged(List<CategoriaProducto> categoria) = _CategoriaChangedState;
  const factory ListenerState.pedidosUpdated(List<Pedido> pedidos) = _PedidosUpdatedState;
  const factory ListenerState.pedidoRemoved(List<Pedido> pedido) = _PedidoRemovedState;
}
