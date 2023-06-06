import 'dart:async';
import 'package:qribar/main.dart';
import 'package:qribar/models/ficha_local.dart';
import 'package:qribar/models/pedidos.dart';
import 'package:qribar/models/pedidosLocal.dart';

import 'package:qribar/services/notifications_service.dart';
import 'package:flutter/material.dart';
import 'package:qribar/provider/navegacion_model.dart';
import 'package:provider/provider.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:qribar/provider/products_provider.dart';

class ListenFirebase extends StatefulWidget {
  static final String routeName = 'listenFirebase';
  @override
  _ListenFirebaseState createState() => _ListenFirebaseState();
}

class _ListenFirebaseState extends State<ListenFirebase> {
  final database = FirebaseDatabase.instance.reference();
  StreamSubscription? _dataStream;

  static String idProd = '';
  static String mesaSnap = '';
  static int numPed = 0;
  static List mesasActivas = [];

  @override
  void initState() {
    final itemElemento = Provider.of<ProductsService>(context, listen: false);
    final numElementos = Provider.of<NavegacionModel>(context, listen: false);
    String idBar = itemElemento.idBar;

    childAddCategoriaNuevaMenu(numElementos, idBar);
    childChangedCategoriaMenu(numElementos, idBar);
    childRemoveListenerMenuCategorias(idBar, numElementos);
    childAddListenerPedidosMesas(idBar, numElementos);
    childAddListenerPedidosMesasLocal(itemElemento.pedidosRealizados, idBar, numElementos, itemElemento.salasMesa);
    childChangedListenerPedidosMesasLocal(itemElemento.pedidosRealizados, idBar, numElementos, itemElemento.salasMesa);

    childRemoveListenerPedidos(itemElemento.pedidosRealizados, idBar, numElementos, itemElemento.salasMesa);
    childRemoveListenerPedidoCompletado(idBar, numElementos, itemElemento.salasMesa);
    childRemoveListenerMesa(idBar, numElementos, itemElemento.pedidosRealizados);

    _childChangedBloqueo(numElementos, idBar);
    _childAddedBloqueo(numElementos, idBar);
    super.initState();
  }

  void childAddCategoriaNuevaMenu(NavegacionModel numElementos, String idBar) {
    final catProductos = Provider.of<ProductsService>(context, listen: false).categoriasProdLocal;
    //Listener de todas las mesas definidas en gestion_local
    List<CategoriaProducto> addNuevaCategoria = [];
    //int _contPed = 0;
    //print(salasMesa[i].mesa);
    DatabaseReference _dataStreamNewCategory = new FirebaseDatabase().reference().child('ficha_local/$idBar/categoria_productos');

    _dataStreamNewCategory.onChildAdded.listen((event) {
      final dataMesas = new Map<String, dynamic>.from(event.snapshot.value);

      numElementos.valRecargaWidget = true;
      //numElementos.mesaActual = salasMesa[i].mesa!;

      numElementos.addDelButton = 1; //Pedido desde fuera
      addNuevaCategoria = [
        CategoriaProducto(
          categoria: dataMesas['categoria'],
          categoriaEn: dataMesas['categoria_en'],
          categoriaDe: dataMesas['categoria_de'],
          envio: dataMesas['envio'],
          icono: dataMesas['icono'],
          imgVertical: dataMesas['img_vertical'],
          orden: dataMesas['orden'],
          id: event.snapshot.key,
        )
      ];

      catProductos.add(addNuevaCategoria[0]);
      //numElementos.categoriaSelected = 'Cocina Estado Pedidos'; //'${catProductos[i].orden}';
      numElementos.itemSeleccionado = 0;
      numElementos.itemSeleccionadoMenu = 0;
      numElementos.valRecargaWidget = true;
    });
    // numElementos.valRecargaWidget = true;

    // print('Añadiendo nueva Categoría del Menú');
  }

