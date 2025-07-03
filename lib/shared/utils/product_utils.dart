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
  final categoriaMap = {
    for (var categoria in categorias) categoria.categoria: categoria,
  };

  final productoMap = {for (var producto in productos) producto.id: producto};

  return pedidos
      .where((pedido) {
        final producto = productoMap[pedido.idProducto];
        if (producto == null) return false;

        final categoria = categoriaMap[producto.categoriaProducto];
        if (categoria == null) return false;

        return categoria.envio == 'cocina';
      })
      .map((pedido) {
        final producto = productoMap[pedido.idProducto]!;
        final categoria = categoriaMap[producto.categoriaProducto]!;

        if (pedido.envio != categoria.envio) {
          return pedido.copyWith(envio: categoria.envio);
        }
        return pedido;
      })
      .toList();
}
