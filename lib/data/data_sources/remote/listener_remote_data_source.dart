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
import 'package:qribar_cocina/shared/utils/event_stream_manager.dart';
import 'package:qribar_cocina/shared/utils/product_utils.dart';

/// A final class that implements [ListenersRemoteDataSourceContract].
///
/// This class is responsible for listening to real-time data changes
/// from Firebase Realtime Database for products, categories, and orders.
/// It processes these changes and emits [ListenerEvent]s through its stream.
///
final class ListenersRemoteDataSource
    implements ListenersRemoteDataSourceContract {
  ListenersRemoteDataSource({required FirebaseDatabase database})
    : _database = database;

  final FirebaseDatabase _database;

  String get _idBar {
    if (!IdBarDataSource.instance.hasIdBar) {
      throw StateError('idBar no inicializado en ListenersRemoteDataSource');
    }
    return IdBarDataSource.instance.idBar;
  }

  // 🔸 Event Controller
  final StreamController<ListenerEvent> _eventController =
      StreamController.broadcast();

  @override
  Stream<ListenerEvent> get eventsStream => _eventController.stream;

  // 🔸 Firebase Subscriptions
  final Map<String, StreamSubscription> _dataStreamProductosMap = {};
  final Map<String, StreamSubscription> _dataStreamCategoriasMap = {};
  final Map<String, StreamSubscription> _dataStreamGestionPedidosMap = {};
  final Map<String, StreamSubscription> _dataStreamRemovedPedidosMap = {};

  // 🔸 Local Data
  final List<SalaEstado> salasMesa = [];
  final List<CategoriaProducto> categorias = [];
  List<Product> products = [];
  List<Pedido> pedidos = [];

  @override
  Future<Result<void>> addProduct() async {
    // 1️⃣
    await cancelAndClearListeners(_dataStreamProductosMap);

    try {
      final ref = _database.ref('productos/$_idBar/');

      // 2️⃣
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

      // 3️⃣
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

      // 4️⃣
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
  Future<Result<void>> addCategoriaMenu() async {
    // 1️⃣
    await cancelAndClearListeners(_dataStreamCategoriasMap);

    try {
      final ref = _database.ref('ficha_local/$_idBar/categoria_productos');

      // 2️⃣
      final DataSnapshot initialSnapshot = await ref.get();
      if (initialSnapshot.exists && initialSnapshot.value is Map) {
        final Map<dynamic, dynamic> rawCategories =
            initialSnapshot.value as Map<dynamic, dynamic>;
        rawCategories.forEach((key, value) {
          try {
            if (value is Map) {
              final CategoriaProducto category = _parseCategoria(key, value);
              categorias.add(category);
            }
          } catch (e, stackTrace) {
            _logError(e, stackTrace, 'Error al parsear categoría existente');
          }
        });

        _eventController.add(ListenerEvent.categorias(List.from(categorias)));
      }

      // 3️⃣
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
      // 4️⃣
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

  @override
  Future<Result<void>> addSalaMesas() async {
    try {
      // 1️⃣
      final ref = _database.ref('gestion_local/$_idBar/');
      final snapshot = await ref.get();

      // 2️⃣
      if (!snapshot.exists) {
        salasMesa.clear();
        log('✅ [addSalaMesas] No se encontraron salas, limpiando cache.');
      } else {
        // 3️⃣
        final raw = snapshot.value;
        if (raw is! Map) {
          throw Exception('⚠️ Formato inesperado o nulo al leer salas: $raw');
        }

        // 4️⃣
        final data = Map<String, dynamic>.from(raw);
        salasMesa.clear();

        data.forEach((key, value) {
          if (value is! Map) {
            log('⚠️ [addSalaMesas] Elemento inválido para la mesa: $key');
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

        log(
          '✅ [addSalaMesas] Salas actualizadas correctamente: ${salasMesa.length} mesas procesadas.',
        );
      }

      // ✅
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
    // 1️⃣
    await cancelAndClearListeners(_dataStreamGestionPedidosMap);

    try {
      // 2️⃣
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
              log(
                '✅ [addAndChangedPedidos] Pedido añadido: ${event.snapshot.key}',
              );
            } catch (e) {
              final netErr = NetworkError.fromException(e);
              final repoErr = RepositoryError.fromDataSourceError(netErr);
              log(
                '❌ [addAndChangedPedidos] Error al procesar pedido añadido: $repoErr',
              );
            }
          },
          onError: (err) {
            final netErr = NetworkError.fromException(err);
            final repoErr = RepositoryError.fromDataSourceError(netErr);
            log('❌ [addAndChangedPedidos] Error en onChildAdded: $repoErr');
          },
        );

        // 4️⃣ onChildChanged
        final changedSub = ref.onChildChanged.listen(
          (event) {
            try {
              _processPedido(event.snapshot, isUpdate: true);
              log(
                '✅ [addAndChangedPedidos] Pedido actualizado: ${event.snapshot.key}',
              );
            } catch (e) {
              final netErr = NetworkError.fromException(e);
              final repoErr = RepositoryError.fromDataSourceError(netErr);
              log(
                '❌ [addAndChangedPedidos] Error al procesar pedido actualizado: $repoErr',
              );
            }
          },
          onError: (err) {
            final netErr = NetworkError.fromException(err);
            final repoErr = RepositoryError.fromDataSourceError(netErr);
            log('❌ [addAndChangedPedidos] Error en onChildChanged: $repoErr');
          },
        );

        // 5️⃣
        _dataStreamGestionPedidosMap['$mesaId-added'] = addedSub;
        _dataStreamGestionPedidosMap['$mesaId-changed'] = changedSub;
        log('✅ [addAndChangedPedidos] Listeners creados para mesa $mesaId');
      }

      // 6️⃣
      log(
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

  @override
  Future<Result<void>> removePedidos() async {
    // 1️⃣
    await cancelAndClearListeners(_dataStreamRemovedPedidosMap);

    try {
      // 2️⃣
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

            pedidos.removeWhere((p) => p.id == pedidoId);
            _eventController.add(ListenerEvent.pedidos(List.from(pedidos)));
          },
          onError: (err) {
            final netErr = NetworkError.fromException(err);
            final repoErr = RepositoryError.fromDataSourceError(netErr);
            log('❌ Error en removePedidos: $repoErr');
          },
        );

        // 4️⃣
        _dataStreamRemovedPedidosMap[mesaId] = sub;
      }

      // 5️⃣
      return const Result.success(null);
    } catch (e) {
      // 6️⃣
      return Result.failure(
        error: RepositoryError.fromDataSourceError(
          NetworkError.fromException(e),
        ),
      );
    }
  }

  @override
  Future<void> dispose() async {
    await cancelAndClearListeners(_dataStreamProductosMap);
    await cancelAndClearListeners(_dataStreamCategoriasMap);
    await cancelAndClearListeners(_dataStreamGestionPedidosMap);
    await cancelAndClearListeners(_dataStreamRemovedPedidosMap);

    await _eventController.close();
  }

  // 🔸 Helper Methods

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

  /// 🔁 onChildAdded y onChildChanged
  void _handleProductoEvent(DatabaseEvent event, {required bool isChanged}) {
    final snap = event.snapshot;
    final raw = snap.value;

    if (raw is! Map<dynamic, dynamic>) {
      log('⚠️ Formato inesperado o nulo en snapshot: $raw');
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
    _eventController.add(ListenerEvent.productos(List.from(products)));
  }

  void _handleProductoRemoved(DatabaseEvent event) {
    final key = event.snapshot.key;
    if (key != null) {
      products.removeWhere((p) => p.id == key);
      _eventController.add(ListenerEvent.productos(List.from(products)));
    }
  }

  void _handleProductoError(Object error, String listenerType) {
    log('Error en listener de productos ($listenerType): $error');
    _eventController.addError(error);
  }

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

  void _handleCategoriaEvent(DatabaseEvent event, {required bool isChanged}) {
    final snap = event.snapshot;
    final raw = snap.value;

    if (raw is! Map<dynamic, dynamic>) {
      log('⚠️ Formato inesperado o nulo en snapshot de categoría: $raw');
      return;
    }

    final String key = snap.key!;
    final CategoriaProducto newCategory = _parseCategoria(key, raw);

    final int index = categorias.indexWhere((c) => c.id == key);

    if (index == -1) {
      if (!isChanged) {
        categorias.add(newCategory);
      }
    } else if (isChanged) {
      categorias[index] = newCategory;
    }

    categorias.sort((a, b) => a.orden.compareTo(b.orden));

    _eventController.add(ListenerEvent.categorias(List.from(categorias)));
    log(
      '✅ Categoría ${isChanged ? 'actualizada' : 'añadida'}: ${newCategory.categoria}',
    );
  }

  void _handleCategoriaRemoved(DatabaseEvent event) {
    final String? key = event.snapshot.key;
    if (key != null) {
      categorias.removeWhere((c) => c.id == key);
      categorias.sort((a, b) => a.orden.compareTo(b.orden));

      _eventController.add(ListenerEvent.categorias(List.from(categorias)));
      log('🗑️ Categoría eliminada: $key');
    }
  }

  void _logError(Object error, StackTrace stackTrace, String message) {
    final repoErr = RepositoryError.fromDataSourceError(
      NetworkError.fromException(error),
    );
    log('❌ [Categorias] $message: $repoErr');
    log('$message error:', error: error, stackTrace: stackTrace);
    _eventController.addError(repoErr);
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
        log('❌ [processPedido] Error de datos: $repoErr');
        return;
      }

      final dataMesas = Map<String, dynamic>.from(raw);
      final idProd = dataMesas['idProducto'] as String?;
      if (idProd == null) return;

      final maybeEnvio = await obtenerEnvioPorProducto(
        categorias,
        idProd,
        products,
      );

      if (maybeEnvio == null) {
        log('⚠️ [processPedido] Envío no encontrado para producto $idProd');
        return;
      }

      final result = await _handleDataChange(
        dataMesas,
        snapshot.key,
        maybeEnvio,
        isUpdate,
      );

      if (result.maybeWhen(failure: (_) => true, orElse: () => false)) {
        log('❌ [processPedido] Error en _handleDataChange: $result');
      }
    } catch (e) {
      final netErr = NetworkError.fromException(e);
      final repoErr = RepositoryError.fromDataSourceError(netErr);
      log('❌ [processPedido] Excepción al procesar el pedido: $repoErr');
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
        pedidos.removeWhere((pedido) => pedido.id == id);
      }

      if (estado == EstadoPedidoEnum.cocinado.name ||
          estado == EstadoPedidoEnum.bloqueado.name) {
        pedidos.removeWhere((pedido) => pedido.id == id);
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

        pedidos.add(nuevoPedido);

        if (estado == EstadoPedidoEnum.pendiente.name) {
          reproducirTimbre();
        }
      }

      _eventController.add(ListenerEvent.pedidos(List.from(pedidos)));

      return const Result.success(null);
    } catch (error) {
      return Result.failure(
        error: RepositoryError.fromDataSourceError(
          NetworkError.fromException(error),
        ),
      );
    }
  }
}
