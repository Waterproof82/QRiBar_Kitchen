import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:qribar_cocina/data/datasources/local_data_source/id_bar_data_source.dart';
import 'package:qribar_cocina/data/repositories/data_sources/remote/listener_repository.dart';
import 'package:qribar_cocina/data/repositories/data_sources/remote/listeners_data_source_contract.dart';

class ListenerRepositoryImpl implements ListenerRepository {
  final FirebaseDatabase database;
  final ListenersDataSourceContract dataSource;

  ListenerRepositoryImpl({
    required this.database,
    required this.dataSource,
  });

  String get idBar => IdBarDataSource.instance.getIdBar();
  
  @override
  Future<void> initializeListeners() async {
    await dataSource.addProduct();
    await dataSource.addCategoriaMenu();
    await dataSource.changeCategoriaMenu();
    await dataSource.addSalaMesas();
    await dataSource.addAndChangedPedidos();
    await dataSource.removePedidos();
  }

  @override
  Future<void> updateEstadoPedido({
    required String mesa,
    required String idPedido,
    required String nuevoEstado,
  }) async {
    final ref = database.ref('gestion_pedidos/$idBar/$mesa/$idPedido');
    await ref.update({'estado_linea': nuevoEstado});
  }

  @override
  Future<void> updateEnMarchaPedido({
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
