import 'package:flutter/material.dart';
import 'package:qribar_cocina/app/const/app_constants.dart';

/// A final [StatelessWidget] that displays a responsive time bar with horizontal scroll.
///
/// This widget dynamically adjusts layout, text size, and spacing based on the
/// provided `ancho` (width), and renders time boxes using constants from [AppConstants].
final class BarraSuperiorTiempo extends StatelessWidget {
  /// The width constraint used for responsive adjustments.
  final double _ancho;

  /// Creates a constant instance of [BarraSuperiorTiempo].
  const BarraSuperiorTiempo({super.key, required double ancho})
    : _ancho = ancho;

  @override
  Widget build(BuildContext context) {
    final tiempoWidgets = AppConstants.tiempos.map((tiempo) {
      final String texto = tiempo['texto'] as String;
      final Color color = tiempo['color'] as Color;
      return _buildTiempoBox(texto, color);
    }).toList();

    final childrenWithSpacing = <Widget>[];
    for (int i = 0; i < tiempoWidgets.length; i++) {
      childrenWithSpacing.add(tiempoWidgets[i]);
      if (i != tiempoWidgets.length - 1) {
        childrenWithSpacing.add(SizedBox(width: _spacing()));
      }
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: _horizontalPadding()),
      child: Row(children: childrenWithSpacing),
    );
  }

  double _spacing() => _ancho > 420 ? 24 : 12;

  double _horizontalPadding() => _ancho > 420 ? 16 : 8;

  Widget _buildTiempoBox(String texto, Color color) {
    return Container(
      decoration: _buildBoxDecoration(color),
      width: _boxWidth(),
      height: 35,
      alignment: Alignment.bottomCenter,
      child: Text(
        texto,
        style: TextStyle(fontSize: _fontSize(), color: Colors.white),
      ),
    );
  }

  /// Builds the [BoxDecoration] for a time box.
  ///
  /// [color]: The fill color for the box.
  /// Note: The first color in AppConstants.tiempos is Color.fromARGB(0, 255, 255, 255)
  /// which is fully transparent. This will result in an invisible box with a white border.
  BoxDecoration _buildBoxDecoration(Color color) => BoxDecoration(
    color: color,
    border: Border.all(width: 2, color: Colors.white),
    borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(10)),
    boxShadow: const [
      BoxShadow(
        blurRadius: 15,
        spreadRadius: -5,
        offset: Offset(1, 5),
      ),
    ],
  );

  /// Calculates the width of a time box based on the total width.
  double _boxWidth() => _ancho > 420 ? 150 : 90;

  /// Calculates the font size for the text inside a time box based on the total width.
  double _fontSize() => _ancho > 420 ? 24 : 18;
}
