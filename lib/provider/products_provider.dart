import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:qribar/models/anuncios.dart';
import 'package:qribar/models/ficha_local.dart';
import 'package:qribar/models/models.dart';
import 'package:qribar/models/pedidos.dart';
import 'package:qribar/models/pedidosLocal.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
//import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:qribar/models/usuarios_online.dart';
import 'package:qribar/services/functions.dart';

class ProductsService extends ChangeNotifier {
  final List<Usuarios> usuarios = [];
  final List<Product> products = [];
  //final List<CategoriaProducto> iconos = [];
  final List<Pedidos> pedidosRealizados = [];
  final List<Pedidos> pedidosRealizadosMesaUsuario = [];
  final List<Pedidos> pedidosCancelados = [];
  final List<Pedidos> pedidosProcesados = [];
  final List<PedidosLocal> salasMesa = [];
  late Product selectedProduct;
  //late CategoriaProducto selectedCategoria;

  //static String idBar = 'Test'; //Viene de URL
  //static int mesa = 7;
  bool isLoading = true;
  bool isLoadingFicha = true;
  static String idPed = '';
  static int cantSnap = 0;
  final List mesasActivas = [];
  final List<CategoriaProducto> categoriasProdLocal = [];
  final List<HistorialAnuncios> historialAnuncios = [];
  final List<AnunciosLocal> fichaAnuncios = [];
  //final String _baseUrl = 'flutterweb-c471d-default-rtdb.firebaseio.com';
  static List<String> alergias = [];
  LinearGradient bgGradient = const LinearGradient(
    colors: <Color>[Color(0xFF262B2F), Color(0xFF1D2125), Color(0xFF16191D)],
    transform: GradientRotation(pi / 2),
    tileMode: TileMode.clamp,
  );

  LinearGradient bgGradientBlanco = const LinearGradient(
    colors: <Color>[Color(0xFFF1F5F8), Color(0xFFDDE7F3), Color(0xFFE5F0F9)],
    transform: GradientRotation(pi / 2),
    tileMode: TileMode.clamp,
  );
  //bool isAuth = false;
  String _idBar = ''; //Viene de URL
  String nombreBar = '';
  String cloudinaryName = '';
  //final int mesa = 1;
  final storage = new FlutterSecureStorage();

  File? newPictureFile;

  bool isSaving = false;
  int _cantidad = 0;

  String get idBar => this._idBar;
  set idBar(String idBar) {
    this._idBar = idBar;
    notifyListeners();
  }

