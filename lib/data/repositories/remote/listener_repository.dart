abstract class ListenerRepository {
  Future<void> initializeListeners();

  Future<void> updateEstadoPedido({
    required String mesa,
    required String idPedido,
    required String nuevoEstado,
  });

  Future<void> updateEnMarchaPedido({
    required String mesa,
    required String idPedido,
    required bool enMarcha,
  });

  Future<void> dispose();
}
