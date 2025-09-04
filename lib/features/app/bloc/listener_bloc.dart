import 'dart:async';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:qribar_cocina/app/types/errors/network_error.dart';
import 'package:qribar_cocina/app/types/repository_error.dart';
import 'package:qribar_cocina/app/types/result.dart';
import 'package:qribar_cocina/data/models/categoria_producto.dart';
import 'package:qribar_cocina/data/models/pedido/pedido.dart';
import 'package:qribar_cocina/data/models/product.dart';
import 'package:qribar_cocina/data/repositories/remote/listener_repository.dart';
import 'package:qribar_cocina/shared/utils/event_stream_manager.dart';

part 'listener_bloc.freezed.dart';
part 'listener_event.dart';
part 'listener_state.dart';

/// An [abstract class] that serves as the contract for a Bloc responsible
/// for managing real-time data listeners and handling application-wide
/// events related to products, categories, and orders.
///
/// This class orchestrates interactions with the [ListenerRepository] and
/// handles authentication status. Concrete implementations will extend this.

abstract class ListenerBloc extends Bloc<ListenerEvent, ListenerState> {
  final ListenerRepository _repository;
  final EventStreamManager _eventStream;

  ListenerBloc({required ListenerRepository repository})
    : _repository = repository,
      _eventStream = EventStreamManager(repository),
      super(const ListenerState.initial()) {
    on<_StartListening>(_onStartListening);
    on<_Productos>(_onProductos);
    on<_Pedidos>(_onPedidos);
    on<_Categorias>(_onCategorias);
    on<_UpdateEstadoPedido>(_onUpdateEstadoPedido);
    on<_UpdateEnMarchaPedido>(_onUpdateEnMarchaPedido);
    on<_StreamError>(_onStreamError);
  }

  Future<void> _onStartListening(
    _StartListening event,
    Emitter<ListenerState> emit,
  ) async {
    emit(const ListenerState.loading());

    final result = await _eventStream.initializeListeners(
      onEvent: (e) => add(e),
      onError: (error, stackTrace) {
        add(
          ListenerEvent.streamError(
            RepositoryError.fromDataSourceError(
              NetworkError.fromException(error),
            ),
          ),
        );
        log('Stream error: $error', stackTrace: stackTrace);
      },
    );

    result.when(
      success: (_) => emit(const ListenerState.success()),
      failure: (error) => emit(ListenerState.failure(error: error)),
    );
  }

  void _onProductos(_Productos event, Emitter<ListenerState> emit) {
    state.maybeMap(
      data: (dataState) => emit(
        dataState.copyWith(productos: List.unmodifiable(event.productos)),
      ),
      orElse: () => emit(
        ListenerState.data(
          productos: List.unmodifiable(event.productos),
          pedidos: [],
          categorias: [],
        ),
      ),
    );
  }

  void _onPedidos(_Pedidos event, Emitter<ListenerState> emit) {
    state.maybeMap(
      data: (dataState) => emit(dataState.copyWith(pedidos: event.pedidos)),
      orElse: () => log('Pedidos recibido en estado no Data, ignorando.'),
    );
  }

  void _onCategorias(_Categorias event, Emitter<ListenerState> emit) {
    state.maybeMap(
      data: (dataState) =>
          emit(dataState.copyWith(categorias: event.categorias)),
      orElse: () => log('Categorias recibido en estado no Data, ignorando.'),
    );
  }

  Future<void> _onUpdateEstadoPedido(
    _UpdateEstadoPedido event,
    Emitter<ListenerState> emit,
  ) async {
    final result = await _repository.updateEstadoPedido(
      mesa: event.mesa,
      idPedido: event.idPedido,
      nuevoEstado: event.nuevoEstado,
    );
    result.whenOrNull(
      failure: (error) => emit(ListenerState.failure(error: error)),
    );
  }

  Future<void> _onUpdateEnMarchaPedido(
    _UpdateEnMarchaPedido event,
    Emitter<ListenerState> emit,
  ) async {
    final result = await _repository.updateEnMarchaPedido(
      mesa: event.mesa,
      idPedido: event.idPedido,
      enMarcha: event.enMarcha,
    );
    result.whenOrNull(
      failure: (error) => emit(ListenerState.failure(error: error)),
    );
  }

  void _onStreamError(_StreamError event, Emitter<ListenerState> emit) {
    emit(ListenerState.failure(error: event.error));
  }

  @override
  Future<void> close() async {
    await _eventStream.dispose();
    await _repository.dispose();
    return super.close();
  }
}
