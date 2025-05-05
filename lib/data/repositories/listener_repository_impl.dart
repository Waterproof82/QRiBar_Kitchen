import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:qribar_cocina/data/data_sources/local/id_bar_data_source.dart';
import 'package:qribar_cocina/data/data_sources/remote/listeners_data_source_contract.dart';
import 'package:qribar_cocina/data/repositories/listener_repository.dart';
import 'package:qribar_cocina/data/types/errors/network_error.dart';
import 'package:qribar_cocina/data/types/repository_error.dart';
import 'package:qribar_cocina/data/types/result.dart';

class ListenerRepositoryImpl implements ListenerRepository {
  final FirebaseDatabase database;
  final ListenersDataSourceContract dataSource;

  ListenerRepositoryImpl({
    required this.database,
    required this.dataSource,
  });

  String get idBar => IdBarDataSource.instance.getIdBar();

  Future<Result<void>> initializeListeners() async {
    try {
      await dataSource.addProduct();
      await dataSource.addCategoriaMenu();
      await dataSource.changeCategoriaMenu();
      await dataSource.addSalaMesas();
      await dataSource.addAndChangedPedidos();
      await dataSource.removePedidos();
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
      final ref = database.ref('gestion_pedidos/$idBar/$mesa/$idPedido');
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
      final ref = database.ref('gestion_pedidos/$idBar/$mesa/$idPedido');
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
  void dispose() {
    dataSource.dispose();
  }
}
