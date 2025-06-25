import 'package:flutter/material.dart';

class AuthBackground extends StatelessWidget {
  final Widget _child;

  const AuthBackground({Key? key, required Widget child})
      : _child = child,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Stack(
        children: [
          _PurpleBox(),
          _HeaderIcon(),
          _child,
        ],
      ),
    );
  }
}

class _HeaderIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.only(top: 30),
        child: Icon(Icons.person_pin, color: Colors.white, size: 100),
      ),
    );
  }
}

class _PurpleBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //final height = context.height;

    return Container(
      width: double.infinity,
      // height: height * 0.8,
      decoration: _buildBoxDecoration(),
      child: Stack(
        children: [
          Positioned(top: 90, left: 30, child: _Burbuja()),
          Positioned(top: -40, left: -30, child: _Burbuja()),
          Positioned(top: -50, left: -20, child: _Burbuja()),
          Positioned(top: -50, left: 10, child: _Burbuja()),
          Positioned(top: 120, left: 20, child: _Burbuja()),
        ],
      ),
    );
  }

  BoxDecoration _buildBoxDecoration() => BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromRGBO(63, 63, 156, 1),
            Color.fromRGBO(90, 70, 178, 1),
          ],
        ),
      );
}

class _Burbuja extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: Color.fromRGBO(255, 255, 255, 0.05),
      ),
    );
  }
}
