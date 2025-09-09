part of 'listener_bloc.dart';

@freezed
sealed class ListenerState with _$ListenerState {
  /// Estado inicial del Bloc
  const factory ListenerState.initial() = _Initial;

  /// Estado de carga, cuando se están inicializando listeners
  const factory ListenerState.loading() = _Loading;

  /// Estado de éxito genérico, sin datos asociados
  const factory ListenerState.success() = _Success;

  /// Estado de fallo con un error asociado
  const factory ListenerState.failure({required RepositoryError error}) =
      _Failure;

  /// Estado que contiene los datos principales del sistema
  const factory ListenerState.data({
    @Default([]) List<Product> productos,
    @Default([]) List<Pedido> pedidos,
    @Default([]) List<CategoriaProducto> categorias,
  }) = _DataState;
}
