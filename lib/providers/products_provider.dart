import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:qribar_cocina/data/models/categoria_producto.dart';
import 'package:qribar_cocina/data/models/pedidos.dart';
import 'package:qribar_cocina/data/models/product.dart';
import 'package:qribar_cocina/data/models/sala_estado.dart';

class ProductsService extends ChangeNotifier {
  final List<Product> products = [];
  final List<Pedidos> pedidosRealizados = [];
  final List<Pedidos> pedidosRealizadosMesaUsuario = [];
  final List<Pedidos> pedidosCancelados = [];
  final List<Pedidos> pedidosProcesados = [];
  final List<SalaEstado> salasMesa = [];
  final List mesasActivas = [];
  final List<CategoriaProducto> categoriasProdLocal = [];
  final database = FirebaseDatabase.instance;
  late Product selectedProduct;
  static String idPed = '';
  static int cantSnap = 0;
  bool isLoading = true;
  bool isLoadingFicha = true;
  String estado = '';
  String _idBar = '';
  String nombreBar = '';
  bool isSaving = false;

  String get idBar => this._idBar;
  set idBar(String idBar) {
    this._idBar = idBar;
    notifyListeners();
  }

  Future<List<SalaEstado>> loadMesas(idBarEmail) async {
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

    DatabaseReference _dataStreamProd = database.ref('gestion_local/$idBar/');
    await _dataStreamProd.once().then((value) {
      final data = new Map<dynamic, dynamic>.from(value.snapshot.value as Map);

      data.forEach((k, v) {
        final List<SalaEstado> listaSalasMesa = [
          SalaEstado(
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
}
