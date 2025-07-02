import 'package:qribar_cocina/data/models/categoria_producto.dart';
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
