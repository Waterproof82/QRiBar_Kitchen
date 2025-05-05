import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:qribar_cocina/data/models/pedido/pedido.dart';
import 'package:qribar_cocina/data/repositories/listener_repository_impl.dart';
import 'package:qribar_cocina/data/types/repository_error.dart';

part 'listener_bloc.freezed.dart';
part 'listener_event.dart';
part 'listener_state.dart';

class ListenerBloc extends Bloc<ListenerEvent, ListenerState> {
  final ListenerRepositoryImpl repository;
  late final StreamSubscription _eventSubscription;

  ListenerBloc({required this.repository}) : super(const ListenerState.initial()) {
    // 🔄 Escucha del stream global del repositorio
    _eventSubscription = repository.dataSource.eventsStream.listen((event) {
      event.mapOrNull(
        startListening: (_) => add(const ListenerEvent.startListening()),
        pedidosUpdated: (e) => add(ListenerEvent.pedidosUpdated(e.pedidos)),
        pedidoRemoved: (e) => add(ListenerEvent.pedidoRemoved(e.pedido)),
      );
    });

    on<ListenerEvent>((event, emit) async {
      switch (event) {
        case _StartListening():
          emit(const ListenerState.loading());

          final result = await repository.initializeListeners();
          result.when(
            success: (_) => emit(const ListenerState.success()),
            failure: (error) => emit(ListenerState.failure(error)),
          );
          break;

        case _PedidosUpdated():
          emit(ListenerState.pedidosUpdated(event.pedidos));
          break;

        case _PedidoRemoved():
          emit(ListenerState.pedidoRemoved(event.pedido));
          break;

        case _UpdateEstadoPedido():
          final result = await repository.updateEstadoPedido(
            mesa: event.mesa,
            idPedido: event.idPedido,
            nuevoEstado: event.nuevoEstado,
          );
          result.whenOrNull(
            failure: (error) => emit(ListenerState.failure(error)),
          );
          break;

        case _UpdateEnMarchaPedido():
          final result = await repository.updateEnMarchaPedido(
            mesa: event.mesa,
            idPedido: event.idPedido,
            enMarcha: event.enMarcha,
          );
          result.whenOrNull(
            failure: (error) => emit(ListenerState.failure(error)),
          );
          break;
      }
    });
  }

  @override
  Future<void> close() {
    _eventSubscription.cancel();
    repository.dispose();
    return super.close();
  }
}
