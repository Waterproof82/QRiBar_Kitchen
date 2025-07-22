import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qribar_cocina/data/models/modifier/modifier.dart';
import 'package:qribar_cocina/data/models/product.dart';
import 'package:qribar_cocina/features/app/bloc/listener_bloc.dart';
import 'package:qribar_cocina/shared/utils/product_utils.dart';

/// A final [StatelessWidget] that displays a list of product modifiers.
///
/// This widget filters and renders modifiers based on the main product
/// and retrieves product data from the [ListenerBloc] for filtering logic.
final class ModifiersOptions extends StatelessWidget {
  /// The width constraint used for responsive adjustments of the modifier boxes.
  final double _ancho;

  /// The list of modifiers to display.
  final List<Modifier> _modifiers;

  /// The name of the main modifier, used for filtering. Can be null.
  final String? _mainModifierName;

  /// Creates a constant instance of [ModifiersOptions].
  ///
  /// [ancho]: The width available for each modifier box.
  /// [modifiers]: The list of [Modifier] objects to potentially display.
  /// [mainModifierName]: An optional name of a main modifier to filter by.
  const ModifiersOptions({
    super.key,
    required double ancho,
    required List<Modifier> modifiers,
    String? mainModifierName,
  }) : _ancho = ancho,
       _modifiers = modifiers,
       _mainModifierName = mainModifierName;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<ListenerBloc, ListenerState, List<Product>>(
      selector: (state) => state.maybeWhen(
        // Extract the list of products from the 'data' state.
        // If not in 'data' state, return an empty list to avoid errors.
        data: (productos, pedidos, categorias) => productos,
        orElse: () => const [],
      ),
      builder: (context, productos) {
        // Filter modifiers based on the _shouldShowModifier logic.
        final filteredModifiers = _modifiers
            .where((opcion) => _shouldShowModifier(opcion, productos))
            .toList(growable: false); // Use growable: false for immutable list

        return Column(
          children: filteredModifiers
              .map(_buildModifierBox)
              .toList(growable: false),
        );
      },
    );
  }

  /// Determines if a [Modifier] should be displayed.
  ///
  /// A modifier is shown if:
  /// 1. Its `mainProduct` is empty (it's a general modifier).
  /// 2. OR, if `_mainModifierName` is null (no specific main modifier filter is applied).
  /// 3. OR, if the name of the product associated with `opcion.mainProduct`
  ///    matches `_mainModifierName`.
  bool _shouldShowModifier(Modifier opcion, List<Product> productos) {
    // If mainProduct is empty, it's a general modifier, always show.
    if (opcion.mainProduct.isEmpty) {
      return true;
    }
    // If no mainModifierName is provided to this widget, show all.
    if (_mainModifierName == null) {
      return true;
    }
    // Otherwise, check if the main product name matches the provided mainModifierName.
    // The third parameter 'true' in obtenerNombreProducto likely refers to 'isRacion'.
    return obtenerNombreProducto(productos, opcion.mainProduct, true) ==
        _mainModifierName;
  }

  /// Builds a [Container] representing a single modifier option.
  ///
  /// [opcion]: The [Modifier] object containing details for the box.
  Widget _buildModifierBox(Modifier opcion) {
    return Container(
      width: _ancho,
      height: 28,
      padding: const EdgeInsets.symmetric(horizontal: 2),
      decoration: _boxDecoration(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildLeadingIcon(), // Icon on the left
          Expanded(
            child: _buildText(opcion.name), // Text for the modifier name
          ),
        ],
      ),
    );
  }

  /// Provides the [BoxDecoration] for the modifier boxes.
  BoxDecoration _boxDecoration() => const BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.all(Radius.circular(100)),
    boxShadow: [
      BoxShadow(color: Colors.black54, blurRadius: 5, spreadRadius: -5),
    ],
  );

  /// Builds the leading icon widget for a modifier box.
  Widget _buildLeadingIcon() => const ClipRRect(
    borderRadius: BorderRadius.only(
      topLeft: Radius.circular(10),
      bottomLeft: Radius.circular(10),
    ),
    child: FittedBox(
      fit: BoxFit.fitWidth,
      child: Icon(Icons.navigate_next, size: 20, color: Colors.red),
    ),
  );

  /// Builds the text widget for a modifier name.
  ///
  /// [text]: The modifier name to display.
  Widget _buildText(String text) {
    return Text(
      text,
      maxLines: 1,
      textAlign: TextAlign.left,
      overflow: TextOverflow.ellipsis,
      style: GoogleFonts.poiretOne(
        color: Colors.black,
        fontSize: _ancho > 450 ? 22 : 16,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
