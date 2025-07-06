import 'package:flutter/material.dart';
import 'package:qribar_cocina/app/enums/selection_type_enum.dart';

/// A final class that acts as a [ChangeNotifier] for navigation-related state.
///
/// This provider manages the selected category, order ID, current table,
/// and a [PageController] for screen navigation.
final class NavegacionProvider extends ChangeNotifier {
  /// Controller for managing page views in a [PageView] widget.
  /// It's initialized here as part of the provider's state.
  final PageController _pageController = PageController();

  /// The currently selected category, initialized to a default value.
  String _categoriaSelected = SelectionTypeEnum.generalScreen.name;

  /// The currently selected order ID, initialized to a default value.
  int _idPedidoSelected = 1;

  /// The ID of the current table, initialized to a default value.
  String _mesaActual = '0';

  /// Gets the currently selected category.
  String get categoriaSelected => _categoriaSelected;

  /// Sets the selected category.
  /// Notifies listeners only if the value has changed.
  set categoriaSelected(String name) {
    if (_categoriaSelected != name) {
      _categoriaSelected = name;
      notifyListeners();
    }
  }

  /// Gets the currently selected order ID.
  int get idPedidoSelected => _idPedidoSelected;

  /// Sets the selected order ID.
  /// Notifies listeners only if the value has changed.
  set idPedidoSelected(int index) {
    if (_idPedidoSelected != index) {
      _idPedidoSelected = index;
      notifyListeners();
    }
  }

  /// Gets the ID of the current table.
  String get mesaActual => _mesaActual;

  /// Sets the ID of the current table.
  /// Notifies listeners only if the value has changed.
  set mesaActual(String index) {
    if (_mesaActual != index) {
      _mesaActual = index;
      notifyListeners();
    }
  }

  /// Provides access to the [PageController].
  PageController get pageController => _pageController;

  @override
  /// Disposes the [PageController] when the provider is no longer needed.
  /// This is crucial for preventing memory leaks.
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
