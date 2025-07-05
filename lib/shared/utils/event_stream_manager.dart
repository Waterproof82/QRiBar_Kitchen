import 'dart:async';
import 'dart:developer';

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
              productos: (e) => onEvent(ListenerEvent.productos(e.productos)),
              pedidos: (e) => onEvent(ListenerEvent.pedidos(e.pedidos)),
              categorias: (e) =>
                  onEvent(ListenerEvent.categorias(e.categorias)),
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

/// Cancels all subscriptions in the provided [listenersMap] and clears the map.
Future<void> cancelAndClearListeners(
  Map<String, StreamSubscription> listenersMap,
) async {
  for (final sub in listenersMap.values) {
    try {
      await sub.cancel();
    } catch (e) {
      log('Error cancelando listener: $e');
    }
  }
  listenersMap.clear();
}
