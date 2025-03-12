import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:qribar_cocina/models/ficha_local.dart';
import 'package:qribar_cocina/models/models.dart';
import 'package:qribar_cocina/models/pedidos.dart';
import 'package:qribar_cocina/models/pedidosLocal.dart';

class ProductsService extends ChangeNotifier {
  final List<Product> products = [];
  final List<Pedidos> pedidosRealizados = [];
  final List<Pedidos> pedidosRealizadosMesaUsuario = [];
  final List<Pedidos> pedidosCancelados = [];
  final List<Pedidos> pedidosProcesados = [];
  final List<PedidosLocal> salasMesa = [];
  late Product selectedProduct;
  bool isLoading = true;
  bool isLoadingFicha = true;
  static String idPed = '';
  static int cantSnap = 0;
  final List mesasActivas = [];
  final List<CategoriaProducto> categoriasProdLocal = [];
  final database = FirebaseDatabase.instance;
  String estado = '';

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

  String _idBar = ''; //Viene de URL
  String nombreBar = '';
  String cloudinaryName = '';
  final storage = new FlutterSecureStorage();

  File? newPictureFile;

  bool isSaving = false;
  int _cantidad = 0;

  String get idBar => this._idBar;
  set idBar(String idBar) {
    this._idBar = idBar;
    notifyListeners();
  }

  Future<List<PedidosLocal>> loadMesas(idBarEmail) async {
    this.isLoading = true;
    notifyListeners();
    DatabaseReference _dataStreamFicha = database.ref('cuentas/$idBarEmail');
    await _dataStreamFicha.once().then((value) {
      idBar = idBarEmail;

      final data = new Map<dynamic, dynamic>.from(value.snapshot.value as Map);
      data.forEach((k, v) {
        if (k == 'nom_local') nombreBar = v;
        if (k == 'estado') estado = v;
      });
    });

    DatabaseReference _readCarpetaCloudinary = database.ref('cuentas/$idBar');
    _readCarpetaCloudinary.once().then((value) {
      final data = new Map<dynamic, dynamic>.from(value.snapshot.value as Map);
      data.forEach((k, v) {
        if (k == 'carpeta_cloudinary') cloudinaryName = v;
      });
    });

    DatabaseReference _dataStreamProd = database.ref('gestion_local/$idBar/');

    await _dataStreamProd.once().then((value) {
      final data = new Map<dynamic, dynamic>.from(value.snapshot.value as Map);

      data.forEach((k, v) {
        final List<PedidosLocal> listaSalasMesa = [
          PedidosLocal(
            mesa: k,
            sala: v['sala'],
            estado: v['estado'],
            hora: v['hora'],
            horaUltimoPedido: v['horaUltimoPedido'],
            //horaUltimoPago: v['horaUltimoPago'],
            personas: v['personas'] ?? 0,
            callCamarero: v['callCamarero'],
            //callPago: v['callPago'],
            nombre: v['nombre'] ?? '',
            positionMap: v['positionMap'],
            qrLink: v['qr_link'] ?? '',
          )
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
