import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:qribar_cocina/data/enums/selection_type.dart';
import 'package:qribar_cocina/data/extensions/build_context_extension.dart';
import 'package:qribar_cocina/data/models/ficha_local.dart';
import 'package:qribar_cocina/presentation/cocina/cocina_general_screen.dart';
import 'package:qribar_cocina/presentation/cocina/cocina_pedidos_screen.dart';
import 'package:qribar_cocina/presentation/home/widgets/menu_lateral.dart';
import 'package:qribar_cocina/providers/listeners_provider.dart';
import 'package:qribar_cocina/providers/navegacion_model.dart';
import 'package:qribar_cocina/providers/products_provider.dart';
import 'package:qribar_cocina/services/functions.dart';
import 'package:qribar_cocina/widgets/loading_screen.dart';
import 'package:qribar_cocina/widgets/widgets_exports.dart';

class HomeScreen extends StatefulWidget {
  static final String routeName = 'home';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    Provider.of<ListenersProvider>(context, listen: false).initializeListeners(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final providerGeneral = Provider.of<NavegacionModel>(context);
    final productsService = Provider.of<ProductsService>(context, listen: false);
    final itemPedidos = Provider.of<ProductsService>(context, listen: false).pedidosRealizados;

    final catProductos = productsService.categoriasProdLocal;
    final double screenWidthSize = context.width;

    List<CategoriaProducto> unicaCategoriaFiltro = [];

    ordenaCategorias(catProductos, unicaCategoriaFiltro, itemPedidos, productsService);

    if (productsService.isLoading) return LoadingScreen();
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          onBackPressed(context);
        }
      },
      child: Scaffold(
        drawer: (providerGeneral.numero == 0) ? MenuLateral() : Container(),
        appBar: AppBar(
          toolbarHeight: 60,
          backgroundColor: Colors.black,
          iconTheme: IconThemeData(color: Colors.white),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    '· ${providerGeneral.categoriaSelected} ·',
                    style: GoogleFonts.poiretOne(color: Color.fromARGB(255, 240, 240, 21), fontSize: (screenWidthSize > 450) ? 35 : 28, fontWeight: FontWeight.w600),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
        ),
        body: Stack(
          children: [
            HeaderWave(),
            // ListenFirebase(),
            (providerGeneral.categoriaSelected == SelectionType.pedidosScreen.path)
                ? CocinaPedidosScreen()
                : (providerGeneral.categoriaSelected == SelectionType.generalScreen.path)
                    ? CocinaGeneralScreen()
                    : SizedBox.shrink()
          ],
        ),
      ),
    );
  }
}
