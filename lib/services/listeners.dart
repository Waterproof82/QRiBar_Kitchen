import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:provider/provider.dart';
import 'package:qribar/models/ficha_local.dart';
import 'package:qribar/provider/navegacion_model.dart';
import 'package:qribar/provider/products_provider.dart';
import 'package:qribar/models/pedidos.dart';
import 'package:qribar/models/pedidosLocal.dart';
import 'package:qribar/services/functions.dart';

class ListenFirebase extends StatefulWidget {
  static final String routeName = 'listenFirebase';
  @override
  _ListenFirebaseState createState() => _ListenFirebaseState();
}

class _ListenFirebaseState extends State<ListenFirebase> {
  final database = FirebaseDatabase.instance.reference();

  StreamSubscription<Event>? _dataStreamCategoria;
  StreamSubscription<Event>? _dataStreamGestionPedidos;
  StreamSubscription<Event>? _dataStreamPedidosRemovidos;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final itemElemento = Provider.of<ProductsService>(context, listen: false);
      final numElementos = Provider.of<NavegacionModel>(context, listen: false);
      String idBar = itemElemento.idBar;

      childAddCategoriaNuevaMenu(numElementos, idBar);
      childChangedCategoriaMenu(numElementos, idBar);
      addAndChangedListenerPedidosMesasLocal(itemElemento.pedidosRealizados, idBar, numElementos, itemElemento.salasMesa);
      childRemoveListenerPedidos(itemElemento.pedidosRealizados, idBar, numElementos, itemElemento.salasMesa);
    });
  }

  Future<void> childAddCategoriaNuevaMenu(NavegacionModel numElementos, String idBar) async {
    final catProductos = Provider.of<ProductsService>(context, listen: false).categoriasProdLocal;

    _dataStreamCategoria = database.child('ficha_local/$idBar/categoria_productos').onChildAdded.listen((event) {
      final dataMesas = Map<String, dynamic>.from(event.snapshot.value);

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

    DatabaseReference _dataStreamNewCategory = FirebaseDatabase.instance.reference().child('ficha_local/$idBar/categoria_productos');

    _dataStreamNewCategory.onChildChanged.listen((event) {
      final dataMesas = new Map<String, dynamic>.from(event.snapshot.value);

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

      _dataStreamGestionPedidos = database.child(path).onChildAdded.listen((event) {
        _handleDataChange(itemPedidos, idBar, numElementos, event.snapshot.value);
      });

      _dataStreamGestionPedidos = database.child(path).onChildChanged.listen((event) {
        _handleDataChange(itemPedidos, idBar, numElementos, event.snapshot.value);
      });
    }
  }

  void _handleDataChange(List<Pedidos> itemPedidos, String idBar, NavegacionModel numElementos, dynamic data) {
    final dataMesas = Map<String, dynamic>.from(data);

    final idProd = dataMesas['idProducto'] as String;
    final mesaSnap = dataMesas['mesa'] as String;
    final numPed = dataMesas['numPedido'] as int;

    final catProductos = Provider.of<ProductsService>(context, listen: false).categoriasProdLocal;
    List<CategoriaProducto> unicaCategoriaFiltro = [];

    String envio = '';

    itemPedidos.removeWhere((element) => element.idProducto == idProd && element.mesa == mesaSnap && element.numPedido == numPed);

    //EXTRAS
    final List<String> extras = [];
    if (dataMesas['extras'] != null)
      dataMesas['extras'].forEach(
        (element) {
          extras.add(element);
        },
      );
    //
    itemPedidos.add(
      Pedidos(
        cantidad: dataMesas['cantidad'],
        categoriaProducto: dataMesas['categoria_producto'],
        fecha: dataMesas['fecha'],
        hora: dataMesas['hora'],
        idBar: idBar,
        mesa: mesaSnap.toString(),
        mesaAbierta: dataMesas['mesaAbierta'] ?? false,
        numPedido: numPed,
        precioProducto: dataMesas['precio_producto'].toDouble(),
        titulo: dataMesas['titulo'],
        nota: dataMesas['nota'],
        estadoLinea: dataMesas['estado_linea'],
        idProducto: idProd,
        enMarcha: false,
        notaExtra: extras,
        id: dataMesas['id'],
      ),
    );
    ordenaCategorias(catProductos, unicaCategoriaFiltro, itemPedidos);
    for (var element in itemPedidos) {
      if (element.idProducto == idProd) envio = element.envio ?? '';
    }
    if ((numPed != numElementos.pedAnterior || numElementos.mesaAnt != mesaSnap) && dataMesas['estado_linea'] == 'pendiente' && envio == 'cocina') {
      timbre();

      numElementos.pedAnterior = numPed;
      numElementos.mesaAnt = mesaSnap;
    }

    numElementos.valRecargaWidget = true;
  }

  Future<void> childRemoveListenerPedidos(List<Pedidos> itemPedidos, String idBar, NavegacionModel numElementos, List<PedidosLocal> salasMesa) async {
    for (var salas in salasMesa) {
      final path = 'gestion_pedidos/$idBar/${salas.mesa}';

      _dataStreamPedidosRemovidos = database.child(path).onChildRemoved.listen((event) {
        final data = Map<String, dynamic>.from(event.snapshot.value);

        final idProd = data['idProducto'] as String;
        final mesaSnap = data['mesa'] as String;
        final numPed = data['numPedido'] as int;

        itemPedidos.removeWhere((element) => element.idProducto == idProd && element.mesa == mesaSnap && element.numPedido == numPed);
        numElementos.valRecargaWidget = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }

  @override
  void dispose() {
    _dataStreamCategoria?.cancel();
    _dataStreamGestionPedidos?.cancel();
    _dataStreamPedidosRemovidos?.cancel();
    super.dispose();
  }
}
