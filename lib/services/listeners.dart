import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qribar_cocina/models/ficha_local.dart';
import 'package:qribar_cocina/models/modifier.dart';
import 'package:qribar_cocina/models/pedidos.dart';
import 'package:qribar_cocina/models/pedidosLocal.dart';
import 'package:qribar_cocina/models/product.dart';
import 'package:qribar_cocina/provider/navegacion_model.dart';
import 'package:qribar_cocina/provider/products_provider.dart';
import 'package:qribar_cocina/services/functions.dart';

class ListenFirebase extends StatefulWidget {
  static final String routeName = 'listenFirebase';
  @override
  _ListenFirebaseState createState() => _ListenFirebaseState();
}

class _ListenFirebaseState extends State<ListenFirebase> {
  final database = FirebaseDatabase.instance;

  StreamSubscription? _dataStreamProductos;
  StreamSubscription? _dataStreamCategoria;
  StreamSubscription? _dataStreamGestionPedidos;
  StreamSubscription? _dataStreamPedidosRemovidos;

  @override
  void initState() {
    super.initState();
    //  WidgetsBinding.instance.addPostFrameCallback((_) {
    final productService = Provider.of<ProductsService>(context, listen: false);
    // final itemElemento = Provider.of<ProductsService>(context, listen: false);
    final numElementos = Provider.of<NavegacionModel>(context, listen: false);
    String idBar = productService.idBar;

    _childListenerAddProductNew(productService.products, numElementos, idBar, productService);
    childAddCategoriaNuevaMenu(numElementos, idBar);
    childChangedCategoriaMenu(numElementos, idBar);
    addAndChangedListenerPedidosMesasLocal(productService.pedidosRealizados, idBar, numElementos, productService.salasMesa);
    childRemoveListenerPedidos(productService.pedidosRealizados, idBar, numElementos, productService.salasMesa);
    //   });
  }

  Future<void> _childListenerAddProductNew(
    List<Product> productService,
    NavegacionModel navModelNotify,
    String idBar,
    ProductsService productServices,
  ) async {
    // _dataStreamProductos = database.ref('productos/$idBar/');
    // Listas para complementar el producto
    List<Complemento> listaComplements = [];
    List<String> alergias = [];
    List<Modifier> modifiers = [];

    _dataStreamProductos = database.ref('productos/$idBar/').onChildAdded.listen(
      (event) {
        final DataSnapshot snapshot = event.snapshot;
        final dynamic value = snapshot.value;

        if (value == null || value is! Map<dynamic, dynamic>) {
          print('Unexpected data format or null value: ${snapshot.value}');
          return;
        }

        final Map<String, dynamic> data = Map<String, dynamic>.from(value);
        final String key = event.snapshot.key ?? '';

        // Extraer complementos
        if (data["complementos"] != null && data["complementos"] is Map) {
          data["complementos"].forEach((k, v) {
            if (v is Map) {
              listaComplements.add(
                Complemento(
                  activo: v["activo"] is bool ? v["activo"] as bool : true,
                  incremento: v['incremento'] is bool ? v['incremento'] as bool : false,
                  id: k,
                ),
              );
            }
          });
        }

        // Extraer alérgenos
        if (data["alergogenos"] != null && data["alergogenos"] is Map) {
          data["alergogenos"].forEach((k, v) {
            if (k is String) {
              alergias.add(k);
            }
          });
        }

// Extraer modificadores
        if (data['modifiers'] != null) {
          data['modifiers'].forEach((k, v) {
            modifiers.add(Modifier(
              name: k,
              increment: v.toDouble(),
            ));
          });
        }

        final bool disponibleSnap = data['disponible'] is bool ? data['disponible'] as bool : false;
        double coste = (data["coste_producto"] is num) ? (data["coste_producto"] as num).toDouble() : 0.0;
        double precio2 = (data["precio_producto2"] is num) ? (data["precio_producto2"] as num).toDouble() : 0.0;

        // Crear producto con copias de listas
        List<Product> listaProductos = [
          Product(
            alergogenos: alergias, // Copia de lista
            categoriaProducto: data["categoria_producto"] as String? ?? '',
            costeProducto: coste,
            disponible: disponibleSnap,
            descripcionProducto: data["descripcion_producto"] as String? ?? '',
            descripcionProductoEn: data["descripcion_producto_en"] as String? ?? '',
            descripcionProductoDe: data["descripcion_producto_de"] as String? ?? '',
            fotoUrl: data["foto_url"] as String? ?? '',
            fotoUrlVideo: data["foto_url_video"] as String? ?? '',
            nombreProductoOriginal: data["nombre_producto"] as String? ?? '',
            nombreProducto: data["nombre_producto"] as String? ?? '',
            nombreProductoEn: data["nombre_producto_en"] ?? null,
            nombreProductoDe: data["nombre_producto_de"] ?? null,
            nombreRacion: data["nombre_racion"] as String? ?? 'Ración',
            nombreRacionMedia: data["nombre_racion_media"] as String? ?? 'Media Ración',
            nombreRacionEn: data["nombre_racion_en"] as String? ?? '',
            nombreRacionMediaEn: data["nombre_racion_media_en"] as String? ?? '',
            nombreRacionDe: data["nombre_racion_de"] as String? ?? '',
            nombreRacionMediaDe: data["nombre_racion_media_de"] as String? ?? '',
            precioProducto: (data["precio_producto"] is num) ? (data["precio_producto"] as num).toDouble() : 0.0,
            //  precioProductoRacion: (data["precio_producto"] is num) ? (data["precio_producto"] as num).toDouble() : 0.0,
            //  precioProductoMediaRacion: precio2,
            precioProducto2: precio2,
            complementos: listaComplements, // Copia de lista
            // primerPlato: data["primer_plato"] as bool? ?? null,
            // tipo: (data["tipo"] is int) ? data["tipo"] as int : 1,
            modifiers: modifiers, // Copia de lista
            id: key,
          )
        ];

        // Agregar producto si no existe ya en la lista
        final index = productService.indexWhere((element) => element.nombreProducto == data["nombre_producto"]);
        if (index == -1) productService.add(listaProductos[0]);

        // Limpiar listas para el próximo producto
        listaComplements = [];
        alergias = [];
        modifiers = [];

        // Notificar cambio de estado
        navModelNotify.cambioEstadoProducto = true;
      },
      onError: (error) {
        print('Error occurred: $error');
      },
    );
  }

