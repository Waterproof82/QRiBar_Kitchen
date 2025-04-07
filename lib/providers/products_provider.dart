import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:qribar_cocina/data/datasources/local_data_source/id_bar_data_source.dart';
import 'package:qribar_cocina/data/models/categoria_producto.dart';
import 'package:qribar_cocina/data/models/pedido/pedido.dart';
import 'package:qribar_cocina/data/models/product.dart';
import 'package:qribar_cocina/data/models/sala_estado.dart';

class ProductsService extends ChangeNotifier {
  final List<Product> products = [];
  final List<Pedido> pedidosRealizados = [];
  final List<SalaEstado> salasMesa = [];
  final List<CategoriaProducto> categoriasProdLocal = [];
  final database = FirebaseDatabase.instance;

  bool isLoading = true;
  String estado = '';

  Future<List<SalaEstado>> loadMesas(String idBarEmail) async {
    try {
      isLoading = true;
      notifyListeners();

      DatabaseReference _dataStreamFicha = database.ref('cuentas/$idBarEmail');
      final fichaSnapshot = await _dataStreamFicha.get();

      IdBarDataSource.instance.setIdBar(idBarEmail);

      if (!fichaSnapshot.exists) {
        isLoading = false;
        notifyListeners();
        return [];
      }

      final data = Map<dynamic, dynamic>.from(fichaSnapshot.value as Map);
      estado = data['estado'] ?? '';

      DatabaseReference _dataStreamProd = database.ref('gestion_local/$idBarEmail/');
      final prodSnapshot = await _dataStreamProd.get();

      if (!prodSnapshot.exists) {
        isLoading = false;
        notifyListeners();
        return [];
      }

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

      return salasMesa;
    } catch (e) {
      print('Error en loadMesas: $e');
      return [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
