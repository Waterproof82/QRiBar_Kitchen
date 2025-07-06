import 'dart:async';
import 'dart:developer';

import 'package:qribar_cocina/app/types/result.dart';
import 'package:qribar_cocina/data/repositories/remote/listener_repository.dart';
import 'package:qribar_cocina/features/app/bloc/listener_bloc.dart';

/// A final class responsible for managing the lifecycle of real-time event streams
/// from the [ListenerRepository].
///
/// It initializes listeners, handles incoming events and errors, and ensures
/// proper disposal of subscriptions.
final class EventStreamManager {
  /// The repository providing the event stream.
  /// This field now accepts the [ListenerRepository] contract.
  final ListenerRepository _repository;

  /// The subscription to the repository's event stream.
  StreamSubscription<ListenerEvent>? _eventSubscription;

  /// Creates an instance of [EventStreamManager].
  ///
  /// Requires a [repository] (contract) to subscribe to its event stream.
  EventStreamManager(this._repository);

  /// Initializes the listeners from the repository and sets up the event subscription.
  ///
  /// [onEvent]: A callback function to handle incoming [ListenerEvent]s.
  /// [onError]: A callback function to handle errors occurring in the stream.
  /// Returns a [Result<void>] indicating the success or failure of the initialization.
  Future<Result<void>> initializeListeners({
    required void Function(ListenerEvent event) onEvent,
    required void Function(Object error, StackTrace stackTrace) onError,
  }) async {
    final result = await _repository.initializeListeners();

    return result.when(
      success: (_) async {
        await _eventSubscription?.cancel();
        _eventSubscription = null;

        // Subscribe to the repository's event stream.
        _eventSubscription = _repository.eventsStream.listen(
          (event) {
            // Map the incoming event to the appropriate ListenerEvent type
            // and pass it to the provided onEvent callback.
            event.mapOrNull(
              productos: (e) => onEvent(ListenerEvent.productos(e.productos)),
              pedidos: (e) => onEvent(ListenerEvent.pedidos(e.pedidos)),
              categorias: (e) =>
                  onEvent(ListenerEvent.categorias(e.categorias)),
            );
          },
          onError: onError,
          cancelOnError:
              false, // Keep the subscription active even after an error.
        );
        log(
          '✅ [EventStreamManager] Listeners inicializados y suscripción al stream activa.',
        );
        return const Result.success(null);
      },
      failure: (error) {
        log(
          '❌ [EventStreamManager] Fallo al inicializar listeners del repositorio: $error',
        );
        return Result.failure(error: error);
      },
    );
  }

  /// Disposes the event stream manager by canceling the active subscription.
  ///
  /// This method should be called when the manager is no longer needed
  /// to prevent memory leaks.
  Future<void> dispose() async {
    log('🧹 [EventStreamManager] Disposing...');
    await _eventSubscription?.cancel();
    _eventSubscription = null;
    log('✅ [EventStreamManager] Suscripción al stream cancelada.');
  }
}

/// Cancels all [StreamSubscription]s stored in the provided [listenersMap]
/// and then clears the map.
///
/// This utility function is typically used to clean up multiple active
/// subscriptions to prevent memory leaks.
/// [listenersMap]: A map where keys are identifiers and values are [StreamSubscription]s.
Future<void> cancelAndClearListeners(
  Map<String, StreamSubscription> listenersMap,
) async {
  log(
    '🧹 [cancelAndClearListeners] Cancelando y limpiando ${listenersMap.length} listeners...',
  );
  for (final sub in listenersMap.values) {
    try {
      await sub.cancel();
    } catch (e, stackTrace) {
      log(
        '❌ [cancelAndClearListeners] Error cancelando listener: $e',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }
  listenersMap.clear();
  log(
    '✅ [cancelAndClearListeners] Todos los listeners cancelados y mapa limpiado.',
  );
}
