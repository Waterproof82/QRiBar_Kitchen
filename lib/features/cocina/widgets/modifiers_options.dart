import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:qribar_cocina/data/models/modifier/modifier.dart';
import 'package:qribar_cocina/features/app/providers/navegacion_provider.dart';
import 'package:qribar_cocina/shared/utils/functions.dart';

class ModifiersOptions extends StatelessWidget {
  const ModifiersOptions({
    Key? key,
    required double ancho,
    required List<Modifier> modifiers,
    String? mainModifierName,
    int? tipo,
  })  : _ancho = ancho,
        _modifiers = modifiers,
        _mainModifierName = mainModifierName,
        super(key: key);

  final double _ancho;
  final List<Modifier> _modifiers;
  final String? _mainModifierName;

  @override
  Widget build(BuildContext context) {
    final navegacionProvider = Provider.of<NavegacionProvider>(context, listen: false);

    return Column(
      children: _modifiers.where((opcion) => _shouldShowModifier(opcion, navegacionProvider)).map((opcion) => _buildModifierBox(opcion)).toList(),
    );
  }

  bool _shouldShowModifier(Modifier opcion, NavegacionProvider provider) {
    return opcion.mainProduct.isEmpty || (_mainModifierName == null || obtenerNombreProducto(provider.productos, opcion.mainProduct, true) == _mainModifierName);
  }

  Widget _buildModifierBox(Modifier opcion) {
    return Container(
      width: _ancho,
      height: 28,
      padding: const EdgeInsets.symmetric(horizontal: 2),
      decoration: _boxDecoration(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildLeadingIcon(),
          _buildText(opcion.name),
        ],
      ),
    );
  }

  BoxDecoration _boxDecoration() => const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(100)),
        boxShadow: [
          BoxShadow(
            color: Colors.black54,
            blurRadius: 5,
            spreadRadius: -5,
          ),
        ],
      );

  Widget _buildLeadingIcon() => const ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          bottomLeft: Radius.circular(10),
        ),
        child: FittedBox(
          fit: BoxFit.fitWidth,
          child: Icon(
            Icons.navigate_next,
            size: 20,
            color: Colors.red,
          ),
        ),
      );

  Widget _buildText(String text) {
    return Flexible(
      fit: FlexFit.tight,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            Text(
              text,
              maxLines: 1,
              textAlign: TextAlign.left,
              style: GoogleFonts.poiretOne(
                color: Colors.black,
                fontSize: _ancho > 450 ? 22 : 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
