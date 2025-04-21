import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:qribar_cocina/data/data_sources/local/id_bar_data_source.dart';
import 'package:qribar_cocina/data/data_sources/remote/listeners_data_source_contract.dart';
import 'package:qribar_cocina/data/enums/estado_pedido.dart';
import 'package:qribar_cocina/data/models/categoria_producto.dart';
import 'package:qribar_cocina/data/models/complementos/complementos.dart';
import 'package:qribar_cocina/data/models/modifier/modifier.dart';
import 'package:qribar_cocina/data/models/pedido/pedido.dart';
import 'package:qribar_cocina/data/models/product.dart';
import 'package:qribar_cocina/data/models/sala_estado.dart';
import 'package:qribar_cocina/providers/bloc/listener_bloc.dart';
import 'package:qribar_cocina/providers/navegacion_provider.dart';
import 'package:qribar_cocina/services/functions.dart';

class ListenersDataSourceImpl implements ListenersDataSourceContract {
  // 🔸 Propiedades obligatorias por constructor
  final FirebaseDatabase database;
  final NavegacionProvider navProvider;

  // 🔸 Constructor
  ListenersDataSourceImpl({
    required this.database,
    required this.navProvider,
  });

  // 🔸 Controlador de eventos
  final StreamController<ListenerEvent> _eventController = StreamController.broadcast();
  Stream<ListenerEvent> get eventsStream => _eventController.stream;

  // 🔸 Subscripciones Firebase
  StreamSubscription? _dataStreamProductos;
  StreamSubscription? _dataStreamCategoria;

  final Map<String, StreamSubscription> _dataStreamGestionPedidosMap = {};
  final Map<String, StreamSubscription> _dataStreamRemovedPedidosMap = {};

  // 🔸 Estado interno (cache local)
  final List<CategoriaProducto> categoriasProdLocal = [];
  final List<SalaEstado> salasMesa = [];
  List<Product> product = [];
  List<Pedido> itemPedidos = [];

  String get idBar => IdBarDataSource.instance.getIdBar();

  @override
  Future<void> addProduct() async {
    try {
      _dataStreamProductos = database.ref('productos/$idBar/').onChildAdded.listen(
        (event) {
          final snapshot = event.snapshot;
          final value = snapshot.value;

          if (value is! Map<dynamic, dynamic>) {
            _eventController.add(ListenerEvent.errorOccurred('Formato de datos inesperado o valor nulo: $value'));
            return;
          }

          final data = Map<String, dynamic>.from(value);
          final String key = snapshot.key ?? '';

          // Extraer complementos
          final List<Complemento> listaComplements = (data["complementos"] as Map<dynamic, dynamic>?)?.entries.where((e) => e.value is Map).map((e) {
                final complemento = Map<String, dynamic>.from(e.value);
                return Complemento(
                  activo: complemento["activo"] is bool ? complemento["activo"] : true,
                  incremento: complemento["incremento"] is bool ? complemento["incremento"] : false,
                  id: e.key,
                );
              }).toList() ??
              [];

          // Extraer alérgenos
          final List<String> alergias = (data["alergogenos"] as Map<dynamic, dynamic>?)?.keys.whereType<String>().toList() ?? [];

          // Extraer modificadores
          final List<Modifier> modifiers = (data["modifiers"] as Map<dynamic, dynamic>?)
                  ?.entries
                  .map((e) => Modifier(
                        name: e.key,
                        increment: (e.value is num) ? (e.value as num).toDouble() : 0.0,
                        mainProduct: key,
                      ))
                  .toList() ??
              [];

          // Construir producto
          final producto = Product(
            id: key,
            alergogenos: alergias,
            categoriaProducto: data["categoria_producto"] ?? '',
            costeProducto: (data["coste_producto"] as num?)?.toDouble() ?? 0.0,
            disponible: data["disponible"] == true,
            descripcionProducto: data["descripcion_producto"] ?? '',
            descripcionProductoEn: data["descripcion_producto_en"] ?? '',
            descripcionProductoDe: data["descripcion_producto_de"] ?? '',
            fotoUrl: data["foto_url"] ?? '',
            fotoUrlVideo: data["foto_url_video"] ?? '',
            nombreProductoOriginal: data["nombre_producto"] ?? '',
            nombreProducto: data["nombre_producto"] ?? '',
            nombreProductoEn: data["nombre_producto_en"],
            nombreProductoDe: data["nombre_producto_de"],
            nombreRacion: data["nombre_racion"] ?? 'Ración',
            nombreRacionMedia: data["nombre_racion_media"] ?? 'Media Ración',
            nombreRacionEn: data["nombre_racion_en"] ?? '',
            nombreRacionMediaEn: data["nombre_racion_media_en"] ?? '',
            nombreRacionDe: data["nombre_racion_de"] ?? '',
            nombreRacionMediaDe: data["nombre_racion_media_de"] ?? '',
            precioProducto: (data["precio_producto"] as num?)?.toDouble() ?? 0.0,
            precioProducto2: (data["precio_producto2"] as num?)?.toDouble() ?? 0.0,
            complementos: listaComplements,
            modifiers: modifiers,
          );

          // Evitar duplicados
          if (!product.any((p) => p.id == producto.id)) {
            product.add(producto);
            navProvider.products.add(producto);
          }
        },
        onError: (error) {
          _eventController.add(ListenerEvent.errorOccurred(error.toString()));
        },
      );
    } catch (e) {
      _eventController.add(ListenerEvent.errorOccurred(e.toString()));
    }
  }

