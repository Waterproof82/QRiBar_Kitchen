import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:qribar_cocina/app/types/repository_error.dart';
import 'package:qribar_cocina/app/types/result.dart';
import 'package:qribar_cocina/data/data_sources/remote/listeners_remote_data_source_contract.dart';
import 'package:qribar_cocina/data/repositories/remote/listener_repository_impl.dart';
import 'package:qribar_cocina/features/app/bloc/listener_bloc.dart';
import 'package:qribar_cocina/features/login/data/data_sources/remote/auth_remote_data_source_contract.dart';

// Mocks
class MockListenerRepositoryImpl extends Mock
    implements ListenerRepositoryImpl {}

class MockDataSource extends Mock
    implements ListenersRemoteDataSourceContract {}

class MockAuthRemoteDataSourceContract extends Mock
    implements AuthRemoteDataSourceContract {}

void main() {
  late MockListenerRepositoryImpl mockRepository;
  late MockDataSource mockDataSource;
  late MockAuthRemoteDataSourceContract mockAuthDataSource;
  late ListenerBloc bloc;
  late StreamController<ListenerEvent> streamController;

  setUp(() {
    mockRepository = MockListenerRepositoryImpl();
    mockDataSource = MockDataSource();
    mockAuthDataSource = MockAuthRemoteDataSourceContract();

    streamController = StreamController<ListenerEvent>.broadcast();

    // Stub del stream de eventos dentro del dataSource
    when(
      () => mockDataSource.eventsStream,
    ).thenAnswer((_) => streamController.stream);

    // Stub métodos async del repositorio para devolver éxito
    when(
      () => mockRepository.initializeListeners(),
    ).thenAnswer((_) async => const Result.success(null));

    when(
      () => mockRepository.updateEstadoPedido(
        mesa: any(named: 'mesa'),
        idPedido: any(named: 'idPedido'),
        nuevoEstado: any(named: 'nuevoEstado'),
      ),
    ).thenAnswer((_) async => const Result.success(null));

    when(
      () => mockRepository.updateEnMarchaPedido(
        mesa: any(named: 'mesa'),
        idPedido: any(named: 'idPedido'),
        enMarcha: any(named: 'enMarcha'),
      ),
    ).thenAnswer((_) async => const Result.success(null));

    bloc = ListenerBloc(
      repository: mockRepository,
      authRemoteDataSourceContract: mockAuthDataSource,
    );
  });

  tearDown(() async {
    await bloc.close();
    await streamController.close();
  });

  test('Estado inicial es ListenerState.initial', () {
    expect(bloc.state, equals(const ListenerState.initial()));
  });

  blocTest<ListenerBloc, ListenerState>(
    'emite ListenerState.loading y luego ListenerState.success cuando se inicia startListening y repo responde con éxito',
    build: () => bloc,
    act: (bloc) => bloc.add(const ListenerEvent.startListening()),
    expect: () => [
      const ListenerState.loading(),
      const ListenerState.success(),
    ],
  );

  blocTest<ListenerBloc, ListenerState>(
    'invoca updateEstadoPedido y no emite nuevo estado si es éxito',
    build: () => bloc,
    act: (bloc) {
      bloc.add(
        const ListenerEvent.updateEstadoPedido(
          mesa: 'mesa1',
          idPedido: 'pedido1',
          nuevoEstado: 'listo',
        ),
      );
    },
    expect: () => [],
    verify: (_) {
      verify(
        () => mockRepository.updateEstadoPedido(
          mesa: 'mesa1',
          idPedido: 'pedido1',
          nuevoEstado: 'listo',
        ),
      ).called(1);
    },
  );

  blocTest<ListenerBloc, ListenerState>(
    'emite ListenerState.failure cuando updateEstadoPedido falla',
    build: () {
      when(
        () => mockRepository.updateEstadoPedido(
          mesa: any(named: 'mesa'),
          idPedido: any(named: 'idPedido'),
          nuevoEstado: any(named: 'nuevoEstado'),
        ),
      ).thenAnswer(
        (_) async => Result.failure(error: RepositoryError.badRequest()),
      );
      return bloc;
    },
    act: (bloc) {
      bloc.add(
        const ListenerEvent.updateEstadoPedido(
          mesa: 'mesa1',
          idPedido: 'pedido1',
          nuevoEstado: 'listo',
        ),
      );
    },
    expect: () => [
      isA<ListenerState>().having(
        (s) => s.maybeMap(failure: (state) => state.error, orElse: () => null),
        'error',
        isNotNull,
      ),
    ],
  );

  blocTest<ListenerBloc, ListenerState>(
    'invoca updateEnMarchaPedido y no emite nuevo estado si es éxito',
    build: () => bloc,
    act: (bloc) {
      bloc.add(
        const ListenerEvent.updateEnMarchaPedido(
          mesa: 'mesa1',
          idPedido: 'pedido1',
          enMarcha: true,
        ),
      );
    },
    expect: () => [],
    verify: (_) {
      verify(
        () => mockRepository.updateEnMarchaPedido(
          mesa: 'mesa1',
          idPedido: 'pedido1',
          enMarcha: true,
        ),
      ).called(1);
    },
  );

  blocTest<ListenerBloc, ListenerState>(
    'emite ListenerState.failure cuando updateEnMarchaPedido falla',
    build: () {
      when(
        () => mockRepository.updateEnMarchaPedido(
          mesa: any(named: 'mesa'),
          idPedido: any(named: 'idPedido'),
          enMarcha: any(named: 'enMarcha'),
        ),
      ).thenAnswer(
        (_) async => Result.failure(error: RepositoryError.badRequest()),
      );
      return bloc;
    },
    act: (bloc) {
      bloc.add(
        const ListenerEvent.updateEnMarchaPedido(
          mesa: 'mesa1',
          idPedido: 'pedido1',
          enMarcha: true,
        ),
      );
    },
    expect: () => [
      isA<ListenerState>().having(
        (s) => s.maybeMap(failure: (state) => state.error, orElse: () => null),
        'error',
        isNotNull,
      ),
    ],
  );
}
