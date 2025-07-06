import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Importar provider
import 'package:qribar_cocina/app/const/app_colors.dart';
import 'package:qribar_cocina/features/home/widgets/custom_app_bar.dart';
import 'package:qribar_cocina/shared/utils/ui_helpers.dart';
import 'package:qribar_cocina/shared/widgets/custom_navigation_rail.dart';
import 'package:qribar_cocina/shared/widgets/header_wave.dart';

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

    final ValueNotifier<bool> isRailVisibleNotifier =
        Provider.of<ValueNotifier<bool>>(context);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          onBackPressed(context);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.black,
        appBar: CustomAppBar(isRailVisible: isRailVisibleNotifier),
        body: Row(
          children: [
            // Pass the ValueNotifier to control its overall visibility.
            CustomNavigationRail(isRailVisible: isRailVisibleNotifier),
            // A vertical divider for visual separation between the rail and content.
            const VerticalDivider(thickness: 1, width: 1),
            // The dynamic child content, expanded to fill the remaining space.
            Expanded(child: Stack(children: [HeaderWave(), child])),
          ],
        ),
      ),
    );
  }
}
