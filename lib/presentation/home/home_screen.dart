import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qribar_cocina/data/datasources/remote_data_source/listeners_data_source.dart';
import 'package:qribar_cocina/data/enums/selection_type.dart';
import 'package:qribar_cocina/data/extensions/build_context_extension.dart';
import 'package:qribar_cocina/presentation/cocina/cocina_general_screen.dart';
import 'package:qribar_cocina/presentation/cocina/cocina_pedidos_screen.dart';
import 'package:qribar_cocina/presentation/home/widgets/custom_app_bar.dart';
import 'package:qribar_cocina/presentation/home/widgets/menu_lateral.dart';
import 'package:qribar_cocina/providers/navegacion_model.dart';
import 'package:qribar_cocina/providers/products_provider.dart';
import 'package:qribar_cocina/services/functions.dart';
import 'package:qribar_cocina/widgets/loading_screen.dart';
import 'package:qribar_cocina/widgets/widgets_exports.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    Provider.of<ListenersDataSource>(context, listen: false).initializeListeners(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final nav = Provider.of<NavegacionModel>(context, listen: true);
    final productsService = Provider.of<ProductsService>(context, listen: false);

    final double screenWidthSize = context.width;

    if (productsService.isLoading) return LoadingScreen();
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          onBackPressed(context);
        }
      },
      child: Scaffold(
        drawer: MenuLateral(),
        appBar: CustomAppBar(nav: nav, screenWidthSize: screenWidthSize),
        body: Stack(
          children: [
            HeaderWave(),
            (nav.categoriaSelected == SelectionType.pedidosScreen.path)
                ? CocinaPedidosScreen()
                : (nav.categoriaSelected == SelectionType.generalScreen.path)
                    ? CocinaGeneralScreen()
                    : SizedBox.shrink()
          ],
        ),
      ),
    );
  }
}
