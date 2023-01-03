import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qribar/provider/navegacion_model.dart';

class HeaderWave extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final navegacionModel = Provider.of<NavegacionModel>(context, listen: false);

    return Container(
      height: 220,
      margin: EdgeInsets.only(top: 0),
      width: double.infinity,
      color: navegacionModel.colorTema,
      child: CustomPaint(
        painter: _HeaderWavePainter(Colors.blueGrey),
      ),
    );
  }
}

class _HeaderWavePainter extends CustomPainter {
  final Color color;

  _HeaderWavePainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final lapiz = new Paint();

    // Propiedades
    lapiz.color = this.color;
    lapiz.style = PaintingStyle.fill; // .fill .stroke
    lapiz.strokeWidth = 10;

    final path = new Path();

    // Dibujar con el path y el lapiz
    path.lineTo(0, size.height * 0.25);
    path.quadraticBezierTo(size.width * 0.25, size.height * 0.30, size.width * 0.5, size.height * 0.25);
    path.quadraticBezierTo(size.width * 0.75, size.height * 0.20, size.width, size.height * 0.25);
    path.lineTo(size.width, 0);

    canvas.drawPath(path, lapiz);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
