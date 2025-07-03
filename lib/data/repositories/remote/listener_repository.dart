import 'package:qribar_cocina/app/types/result.dart';

abstract class ListenerRepository {
  Future<Result<void>> initializeListeners();

  Future<Result<void>> updateEstadoPedido({
    required String mesa,
    required String idPedido,
    required String nuevoEstado,
  });

  Future<Result<void>> updateEnMarchaPedido({
    required String mesa,
    required String idPedido,
    required bool enMarcha,
  });

  Future<void> dispose();
}
