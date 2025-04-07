part of 'listener_bloc.dart';

@freezed
class ListenerState with _$ListenerState {
  const factory ListenerState.initial() = _Initial;
  const factory ListenerState.loading() = _Loading;
  const factory ListenerState.success() = _Success;
  const factory ListenerState.pedidosUpdated(List<Pedido> pedidos) = _PedidosUpdated;
  const factory ListenerState.failure(String message) = _Failure;
}
