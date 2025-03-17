abstract class ListenersDataSourceContract {
  Future<void> addProduct();
  Future<void> addCategoriaMenu();
  Future<void> changeCategoriaMenu();
  Future<void> addAndChangedPedidos();
  Future<void> removePedidos();
}
