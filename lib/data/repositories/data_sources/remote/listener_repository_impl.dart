import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:qribar_cocina/data/datasources/local_data_source/id_bar_data_source.dart';
import 'package:qribar_cocina/data/datasources/remote_data_source/listeners_data_source_contract.dart';
import 'package:qribar_cocina/data/enums/estado_pedido.dart';
import 'package:qribar_cocina/data/models/categoria_producto.dart';
import 'package:qribar_cocina/data/models/modifier/modifier.dart';
import 'package:qribar_cocina/data/models/pedido/pedido.dart';
import 'package:qribar_cocina/data/models/product.dart';
import 'package:qribar_cocina/data/repositories/data_sources/remote/listener_repository.dart';
import 'package:qribar_cocina/providers/bloc/listener_bloc.dart';
import 'package:qribar_cocina/providers/navegacion_provider.dart';
import 'package:qribar_cocina/providers/products_provider.dart';
import 'package:qribar_cocina/services/functions.dart';

class ListenerRepositoryImpl implements ListenerRepository, ListenersDataSourceContract {
  final FirebaseDatabase database;
  final ProductsService productService;
  final NavegacionProvider nav;
  late String idBar;
  ListenerBloc? listenerBloc;

  StreamSubscription? _dataStreamProductos;
  StreamSubscription? _dataStreamCategoria;
  StreamSubscription? _dataStreamGestionPedidos;
  StreamSubscription? _dataStreamRemovedPedidos;

  ListenerRepositoryImpl({
    required this.database,
    required this.productService,
    required this.nav,
  });

  // Método para configurar el ListenerBloc después de la creación
  void setListenerBloc(ListenerBloc bloc) {
    listenerBloc = bloc;
  }

  @override
  Future<void> initializeListeners() async {
    idBar = IdBarDataSource.instance.getIdBar();
    await addProduct();
    await addCategoriaMenu();
    await changeCategoriaMenu();
    await addAndChangedPedidos();
    await removePedidos();
  }

