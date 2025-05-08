import 'package:flutter/material.dart';
import 'package:qribar_cocina/app/const/app_constants.dart';

class BarraSuperiorTiempo extends StatelessWidget {
  const BarraSuperiorTiempo({Key? key, required this.ancho}) : super(key: key);

  final double ancho;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: (ancho > 420) ? MainAxisAlignment.spaceEvenly : MainAxisAlignment.spaceBetween,
      children: AppConstants.tiempos.map((tiempo) => _buildTiempoBox(tiempo['texto'], tiempo['color'])).toList(),
    );
  }

  Widget _buildTiempoBox(String texto, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        border: Border.all(width: 2, color: Colors.white),
        borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(10)),
        boxShadow: const [
          BoxShadow(color: Colors.black, blurRadius: 15, spreadRadius: -5, offset: Offset(1, 5)),
        ],
      ),
      width: (ancho > 420) ? 150 : 90,
      height: 35,
      alignment: Alignment.bottomCenter,
      child: Text(
        texto,
        style: TextStyle(fontSize: (ancho > 420) ? 24 : 18, color: Colors.white),
      ),
    );
  }
}