  @override
  Future<void> addCategoriaMenu() async {
    try {
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
        categoriasProdLocal.add(nuevaCategoria);
      });
    } on Exception catch (e) {
      _eventController.add(ListenerEvent.errorOccurred(e.toString()));
    }
  }

  @override
  Future<void> changeCategoriaMenu() async {
    try {
      _dataStreamCategoria = database.ref('ficha_local/$idBar/categoria_productos').onChildChanged.listen((event) {
        final dataMesas = Map<String, dynamic>.from(event.snapshot.value as Map);

        CategoriaProducto producto = categoriasProdLocal.firstWhere((producto) => producto.id == event.snapshot.key, orElse: () => CategoriaProducto(categoria: ''));
        producto.categoria = dataMesas['categoria'];
        producto.categoriaEn = dataMesas['categoria_en'];
        producto.categoriaDe = dataMesas['categoria_de'];
        producto.envio = dataMesas['envio'];
        producto.icono = dataMesas['nombreIcon'];
        producto.orden = dataMesas['orden'];
        producto.icono = dataMesas['icono'];
        producto.imgVertical = dataMesas['img_vertical'];
      });
    } on Exception catch (e) {
      _eventController.add(ListenerEvent.errorOccurred(e.toString()));
    }
  }

  @override
  Future<void> addSalaMesas() async {
    try {
      DatabaseReference _dataStreamProd = database.ref('gestion_local/$idBar/');
      final prodSnapshot = await _dataStreamProd.get();

      if (!prodSnapshot.exists) return;

      final prodData = Map<dynamic, dynamic>.from(prodSnapshot.value as Map);

      salasMesa.clear();
      prodData.forEach((k, v) {
        salasMesa.add(SalaEstado(
          mesa: k,
          sala: v['sala'],
          estado: v['estado'],
          hora: v['hora'],
          horaUltimoPedido: v['horaUltimoPedido'],
          personas: v['personas'] ?? 0,
          callCamarero: v['callCamarero'],
          nombre: v['nombre'] ?? '',
          positionMap: v['positionMap'],
          qrLink: v['qr_link'] ?? '',
        ));
      });
    } catch (e) {
      _eventController.add(ListenerEvent.errorOccurred(e.toString()));
      return;
    }
  }

  @override
  Future<void> addAndChangedPedidos() async {
    for (var salas in salasMesa) {
      final String? mesaId = salas.mesa;
      if (mesaId == null) continue;

      // Verificar si ya existe una suscripción para esta mesa
      if (_dataStreamGestionPedidosMap.containsKey(mesaId)) {
        continue;
      }

      final path = 'gestion_pedidos/$idBar/$mesaId';

      // Crear y almacenar la suscripción para onChildAdded
      final addedSubscription = database.ref(path).onChildAdded.listen((event) {
        _processPedido(event.snapshot);
      });

      // Crear y almacenar la suscripción para onChildChanged
      final changedSubscription = database.ref(path).onChildChanged.listen((event) {
        _processPedido(event.snapshot, isUpdate: true);
      });

      // Almacenar ambas suscripciones en el mapa
      _dataStreamGestionPedidosMap['$mesaId-added'] = addedSubscription;
      _dataStreamGestionPedidosMap['$mesaId-changed'] = changedSubscription;
    }
  }

  Future<void> _processPedido(
    DataSnapshot snapshot, {
    bool isUpdate = false,
  }) async {
    try {
      final data = snapshot.value;
      if (data == null || data is! Map) return;

      final dataMesas = Map<String, dynamic>.from(data);
      final idProd = dataMesas['idProducto'] as String?;
      if (idProd == null) return;

      final envio = await obtenerEnvioPorProducto(categoriasProdLocal, idProd, product);
      if (envio != 'cocina') return;

      _handleDataChange(dataMesas, snapshot.key, envio ?? 'error', isUpdate);
    } catch (e) {
      _eventController.add(ListenerEvent.errorOccurred(e.toString()));
    }
  }

  void _handleDataChange(
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
        enMarcha: dataMesas['en_marcha'] ?? false,
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
      _eventController.add(ListenerEvent.pedidosUpdated(List.from(itemPedidos)));
    } catch (e) {
      _eventController.add(ListenerEvent.errorOccurred(e.toString()));
    }
  }

  @override
  Future<void> removePedidos() async {
    for (var sala in salasMesa) {
      final String? mesaId = sala.mesa;
      if (mesaId == null) continue;

      // Verificar si ya existe una suscripción para esta mesa
      if (_dataStreamRemovedPedidosMap.containsKey(mesaId)) {
        continue;
      }

      final subscription = database.ref('gestion_pedidos/$idBar/$mesaId').onChildRemoved.listen((event) {
        try {
          String? pedidoId = event.snapshot.key;
          if (pedidoId == null) return;

          itemPedidos.removeWhere((pedido) => pedido.id == pedidoId);
          _eventController.add(ListenerEvent.pedidoRemoved(List.from(itemPedidos)));
        } catch (e) {
          _eventController.add(ListenerEvent.errorOccurred(e.toString()));
        }
      });

      // Almacenar la suscripción en el mapa
      _dataStreamRemovedPedidosMap[mesaId] = subscription;
    }
  }

  @override
  void dispose() {
    _dataStreamProductos?.cancel();
    _dataStreamCategoria?.cancel();

    // Cancelar todas las suscripciones almacenadas en el mapa por Mesa
    //Pedidos Realizados
    for (final subscription in _dataStreamGestionPedidosMap.values) {
      subscription.cancel();
    }

    for (final subscription in _dataStreamRemovedPedidosMap.values) {
      subscription.cancel();
    }
    //
    _dataStreamGestionPedidosMap.clear();
    _dataStreamRemovedPedidosMap.clear();
    _eventController.close();
  }
}