  @override
  Future<void> addProduct() async {
    List<Complemento> listaComplements = [];
    List<String> alergias = [];
    List<Modifier> modifiers = [];
    List<Product> product = productService.products;

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

        if (data["alergogenos"] != null && data["alergogenos"] is Map) {
          data["alergogenos"].forEach((k, v) {
            if (k is String) {
              alergias.add(k);
            }
          });
        }

        if (data['modifiers'] != null) {
          data['modifiers'].forEach((k, v) {
            modifiers.add(Modifier(
              name: k,
              increment: v.toDouble(),
              mainProduct: key,
            ));
          });
        }

        final bool disponibleSnap = data['disponible'] is bool ? data['disponible'] as bool : false;
        double coste = (data["coste_producto"] is num) ? (data["coste_producto"] as num).toDouble() : 0.0;
        double precio2 = (data["precio_producto2"] is num) ? (data["precio_producto2"] as num).toDouble() : 0.0;

        List<Product> listaProductos = [
          Product(
            alergogenos: alergias,
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
            precioProducto2: precio2,
            complementos: listaComplements,
            modifiers: modifiers,
            id: key,
          )
        ];

        final index = product.indexWhere((element) => element.nombreProducto == data["nombre_producto"]);
        if (index == -1) product.add(listaProductos[0]);

        listaComplements = [];
        alergias = [];
        modifiers = [];
      },
      onError: (error) {
        print('Error occurred: $error');
      },
    );
  }

  @override
  Future<void> addCategoriaMenu() async {
    final catProductos = productService.categoriasProdLocal;

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
    });
  }

  @override
  Future<void> changeCategoriaMenu() async {
    final catProductos = productService.categoriasProdLocal;

    _dataStreamCategoria = database.ref('ficha_local/$idBar/categoria_productos').onChildChanged.listen((event) {
      final dataMesas = Map<String, dynamic>.from(event.snapshot.value as Map);

      CategoriaProducto producto = catProductos.firstWhere((producto) => producto.id == event.snapshot.key, orElse: () => CategoriaProducto(categoria: ''));
      producto.categoria = dataMesas['categoria'];
      producto.categoriaEn = dataMesas['categoria_en'];
      producto.categoriaDe = dataMesas['categoria_de'];
      producto.envio = dataMesas['envio'];
      producto.icono = dataMesas['nombreIcon'];
      producto.orden = dataMesas['orden'];
      producto.icono = dataMesas['icono'];
      producto.imgVertical = dataMesas['img_vertical'];
    });
  }

  @override
  Future<void> addAndChangedPedidos() async {
    final itemPedidos = productService.pedidosRealizados;
    final salasMesa = productService.salasMesa;

    for (var salas in salasMesa) {
      final path = 'gestion_pedidos/$idBar/${salas.mesa}';

      _dataStreamGestionPedidos = database.ref(path).onChildAdded.listen((event) {
        _processPedido(event.snapshot, itemPedidos, idBar, productService);
      });

      _dataStreamGestionPedidos = database.ref(path).onChildChanged.listen((event) {
        _processPedido(event.snapshot, itemPedidos, idBar, productService, isUpdate: true);
      });
    }
  }

  Future<void> _processPedido(
    DataSnapshot snapshot,
    List<Pedido> itemPedidos,
    String idBar,
    ProductsService productService, {
    bool isUpdate = false,
  }) async {
    try {
      final data = snapshot.value;
      if (data == null || data is! Map) return;

      final dataMesas = Map<String, dynamic>.from(data);
      final idProd = dataMesas['idProducto'] as String?;
      if (idProd == null) return;

      final envio = await obtenerEnvioPorProducto(productService, idProd);
      if (envio != 'cocina') return;

      _handleDataChange(itemPedidos, idBar, dataMesas, snapshot.key, envio ?? 'error', isUpdate);
    } catch (e) {
      listenerBloc?.add(ListenerEvent.errorOccurred(e.toString()));
    }
  }

  void _handleDataChange(
    List<Pedido> itemPedidos,
    String idBar,
    Map<String, dynamic> dataMesas,
    String? pedidoId,
    String envio,
    bool isUpdate,
  ) {
    try {
      final nuevoPedido = Pedido(
        cantidad: dataMesas['cantidad'],
        fecha: dataMesas['fecha'],
        hora: dataMesas['hora'],
        mesa: dataMesas['mesa'].toString(),
        numPedido: dataMesas['numPedido'] as int,
        nota: dataMesas['nota'],
        estadoLinea: dataMesas['estado_linea'],
        idProducto: dataMesas['idProducto'],
        enMarcha: false,
        racion: dataMesas['racion'],
        modifiers: (dataMesas['modifiers'] as List?)
                ?.map((modifier) => Modifier(
                      name: modifier['name'] ?? '',
                      increment: (modifier['increment'] ?? 0).toDouble(),
                      mainProduct: modifier['mainProduct'] ?? '',
                    ))
                .toList() ??
            [],
        envio: envio,
        id: dataMesas['id'],
      );

      if (isUpdate) {
        itemPedidos.removeWhere((pedido) => pedido.id == pedidoId);
      }

      itemPedidos.add(nuevoPedido);

      if (dataMesas['estado_linea'] == EstadoPedido.pendiente.name) {
        timbre();
      } else if (dataMesas['estado_linea'] == EstadoPedido.cocinado.name || dataMesas['estado_linea'] == EstadoPedido.bloqueado.name) {
        itemPedidos.removeWhere((pedido) => pedido.id == pedidoId);
      }

      listenerBloc?.add(ListenerEvent.pedidosUpdated(itemPedidos));
    } catch (e) {
      listenerBloc?.add(ListenerEvent.errorOccurred(e.toString()));
    }
  }

  @override
  Future<void> removePedidos() async {
    final List<Pedido> itemPedidos = productService.pedidosRealizados;
    final salasMesa = productService.salasMesa;

    for (var sala in salasMesa) {
      _dataStreamRemovedPedidos = database.ref('gestion_pedidos/$idBar/${sala.mesa}').onChildRemoved.listen((event) {
        try {
          String? pedidoId = event.snapshot.key;
          if (pedidoId == null) return;

          itemPedidos.removeWhere((pedido) => pedido.id == pedidoId);
          listenerBloc?.add(ListenerEvent.pedidosUpdated(itemPedidos));
        } catch (e) {
          listenerBloc?.add(ListenerEvent.errorOccurred(e.toString()));
        }
      });
    }
  }

  @override
  void dispose() {
    _dataStreamProductos?.cancel();
    _dataStreamCategoria?.cancel();
    _dataStreamGestionPedidos?.cancel();
    _dataStreamRemovedPedidos?.cancel();
  }
}