  ProductsService() {
/*     const oneSec = Duration(hours: 2);
    Timer.periodic(oneSec, (Timer t) {
      if (idBar != '') {
        DatabaseReference _dataStreamReadClave = new FirebaseDatabase().reference().child('cuentas/$idBar/');
        String clave = getRandomString(3);
        _dataStreamReadClave.update({'clave_acceso': '$clave'});
      }
    }); */
    //this.userInit();

    // this.loadProducts();
    //this.loadMesas();
    // this.loadcategoriaProductos();
    // this.pedidosCanceladosTotal();
  }

/*   Future<List<CategoriaProducto>> loadcategoriaProductos() async {
    this.isLoadingFicha = true;
    notifyListeners();
    //print('$idBar');
    DatabaseReference _dataStreamProd = new FirebaseDatabase().reference().child('ficha_local/$idBar/categoria_productos/');
    //if (isAuth)
    await _dataStreamProd.once().then((value) {
      //_dataStream.onChildAdded.listen((event) {
      final data = new Map<String, dynamic>.from(value.value);
      print('Estoy leyendo Categorias');

      data.forEach((key, v) {
        //print(key);
        // print(v);
        List<dynamic> categoriasProd = [
          CategoriaProducto(
            categoria: v['categoria'],
            envio: v['envio'],
            icono: v['icono'],
            imgVertical: v['img_vertical'],
            orden: v['orden'],
          )
        ];
        categoriasProdLocal.add(categoriasProd[0]);
      });

      notifyListeners();

      this.isLoadingFicha = false;
      notifyListeners();
    });
    return this.categoriasProdLocal;
  } */

/*   Future<List<Product>> loadProducts() async {
    this.isLoading = true;
    notifyListeners();
    //print('$idBar');
    DatabaseReference _dataStreamProd = new FirebaseDatabase().reference().child('productos/$idBar/');
    //if (isAuth)
    try {
      await _dataStreamProd.once().then((value) {
        //_dataStream.onChildAdded.listen((event) {
        final data = new Map<String, dynamic>.from(value.value);
        print('Estoy leyendo Productos');
        data.forEach((k, v) {
          if (v["alergogenos"] != null) v["alergogenos"].forEach((k, v) => alergias.add(k));
          List<Product> listaProductos = [
            Product(
              alergogenos: alergias,
              categoriaProducto: v["categoria_producto"],
              costeProducto: v["coste_producto"].toDouble(),
              disponible: v["disponible"],
              descripcionProducto: v["descripcion_producto"],
              fotoUrl: v["foto_url"],
              nombreProducto: v["nombre_producto"],
              precioProducto: v["precio_producto"].toDouble(),
              precioProducto2: v["precio_producto2"].toDouble() ?? 0.00,
              nombreRacion: v["nombre_racion"],
              nombreRacionMedia: v["nombre_racion_media"],
              idBar: v["id_bar"],
              id: k,
            )
          ];
          /*  if (v["disponible"] == true)  */ products.add(listaProductos[0]);
          alergias = [];
          notifyListeners();
        });
        this.isLoading = false;
        notifyListeners();
      });
    } catch (e) {
      print(e);
    }

    return this.products;
  } */

  Future<List<PedidosLocal>> loadMesas(idBarEmail) async {
    this.isLoading = true;
    notifyListeners();
    DatabaseReference _dataStreamFicha = new FirebaseDatabase().reference().child('cuentas/$idBarEmail');
    await _dataStreamFicha.once().then((value) {
      idBar = idBarEmail;

      final data = new Map<String, dynamic>.from(value.value);
      data.forEach((k, v) {
        if (k == 'nom_local') nombreBar = v;
      });
    });

    DatabaseReference _readCarpetaCloudinary = new FirebaseDatabase().reference().child('cuentas/$idBar');
    _readCarpetaCloudinary.once().then((value) {
      final data = new Map<String, dynamic>.from(value.value);
      print('Estoy leyendo carpeta cloudinary');
      data.forEach((k, v) {
        if (k == 'carpeta_cloudinary') cloudinaryName = v;
      });
    });

    DatabaseReference _dataStreamProd = new FirebaseDatabase().reference().child('gestion_local/$idBar/');

    await _dataStreamProd.once().then((value) {
      // print(idBar);
      // String keys = _dataStreamProd.key;
      //_dataStream.onChildAdded.listen((event) {
      final data = new Map<String, dynamic>.from(value.value);
      print('Estoy leyendo Numero de Mesas');
      data.forEach((k, v) {
        final List<PedidosLocal> listaSalasMesa = [
          PedidosLocal(
              mesa: k,
              sala: v['sala'],
              estado: v['estado'],
              hora: v['hora'],
              horaUltimaActiva: v['horaUltimaActiva'],
              horaUltimoPedido: v['horaUltimoPedido'],
              horaUltimoPago: v['horaUltimoPago'],
              personas: v['personas'] ?? 0,
              callCamarero: v['callCamarero'],
              callPago: v['callPago'],
              nombre: v['nombre'] ?? '',
              positionMap: v['positionMap'],
              qrLink: v['qr_link'] ?? '')
        ];
        salasMesa.add(listaSalasMesa[0]);
        notifyListeners();
      });
      this.isLoading = false;
      notifyListeners();
    });
    return this.salasMesa;
  }

  int get cantidad => this._cantidad;
  set cantidad(int cantidad) {
    this._cantidad = cantidad;
    notifyListeners();
  }
}
