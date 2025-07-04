import 'dart:async';
import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:qribar_cocina/app/enums/estado_pedido_enum.dart';
import 'package:qribar_cocina/app/types/errors/network_error.dart';
import 'package:qribar_cocina/app/types/repository_error.dart';
import 'package:qribar_cocina/app/types/result.dart';
import 'package:qribar_cocina/data/data_sources/local/id_bar_data_source.dart';
import 'package:qribar_cocina/data/data_sources/remote/listeners_remote_data_source_contract.dart';
import 'package:qribar_cocina/data/models/categoria_producto.dart';
import 'package:qribar_cocina/data/models/complementos/complementos.dart';
import 'package:qribar_cocina/data/models/modifier/modifier.dart';
import 'package:qribar_cocina/data/models/pedido/pedido.dart';
import 'package:qribar_cocina/data/models/product.dart';
import 'package:qribar_cocina/data/models/sala_estado.dart';
import 'package:qribar_cocina/features/app/bloc/listener_bloc.dart';
import 'package:qribar_cocina/shared/utils/audio_helpers.dart';
import 'package:qribar_cocina/shared/utils/product_utils.dart';

class ListenersRemoteDataSource implements ListenersRemoteDataSourceContract {
  ListenersRemoteDataSource({required FirebaseDatabase database})
    : _database = database;

  final FirebaseDatabase _database;

  String get _idBar {
    if (!IdBarDataSource.instance.hasIdBar) {
      throw StateError('idBar no inicializado en ListenersRemoteDataSource');
    }
    return IdBarDataSource.instance.idBar;
  }

  // 🔸 Controlador de eventos
  final StreamController<ListenerEvent> _eventController =
      StreamController.broadcast();
  Stream<ListenerEvent> get eventsStream => _eventController.stream;

  // 🔸 Subscripciones Firebase
  final Map<String, StreamSubscription> _dataStreamProductosMap = {};
  final Map<String, StreamSubscription> _dataStreamCategoriasMap = {};

  final Map<String, StreamSubscription> _dataStreamGestionPedidosMap = {};
  final Map<String, StreamSubscription> _dataStreamRemovedPedidosMap = {};

  // 🔸 Estado interno (cache local)
  final List<SalaEstado> salasMesa = [];
  final List<CategoriaProducto> categoriasProdLocal = [];
  List<Product> products = [];
  List<Pedido> itemPedidos = [];

  @override
  Future<Result<void>> addProduct() async {
    // 1️⃣ Cancel previous subscriptions and clear them
    for (var sub in _dataStreamProductosMap.values) {
      try {
        await sub.cancel();
      } catch (_) {}
    }
    _dataStreamProductosMap.clear();

    try {
      final ref = _database.ref('productos/$_idBar/');

      // 2️⃣ Obtener todos los datos iniciales primero
      final DataSnapshot initialSnapshot = await ref.get();
      if (initialSnapshot.value != null) {
        final Map<dynamic, dynamic> rawData =
            initialSnapshot.value as Map<dynamic, dynamic>;
        final List<Product> initialProducts = [];
        rawData.forEach((key, value) {
          if (value is Map<dynamic, dynamic>) {
            final data = Map<String, dynamic>.from(value);
            final product = _parseProduct(key, data);
            initialProducts.add(product);
          }
        });
        products = initialProducts;
        _eventController.add(ListenerEvent.productos(products));
      }

      // 3️⃣ Luego, configurar los listeners para cambios futuros
      final String baseKey = _idBar;

      _dataStreamProductosMap['$baseKey-added'] = ref.onChildAdded.listen(
        (event) => _handleProductoEvent(event, isChanged: false),
        onError: (err) => _handleProductoError(err, 'onChildAdded'),
      );

      _dataStreamProductosMap['$baseKey-changed'] = ref.onChildChanged.listen(
        (event) => _handleProductoEvent(event, isChanged: true),
        onError: (err) => _handleProductoError(err, 'onChildChanged'),
      );

      _dataStreamProductosMap['$baseKey-removed'] = ref.onChildRemoved.listen(
        (event) => _handleProductoRemoved(event),
        onError: (err) => _handleProductoError(err, 'onChildRemoved'),
      );

      // 4️⃣ Éxito
      return const Result.success(null);
    } catch (error) {
      return Result.failure(
        error: RepositoryError.fromDataSourceError(
          NetworkError.fromException(error),
        ),
      );
    }
  }

