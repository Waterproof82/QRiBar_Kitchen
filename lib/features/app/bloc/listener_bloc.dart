import 'dart:async';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:qribar_cocina/app/types/errors/network_error.dart';
import 'package:qribar_cocina/app/types/repository_error.dart';
import 'package:qribar_cocina/data/models/pedido/pedido.dart';
import 'package:qribar_cocina/data/models/product.dart';
import 'package:qribar_cocina/data/repositories/remote/listener_repository_impl.dart';
import 'package:qribar_cocina/features/login/data/data_sources/remote/auth_remote_data_source_contract.dart';
import 'package:qribar_cocina/shared/utils/auth_service.dart';
import 'package:qribar_cocina/shared/utils/event_stream_manager.dart';

part 'listener_bloc.freezed.dart';
part 'listener_event.dart';
part 'listener_state.dart';

class ListenerBloc extends Bloc<ListenerEvent, ListenerState> {
  final ListenerRepositoryImpl _repository;
  final AuthRemoteDataSourceContract _authRemoteDataSourceContract;
  final AuthService _authService;
  final EventStreamManager _eventStream;

  ListenerBloc({
    required ListenerRepositoryImpl repository,
    required AuthRemoteDataSourceContract authRemoteDataSourceContract,
  }) : _repository = repository,
       _authRemoteDataSourceContract = authRemoteDataSourceContract,
       _authService = AuthService(authRemoteDataSourceContract),
       _eventStream = EventStreamManager(repository),
       super(const ListenerState.initial()) {
    on<_StartListening>(_onStartListening);

    on<_Productos>(_onProductos);
    on<_Pedidos>(_onPedidos);

    on<_UpdateEstadoPedido>(_onUpdateEstadoPedido);
    on<_UpdateEnMarchaPedido>(_onUpdateEnMarchaPedido);

    on<_StreamError>(_onStreamError);
  }

  Future<void> _onStartListening(
    _StartListening event,
    Emitter<ListenerState> emit,
  ) async {
    emit(const ListenerState.loading());

    try {
      final authResult = await _authService.checkAuth();

      await authResult.when(
        failure: (error) {
          emit(ListenerState.failure(error));
          return;
        },
        success: (userName) async {
          final initResult = await _eventStream.initializeListeners(
            onEvent: (event) => add(event),
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

          initResult.when(
            failure: (error) => emit(ListenerState.failure(error)),
            success: (_) => emit(const ListenerState.success()),
          );
        },
      );
    } catch (e, stackTrace) {
      emit(
        ListenerState.failure(
          RepositoryError.fromDataSourceError(NetworkError.fromException(e)),
        ),
      );
      log(
        'ListenerBloc _onStartListening error:',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  void _onProductos(_Productos event, Emitter<ListenerState> emit) {
    emit(
      ListenerState.data(
        productos: List.unmodifiable(event.productos),
        pedidos: state.maybeWhen(
          data: (_, pedidos) => pedidos,
          orElse: () => [],
        ),
      ),
    );
  }

  void _onPedidos(_Pedidos event, Emitter<ListenerState> emit) {
    emit(
      ListenerState.data(
        productos: state.maybeWhen(
          data: (productos, _) => productos,
          orElse: () => [],
        ),
        pedidos: List.unmodifiable(event.pedidos),
      ),
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
    result.whenOrNull(failure: (error) => emit(ListenerState.failure(error)));
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
    result.whenOrNull(failure: (error) => emit(ListenerState.failure(error)));
  }

  void _onStreamError(_StreamError event, Emitter<ListenerState> emit) {
    emit(ListenerState.failure(event.error));
  }

  @override
  Future<void> close() async {
    await _eventStream.dispose();
    await _repository.dispose();
    await _authRemoteDataSourceContract.signOut();
    return super.close();
  }
}
