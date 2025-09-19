part of 'listener_bloc.dart';

@freezed
sealed class ListenerState with _$ListenerState {
  /// Initial state of the Bloc
  const factory ListenerState.initial() = _Initial;

  /// Loading state, when listeners are being initialized
  const factory ListenerState.loading() = _Loading;

  /// Generic success state, without associated data
  const factory ListenerState.success() = _Success;

  /// Error state with an associated RepositoryError
  const factory ListenerState.error({required RepositoryError error}) = _Error;

  /// State containing the main system data
  const factory ListenerState.data({
    @Default([]) List<Product> productos,
    @Default([]) List<Pedido> pedidos,
    @Default([]) List<CategoriaProducto> categorias,
  }) = _DataState;
}