  void childChangedCategoriaMenu(NavegacionModel numElementos, String idBar) {
    final catProductos = Provider.of<ProductsService>(context, listen: false).categoriasProdLocal;
    //Listener de todas las mesas definidas en gestion_local
    //List<CategoriaProducto> addNuevaCategoria = [];
    //int _contPed = 0;
    //print(salasMesa[i].mesa);
    DatabaseReference _dataStreamNewCategory = new FirebaseDatabase().reference().child('ficha_local/$idBar/categoria_productos');

    _dataStreamNewCategory.onChildChanged.listen((event) {
      final dataMesas = new Map<String, dynamic>.from(event.snapshot.value);

      for (var i = 0; i < catProductos.length; i++) {
        if (catProductos[i].id == event.snapshot.key) {
          catProductos[i].categoria = dataMesas['categoria'];
          catProductos[i].categoriaEn = dataMesas['categoria_en'];
          catProductos[i].categoriaDe = dataMesas['categoria_de'];
          catProductos[i].envio = dataMesas['envio'];
          catProductos[i].icono = dataMesas['nombreIcon'];
          catProductos[i].orden = dataMesas['orden'];
          catProductos[i].icono = dataMesas['icono'];
          catProductos[i].imgVertical = dataMesas['img_vertical'];
        }
      }
      numElementos.categoriaSelected = 'Sugerencias';
      numElementos.itemSeleccionado = 0;
      numElementos.itemSeleccionadoMenu = 0;
      numElementos.valRecargaWidget = true;
    });
    //  print('Cambio en Categoría del Menú');
  }

  void childRemoveListenerMenuCategorias(String idBar, NavegacionModel numElementos) {
    final catProductos = Provider.of<ProductsService>(context, listen: false).categoriasProdLocal;
    DatabaseReference _dataStreamNewCategory = new FirebaseDatabase().reference().child('ficha_local/$idBar/categoria_productos');

    _dataStreamNewCategory.onChildRemoved.listen((event) {
      final data = new Map<String, dynamic>.from(event.snapshot.value);
      //var key = event.snapshot.key;
      catProductos.removeWhere((element) => element.categoria == data['categoria']);

      numElementos.itemSeleccionadoMenu = 0;
      numElementos.itemSeleccionado = 0;
      //numElementos.categoriaSelected = 'Sugerencias';
      numElementos.valRecargaWidget = true;
    });
  }

  void childAddListenerPedidosMesasLocal(List<Pedidos> itemPedidos, String idBar, NavegacionModel numElementos, List<PedidosLocal> salasMesa) {
    //Listener de todas las mesas definidas en gestion_local
    List<Pedidos> listaPedidosNuevos = [];
    int _contPed = 0;

    for (var i = 0; i < salasMesa.length; i++) {
      //print(salasMesa[i].mesa);
      DatabaseReference _dataStreamPedidosMesasCambios = new FirebaseDatabase().reference().child('gestion_pedidos/$idBar/${salasMesa[i].mesa}');

      _dataStreamPedidosMesasCambios.onChildAdded.listen((event) {
        final dataMesas = new Map<String, dynamic>.from(event.snapshot.value);

        //numElementos.mesaActual = salasMesa[i].mesa!;

        numElementos.addDelButton = 1; //Pedido desde fuera
        listaPedidosNuevos = [
          Pedidos(
              cantidad: dataMesas['cantidad'],
              categoriaProducto: dataMesas['categoria_producto'],
              fecha: dataMesas['fecha'],
              hora: dataMesas['hora'],
              idBar: idBar,
              mesa: dataMesas['mesa'].toString(),
              mesaAbierta: dataMesas['mesaAbierta'] ?? false,
              numPedido: dataMesas['numPedido'],
              precioProducto: dataMesas['precio_producto'].toDouble(),
              titulo: dataMesas['titulo'],
              nota: dataMesas['nota'],
              estadoLinea: dataMesas['estado_linea'],
              idProducto: idProd = dataMesas['idProducto'],
              enMarcha: false,
              id: dataMesas['id'])
        ];

        itemPedidos.add(listaPedidosNuevos[0]);

        for (var i = 0; i < itemPedidos.length; i++) {
          //if (itemPedidos[i].mesa == numElementos.mesaActual) {
          if (itemPedidos[i].idProducto == idProd) {
            if (itemPedidos[i].numPedido > _contPed) {
              _contPed = itemPedidos[i].numPedido;
              // NotificationService.showSnackbar('Pedido $_contPed realizado!');
            }
            //numElementos.numPedido = _contPed; //Revisar
          }
        }
        // }
        //numElementos.idPedidoSelected = _contPed;
        numElementos.numPedido = _contPed;
      });
      // numElementos.valRecargaWidget = true;
    }
    //print('Estoy leyendo Gestión de pedidos');
  }

