import 'package:flutter/material.dart';
import 'package:qribar_cocina/app/enums/selection_type_enum.dart';
import 'package:qribar_cocina/data/models/product.dart';

class NavegacionProvider extends ChangeNotifier {
  final PageController _pageController = PageController();

  String _categoriaSelected = SelectionTypeEnum.generalScreen.name;
  int _idPedidoSelected = 1;
  String _mesaActual = '0';

  final List<Product> _productos = [];
  List<Product> get productos => List.unmodifiable(_productos);

  void addProducto(Product producto) {
    _productos.add(producto);
    notifyListeners();
  }

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
