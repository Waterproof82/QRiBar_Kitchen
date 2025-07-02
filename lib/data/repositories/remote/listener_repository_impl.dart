import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:qribar_cocina/app/types/errors/network_error.dart';
import 'package:qribar_cocina/app/types/repository_error.dart';
import 'package:qribar_cocina/app/types/result.dart';
import 'package:qribar_cocina/data/data_sources/local/id_bar_data_source.dart';
import 'package:qribar_cocina/data/data_sources/remote/listeners_remote_data_source_contract.dart';
import 'package:qribar_cocina/data/repositories/remote/listener_repository.dart';

class ListenerRepositoryImpl implements ListenerRepository {
  final FirebaseDatabase _database;
  final ListenersRemoteDataSourceContract _dataSource;

  ListenerRepositoryImpl({
    required FirebaseDatabase database,
    required ListenersRemoteDataSourceContract dataSource,
  }) : _database = database,
       _dataSource = dataSource;

  String get _idBar {
    if (!IdBarDataSource.instance.hasIdBar) {
      throw StateError('idBar no inicializado en ListenersRemoteDataSource');
    }
    return IdBarDataSource.instance.idBar;
  }

  @override
  Future<Result<void>> initializeListeners() async {
    try {
      await _dataSource.addSalaMesas();
      await _dataSource.addProduct();
      await _dataSource.addCategoriaMenu();
      await _dataSource.changeCategoriaMenu();
      await _dataSource.addAndChangedPedidos();
      await _dataSource.removePedidos();
      return const Result.success(null);
    } catch (e) {
      return Result.failure(
        error: RepositoryError.fromDataSourceError(
          NetworkError.fromException(e),
        ),
      );
    }
  }

  @override
  Future<Result<void>> updateEstadoPedido({
    required String mesa,
    required String idPedido,
    required String nuevoEstado,
  }) async {
    try {
      final ref = _database.ref('gestion_pedidos/$_idBar/$mesa/$idPedido');
      await ref.update({'estado_linea': nuevoEstado});
      return const Result.success(null);
    } catch (e) {
      return Result.failure(
        error: RepositoryError.fromDataSourceError(
          NetworkError.fromException(e),
        ),
      );
    }
  }

  @override
  Future<Result<void>> updateEnMarchaPedido({
    required String mesa,
    required String idPedido,
    required bool enMarcha,
  }) async {
    try {
      final ref = _database.ref('gestion_pedidos/$_idBar/$mesa/$idPedido');
      await ref.update({'en_marcha': enMarcha});
      return const Result.success(null);
    } catch (e) {
      return Result.failure(
        error: RepositoryError.fromDataSourceError(
          NetworkError.fromException(e),
        ),
      );
    }
  }

  @override
  Future<void> dispose() async {
    await _dataSource.dispose();
  }

  // Expones el dataSource solo si es necesario para el Bloc
  ListenersRemoteDataSourceContract get dataSource => _dataSource;
}