  void childChangedListenerPedidosMesasLocal(List<Pedidos> itemPedidos, String idBar, NavegacionModel numElementos, List<PedidosLocal> salasMesa) {
    //Listener de todas las mesas definidas en gestion_local
    //List<Pedidos> listaPedidosNuevos = [];
    //int _contPed = 0;

    for (var i = 0; i < salasMesa.length; i++) {
      //print(salasMesa[i].mesa);
      DatabaseReference _dataStreamPedidosMesasCambios = new FirebaseDatabase().reference().child('gestion_pedidos/$idBar/${salasMesa[i].mesa}');

      _dataStreamPedidosMesasCambios.onChildChanged.listen((event) {
        final dataMesas = new Map<String, dynamic>.from(event.snapshot.value);
        //rint(dataMesas['estado_linea']);
        //print(dataMesas['precio_producto']);
        //numElementos.mesaActual = salasMesa[i].mesa!;
        idProd = dataMesas['idProducto'] as String;
        mesaSnap = dataMesas['mesa'] as String;
        numPed = dataMesas['numPedido'] as int;
/*         var estado = dataMesas['estado_linea'] as String;
        print(estado); */
        // precio = dataMesas['precio_producto'] as double;
        //print(precio);
        //numElementos.addDelButton = 1; //Pedido desde fuera

        for (var i = 0; i < itemPedidos.length; i++) {
          //if (itemPedidos[i].mesa == numElementos.mesaActual) {
          if (itemPedidos[i].idProducto == idProd && itemPedidos[i].mesa == mesaSnap && itemPedidos[i].numPedido == numPed) {
            itemPedidos[i].estadoLinea = dataMesas['estado_linea'];
            //if (itemPedidos[i].estadoLinea == 'cocinado') NotificationService.showSnackbar('Plato Listo para mesa ${int.parse(mesaSnap)}', numElementos);
            if (itemPedidos[i].estadoLinea == 'pendiente') NotificationService.showSnackbar('Cancelado ${itemPedidos[i].titulo} en mesa ${int.parse(mesaSnap)}', numElementos);
            // if (dataMesas['precio_producto'] == 0) itemPedidos[i].precioProducto = 0.0;
            // itemPedidos[i].precioProducto = precio;
          }
        }
        numElementos.valRecargaWidget = true;
      });
    }
    // print('Cambio Estado Línea Gestión de pedidos');
  }

  void childAddListenerPedidosMesas(String idBar, NavegacionModel numElementos) {
    DatabaseReference _dataStreamPedidosMesas = new FirebaseDatabase().reference().child('gestion_pedidos/$idBar/');

    _dataStreamPedidosMesas.onChildAdded.listen((event) {
      mesasActivas.add(event.snapshot.key);

      numElementos.mesasActivas = mesasActivas.length;
    });
    // print('Estoy leyendo número de Mesas del Local');
    //return mesasActivas;
  }