  /// Helper to parse product data
  Product _parseProduct(String key, Map<String, dynamic> data) {
    return Product(
      id: key,
      alergogenos:
          (data['alergogenos'] as Map?)?.keys.cast<String>().toList() ?? [],
      categoriaProducto: data['categoria_producto'] ?? '',
      costeProducto: (data['coste_producto'] as num?)?.toDouble() ?? 0.0,
      disponible: data['disponible'] == true,
      descripcionProducto: data['descripcion_producto'] ?? '',
      fotoUrl: data['foto_url'] ?? '',
      nombreProducto: data['nombre_producto'] ?? '',
      precioProducto: (data['precio_producto'] as num?)?.toDouble() ?? 0.0,
      complementos:
          (data['complementos'] as Map?)?.entries
              .where((e) => e.value is Map)
              .map((e) {
                final m = Map<String, dynamic>.from(e.value as Map);
                return Complemento(
                  id: e.key,
                  activo: m['activo'] is bool ? m['activo'] : true,
                  incremento: m['incremento'] is bool ? m['incremento'] : false,
                );
              })
              .toList() ??
          [],
      modifiers:
          (data['modifiers'] as Map?)?.entries.map((e) {
            return Modifier(
              name: e.key,
              increment: (e.value is num) ? (e.value as num).toDouble() : 0.0,
              mainProduct: key,
            );
          }).toList() ??
          [],
    );
  }

  /// 🔁 Manejador común para onChildAdded y onChildChanged
  void _handleProductoEvent(DatabaseEvent event, {required bool isChanged}) {
    final snap = event.snapshot;
    final raw = snap.value;

    if (raw is! Map<dynamic, dynamic>) {
      print('⚠️ Formato inesperado o nulo en snapshot: $raw');
      return;
    }

    final data = Map<String, dynamic>.from(raw);
    final key = snap.key!;
    final producto = _parseProduct(key, data);

    final index = products.indexWhere((p) => p.id == producto.id);

    if (index == -1) {
      if (!isChanged) {
        products.add(producto);
      }
    } else if (isChanged) {
      products[index] = producto;
    }
    _eventController.add(ListenerEvent.productos(products));
  }

  void _handleProductoRemoved(DatabaseEvent event) {
    final key = event.snapshot.key;
    if (key != null) {
      products.removeWhere((p) => p.id == key);
      _eventController.add(ListenerEvent.productos(products));
    }
  }

  void _handleProductoError(Object error, String listenerType) {
    print('Error en listener de productos ($listenerType): $error');
    _eventController.addError(error); // Propagate error to stream
  }

  // --- CATEGORY LISTENERS ---
  @override
  Future<Result<void>> addCategoriaMenu() async {
    // 1️⃣ Consolidate previous listeners and ensure cleanup
    for (var sub in _dataStreamCategoriasMap.values) {
      try {
        await sub.cancel();
      } catch (_) {}
    }
    _dataStreamCategoriasMap.clear();

    try {
      final ref = _database.ref('ficha_local/$_idBar/categoria_productos');

      // 2️⃣ Get all existing categories first
      final DataSnapshot initialSnapshot = await ref.get();
      if (initialSnapshot.exists && initialSnapshot.value is Map) {
        final Map<dynamic, dynamic> rawCategories =
            initialSnapshot.value as Map<dynamic, dynamic>;
        rawCategories.forEach((key, value) {
          try {
            if (value is Map) {
              final CategoriaProducto category = _parseCategoria(key, value);
              categoriasProdLocal.add(category);
            }
          } catch (e, stackTrace) {
            _logError(e, stackTrace, 'Error al parsear categoría existente');
          }
        });
        // Emit the complete initial list of categories
        _eventController.add(
          ListenerEvent.categorias(List.from(categoriasProdLocal)),
        );
      }

      // 3️⃣ Set up listeners for future changes and assign them
      final String baseKey = _idBar;

      _dataStreamCategoriasMap['$baseKey-added'] = ref.onChildAdded.listen(
        (event) => _handleCategoriaEvent(event, isChanged: false),
        onError: (err, stackTrace) =>
            _logError(err, stackTrace, 'onChildAdded Categoría'),
      );

      _dataStreamCategoriasMap['$baseKey-changed'] = ref.onChildChanged.listen(
        (event) => _handleCategoriaEvent(event, isChanged: true),
        onError: (err, stackTrace) =>
            _logError(err, stackTrace, 'onChildChanged Categoría'),
      );

      _dataStreamCategoriasMap['$baseKey-removed'] = ref.onChildRemoved.listen(
        (event) => _handleCategoriaRemoved(event),
        onError: (err, stackTrace) =>
            _logError(err, stackTrace, 'onChildRemoved Categoría'),
      );

      return const Result.success(null);
    } catch (error, stackTrace) {
      _logError(error, stackTrace, 'Error al iniciar listener de categorías');
      return Result.failure(
        error: RepositoryError.fromDataSourceError(
          NetworkError.fromException(error),
        ),
      );
    }
  }

