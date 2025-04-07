import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:qribar_cocina/data/models/pedido/pedido.dart';
import 'package:qribar_cocina/data/repositories/data_sources/remote/listener_repository.dart';

part 'listener_bloc.freezed.dart';
part 'listener_event.dart';
part 'listener_state.dart';

class ListenerBloc extends Bloc<ListenerEvent, ListenerState> {
  final ListenerRepository repository;

  ListenerBloc({required this.repository}) : super(const ListenerState.initial()) {
    on<ListenerEvent>((event, emit) async {
      if (event is _StartListening) {
        emit(const ListenerState.loading());
        try {
          await repository.initializeListeners();
          emit(const ListenerState.success());
        } catch (e) {
          emit(ListenerState.failure(e.toString()));
        }
      } else if (event is _PedidosUpdatedEvent) {
        emit(ListenerState.pedidosUpdated(List.from(event.pedidos)));
      }
      else if (event is _ErrorOccurred) {
        emit(ListenerState.failure(event.message));
      }
    });
  }

  @override
  Future<void> close() {
    repository.dispose();
    return super.close();
  }
}
