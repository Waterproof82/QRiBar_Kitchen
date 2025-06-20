import 'package:flutter/material.dart';
import 'package:qribar_cocina/app/const/app_constants.dart';

class BarraSuperiorTiempo extends StatelessWidget {
  const BarraSuperiorTiempo({Key? key, required double ancho})
      : _ancho = ancho,
        super(key: key);

  final double _ancho;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: _mainAxisAlignment(),
      children: AppConstants.tiempos.map((tiempo) => _buildTiempoBox(tiempo['texto'], tiempo['color'])).toList(),
    );
  }

  MainAxisAlignment _mainAxisAlignment() => _ancho > 420 ? MainAxisAlignment.spaceEvenly : MainAxisAlignment.spaceBetween;

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

  BoxDecoration _buildBoxDecoration(Color color) => BoxDecoration(
        color: color,
        border: Border.all(width: 2, color: Colors.white),
        borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(10)),
        boxShadow: const [
          BoxShadow(
            color: Colors.black,
            blurRadius: 15,
            spreadRadius: -5,
            offset: Offset(1, 5),
          ),
        ],
      );

  double _boxWidth() => _ancho > 420 ? 150 : 90;

  double _fontSize() => _ancho > 420 ? 24 : 18;
}