  // Helper method to parse CategoriaProducto
  CategoriaProducto _parseCategoria(String key, Map<dynamic, dynamic> rawData) {
    final m = Map<String, dynamic>.from(rawData);
    return CategoriaProducto(
      id: key,
      categoria: m['categoria'] ?? '',
      categoriaEn: m['categoria_en'] ?? '',
      categoriaDe: m['categoria_de'] ?? '',
      envio: m['envio'] ?? '',
      icono: m['icono'] ?? '',
      imgVertical: m['img_vertical'] as bool? ?? false,
      orden: (m['orden'] as num?)?.toInt() ?? 0,
    );
  }

  // Handle category added/changed events
  void _handleCategoriaEvent(DatabaseEvent event, {required bool isChanged}) {
    final snap = event.snapshot;
    final raw = snap.value;

    if (raw is! Map<dynamic, dynamic>) {
      print('⚠️ Formato inesperado o nulo en snapshot de categoría: $raw');
      return;
    }

    final String key = snap.key!;
    final CategoriaProducto newCategory = _parseCategoria(key, raw);

    final int index = categoriasProdLocal.indexWhere((c) => c.id == key);

    if (index == -1) {
      if (!isChanged) {
        categoriasProdLocal.add(newCategory);
      }
    } else if (isChanged) {
      categoriasProdLocal[index] = newCategory;
    }

    categoriasProdLocal.sort((a, b) => a.orden.compareTo(b.orden));

    _eventController.add(
      ListenerEvent.categorias(List.from(categoriasProdLocal)),
    );
    print(
      '✅ Categoría ${isChanged ? 'actualizada' : 'añadida'}: ${newCategory.categoria}',
    );
  }

  // Handle category removed events
  void _handleCategoriaRemoved(DatabaseEvent event) {
    final String? key = event.snapshot.key;
    if (key != null) {
      categoriasProdLocal.removeWhere((c) => c.id == key);
      categoriasProdLocal.sort((a, b) => a.orden.compareTo(b.orden));

      _eventController.add(
        ListenerEvent.categorias(List.from(categoriasProdLocal)),
      );
      print('🗑️ Categoría eliminada: $key');
    }
  }

  // Consolidated error logging
  void _logError(Object error, StackTrace stackTrace, String message) {
    final repoErr = RepositoryError.fromDataSourceError(
      NetworkError.fromException(error),
    );
    print('❌ [Categorias] $message: $repoErr');
    log('$message error:', error: error, stackTrace: stackTrace);
    _eventController.addError(repoErr);
  }

  @override
  Future<Result<void>> addSalaMesas() async {
    try {
      // 1️⃣ Obtenemos snapshot único de salas
      final ref = _database.ref('gestion_local/$_idBar/');
      final snapshot = await ref.get();

      // 2️⃣ Si no existe, limpiamos cache
      if (!snapshot.exists) {
        salasMesa.clear();
        print('✅ [addSalaMesas] No se encontraron salas, limpiando cache.');
      } else {
        // 3️⃣ Validación del formato del snapshot
        final raw = snapshot.value;
        if (raw is! Map) {
          throw Exception('⚠️ Formato inesperado o nulo al leer salas: $raw');
        }

        // 4️⃣ Parseo a Map<String, dynamic> y refresco del cache
        final data = Map<String, dynamic>.from(raw);
        salasMesa.clear();

        data.forEach((key, value) {
          if (value is! Map) {
            print('⚠️ [addSalaMesas] Elemento inválido para la mesa: $key');
            return;
          }

          final m = Map<String, dynamic>.from(value);
          salasMesa.add(
            SalaEstado(
              mesa: key,
              sala: m['sala'] as String? ?? '',
              estado: m['estado'] as String? ?? '',
              hora: m['hora'] as String? ?? '',
              horaUltimoPedido: m['horaUltimoPedido'] as String? ?? '',
              personas: m['personas'] as int? ?? 0,
              callCamarero: m['callCamarero'] as bool? ?? false,
              nombre: m['nombre'] as String? ?? '',
              positionMap: m['positionMap'],
              qrLink: m['qr_link'] as String? ?? '',
            ),
          );
        });

        print(
          '✅ [addSalaMesas] Salas actualizadas correctamente: ${salasMesa.length} mesas procesadas.',
        );
      }

      // ✅ Solo un return de éxito
      return const Result.success(null);
    } catch (error) {
      return Result.failure(
        error: RepositoryError.fromDataSourceError(
          NetworkError.fromException(error),
        ),
      );
    }
  }

