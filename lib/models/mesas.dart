class Mesa {
  final int cantidad;
  final String idBar;
  final String idMesa;
  final String idProducto;

  Mesa({
    required this.cantidad,
    required this.idBar,
    required this.idMesa,
    required this.idProducto,
  });

/*   factory Mesa.fromRTDB(Map<String, dynamic> data) {
    return Mesa(cantidad: data['cantidad'] ?? 0, idBar: data['id_bar'] ?? '', idMesa: data['id_mesa'] ?? '', idProducto: data['id_producto'] ?? '');
  } */
}
