import 'package:qribar_cocina/providers/bloc/listener_bloc.dart';

abstract class ListenersDataSourceContract {
  Stream<ListenerEvent> get eventsStream;

  Future<void> addProduct();
  Future<void> addCategoriaMenu();
  Future<void> changeCategoriaMenu();
  Future<void> addAndChangedPedidos();
  Future<void> removePedidos();
  void dispose();
}
