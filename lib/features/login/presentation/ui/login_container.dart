import 'package:flutter/material.dart';

class LoginContainer extends StatelessWidget {
  final Widget _child;

  const LoginContainer({Key? key, required Widget child})
      : _child = child,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return _buildPadding(
      child: _buildContainer(),
    );
  }

  Padding _buildPadding({required Widget child}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: child,
    );
  }

  Container _buildContainer() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: _cardDecoration(),
      child: _child,
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(25),
      boxShadow: const [
        BoxShadow(
          color: Colors.black12,
          blurRadius: 15,
          offset: Offset(0, 10),
        ),
      ],
    );
  }
}
