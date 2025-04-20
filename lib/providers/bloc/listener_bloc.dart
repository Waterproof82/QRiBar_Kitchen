import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:qribar_cocina/data/models/pedido/pedido.dart';
import 'package:qribar_cocina/data/repositories/data_sources/remote/listener_repository_impl.dart';

part 'listener_bloc.freezed.dart';
part 'listener_event.dart';
part 'listener_state.dart';

class ListenerBloc extends Bloc<ListenerEvent, ListenerState> {
  final ListenerRepositoryImpl repository;
  late final StreamSubscription _eventSubscription;

  ListenerBloc({required this.repository}) : super(const ListenerState.initial()) {
    _eventSubscription = repository.dataSource.eventsStream.listen((event) {
      event.mapOrNull(
          startListening: (e) => add(ListenerEvent.startListening()),
          pedidosUpdated: (e) => add(ListenerEvent.pedidosUpdated(e.pedidos)),
          pedidoRemoved: (e) => add(ListenerEvent.pedidoRemoved(e.pedido)),
          errorOccurred: (e) => add(ListenerEvent.errorOccurred(e.toString())));
    });

    on<ListenerEvent>((event, emit) async {
      if (event is _StartListening) {
        emit(const ListenerState.loading());
        try {
          await repository.initializeListeners();
          emit(const ListenerState.success());
        } catch (e) {
          emit(ListenerState.failure(e.toString()));
        }
      } else if (event is _PedidosUpdated) {
        emit(
          ListenerState.pedidosUpdated(event.pedidos),
        );
      } else if (event is _PedidoRemoved) {
        emit(
          ListenerState.pedidoRemoved(event.pedido),
        );
      } else if (event is _UpdateEstadoPedido) {
        try {
          await repository.updateEstadoPedido(
            mesa: event.mesa,
            idPedido: event.idPedido,
            nuevoEstado: event.nuevoEstado,
          );
        } catch (e) {
          emit(ListenerState.failure('Error al actualizar estado: ${e.toString()}'));
        }
      } else if (event is _UpdateEnMarchaPedido) {
        try {
          await repository.updateEnMarchaPedido(
            mesa: event.mesa,
            idPedido: event.idPedido,
            enMarcha: event.enMarcha,
          );
        } catch (e) {
          emit(ListenerState.failure('Error al actualizar marchando pedido: ${e.toString()}'));
        }
      } else if (event is _ErrorOccurred) {
        emit(ListenerState.failure(event.message));
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
