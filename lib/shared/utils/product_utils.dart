import 'package:qribar_cocina/data/models/categoria_producto.dart';
import 'package:qribar_cocina/data/models/pedido/pedido.dart';
import 'package:qribar_cocina/data/models/product.dart';

String obtenerNombreProducto(
  List<Product> productos,
  String idProducto,
  bool racion,
) {
  final producto = productos.firstWhere(
    (p) => p.id == idProducto,
    orElse: () => Product(
      id: '',
      nombreProducto: 'Producto no encontrado',
      categoriaProducto: '',
    ),
  );
  if (producto.id!.isEmpty) return producto.nombreProducto;

  return racion
      ? producto.nombreProducto
      : '${producto.nombreProducto} (${producto.nombreRacionMedia ?? 'Media Ración'})';
}

Future<String?> obtenerEnvioPorProducto(
  List<CategoriaProducto> categorias,
  String idProd,
  List<Product> productos,
) async {
  final categoriaMap = {
    for (var categoria in categorias) categoria.categoria: categoria,
  };

  final categoria = categoriaMap[obtenerCategoriaProducto(productos, idProd)];
  return categoria?.envio;
}

String obtenerCategoriaProducto(List<Product> productos, String idProducto) {
  final producto = productos.firstWhere(
    (p) => p.id == idProducto,
    orElse: () => Product(
      id: '',
      categoriaProducto: 'Categoría no encontrada',
      nombreProducto: '',
    ),
  );
  return producto.categoriaProducto;
}

List<Pedido> asignarEnviosPorPedidos({
  required List<Pedido> pedidos,
  required List<Product> productos,
  required List<CategoriaProducto> categorias,
}) {
  final categoriaMap = {for (final c in categorias) c.categoria: c};
  final productoMap = {for (final p in productos) p.id!: p};

  return pedidos
      .map((pedido) {
        final producto = productoMap[pedido.idProducto];
        if (producto == null) return pedido;

        final categoria = categoriaMap[producto.categoriaProducto];
        if (categoria == null) return pedido;

        if (pedido.envio != categoria.envio) {
          return pedido.copyWith(envio: categoria.envio);
        }
        return pedido;
      })
      .toList(growable: false);
}
