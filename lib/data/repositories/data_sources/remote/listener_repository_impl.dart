import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:qribar_cocina/data/datasources/local_data_source/id_bar_data_source.dart';
import 'package:qribar_cocina/data/repositories/data_sources/remote/listener_data_source_impl.dart';
import 'package:qribar_cocina/data/repositories/data_sources/remote/listener_repository.dart';
import 'package:qribar_cocina/data/models/modifier/listeners_data_source_contract.dart';

class ListenerRepositoryImpl implements ListenerRepository {
  final FirebaseDatabase database;
  final ListenersDataSourceContract dataSource;
  late final String idBar;

  ListenerRepositoryImpl({required this.database, required this.dataSource});

  @override
  Future<void> initializeListeners() async {
    idBar = IdBarDataSource.instance.getIdBar();

    if (dataSource is ListenersDataSourceImpl) {
      (dataSource as ListenersDataSourceImpl).setIdBar(idBar);
    }

    await dataSource.addProduct();
    await dataSource.addCategoriaMenu();
    await dataSource.changeCategoriaMenu();
    await dataSource.addAndChangedPedidos();
    await dataSource.removePedidos();
  }

  @override
  Future<void> updateEstadoPedido({
    required String idBar,
    required String mesa,
    required String idPedido,
    required String nuevoEstado,
  }) async {
    final ref = database.ref('gestion_pedidos/$idBar/$mesa/$idPedido');
    await ref.update({'estado_linea': nuevoEstado});
  }

  @override
  Future<void> updateEnMarchaPedido({
    required String idBar,
    required String mesa,
    required String idPedido,
    required bool enMarcha,
  }) async {
    final ref = database.ref('gestion_pedidos/$idBar/$mesa/$idPedido');
    await ref.update({'en_marcha': enMarcha});
  }

  @override
  void dispose() {
    dataSource.dispose();
  }
}
