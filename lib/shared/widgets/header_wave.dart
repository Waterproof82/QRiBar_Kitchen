import 'package:flutter/material.dart';
import 'package:qribar_cocina/app/const/app_colors.dart';

/// A final [StatelessWidget] that displays a wave-shaped header.

final class HeaderWave extends StatelessWidget {
  /// Creates a constant instance of [HeaderWave].
  const HeaderWave({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220,
      margin: const EdgeInsets.only(top: 0),
      width: double.infinity,
      color: AppColors.black,
      child: CustomPaint(
        // Paints the wave shape with a specific color.
        painter: _HeaderWavePainter(AppColors.onBackground),
      ),
    );
  }
}

/// A final [CustomPainter] that draws a wave shape.
/// This painter is used by [HeaderWave] to create the visual effect.
final class _HeaderWavePainter extends CustomPainter {
  /// The color used to paint the wave.
  final Color color;

  /// Creates a constant instance of [_HeaderWavePainter].
  ///
  /// [color]: The color for the wave.
  const _HeaderWavePainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    // Define the paint properties for the wave.
    final Paint lapiz = Paint()
      ..color =
          color // Set the wave color
      ..style = PaintingStyle.fill; // Fill the shape

    // Define the path for the wave shape.
    final Path path = Path();
    path.lineTo(0, size.height * 0.25); // Start point
    path.quadraticBezierTo(
      size.width * 0.25,
      size.height * 0.30,
      size.width * 0.5,
      size.height * 0.25,
    ); // First curve
    path.quadraticBezierTo(
      size.width * 0.75,
      size.height * 0.20,
      size.width,
      size.height * 0.25,
    ); // Second curve
    path.lineTo(size.width, 0); // Close the path to the top right corner
    path.close(); // Close the path to form a complete shape

    // Draw the defined path on the canvas with the specified paint.
    canvas.drawPath(path, lapiz);
  }

  @override
  /// Indicates whether the painter should repaint.
  /// Returning `true` means it will always repaint when its dependencies change.
  bool shouldRepaint(covariant _HeaderWavePainter oldDelegate) {
    // Repaint only if the color has changed.
    return oldDelegate.color != color;
  }
}
