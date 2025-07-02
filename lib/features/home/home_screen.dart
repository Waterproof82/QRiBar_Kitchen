import 'package:flutter/material.dart';
import 'package:qribar_cocina/features/home/widgets/custom_app_bar.dart';
import 'package:qribar_cocina/shared/utils/ui_helpers.dart';
import 'package:qribar_cocina/shared/widgets/header_wave.dart';
import 'package:qribar_cocina/shared/widgets/menu_lateral.dart';

class HomeScreen extends StatelessWidget {
  final Widget child;
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
        drawer: MenuLateral(),
        appBar: CustomAppBar(),
        body: Stack(children: [HeaderWave(), child]),
      ),
    );
  }
}
