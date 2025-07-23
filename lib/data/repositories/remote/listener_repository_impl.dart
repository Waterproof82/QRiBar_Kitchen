import 'dart:async';
import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:qribar_cocina/app/types/errors/network_error.dart';
import 'package:qribar_cocina/app/types/repository_error.dart';
import 'package:qribar_cocina/app/types/result.dart';
import 'package:qribar_cocina/data/data_sources/local/id_bar_data_source.dart';
import 'package:qribar_cocina/data/data_sources/remote/listeners_remote_data_source_contract.dart';
import 'package:qribar_cocina/data/repositories/remote/listener_repository.dart';
import 'package:qribar_cocina/features/app/bloc/listener_bloc.dart';

/// This repository acts as an intermediary between the application's business logic
/// and the remote data source for real-time listeners. It handles the initialization
/// and management of various Firebase listeners and provides methods to update
/// order states.
///
final class ListenerRepositoryImpl implements ListenerRepository {
  final FirebaseDatabase _database;

  /// The contract for the remote data source that manages real-time listeners.
  final ListenersRemoteDataSourceContract _dataSource;

  /// Creates an instance of [ListenerRepositoryImpl].
  ///
  /// Requires a [FirebaseDatabase] instance for direct database interactions
  /// and a [ListenersRemoteDataSourceContract] for managing real-time data streams.
  ListenerRepositoryImpl({
    required FirebaseDatabase database,
    required ListenersRemoteDataSourceContract dataSource,
  }) : _database = database,
       _dataSource = dataSource;

  /// Retrieves the current `idBar` from [IdBarDataSource].
  ///
  /// This ID is crucial for constructing Firebase Realtime Database paths.
  String get _idBar {
    if (!IdBarDataSource.instance.hasIdBar) {
      throw StateError(
        'idBar no inicializado en ListenerRepositoryImpl',
      ); // Lanzar error si no está listo
    }
    return IdBarDataSource.instance.idBar;
  }

  @override
  Stream<ListenerEvent> get eventsStream => _dataSource.eventsStream;

  /// Initializes all necessary real-time listeners for the application.
  ///
  /// This includes listeners for tables/rooms, products, categories, and orders.
  /// It first checks if `idBar` is initialized.
  /// Returns a [Result<void>] indicating the success or failure of the initialization.
  @override
  Future<Result<void>> initializeListeners() async {
    if (!IdBarDataSource.instance.hasIdBar) {
      log(
        '❌ [ListenerRepositoryImpl] idBar no inicializado. Fallo en la inicialización de listeners.',
      );
      return const Result.failure(error: RepositoryError.authExpired());
    }

    try {
      log('🔄 [ListenerRepositoryImpl] Inicializando listeners...');

      final results = await Future.wait([
        _dataSource.addSalaMesas(),
        _dataSource.addProduct(),
        _dataSource.addCategoriaMenu(),
      ]);

      // Check if any of the initial operations failed
      for (final initialResult in results) {
        if (initialResult case Failure<void>(error: final err)) {
          log(
            '❌ [ListenerRepositoryImpl] Fallo una de las cargas iniciales de datos: $err',
            error: err,
          );
          return Result.failure(error: err);
        }
      }

      log(
        '✅ [ListenerRepositoryImpl] Datos iniciales (salas, productos, categorías) cargados.',
      );

      await _dataSource.addAndChangedPedidos();
      await _dataSource.removePedidos();

      log('✅ [ListenerRepositoryImpl] Listeners de pedidos configurados.');
      log(
        '✅ [ListenerRepositoryImpl] Todos los listeners inicializados correctamente.',
      );
      return const Result.success(null);
    } catch (e, stackTrace) {
      log(
        '❌ [ListenerRepositoryImpl] Error al inicializar listeners: $e',
        error: e,
        stackTrace: stackTrace,
      );
      return Result.failure(
        error: RepositoryError.fromDataSourceError(
          NetworkError.fromException(e),
        ),
      );
    }
  }

  @override
  /// Updates the `estado_linea` (order status) for a specific order in Firebase.
  ///
  /// [mesa]: The ID of the table/room.
  /// [idPedido]: The ID of the order to update.
  /// [nuevoEstado]: The new status to set for the order.
  /// Returns a [Result<void>] indicating the success or failure of the update operation.
  Future<Result<void>> updateEstadoPedido({
    required String mesa,
    required String idPedido,
    required String nuevoEstado,
  }) async {
    try {
      final ref = _database.ref('gestion_pedidos/$_idBar/$mesa/$idPedido');
      await ref.update({'estado_linea': nuevoEstado});
      log(
        '✅ [ListenerRepositoryImpl] Estado de pedido actualizado: Mesa $mesa, Pedido $idPedido a $nuevoEstado',
      );
      return const Result.success(null);
    } catch (e, stackTrace) {
      log(
        '❌ [ListenerRepositoryImpl] Error al actualizar estado de pedido: Mesa $mesa, Pedido $idPedido, Estado $nuevoEstado. Error: $e',
        error: e,
        stackTrace: stackTrace,
      );
      return Result.failure(
        error: RepositoryError.fromDataSourceError(
          NetworkError.fromException(e),
        ),
      );
    }
  }

  @override
  /// Updates the `en_marcha` (in progress) status for a specific order in Firebase.
  ///
  /// [mesa]: The ID of the table/room.
  /// [idPedido]: The ID of the order to update.
  /// [enMarcha]: The new 'in progress' status (true/false).
  /// Returns a [Result<void>] indicating the success or failure of the update operation.
  Future<Result<void>> updateEnMarchaPedido({
    required String mesa,
    required String idPedido,
    required bool enMarcha,
  }) async {
    try {
      final ref = _database.ref('gestion_pedidos/$_idBar/$mesa/$idPedido');
      await ref.update({'en_marcha': enMarcha});
      log(
        '✅ [ListenerRepositoryImpl] Estado "en marcha" actualizado: Mesa $mesa, Pedido $idPedido a $enMarcha',
      );
      return const Result.success(null);
    } catch (e, stackTrace) {
      log(
        '❌ [ListenerRepositoryImpl] Error al actualizar estado "en marcha" de pedido: Mesa $mesa, Pedido $idPedido, EnMarcha $enMarcha. Error: $e',
        error: e,
        stackTrace: stackTrace,
      );
      return Result.failure(
        error: RepositoryError.fromDataSourceError(
          NetworkError.fromException(e),
        ),
      );
    }
  }

  @override
  /// Disposes all active listeners and resources managed by the data source.
  ///
  /// This method delegates the disposal to the underlying [ListenersRemoteDataSourceContract].
  Future<void> dispose() async {
    log('🧹 [ListenerRepositoryImpl] Disposing repository...');
    await _dataSource.dispose();
    log('✅ [ListenerRepositoryImpl] Repository disposed.');
  }
}
