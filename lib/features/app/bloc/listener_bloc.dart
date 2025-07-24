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
import 'package:qribar_cocina/features/login/data/data_sources/remote/auth_remote_data_source_contract.dart';
import 'package:qribar_cocina/shared/utils/auth_service.dart';
import 'package:qribar_cocina/shared/utils/event_stream_manager.dart';
import 'package:qribar_cocina/shared/utils/product_utils.dart';

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
  /// The repository for managing real-time data listeners.
  final ListenerRepository _repository;

  /// The contract for authentication-related remote data source operations.
  final AuthRemoteDataSourceContract _authRemoteDataSourceContract;

  /// Service for handling authentication logic.
  final AuthService _authService;

  /// Manager for handling event streams from the repository.
  final EventStreamManager _eventStream;

  /// Creates an instance of [ListenerBloc].
  ///
  /// Requires a [ListenerRepository] (contract) and an [AuthRemoteDataSourceContract]
  /// to manage data listening and authentication.
  ListenerBloc({
    required ListenerRepository repository,
    required AuthRemoteDataSourceContract authRemoteDataSourceContract,
  }) : _repository = repository,
       _authRemoteDataSourceContract = authRemoteDataSourceContract,
       _authService = AuthService(authRemoteDataSourceContract),
       _eventStream = EventStreamManager(repository),
       super(const ListenerState.initial()) {
    // Event handlers
    on<_StartListening>(_onStartListening);
    on<_Productos>(_onProductos);
    on<_Pedidos>(_onPedidos);
    on<_Categorias>(_onCategorias);
    on<_UpdateEstadoPedido>(_onUpdateEstadoPedido);
    on<_UpdateEnMarchaPedido>(_onUpdateEnMarchaPedido);
    on<_StreamError>(_onStreamError);
  }

  /// Handles the [_StartListening] event.
  ///
  /// Initiates the authentication check and then initializes all real-time listeners
  /// via the repository. Emits [ListenerState.loading], [ListenerState.success],
  /// or [ListenerState.failure] based on the outcome.
  Future<void> _onStartListening(
    _StartListening event,
    Emitter<ListenerState> emit,
  ) async {
    emit(const ListenerState.loading());

    try {
      final authResult = await _authService.checkAuth();

      await authResult.when(
        failure: (error) {
          log(
            '❌ [ListenerBloc] Fallo de autenticación al iniciar listeners: $error',
          );
          emit(ListenerState.failure(error));
        },
        success: (userName) async {
          log(
            '✅ [ListenerBloc] Autenticación exitosa para $userName. Inicializando listeners...',
          );
          final initResult = await _eventStream.initializeListeners(
            onEvent: (event) => add(event), // Dispatch events back to the BLoC
            onError: (error, stackTrace) {
              add(
                ListenerEvent.streamError(
                  RepositoryError.fromDataSourceError(
                    NetworkError.fromException(error),
                  ),
                ),
              );
              log(
                '❌ [ListenerBloc] Error en el stream de listeners: $error',
                stackTrace: stackTrace,
              );
            },
          );

          initResult.when(
            failure: (error) {
              log('❌ [ListenerBloc] Fallo al inicializar listeners: $error');
              emit(ListenerState.failure(error));
            },
            success: (_) {
              log(
                '✅ [ListenerBloc] Listeners inicializados y en funcionamiento.',
              );
              emit(const ListenerState.success());
            },
          );
        },
      );
    } catch (e, stackTrace) {
      final repoError = RepositoryError.fromDataSourceError(
        NetworkError.fromException(e),
      );
      emit(ListenerState.failure(repoError));
      log(
        '❌ [ListenerBloc] Error inesperado en _onStartListening:',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Handles the [_Productos] event.
  ///
  /// Updates the product list in the current state, preserving other data.
  void _onProductos(_Productos event, Emitter<ListenerState> emit) {
    state.maybeMap(
      data: (dataState) {
        // If the current state is already 'data', update it using copyWith.
        // This preserves 'pedidos' and 'categorias' from the existing state.
        emit(dataState.copyWith(productos: List.unmodifiable(event.productos)));
      },
      orElse: () {
        // If the current state is not 'data' (e.g., initial, loading, failure),
        // transition to a 'data' state. Initialize other lists as empty.
        emit(
          ListenerState.data(
            productos: List.unmodifiable(event.productos),
            pedidos: [],
            categorias: [],
          ),
        );
      },
    );
    log(
      '🔄 [ListenerBloc] Productos actualizados. Total: ${event.productos.length}',
    );
  }

  /// Handles the [_Pedidos] event.
  ///
  /// Updates the order list in the current state, applying necessary
  /// transformations (like assigning shipping info).
  void _onPedidos(_Pedidos event, Emitter<ListenerState> emit) {
    state.maybeMap(
      data: (dataState) {
        final nuevosPedidos = asignarEnviosPorPedidos(
          pedidos: event.pedidos,
          productos: dataState.productos,
          categorias: dataState.categorias,
        );

        emit(dataState.copyWith(pedidos: nuevosPedidos));
        log(
          '🔄 [ListenerBloc] Pedidos actualizados. Total: ${nuevosPedidos.length}',
        );
      },
      orElse: () {
        log(
          '⚠️ [ListenerBloc] _onPedidos recibido en estado no Data. Ignorando.',
        );
      },
    );
  }

  /// Handles the [_Categorias] event.
  ///
  /// Updates the category list in the current state and re-processes orders
  /// to reflect potential changes in shipping information based on categories.
  void _onCategorias(_Categorias event, Emitter<ListenerState> emit) {
    state.maybeMap(
      data: (dataState) {
        final nuevosPedidos = asignarEnviosPorPedidos(
          pedidos: dataState.pedidos,
          productos: dataState.productos,
          categorias: event.categorias,
        );

        emit(
          dataState.copyWith(
            pedidos: nuevosPedidos,
            categorias: event.categorias,
          ),
        );
        log(
          '🔄 [ListenerBloc] Categorías actualizadas. Total: ${event.categorias.length}',
        );
      },
      orElse: () {
        log(
          '⚠️ [ListenerBloc] _onCategorias recibido en estado no Data. Ignorando.',
        );
      },
    );
  }

  /// Handles the [_UpdateEstadoPedido] event.
  ///
  /// Delegates the order status update to the repository.
  /// Emits [ListenerState.failure] if the update fails.
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
      failure: (error) {
        log('❌ [ListenerBloc] Fallo al actualizar estado de pedido: $error');
        emit(ListenerState.failure(error));
      },
    );
  }

  /// Handles the [_UpdateEnMarchaPedido] event.
  ///
  /// Delegates the 'in progress' status update to the repository.
  /// Emits [ListenerState.failure] if the update fails.
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
      failure: (error) {
        log(
          '❌ [ListenerBloc] Fallo al actualizar estado "en marcha" de pedido: $error',
        );
        emit(ListenerState.failure(error));
      },
    );
  }

  /// Handles the [_StreamError] event.
  ///
  /// Emits a [ListenerState.failure] with the provided error.
  void _onStreamError(_StreamError event, Emitter<ListenerState> emit) {
    log('❌ [ListenerBloc] Error de stream capturado: ${event.error}');
    emit(ListenerState.failure(event.error));
  }

  @override
  /// Disposes all resources when the BLoC is closed.
  ///
  /// This includes disposing the event stream manager, the repository,
  /// and signing out from authentication.
  Future<void> close() async {
    log('🧹 [ListenerBloc] Cerrando BLoC...');
    await _eventStream.dispose();
    await _repository.dispose();
    await _authRemoteDataSourceContract.signOut();
    log('✅ [ListenerBloc] BLoC cerrado y recursos liberados.');
    return super.close();
  }
}
