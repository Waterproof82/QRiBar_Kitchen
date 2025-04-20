part of 'listener_bloc.dart';

@freezed
class ListenerEvent with _$ListenerEvent {
  const factory ListenerEvent.startListening() = _StartListening;
  const factory ListenerEvent.pedidosUpdated(List<Pedido> pedidos) = _PedidosUpdated;
  const factory ListenerEvent.pedidoRemoved(List<Pedido> pedido) = _PedidoRemoved;

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

  const factory ListenerEvent.errorOccurred(String message) = _ErrorOccurred;
}
