import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qribar_cocina/app/routes/data_exports.dart';
import 'package:qribar_cocina/features/app/providers/navegacion_provider.dart';
import 'package:qribar_cocina/features/cocina/cocina_general_screen.dart';
import 'package:qribar_cocina/features/cocina/cocina_pedidos_screen.dart';
import 'package:qribar_cocina/features/home/widgets/custom_app_bar.dart';
import 'package:qribar_cocina/shared/utils/functions.dart';
import 'package:qribar_cocina/shared/widgets/header_wave.dart';
import 'package:qribar_cocina/shared/widgets/menu_lateral.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final nav = Provider.of<NavegacionProvider>(context, listen: true);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          onBackPressed(context);
        }
      },
      child: Scaffold(
        drawer: MenuLateral(nav: nav),
        appBar: CustomAppBar(nav: nav),
        body: _buildContent(nav),
      ),
    );
  }

  Widget _buildContent(NavegacionProvider nav) {
    return Stack(
      children: [
        HeaderWave(),
        if (nav.categoriaSelected == SelectionTypeEnum.pedidosScreen.path)
          CocinaPedidosScreen()
        else if (nav.categoriaSelected == SelectionTypeEnum.generalScreen.path)
          CocinaGeneralScreen()
        else
          SizedBox.shrink(),
      ],
    );
  }
}
