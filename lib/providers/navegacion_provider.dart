import 'package:flutter/material.dart';

class NavegacionProvider extends ChangeNotifier {
  final PageController _pageController = PageController();

  String _categoriaSelected = "Cocina Estado Pedidos";
  int _idPedidoSelected = 1;
  String _mesaActual = '0';

  String get categoriaSelected => _categoriaSelected;
  set categoriaSelected(String name) {
    if (_categoriaSelected != name) {
      _categoriaSelected = name;
      notifyListeners();
    }
  }

  int get idPedidoSelected => _idPedidoSelected;
  set idPedidoSelected(int index) {
    if (_idPedidoSelected != index) {
      _idPedidoSelected = index;
      notifyListeners();
    }
  }

  String get mesaActual => _mesaActual;
  set mesaActual(String index) {
    if (_mesaActual != index) {
      _mesaActual = index;
      notifyListeners();
    }
  }

  PageController get pageController => _pageController;
}