  void childRemoveListenerPedidos(List<Pedidos> itemPedidos, String idBar, NavegacionModel numElementos, List<PedidosLocal> salasMesa) {
    for (var i = 0; i < salasMesa.length; i++) {
      DatabaseReference _dataStreamPedidosBorrados = new FirebaseDatabase().reference().child('gestion_pedidos/$idBar/${salasMesa[i].mesa}');

      _dataStreamPedidosBorrados.onChildRemoved.listen((event) {
        final data = new Map<String, dynamic>.from(event.snapshot.value);

        idProd = data['idProducto'] as String;
        mesaSnap = data['mesa'] as String;
        numPed = data['numPedido'] as int;
        //print(('mesa $mesaSnap $numPed'));
        itemPedidos.removeWhere((element) => element.idProducto == idProd && element.mesa == mesaSnap && element.numPedido == numPed);
        numElementos.valRecargaWidget = true; //Para actualizar widgets?
        //numElementos.mesaActiva = 0;
      });
    }
  }

  void childRemoveListenerPedidoCompletado(String idBar, NavegacionModel numElementos, List<PedidosLocal> salasMesa) {
    DatabaseReference _dataStreamPedidosBorrados = new FirebaseDatabase().reference().child('gestion_local/$idBar/');

    DatabaseReference _dataStreamMesasBorradas = new FirebaseDatabase().reference().child('gestion_pedidos/$idBar/');

    _dataStreamMesasBorradas.onChildRemoved.listen((event) {
      final data = new Map<String, dynamic>.from(event.snapshot.value);
      data.forEach((k, v) {
        mesaSnap = v['mesa'] as String;
        _dataStreamPedidosBorrados.child('$mesaSnap').update({'estado': 'procesando'});
      });
      //NotificationService.showSnackbar('Todo servido! Mesa ${int.parse(mesaSnap)}', Key);
    });
  }

  void childRemoveListenerMesa(String idBar, NavegacionModel numElementos, List<Pedidos> pedidosRealizados) {
    //Si se remueve mesa es que se ha hecho un pedido
    int _contPed = 0;
    DatabaseReference _dataStreamPedidos = new FirebaseDatabase().reference().child('mesas/$idBar/');

    _dataStreamPedidos.onChildRemoved.listen((event) {
      final data = new Map<String, dynamic>.from(event.snapshot.value);
      mesaSnap = data.values.first['id_mesa'];

      for (var i = 0; i < pedidosRealizados.length; i++) {
        if (pedidosRealizados[i].mesa == mesaSnap) {
          if (pedidosRealizados[i].idProducto == idProd) {
            if (pedidosRealizados[i].numPedido > _contPed) {
              _contPed = pedidosRealizados[i].numPedido;
              // NotificationService.showSnackbar('Pedido $_contPed realizado!');
            }
            //numElementos.numPedido = _contPed; //Revisar
          }
        }
      }
      //numElementos.idPedidoSelected = _contPed;
      numElementos.numPedido = _contPed;
      if (numElementos.addDelButton == 1) {
        showNotification(numElementos.numPedido, mesaSnap, false, false, false);
        //NotificationService.showSnackbar('Pedido ${numElementos.numPedido} realizado en mesa ${int.parse(mesaSnap)}', numElementos);
      }

      //\nEnseguida te lo traemos!
      numElementos.addDelButton = 0;
      _contPed = 0;
      numElementos.numero = 0;
      numElementos.cambioEstadoProducto = false;
    });
  }

  void _childAddedBloqueo(NavegacionModel numElementosNotify, String idBar) {
    DatabaseReference _dataStreamReadClave = new FirebaseDatabase().reference().child('cuentas/$idBar');
    _dataStreamReadClave.onChildAdded.listen(
      (event) {
        final data = (event.snapshot.value);
        if (event.snapshot.key == 'bloqueo_pedidos') numElementosNotify.bloqueoPedidos = data;
      },
    );
  }

  void _childChangedBloqueo(NavegacionModel numElementosNotify, String idBar) {
    DatabaseReference _dataStreamClave = new FirebaseDatabase().reference().child('cuentas/$idBar');
    _dataStreamClave.onChildChanged.listen(
      (event) {
        final data = (event.snapshot.value);
        if (event.snapshot.key == 'bloqueo_pedidos') numElementosNotify.bloqueoPedidos = data;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }

  @override
  void deactivate() {
    _dataStream?.cancel();
    super.deactivate();
  }
}
