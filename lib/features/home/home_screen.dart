import 'package:flutter/material.dart';
import 'package:qribar_cocina/features/home/widgets/custom_app_bar.dart';
import 'package:qribar_cocina/shared/utils/ui_helpers.dart'; // Assuming onBackPressed is defined here
import 'package:qribar_cocina/shared/widgets/header_wave.dart';
import 'package:qribar_cocina/shared/widgets/menu_lateral.dart';

/// A final [StatelessWidget] that serves as the main layout for the home screen.
/// It includes a custom app bar, a side menu drawer, and a stacked body
/// with a header wave and dynamic content.
/// This widget also handles the back button press behavior.
final class HomeScreen extends StatelessWidget {
  /// The child widget to be displayed as the main content of the screen.
  final Widget child;

  /// Creates a constant instance of [HomeScreen].
  const HomeScreen({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      // Prevents the screen from being popped automatically by the system back button.
      canPop: false,
      // Callback invoked when a pop gesture or system back button is pressed.
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          onBackPressed(context);
        }
      },
      child: Scaffold(
        // Side navigation drawer.
        drawer: const MenuLateral(),
        // Custom application bar.
        appBar: const CustomAppBar(),
        // Main body content, using a Stack to layer widgets.
        body: Stack(
          children: [
            // A decorative wave header at the top of the screen.
            HeaderWave(),
            // The dynamic child content provided to this screen.
            child,
          ],
        ),
      ),
    );
  }
}
