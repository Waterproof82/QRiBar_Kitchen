import 'package:flutter/material.dart';
import 'package:qribar_cocina/app/const/app_colors.dart';
import 'package:qribar_cocina/features/home/widgets/custom_app_bar.dart';
import 'package:qribar_cocina/shared/utils/ui_helpers.dart';
import 'package:qribar_cocina/shared/widgets/header_wave.dart';
import 'package:qribar_cocina/shared/widgets/navigation_rail/custom_navigation_rail.dart';

/// A final [StatelessWidget] that serves as the main layout for the home screen.
/// It includes a custom app bar, a persistent side navigation rail, and dynamic content.
/// This widget also handles the back button press behavior.
final class HomeScreen extends StatelessWidget {
  /// The child widget to be displayed as the main content of the screen.
  final Widget child;

  /// Creates a constant instance of [HomeScreen].
  const HomeScreen({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          onBackPressed(context);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.black,
        appBar: const CustomAppBar(),
        body: Row(
          children: [
            const CustomNavigationRail(),
            // The dynamic child content, expanded to fill the remaining space.
            Expanded(child: Stack(children: [const HeaderWave(), child])),
          ],
        ),
      ),
    );
  }
}
