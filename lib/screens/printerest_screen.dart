import 'package:qribar/models/ficha_local.dart';
import 'package:qribar/provider/products_provider.dart';

import 'package:qribar/screens/cuenta_cocina_general.dart';
import 'package:qribar/screens/cuenta_cocina_screen.dart';

import 'package:qribar/services/functions.dart';
import 'package:qribar/services/listeners.dart';

import 'package:qribar/widgets/menu_widgets.dart';
import 'package:qribar/widgets/texto_categoria_notify.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qribar/provider/navegacion_model.dart';

import 'package:qribar/screens/screens.dart';
import 'package:qribar/widgets/widgets.dart';

class PrinterestScreen extends StatelessWidget {
  static final String routeName = 'home';

  @override
  Widget build(BuildContext context) {
    final providerGeneral = Provider.of<NavegacionModel>(context);
    final productsService = Provider.of<ProductsService>(context, listen: true);

    final itemPedidos = Provider.of<ProductsService>(context, listen: false).pedidosRealizados;
    final catProductos = Provider.of<ProductsService>(context).categoriasProdLocal;

    List<CategoriaProducto> unicaCategoriaFiltro = [];

    //String clave = '';
    int cont = 0;
    int contBarra = 0;

    ordenaCategorias(catProductos, unicaCategoriaFiltro, itemPedidos);

    for (var i = 0; i < itemPedidos.length; i++) {
      if (itemPedidos[i].estadoLinea == 'cocinado') cont++;
      if (itemPedidos[i].envio == 'barra') contBarra++;
    }

    if (productsService.isLoading) return LoadingScreen();
    return WillPopScope(
      onWillPop: () => onBackPressed(context),
      child: Scaffold(
        drawer: (providerGeneral.numero == 0) ? MenuWidget() : Container(),
        appBar: AppBar(
          /* leading: IconButton(
          icon: Icon(Icons.accessible),
          onPressed: () => Scaffold.of(context).openDrawer(),
        ), */
          //foregroundColor: Colors.orange,
          toolbarHeight: 60,
          backgroundColor: Colors.black,
          // title: IconosCabecera(providerGeneral: providerGeneral, screenWidthSize: screenWidthSize, contBarra: contBarra, cont: cont),
        ),
        body: Stack(
          children: [
            HeaderWave(),
            ListenFirebase(),
            TextoCategoriaYnotificador(),
            (providerGeneral.categoriaSelected == 'Cocina Pedidos')
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
