import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:qribar_cocina/app/types/repository_error.dart';
import 'package:qribar_cocina/app/types/result.dart';
import 'package:qribar_cocina/data/data_sources/local/id_bar_data_source.dart';
import 'package:qribar_cocina/data/data_sources/remote/listeners_remote_data_source_contract.dart';
import 'package:qribar_cocina/data/repositories/remote/listener_repository_impl.dart';

class MockFirebaseDatabase extends Mock implements FirebaseDatabase {}

class MockListenersRemoteDataSourceContract extends Mock implements ListenersRemoteDataSourceContract {}

class MockDatabaseReference extends Mock implements DatabaseReference {}

void main() {
  late MockFirebaseDatabase mockDatabase;
  late MockListenersRemoteDataSourceContract mockDataSource;
  late ListenerRepositoryImpl repository;
  late MockDatabaseReference mockRef;

  setUp(() {
    mockDatabase = MockFirebaseDatabase();
    mockDataSource = MockListenersRemoteDataSourceContract();
    mockRef = MockDatabaseReference();
    IdBarDataSource.instance.setIdBarForTest('test_id');

    when(() => mockDatabase.ref(any())).thenReturn(mockRef);
    when(() => mockRef.update(any())).thenAnswer((_) async {});

    repository = ListenerRepositoryImpl(
      database: mockDatabase,
      dataSource: mockDataSource,
    );
  });

  group('initializeListeners', () {
    test('debe ejecutar todos los listeners y devolver Result.success', () async {
      when(() => mockDataSource.addProduct()).thenAnswer((_) async {});
      when(() => mockDataSource.addCategoriaMenu()).thenAnswer((_) async {});
      when(() => mockDataSource.changeCategoriaMenu()).thenAnswer((_) async {});
      when(() => mockDataSource.addSalaMesas()).thenAnswer((_) async {});
      when(() => mockDataSource.addAndChangedPedidos()).thenAnswer((_) async {});
      when(() => mockDataSource.removePedidos()).thenAnswer((_) async {});

      final result = await repository.initializeListeners();

      expect(result, isA<Success<void>>());
      expect((result as Success).data, isNull);

      verifyInOrder([
        () => mockDataSource.addProduct(),
        () => mockDataSource.addCategoriaMenu(),
        () => mockDataSource.changeCategoriaMenu(),
        () => mockDataSource.addSalaMesas(),
        () => mockDataSource.addAndChangedPedidos(),
        () => mockDataSource.removePedidos(),
      ]);
    });

    test('debe capturar errores y devolver Result.failure con RepositoryError', () async {
      when(() => mockDataSource.addProduct()).thenThrow(Exception('Error'));

      final result = await repository.initializeListeners();

      expect(result, isA<Failure<void>>());
      final failure = result as Failure<void>;
      expect(failure.error, isA<RepositoryError>());
    });
  });

  group('updateEstadoPedido', () {
    test('actualiza correctamente estado_linea y devuelve Result.success', () async {
      final result = await repository.updateEstadoPedido(
        mesa: 'mesa1',
        idPedido: 'pedido123',
        nuevoEstado: 'listo',
      );

      expect(result, isA<Success<void>>());
      expect((result as Success).data, isNull);
      verify(() => mockRef.update({'estado_linea': 'listo'})).called(1);
    });

    test('devuelve Result.failure si falla actualización', () async {
      when(() => mockRef.update(any())).thenThrow(Exception('Error Firebase'));

      final result = await repository.updateEstadoPedido(
        mesa: 'mesa1',
        idPedido: 'pedido123',
        nuevoEstado: 'fallido',
      );

      expect(result, isA<Failure<void>>());
      final failure = result as Failure<void>;
      expect(failure.error, isA<RepositoryError>());
    });
  });

  group('updateEnMarchaPedido', () {
    test('actualiza correctamente en_marcha y devuelve Result.success', () async {
      final result = await repository.updateEnMarchaPedido(
        mesa: 'mesa1',
        idPedido: 'pedido456',
        enMarcha: true,
      );

      expect(result, isA<Success<void>>());
      expect((result as Success).data, isNull);
      verify(() => mockRef.update({'en_marcha': true})).called(1);
    });

    test('devuelve Result.failure si falla actualización', () async {
      final idBarDataSource = IdBarDataSource.instance;
      IdBarDataSource.instance.clearIdBarForTest();

      when(() => mockRef.update(any())).thenThrow(Exception('Error Firebase'));

      final result = await repository.updateEnMarchaPedido(
        mesa: 'mesa1',
        idPedido: 'pedido456',
        enMarcha: false,
      );

      expect(result, isA<Failure<void>>());
      final failure = result as Failure<void>;
      expect(failure.error, isA<RepositoryError>());
      expect(() => idBarDataSource.idBar, throwsA(isA<StateError>()));
      expect(
        () => idBarDataSource.idBar,
        throwsA(predicate((e) => e is StateError && e.message == 'idBar no ha sido inicializado')),
      );
    });
  });

  test('dispose llama correctamente a dispose del dataSource', () {
    repository.dispose();
    verify(() => mockDataSource.dispose()).called(1);
  });


}
