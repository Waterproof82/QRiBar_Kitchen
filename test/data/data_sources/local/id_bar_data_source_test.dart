import 'package:flutter_test/flutter_test.dart';
import 'package:qribar_cocina/data/data_sources/local/id_bar_data_source.dart';

void main() {
  final idBarDataSource = IdBarDataSource.instance;

  group('IdBarDataSource Tests', () {
    setUp(() {
      // Limpiar idBar antes de cada test
      idBarDataSource.clearIdBarForTest();
    });

    test('hasIdBar devuelve false si no está inicializado', () {
      expect(idBarDataSource.hasIdBar, isFalse);
    });

    test('idBar lanza StateError si no está inicializado', () {

      expect(() => idBarDataSource.idBar, throwsA(isA<StateError>()));
      expect(
        () => idBarDataSource.idBar,
        throwsA(predicate((e) => e is StateError && e.message == 'idBar no ha sido inicializado')),
      );
    });

    test('setIdBar y setIdBarForTest inicializan idBar correctamente', () {
      idBarDataSource.setIdBar('test_id');
      expect(idBarDataSource.hasIdBar, isTrue);
      expect(idBarDataSource.idBar, 'test_id');

      idBarDataSource.setIdBarForTest('test_id_2');
      expect(idBarDataSource.hasIdBar, isTrue);
      expect(idBarDataSource.idBar, 'test_id_2');
    });

    test('hasIdBar devuelve true cuando idBar está inicializado', () {
      idBarDataSource.setIdBarForTest('some_id');
      expect(idBarDataSource.hasIdBar, isTrue);
    });
  });
}
