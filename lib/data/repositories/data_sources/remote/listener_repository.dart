abstract class ListenerRepository {
  Future<void> initializeListeners();

  Future<void> updateEstadoPedido({
    required String idBar,
    required String mesa,
    required String idPedido,
    required String nuevoEstado,
  });

  Future<void> updateEnMarchaPedido({
    required String idBar,
    required String mesa,
    required String idPedido,
    required bool enMarcha,
  });

  void dispose();
}
