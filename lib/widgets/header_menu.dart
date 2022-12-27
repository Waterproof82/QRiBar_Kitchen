import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
        painter: _HeaderWavePainter(Colors.black26),
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
    lapiz.strokeWidth = 20;

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

class IconHeader extends StatelessWidget {
  final IconData icon;
  final String titulo;
  final String subtitulo;
  final Color color1;
  final Color color2;

  const IconHeader({
    required this.icon,
    required this.titulo,
    required this.subtitulo,
    this.color1 = Colors.grey,
    this.color2 = Colors.blue,
  });

  @override
  Widget build(BuildContext context) {
    final Color colorBlanco = Colors.white.withOpacity(0.7);
    return Stack(
      children: <Widget>[
        _IconHeaderBackground(
          color1: this.color1,
          color2: this.color2,
        ),
        //Positioned ubica dentro de un Stack
        Positioned(
            top: 0,
            right: 20,
            //FaIcon del packete FontAwesomeIcons. Iconos curiosos
            child: FaIcon(
              this.icon,
              size: 100,
              color: Colors.white.withOpacity(0.2),
            )),
        Column(
          children: <Widget>[
            SizedBox(height: 10, width: double.infinity),
            Text(
              this.subtitulo,
              style: TextStyle(fontSize: 20, color: colorBlanco),
            ),
            SizedBox(height: 20),
            Text(
              this.titulo,
              style: TextStyle(fontSize: 20, color: colorBlanco, fontWeight: FontWeight.bold),
            ),
            FaIcon(
              this.icon,
              size: 50,
              color: Colors.white,
            )
          ],
        )
      ],
    );
  }
}

class _IconHeaderBackground extends StatelessWidget {
  final Color color1;
  final Color color2;
  const _IconHeaderBackground({
    Key? key,
    required this.color1,
    required this.color2,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        height: 150,
        //
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(80)),
          gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: <Color>[this.color1, this.color2]),
        ));
  }
}