  Future<void> childAddCategoriaNuevaMenu(NavegacionModel numElementos, String idBar) async {
    final catProductos = Provider.of<ProductsService>(context, listen: false).categoriasProdLocal;

    _dataStreamCategoria = database.ref('ficha_local/$idBar/categoria_productos').onChildAdded.listen((event) {
      final dataMesas = Map<String, dynamic>.from(event.snapshot.value as Map);

      final nuevaCategoria = CategoriaProducto(
        categoria: dataMesas['categoria'],
        categoriaEn: dataMesas['categoria_en'],
        categoriaDe: dataMesas['categoria_de'],
        envio: dataMesas['envio'],
        icono: dataMesas['icono'],
        imgVertical: dataMesas['img_vertical'],
        orden: dataMesas['orden'],
        id: event.snapshot.key!,
      );

      catProductos.add(nuevaCategoria);
      numElementos.valRecargaWidget = true;
    });
  }

  Future<void> childChangedCategoriaMenu(NavegacionModel numElementos, String idBar) async {
    final catProductos = Provider.of<ProductsService>(context, listen: false).categoriasProdLocal;

    DatabaseReference _dataStreamNewCategory = FirebaseDatabase.instance.ref('ficha_local/$idBar/categoria_productos');

    _dataStreamNewCategory.onChildChanged.listen((event) {
      final dataMesas = Map<String, dynamic>.from(event.snapshot.value as Map);

      var producto = catProductos.firstWhere((producto) => producto.id == event.snapshot.key, orElse: () => CategoriaProducto(categoria: ''));
      producto.categoria = dataMesas['categoria'];
      producto.categoriaEn = dataMesas['categoria_en'];
      producto.categoriaDe = dataMesas['categoria_de'];
      producto.envio = dataMesas['envio'];
      producto.icono = dataMesas['nombreIcon'];
      producto.orden = dataMesas['orden'];
      producto.icono = dataMesas['icono'];
      producto.imgVertical = dataMesas['img_vertical'];
/*       numElementos.categoriaSelected = 'Sugerencias';
      numElementos.itemSeleccionado = 0;
      numElementos.itemSeleccionadoMenu = 0; */
      numElementos.valRecargaWidget = true;
    });
  }