  @override
  Future<Result<void>> addAndChangedPedidos() async {
    // 1️⃣ Cancelar suscripciones previas
    for (var sub in _dataStreamGestionPedidosMap.values) {
      try {
        await sub.cancel();
        print('✅ [addAndChangedPedidos] Suscripción cancelada correctamente.');
      } catch (_) {
        print('⚠️ [addAndChangedPedidos] Error al cancelar suscripción.');
      }
    }
    _dataStreamGestionPedidosMap.clear();

    try {
      // 2️⃣ Para cada sala, crear listeners de añadido y cambio
      for (final sala in salasMesa) {
        final mesaId = sala.mesa;
        if (mesaId == null || mesaId.isEmpty) continue;

        final path = 'gestion_pedidos/$_idBar/$mesaId';
        final ref = _database.ref(path);

        // 3️⃣ onChildAdded
        final addedSub = ref.onChildAdded.listen(
          (event) {
            try {
              _processPedido(event.snapshot);
              print(
                '✅ [addAndChangedPedidos] Pedido añadido: ${event.snapshot.key}',
              );
            } catch (e) {
              final netErr = NetworkError.fromException(e);
              final repoErr = RepositoryError.fromDataSourceError(netErr);
              print(
                '❌ [addAndChangedPedidos] Error al procesar pedido añadido: $repoErr',
              );
            }
          },
          onError: (err) {
            final netErr = NetworkError.fromException(err);
            final repoErr = RepositoryError.fromDataSourceError(netErr);
            print('❌ [addAndChangedPedidos] Error en onChildAdded: $repoErr');
          },
        );

        // 4️⃣ onChildChanged
        final changedSub = ref.onChildChanged.listen(
          (event) {
            try {
              _processPedido(event.snapshot, isUpdate: true);
              print(
                '✅ [addAndChangedPedidos] Pedido actualizado: ${event.snapshot.key}',
              );
            } catch (e) {
              final netErr = NetworkError.fromException(e);
              final repoErr = RepositoryError.fromDataSourceError(netErr);
              print(
                '❌ [addAndChangedPedidos] Error al procesar pedido actualizado: $repoErr',
              );
            }
          },
          onError: (err) {
            final netErr = NetworkError.fromException(err);
            final repoErr = RepositoryError.fromDataSourceError(netErr);
            print('❌ [addAndChangedPedidos] Error en onChildChanged: $repoErr');
          },
        );

        // 5️⃣ Guardar suscripciones
        _dataStreamGestionPedidosMap['$mesaId-added'] = addedSub;
        _dataStreamGestionPedidosMap['$mesaId-changed'] = changedSub;
        print('✅ [addAndChangedPedidos] Listeners creados para mesa $mesaId');
      }

      // 6️⃣ Todo bien → éxito
      print(
        '✅ [addAndChangedPedidos] Todos los listeners configurados correctamente.',
      );
      return const Result.success(null);
    } catch (error) {
      return Result.failure(
        error: RepositoryError.fromDataSourceError(
          NetworkError.fromException(error),
        ),
      );
    }
  }

  Future<void> _processPedido(
    DataSnapshot snapshot, {
    bool isUpdate = false,
  }) async {
    try {
      final raw = snapshot.value;
      if (raw == null || raw is! Map<dynamic, dynamic>) {
        final msg = '⚠️ Formato inesperado o nulo al procesar el pedido: $raw';
        final netErr = NetworkError.fromException(Exception(msg));
        final repoErr = RepositoryError.fromDataSourceError(netErr);
        print('❌ [processPedido] Error de datos: $repoErr');
        return;
      }

      final dataMesas = Map<String, dynamic>.from(raw);
      final idProd = dataMesas['idProducto'] as String?;
      if (idProd == null) return;

      final maybeEnvio = await obtenerEnvioPorProducto(
        categoriasProdLocal,
        idProd,
        products,
      );

      if (maybeEnvio == null) {
        print('⚠️ [processPedido] Envío no encontrado para producto $idProd');
        return;
      }

      final result = await _handleDataChange(
        dataMesas,
        snapshot.key,
        maybeEnvio,
        isUpdate,
      );

      if (result.maybeWhen(failure: (_) => true, orElse: () => false)) {
        print('❌ [processPedido] Error en _handleDataChange: $result');
      }
    } catch (e) {
      final netErr = NetworkError.fromException(e);
      final repoErr = RepositoryError.fromDataSourceError(netErr);
      print('❌ [processPedido] Excepción al procesar el pedido: $repoErr');
    }
  }

