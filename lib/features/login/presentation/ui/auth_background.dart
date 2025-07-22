import 'package:flutter/material.dart';

/// A final [StatelessWidget] that provides a common background for authentication screens.
/// It layers a decorative purple box, a header icon, and a child widget.
final class AuthBackground extends StatelessWidget {
  /// The main content widget to be displayed on top of the background.
  final Widget _child;

  /// Creates a constant instance of [AuthBackground].
  ///
  /// [child]: The widget to be placed as the foreground content.
  const AuthBackground({super.key, required Widget child}) : _child = child;

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Stack(
        children: [
          // The decorative purple background box with bubbles.
          const _PurpleBox(),
          // The icon displayed at the top of the background.
          const _HeaderIcon(),
          // The main content of the authentication screen.
          _child,
        ],
      ),
    );
  }
}

/// A final [StatelessWidget] that displays a person icon in the header.
final class _HeaderIcon extends StatelessWidget {
  /// Creates a constant instance of [_HeaderIcon].
  const _HeaderIcon();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(top: 30),
        child: const Icon(Icons.person_pin, color: Colors.white, size: 100),
      ),
    );
  }
}

/// A final [StatelessWidget] that creates the purple background box with decorative bubbles.
final class _PurpleBox extends StatelessWidget {
  /// Creates a constant instance of [_PurpleBox].
  const _PurpleBox();

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;

    return Container(
      width: double.infinity,
      height: screenHeight,
      decoration: _buildBoxDecoration(),
      child: const Stack(
        children: [
          Positioned(bottom: 50, left: 30, child: _Burbuja()),
          Positioned(bottom: 70, left: 80, child: _Burbuja()),
          Positioned(bottom: 90, left: 50, child: _Burbuja()),
          Positioned(top: 150, left: 10, child: _Burbuja()),
          Positioned(top: 100, left: 120, child: _Burbuja()),
          Positioned(top: 50, left: 180, child: _Burbuja()),
          Positioned(top: 20, left: 230, child: _Burbuja()),
          Positioned(top: 0, left: 100, child: _Burbuja()),
        ],
      ),
    );
  }

  /// Builds the [BoxDecoration] for the purple background box.
  BoxDecoration _buildBoxDecoration() => const BoxDecoration(
    gradient: LinearGradient(
      colors: [Color.fromRGBO(63, 63, 156, 1), Color.fromRGBO(90, 70, 178, 1)],
    ),
  );
}

/// A final [StatelessWidget] that represents a single decorative bubble.
final class _Burbuja extends StatelessWidget {
  const _Burbuja();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: const Color.fromRGBO(255, 255, 255, 0.05),
      ),
    );
  }
}