  Future<void> addAndChangedListenerPedidosMesasLocal(List<Pedidos> itemPedidos, String idBar, NavegacionModel numElementos, List<PedidosLocal> salasMesa) async {
    for (var salas in salasMesa) {
      final path = 'gestion_pedidos/$idBar/${salas.mesa}';

      _dataStreamGestionPedidos = database.ref(path).onChildAdded.listen((event) {
        _handleDataChange(itemPedidos, idBar, numElementos, event.snapshot.value, '');
      });

      _dataStreamGestionPedidos = database.ref(path).onChildChanged.listen((event) {
        String? pedidoId = event.snapshot.key;
        _handleDataChange(itemPedidos, idBar, numElementos, event.snapshot.value, pedidoId);
      });
    }
  }

  void _handleDataChange(List<Pedidos> itemPedidos, String idBar, NavegacionModel numElementos, dynamic data, String? pedidoId) {
    final dataMesas = Map<String, dynamic>.from(data);

    final idProd = dataMesas['idProducto'] as String;
    final mesaSnap = dataMesas['mesa'] as String;
    final numPed = dataMesas['numPedido'] as int;

    final productService = Provider.of<ProductsService>(context, listen: false);

    final catProductos = productService.categoriasProdLocal;
    List<CategoriaProducto> unicaCategoriaFiltro = [];
    List<Modifier> modifiers = [];
    String envio = '';

    //EXTRAS
    final List<String> extras = [];
    if (dataMesas['extras'] != null)
      dataMesas['extras'].forEach(
        (element) {
          extras.add(element);
        },
      );
    //

    if (dataMesas['modifiers'] != null && dataMesas['modifiers'] is List) {
      final modifiersList = List.from(dataMesas['modifiers']); // Convierte a una lista genérica
      modifiers = modifiersList.map((modifier) {
        if (modifier is Map) {
          final modifierMap = Map<String, dynamic>.from(modifier);
          return Modifier(
            name: modifierMap['name'] ?? '', // Valor por defecto si falta
            increment: (modifierMap['increment'] ?? 0).toDouble(), // Conversión a double
          );
        } else {
          return Modifier();
        }
      }).toList();
    }

    itemPedidos.add(
      Pedidos(
        cantidad: dataMesas['cantidad'],
        //categoriaProducto: dataMesas['categoria_producto'],
        fecha: dataMesas['fecha'],
        hora: dataMesas['hora'],
        //idBar: idBar,
        mesa: mesaSnap.toString(),
        //mesaAbierta: dataMesas['mesaAbierta'] ?? false,
        numPedido: numPed,
        // precioProducto: dataMesas['precio_producto'].toDouble(),
        // titulo: dataMesas['titulo'],
        nota: dataMesas['nota'],
        estadoLinea: dataMesas['estado_linea'],
        idProducto: idProd,
        enMarcha: false,
        notaExtra: extras,
        racion: dataMesas['racion'],
        modifiers: modifiers,
        id: dataMesas['id'],
      ),
    );
    ordenaCategorias(catProductos, unicaCategoriaFiltro, itemPedidos, productService);
    for (var element in itemPedidos) {
      if (element.idProducto == idProd) envio = element.envio ?? '';
    }
    if ((numPed != numElementos.pedAnterior || numElementos.mesaAnt != mesaSnap) && dataMesas['estado_linea'] == 'pendiente' && envio == 'cocina') {
      timbre();

      numElementos.pedAnterior = numPed;
      numElementos.mesaAnt = mesaSnap;
    } else if (dataMesas['estado_linea'] == 'cocinado' || dataMesas['estado_linea'] == 'bloqueado') {
      itemPedidos.removeWhere((pedido) => pedido.id == pedidoId);
    }

    numElementos.valRecargaWidget = true;
  }

  Future<void> childRemoveListenerPedidos(List<Pedidos> itemPedidos, String idBar, NavegacionModel navModel, List<PedidosLocal> salasMesa) async {
    for (var sala in salasMesa) {
      _dataStreamGestionPedidos = database.ref('gestion_pedidos/$idBar/${sala.mesa}').onChildRemoved.listen((event) {
        try {
          String? pedidoId = event.snapshot.key;
          itemPedidos.removeWhere((pedido) => pedido.id == pedidoId);
          navModel.valRecargaWidget = true;
        } catch (e) {
          print("Error handling removed pedido: $e");
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }

  @override
  void dispose() {
    _dataStreamProductos?.cancel();
    _dataStreamCategoria?.cancel();
    _dataStreamGestionPedidos?.cancel();
    _dataStreamPedidosRemovidos?.cancel();
    super.dispose();
  }
}
