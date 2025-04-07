part of 'listener_bloc.dart';

@freezed
class ListenerEvent with _$ListenerEvent {
  const factory ListenerEvent.startListening() = _StartListening;
  // const factory ListenerEvent.dataUpdated(List<Product> products) = _DataUpdated;
  const factory ListenerEvent.pedidosUpdated(List<Pedido> pedidos) = _PedidosUpdatedEvent;
  const factory ListenerEvent.errorOccurred(String message) = _ErrorOccurred;
}
