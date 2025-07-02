import 'dart:async';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:qribar_cocina/app/extensions/string_casing_extension.dart';
import 'package:qribar_cocina/app/types/errors/network_error.dart';
import 'package:qribar_cocina/app/types/repository_error.dart';
import 'package:qribar_cocina/data/data_sources/local/id_bar_data_source.dart';
import 'package:qribar_cocina/data/models/pedido/pedido.dart';
import 'package:qribar_cocina/data/repositories/remote/listener_repository_impl.dart';
import 'package:qribar_cocina/features/login/data/data_sources/remote/auth_remote_data_source_contract.dart';

part 'listener_bloc.freezed.dart';
part 'listener_event.dart';
part 'listener_state.dart';

class ListenerBloc extends Bloc<ListenerEvent, ListenerState> {
  final ListenerRepositoryImpl _repository;
  final AuthRemoteDataSourceContract _authRemoteDataSourceContract;
  late final StreamSubscription _eventSubscription;

  ListenerBloc({
    required ListenerRepositoryImpl repository,
    required AuthRemoteDataSourceContract authRemoteDataSourceContract,
  }) : _repository = repository,
       _authRemoteDataSourceContract = authRemoteDataSourceContract,
       super(const ListenerState.initial()) {
    _eventSubscription = _repository.dataSource.eventsStream.listen(
      (event) {
        event.mapOrNull(
          pedidosUpdated: (e) => add(ListenerEvent.pedidosUpdated(e.pedidos)),
          pedidoRemoved: (e) => add(ListenerEvent.pedidoRemoved(e.pedido)),
        );
      },
      onError: (e, stackTrace) {
        add(
          ListenerEvent.streamError(
            RepositoryError.fromDataSourceError(NetworkError.fromException(e)),
          ),
        );
      },
    );

    on<_StartListening>(_onStartListening);

    on<_PedidosUpdated>(_onPedidosUpdated);
    on<_PedidoRemoved>(_onPedidoRemoved);

    on<_UpdateEstadoPedido>(_onUpdateEstadoPedido);
    on<_UpdateEnMarchaPedido>(_onUpdateEnMarchaPedido);
  }

  Future<void> _onStartListening(
    _StartListening event,
    Emitter<ListenerState> emit,
  ) async {
    emit(const ListenerState.loading());

    try {
      final email = _authRemoteDataSourceContract.getCurrentEmail();

      if (email == null) {
        emit(ListenerState.failure(RepositoryError.authExpired()));
        return;
      }

      final userName = email.contains('@')
          ? email.split('@').first.toTitleCase()
          : email.toTitleCase();

      IdBarDataSource.instance.setIdBar(userName);

      final result = await _repository.initializeListeners();

      result.when(
        success: (_) => emit(const ListenerState.success()),
        failure: (error) => emit(ListenerState.failure(error)),
      );
    } catch (e, stackTrace) {
      emit(
        ListenerState.failure(
          RepositoryError.fromDataSourceError(NetworkError.fromException(e)),
        ),
      );
      log(stackTrace.toString());
    }
  }

  void _onPedidosUpdated(_PedidosUpdated event, Emitter<ListenerState> emit) {
    emit(ListenerState.pedidosUpdated(event.pedidos));
  }

  void _onPedidoRemoved(_PedidoRemoved event, Emitter<ListenerState> emit) {
    emit(ListenerState.pedidoRemoved(event.pedido));
  }

  Future<void> _onUpdateEstadoPedido(
    _UpdateEstadoPedido event,
    Emitter<ListenerState> emit,
  ) async {
    final result = await _repository.updateEstadoPedido(
      mesa: event.mesa,
      idPedido: event.idPedido,
      nuevoEstado: event.nuevoEstado,
    );
    result.whenOrNull(failure: (error) => emit(ListenerState.failure(error)));
  }

  Future<void> _onUpdateEnMarchaPedido(
    _UpdateEnMarchaPedido event,
    Emitter<ListenerState> emit,
  ) async {
    final result = await _repository.updateEnMarchaPedido(
      mesa: event.mesa,
      idPedido: event.idPedido,
      enMarcha: event.enMarcha,
    );
    result.whenOrNull(failure: (error) => emit(ListenerState.failure(error)));
  }

  @override
  Future<void> close() async {
    await _eventSubscription.cancel();
    await _repository.dispose();
    await _authRemoteDataSourceContract.signOut();
    return super.close();
  }
}