  Future<Result<void>> _handleDataChange(
    Map<String, dynamic> dataMesas,
    String? pedidoId,
    String envio,
    bool isUpdate,
  ) async {
    try {
      final estado = dataMesas['estado_linea'] as String? ?? '';
      final id = pedidoId ?? '';
      final titulo = obtenerNombreProducto(
        products,
        dataMesas['idProducto'],
        dataMesas['racion'] ?? true,
      );

      if (isUpdate) {
        itemPedidos.removeWhere((pedido) => pedido.id == id);
      }

      if (estado == EstadoPedidoEnum.cocinado.name ||
          estado == EstadoPedidoEnum.bloqueado.name) {
        itemPedidos.removeWhere((pedido) => pedido.id == id);
      } else {
        final nuevoPedido = Pedido(
          cantidad: dataMesas['cantidad'] as int? ?? 0,
          fecha: dataMesas['fecha'] as String? ?? '',
          hora: dataMesas['hora'] as String? ?? '',
          mesa: dataMesas['mesa'].toString(),
          numPedido: dataMesas['numPedido'] as int? ?? 0,
          nota: dataMesas['nota'] as String? ?? '',
          estadoLinea: estado,
          idProducto: dataMesas['idProducto'] as String? ?? '',
          titulo: titulo,
          enMarcha: dataMesas['en_marcha'] as bool? ?? false,
          racion: dataMesas['racion'] as bool? ?? true,
          modifiers:
              (dataMesas['modifiers'] as List?)?.map((modifier) {
                final m = Map<String, dynamic>.from(modifier as Map);
                return Modifier(
                  name: m['name'] ?? '',
                  increment: (m['increment'] as num?)?.toDouble() ?? 0.0,
                  mainProduct: m['mainProduct'] ?? '',
                );
              }).toList() ??
              <Modifier>[],
          envio: envio,
          id: id,
        );

        itemPedidos.add(nuevoPedido);

        if (estado == EstadoPedidoEnum.pendiente.name) {
          reproducirTimbre();
        }
      }

      _eventController.add(ListenerEvent.pedidos(List.from(itemPedidos)));

      return const Result.success(null);
    } catch (error) {
      return Result.failure(
        error: RepositoryError.fromDataSourceError(
          NetworkError.fromException(error),
        ),
      );
    }
  }

  @override
  Future<Result<void>> removePedidos() async {
    // 1️⃣ Cancelamos suscripciones previas de removals
    for (var sub in _dataStreamRemovedPedidosMap.values) {
      try {
        await sub.cancel();
      } catch (_) {}
    }
    _dataStreamRemovedPedidosMap.clear();

    try {
      // 2️⃣ Creamos nueva suscripción para cada sala
      for (final sala in salasMesa) {
        final mesaId = sala.mesa;
        if (mesaId == null || mesaId.isEmpty) continue;

        final path = 'gestion_pedidos/$_idBar/$mesaId';
        final ref = _database.ref(path);

        // 3️⃣ onChildRemoved
        final sub = ref.onChildRemoved.listen(
          (event) {
            final pedidoId = event.snapshot.key;
            if (pedidoId == null) return;

            itemPedidos.removeWhere((p) => p.id == pedidoId);
            _eventController.add(ListenerEvent.pedidos(itemPedidos));
          },
          onError: (err) {
            final netErr = NetworkError.fromException(err);
            final repoErr = RepositoryError.fromDataSourceError(netErr);
            print('❌ Error en removePedidos: $repoErr');
          },
        );

        // 4️⃣ Guardamos la suscripción
        _dataStreamRemovedPedidosMap[mesaId] = sub;
      }

      // 5️⃣ Éxito
      return const Result.success(null);
    } catch (e) {
      // 6️⃣ Error al crear las suscripciones
      return Result.failure(
        error: RepositoryError.fromDataSourceError(
          NetworkError.fromException(e),
        ),
      );
    }
  }

  @override
  Future<void> dispose() async {
    for (final subscription in _dataStreamProductosMap.values) {
      await subscription.cancel();
    }
    _dataStreamProductosMap.clear();

    for (final subscription in _dataStreamCategoriasMap.values) {
      await subscription.cancel();
    }
    _dataStreamCategoriasMap.clear();

    for (final subscription in _dataStreamGestionPedidosMap.values) {
      await subscription.cancel();
    }
    _dataStreamGestionPedidosMap.clear();

    for (final subscription in _dataStreamRemovedPedidosMap.values) {
      await subscription.cancel();
    }
    _dataStreamRemovedPedidosMap.clear();

    await _eventController.close();
  }
}
