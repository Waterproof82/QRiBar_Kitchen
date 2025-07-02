import 'dart:async';

import 'package:qribar_cocina/app/types/result.dart';
import 'package:qribar_cocina/data/repositories/remote/listener_repository_impl.dart';
import 'package:qribar_cocina/features/app/bloc/listener_bloc.dart';

class EventStreamManager {
  final ListenerRepositoryImpl _repository;
  StreamSubscription<ListenerEvent>? _eventSubscription;

  EventStreamManager(this._repository);

  Future<Result<void>> initializeListeners({
    required void Function(ListenerEvent event) onEvent,
    required void Function(Object error, StackTrace stackTrace) onError,
  }) async {
    final result = await _repository.initializeListeners();

    return result.when(
      success: (_) async {
        await _eventSubscription?.cancel();
        _eventSubscription = null;

        _eventSubscription = _repository.eventsStream.listen(
          (event) {
            event.mapOrNull(
              pedidosUpdated: (e) =>
                  onEvent(ListenerEvent.pedidosUpdated(e.pedidos)),
              pedidoRemoved: (e) =>
                  onEvent(ListenerEvent.pedidoRemoved(e.pedido)),
            );
          },
          onError: onError,
          cancelOnError: false,
        );

        return const Result.success(null);
      },
      failure: (error) {
        return Result.failure(error: error);
      },
    );
  }

  Future<void> dispose() async {
    await _eventSubscription?.cancel();
    _eventSubscription = null;
  }
}
