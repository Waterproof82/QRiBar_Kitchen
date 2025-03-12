import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:qribar_cocina/models/ficha_local.dart';
import 'package:qribar_cocina/provider/navegacion_model.dart';
import 'package:qribar_cocina/provider/products_provider.dart';
import 'package:qribar_cocina/screens/cuenta_cocina_general.dart';
import 'package:qribar_cocina/screens/cuenta_cocina_screen.dart';
import 'package:qribar_cocina/screens/screens.dart';
import 'package:qribar_cocina/services/functions.dart';
import 'package:qribar_cocina/services/listeners.dart';
import 'package:qribar_cocina/widgets/menu_widgets.dart';
import 'package:qribar_cocina/widgets/widgets.dart';

class PrinterestScreen extends StatelessWidget {
  static final String routeName = 'home';

  @override
  Widget build(BuildContext context) {
    final providerGeneral = Provider.of<NavegacionModel>(context);
    final productsService = Provider.of<ProductsService>(context, listen: true);

    final itemPedidos = Provider.of<ProductsService>(context, listen: false).pedidosRealizados;
    final catProductos = productsService.categoriasProdLocal;
    final double screenWidthSize = MediaQuery.of(context).size.width;

    List<CategoriaProducto> unicaCategoriaFiltro = [];

    ordenaCategorias(catProductos, unicaCategoriaFiltro, itemPedidos, productsService);

    if (productsService.isLoading) return LoadingScreen();
    return WillPopScope(
      onWillPop: () => onBackPressed(context),
      child: Scaffold(
        drawer: (providerGeneral.numero == 0) ? MenuWidget() : Container(),
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
            ListenFirebase(),
            (providerGeneral.categoriaSelected == 'Cocina Pedidos Por Mesa')
                ? CuentaCocinaScreen()
                : (providerGeneral.categoriaSelected == 'Cocina Estado Pedidos')
                    ? CuentaCocinaGeneralScreen()
                    : Container()
          ],
        ),
      ),
    );
  }
}
