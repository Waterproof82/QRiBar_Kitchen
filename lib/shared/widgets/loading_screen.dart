import 'package:flutter/material.dart';
import 'package:qribar_cocina/app/const/app_colors.dart';

/// A final [StatelessWidget] that displays a simple loading screen.
/// It includes an AppBar and a centered circular progress indicator.
final class LoadingScreen extends StatelessWidget {
  /// Creates a constant instance of [LoadingScreen].
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.black,
        title: const Text(
          'QR iBar Cocina',
          style: TextStyle(color: AppColors.onPrimary),
        ),
      ),
      body: const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      ),
    );
  }
}
