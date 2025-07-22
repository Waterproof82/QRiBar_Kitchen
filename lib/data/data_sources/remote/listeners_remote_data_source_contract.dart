import 'package:qribar_cocina/features/app/bloc/listener_bloc.dart';

abstract class ListenersRemoteDataSourceContract {
  Stream<ListenerEvent> get eventsStream;

  Future<void> addProduct();
  Future<void> addCategoriaMenu();
  Future<void> addSalaMesas();
  Future<void> addAndChangedPedidos();
  Future<void> removePedidos();
  Future<void> dispose();
}
