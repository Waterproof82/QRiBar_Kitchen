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
import 'package:qribar_cocina/data/types/errors/network_error.dart';
import 'package:qribar_cocina/data/types/repository_error.dart';
import 'package:qribar_cocina/data/types/result.dart';
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
  Future<Result<void>> addProduct() async {
    // 1️⃣ Cancelamos la suscripción previa (si existe)
    await _dataStreamProductos?.cancel();
    _dataStreamProductos = null;

    try {
      // 2️⃣ Nos suscribimos de nuevo
      _dataStreamProductos = database.ref('productos/$idBar/').onChildAdded.listen(
        (event) {
          final snap = event.snapshot;
          final raw = snap.value;

          // 3️⃣ Validación del formato
          if (raw is! Map<dynamic, dynamic>) {
            final msg = '⚠️ Formato inesperado o nulo en snapshot: $raw';
            print(msg); // Puedes usar logger aquí si prefieres
            return;
          }

          // 4️⃣ Parseo modelo Product
          final data = Map<String, dynamic>.from(raw);
          final key = snap.key!;

          final producto = Product(
            id: key,
            alergogenos: (data['alergogenos'] as Map?)?.keys.cast<String>().toList() ?? [],
            categoriaProducto: data['categoria_producto'] ?? '',
            costeProducto: (data['coste_producto'] as num?)?.toDouble() ?? 0.0,
            disponible: data['disponible'] == true,
            descripcionProducto: data['descripcion_producto'] ?? '',
            fotoUrl: data['foto_url'] ?? '',
            nombreProducto: data['nombre_producto'] ?? '',
            precioProducto: (data['precio_producto'] as num?)?.toDouble() ?? 0.0,
            complementos: (data['complementos'] as Map?)?.entries.where((e) => e.value is Map).map((e) {
                  final m = Map<String, dynamic>.from(e.value as Map);
                  return Complemento(
                    id: e.key,
                    activo: m['activo'] is bool ? m['activo'] : true,
                    incremento: m['incremento'] is bool ? m['incremento'] : false,
                  );
                }).toList() ??
                [],
            modifiers: (data['modifiers'] as Map?)?.entries.map((e) {
                  return Modifier(
                    name: e.key,
                    increment: (e.value is num) ? (e.value as num).toDouble() : 0.0,
                    mainProduct: key,
                  );
                }).toList() ??
                [],
          );

          // 5️⃣ Solo añadimos si no existía ya
          if (!product.any((p) => p.id == producto.id)) {
            product.add(producto);
            navProvider.products.add(producto);
          }
        },
        onError: (err) {
          // 6️⃣ Log del error (no se emite evento al Bloc)
          final netErr = NetworkError.fromException(err);
          final repoErr = RepositoryError.fromDataSourceError(netErr);
          print('❌ Error en listener de productos: $repoErr');
        },
      );

      // 7️⃣ Todo bien → devolvemos éxito
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
    // 1️⃣ Cancelar cualquier suscripción previa
    await _dataStreamCategoria?.cancel();
    _dataStreamCategoria = null;

    try {
      final ref = database.ref('ficha_local/$idBar/categoria_productos');

      // 2️⃣ Procesar categorías ya existentes de una vez
      final snapshot = await ref.get();
      if (snapshot.exists) {
        final raw = snapshot.value;
        if (raw is Map) {
          // Si es un map de hijos, iteramos
          (raw).forEach((key, value) {
            try {
              final m = Map<String, dynamic>.from(value);
              final categoria = CategoriaProducto(
                id: key,
                categoria: m['categoria'] ?? '',
                categoriaEn: m['categoria_en'] ?? '',
                categoriaDe: m['categoria_de'] ?? '',
                envio: m['envio'] ?? '',
                icono: m['icono'] ?? '',
                imgVertical: m['img_vertical'] as bool? ?? false,
                orden: (m['orden'] as num?)?.toInt() ?? 0,
              );
              categoriasProdLocal.add(categoria);
            } catch (e) {
              // Log formateado
              final repoErr = RepositoryError.fromDataSourceError(
                NetworkError.fromException(e),
              );
              print('❌ [addCategoriaMenu] Error al parsear existente: $repoErr');
            }
          });
        }
      }

      // 3️⃣ Luego suscribimos onChildAdded para futuros insert
      _dataStreamCategoria = ref.onChildAdded.listen(
        (event) {
          try {
            final raw = event.snapshot.value;
            if (raw is! Map) {
              throw Exception('Formato inesperado o nulo al leer categoría: $raw');
            }
            final m = Map<String, dynamic>.from(raw);
            final nueva = CategoriaProducto(
              id: event.snapshot.key!,
              categoria: m['categoria'] ?? '',
              categoriaEn: m['categoria_en'] ?? '',
              categoriaDe: m['categoria_de'] ?? '',
              envio: m['envio'] ?? '',
              icono: m['icono'] ?? '',
              imgVertical: m['img_vertical'] as bool? ?? false,
              orden: (m['orden'] as num?)?.toInt() ?? 0,
            );
            categoriasProdLocal.add(nueva);
            print('✅ [addCategoriaMenu] Categoría añadida (nuevo): ${nueva.categoria}');
          } catch (e) {
            final repoErr = RepositoryError.fromDataSourceError(
              NetworkError.fromException(e),
            );
            print('❌ [addCategoriaMenu] Error al procesar nuevo: $repoErr');
          }
        },
        onError: (err) {
          final repoErr = RepositoryError.fromDataSourceError(
            NetworkError.fromException(err),
          );
          print('❌ [addCategoriaMenu] Error del listener: $repoErr');
        },
      );

      // 4️⃣ Al final, devolvemos éxito
      return const Result.success(null);
    } catch (error) {
      // 5️⃣ Si la creación de la suscripción falla
      return Result.failure(
        error: RepositoryError.fromDataSourceError(
          NetworkError.fromException(error),
        ),
      );
    }
  }

  @override
  Future<Result<void>> changeCategoriaMenu() async {
    await _dataStreamCategoria?.cancel();
    _dataStreamCategoria = null;

    try {
      _dataStreamCategoria = database.ref('ficha_local/$idBar/categoria_productos').onChildChanged.listen(
        (event) {
          final raw = event.snapshot.value;

          if (raw is! Map<dynamic, dynamic>) {
            final msg = '⚠️ Formato inesperado o nulo al cambiar categoría: $raw';
            final netErr = NetworkError.fromException(Exception(msg));
            final repoErr = RepositoryError.fromDataSourceError(netErr);
            print('❌ [changeCategoriaMenu] Error de datos: $repoErr');
            return;
          }

          final data = Map<String, dynamic>.from(raw);
          final key = event.snapshot.key!;
          final idx = categoriasProdLocal.indexWhere((c) => c.id == key);

          if (idx >= 0) {
            final cat = categoriasProdLocal[idx];
            cat.categoria = data['categoria'] ?? cat.categoria;
            cat.categoriaEn = data['categoria_en'] ?? cat.categoriaEn;
            cat.categoriaDe = data['categoria_de'] ?? cat.categoriaDe;
            cat.envio = data['envio'] ?? cat.envio;
            cat.icono = data['icono'] ?? cat.icono;
            cat.imgVertical = data['img_vertical'] as bool? ?? cat.imgVertical;
            cat.orden = (data['orden'] as num?)?.toInt() ?? cat.orden;

            print('🔄 [changeCategoriaMenu] Categoría actualizada: ${cat.categoria}');
          }
        },
        onError: (err) {
          final repoErr = RepositoryError.fromDataSourceError(NetworkError.fromException(err));
          print('❌ [changeCategoriaMenu] Error del listener: $repoErr');
        },
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
  Future<Result<void>> addSalaMesas() async {
    try {
      // 1️⃣ Obtenemos snapshot único de salas
      final ref = database.ref('gestion_local/$idBar/');
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
          salasMesa.add(SalaEstado(
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
          ));
        });

        print('✅ [addSalaMesas] Salas actualizadas correctamente: ${salasMesa.length} mesas procesadas.');
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
        final addedKey = '$mesaId-added';
        final changedKey = '$mesaId-changed';
        // si ya existían, saltamos
        if (_dataStreamGestionPedidosMap.containsKey(addedKey)) continue;
        if (_dataStreamGestionPedidosMap.containsKey(changedKey)) continue;

        final path = 'gestion_pedidos/$idBar/$mesaId';
        final ref = database.ref(path);

        // 3️⃣ onChildAdded
        final addedSub = ref.onChildAdded.listen(
          (event) {
            try {
              _processPedido(event.snapshot);
              print('✅ [addAndChangedPedidos] Pedido añadido: ${event.snapshot.key}');
            } catch (e) {
              final netErr = NetworkError.fromException(e);
              final repoErr = RepositoryError.fromDataSourceError(netErr);
              print('❌ [addAndChangedPedidos] Error al procesar pedido añadido: $repoErr');
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
              print('✅ [addAndChangedPedidos] Pedido actualizado: ${event.snapshot.key}');
            } catch (e) {
              final netErr = NetworkError.fromException(e);
              final repoErr = RepositoryError.fromDataSourceError(netErr);
              print('❌ [addAndChangedPedidos] Error al procesar pedido actualizado: $repoErr');
            }
          },
          onError: (err) {
            final netErr = NetworkError.fromException(err);
            final repoErr = RepositoryError.fromDataSourceError(netErr);
            print('❌ [addAndChangedPedidos] Error en onChildChanged: $repoErr');
          },
        );

        // 5️⃣ Guardar suscripciones
        _dataStreamGestionPedidosMap[addedKey] = addedSub;
        _dataStreamGestionPedidosMap[changedKey] = changedSub;
        print('✅ [addAndChangedPedidos] Listeners creados para mesa $mesaId');
      }

      // 6️⃣ Todo bien → éxito
      print('✅ [addAndChangedPedidos] Todos los listeners configurados correctamente.');
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

      final envio = await obtenerEnvioPorProducto(
        categoriasProdLocal,
        idProd,
        product,
      );
      if (envio != 'cocina') return;

      // Llamamos a la función _handleDataChange para procesar el cambio de datos
      final result = await _handleDataChange(
        dataMesas,
        snapshot.key,
        envio ?? 'barra',
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

      // Si es una actualización, eliminamos el pedido antes de agregar el nuevo
      if (isUpdate) {
        itemPedidos.removeWhere((pedido) => pedido.id == id);
      }

      // Si el estado es cocinado o bloqueado, solo removemos el pedido
      if (estado == EstadoPedido.cocinado.name || estado == EstadoPedido.bloqueado.name) {
        itemPedidos.removeWhere((pedido) => pedido.id == id);
      } else {
        // Creamos el nuevo pedido
        final nuevoPedido = Pedido(
          cantidad: dataMesas['cantidad'] as int? ?? 0,
          fecha: dataMesas['fecha'] as String? ?? '',
          hora: dataMesas['hora'] as String? ?? '',
          mesa: dataMesas['mesa'].toString(),
          numPedido: dataMesas['numPedido'] as int? ?? 0,
          nota: dataMesas['nota'] as String? ?? '',
          estadoLinea: estado,
          idProducto: dataMesas['idProducto'] as String? ?? '',
          enMarcha: dataMesas['en_marcha'] as bool? ?? false,
          racion: dataMesas['racion'] as bool? ?? true,
          modifiers: (dataMesas['modifiers'] as List?)?.map((modifier) {
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

        // Añadimos el nuevo pedido
        itemPedidos.add(nuevoPedido);

        // Si el estado es pendiente, activamos el timbre
        if (estado == EstadoPedido.pendiente.name) {
          timbre();
        }
      }

      // Solo actualizamos el _eventController al final
      _eventController.add(ListenerEvent.pedidosUpdated(List.from(itemPedidos)));

      // Devolvemos Result.success solo al final
      return const Result.success(null);
    } catch (error) {
      // Formato estándar de manejo de errores
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

        final path = 'gestion_pedidos/$idBar/$mesaId';
        final ref = database.ref(path);

        // 3️⃣ onChildRemoved
        final sub = ref.onChildRemoved.listen(
          (event) {
            final pedidoId = event.snapshot.key;
            if (pedidoId == null) return;

            itemPedidos.removeWhere((p) => p.id == pedidoId);
            _eventController.add(
              ListenerEvent.pedidoRemoved(List.from(itemPedidos)),
            );
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
  void dispose() {
    _dataStreamProductos?.cancel();
    _dataStreamProductos = null;

    _dataStreamCategoria?.cancel();
    _dataStreamCategoria = null;
    // Cancelar todas las suscripciones almacenadas en el mapa por Mesa
    //Pedidos Realizados
    for (final subscription in _dataStreamGestionPedidosMap.values) {
      subscription.cancel();
    }
    _dataStreamGestionPedidosMap.clear();

    for (final subscription in _dataStreamRemovedPedidosMap.values) {
      subscription.cancel();
    }
    _dataStreamRemovedPedidosMap.clear();
    //

    _eventController.close();
  }
}
