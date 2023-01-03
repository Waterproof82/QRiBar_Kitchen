import 'dart:math';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:qribar/models/ficha_local.dart';
import 'package:qribar/models/pedidos.dart';
import 'package:qribar/models/product.dart';

import 'package:qribar/provider/navegacion_model.dart';
import 'package:qribar/provider/products_provider.dart';

Future<void> salirApp({bool? animated}) async {
  await SystemChannels.platform.invokeMethod<void>('SystemNavigator.pop', animated);
}

Future<bool> onBackPressed(BuildContext context) async {
  return await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Container(
          child: new AlertDialog(
            alignment: Alignment.center,
            title: new Text(
              'Salir de la Carta',
              textAlign: TextAlign.center,
            ),
            content: new Text(
              '¿Quieres cerrar la aplicación?',
              textAlign: TextAlign.center,
            ),
            actions: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  new MaterialButton(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    disabledColor: Colors.grey,
                    elevation: 1,
                    color: Colors.black26,
                    onPressed: () {
                      SystemNavigator.pop();
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 8),
                      child: Text(
                        'Sí',
                        style: TextStyle(color: Color.fromARGB(255, 255, 0, 0), fontSize: 18),
                      ),
                    ),
                  ),
                  new MaterialButton(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    disabledColor: Colors.grey,
                    elevation: 1,
                    color: Colors.black26,
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 8),
                      child: Text(
                        'No',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ) ??
      false;
}
class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: capitalize(newValue.text),
      selection: newValue.selection,
    );
  }
}

String capitalize(String value) {
  if (value.trim().isEmpty) return "";
  return "${value[0].toUpperCase()}${value.substring(1).toLowerCase()}";
}

void ordenaCategorias(List<CategoriaProducto> catProductos, List<CategoriaProducto> unicaCategoriaFiltro, List<Pedidos> itemPedidos) {
  for (var i = 0; i < catProductos.length; i++) {
    catProductos.sort((a, b) => a.orden.compareTo(b.orden));
    unicaCategoriaFiltro = catProductos.toList();
  }
  for (var i = 0; i < itemPedidos.length; i++) {
    for (var ind = 0; ind < unicaCategoriaFiltro.length; ind++) {
      if (itemPedidos[i].categoriaProducto == unicaCategoriaFiltro[ind].categoria) {
        itemPedidos[i].orden = unicaCategoriaFiltro[ind].orden;
        itemPedidos[i].envio = unicaCategoriaFiltro[ind].envio;
      }
    }
  }
}

void mostrarCatSelected(List<Product> itemElemento, NavegacionModel navModel, List<Product> rstCategoria) {
  for (var i = 0; i < itemElemento.length; i++) {
    itemElemento.sort((a, b) => a.nombreProducto.compareTo(b.nombreProducto));
    if (itemElemento[i].categoriaProducto == navModel.categoriaSelected) {
      if (navModel.filtroCantidad == true && itemElemento[i].cantidad > 0) {
        rstCategoria.add(itemElemento[i]);
      } else if (navModel.filtroCantidad == false) {
        rstCategoria.add(itemElemento[i]);
      }
    }
  }
}

void mostrarTodasCategorias(List<Product> itemElemento, NavegacionModel navModel, List<Product> rstCategoria) {
  for (var i = 0; i < itemElemento.length; i++) {
    //itemElemento.sort((a, b) => a.disponible.toString().compareTo(b.disponible.toString()));
    itemElemento.sort((a, b) => a.nombreProducto.compareTo(b.nombreProducto));

    if (navModel.filtroCantidad == true && itemElemento[i].cantidad > 0) {
      rstCategoria.add(itemElemento[i]);
    } else if (navModel.filtroCantidad == false) {
      rstCategoria.add(itemElemento[i]);
    }
  }
}

void mostrarProductosOcultos(List<Product> itemElemento, NavegacionModel navModel, List<Product> rstCategoria) {
  for (var i = 0; i < itemElemento.length; i++) {
    //itemElemento.sort((a, b) => a.disponible.toString().compareTo(b.disponible.toString()));
    itemElemento.sort((a, b) => a.nombreProducto.compareTo(b.nombreProducto));

    if (itemElemento[i].disponible == false) rstCategoria.add(itemElemento[i]);
  }
}

class NotificacionPendiente extends StatelessWidget {
  const NotificacionPendiente({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final itemPedidos = Provider.of<ProductsService>(context, listen: false).pedidosRealizados;
    final navegacionModel = Provider.of<NavegacionModel>(context, listen: false);
    int cont = 0;

    for (var i = 0; i < itemPedidos.length; i++) {
      if (itemPedidos[i].estadoLinea == 'cocinado') cont++;
    }

    return Positioned(
      top: 0,
      right: 0,
      child: BounceInDown(
        //from: 5,
        //animate: (providerGeneral.numero > 0) ? true : false, //oculta si numero es 0
        child: GestureDetector(
          onTap: () => navegacionModel.categoriaSelected = 'Situación Cocina',
          child: Container(
            child: Text('$cont', style: GoogleFonts.notoSans(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
            alignment: Alignment.center,
            width: 25,
            height: 25,
            decoration: BoxDecoration(color: Color.fromARGB(255, 42, 185, 13), shape: BoxShape.circle),
          ),
        ),
      ),
    );
  }
}

class NotificacionPendienteBarra extends StatelessWidget {
  const NotificacionPendienteBarra({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final itemPedidos = Provider.of<ProductsService>(context, listen: false).pedidosRealizados;
    final navegacionModel = Provider.of<NavegacionModel>(context, listen: false);
    int cont = 0;

    for (var i = 0; i < itemPedidos.length; i++) {
      if (itemPedidos[i].envio == 'barra') cont++;
    }

    return Positioned(
      top: 0,
      right: 2,
      child: BounceInDown(
        //from: 5,
        //animate: (providerGeneral.numero > 0) ? true : false, //oculta si numero es 0
        child: GestureDetector(
          onTap: () => navegacionModel.categoriaSelected = 'Barra Estado Pedidos',
          child: Container(
            child: Text('$cont', style: GoogleFonts.notoSans(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
            alignment: Alignment.center,
            width: 25,
            height: 25,
            decoration: BoxDecoration(color: Color.fromARGB(255, 255, 0, 0), shape: BoxShape.circle),
          ),
        ),
      ),
    );
  }
}

class NotificacionPendienteSala extends StatelessWidget {
  const NotificacionPendienteSala({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //final itemPedidos = Provider.of<ProductsService>(context, listen: false).pedidosRealizados;
    final navegacionModel = Provider.of<NavegacionModel>(context, listen: false);
    //int cont = 0;
/* 
    for (var i = 0; i < itemPedidos.length; i++) {
      if (itemPedidos[i].envio == 'barra') cont++;
    } */
    // cont = navegacionModel.avisoSala;

    return Positioned(
      top: 0,
      right: 0,
      child: BounceInDown(
        //from: 5,
        //animate: (providerGeneral.numero > 0) ? true : false, //oculta si numero es 0
        child: GestureDetector(
          onTap: () => Navigator.pushNamed(context, 'salas'),
          child: Container(
            child: Text('${navegacionModel.avisoSala}', style: GoogleFonts.notoSans(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w600)),
            alignment: Alignment.center,
            width: 25,
            height: 25,
            decoration: BoxDecoration(color: Color.fromARGB(255, 234, 255, 0), shape: BoxShape.circle),
          ),
        ),
      ),
    );
  }
}

const _chars = 'ABCDEFGHJKMNPQRSTWXYZ123456789';
Random _rnd = Random();

String getRandomString(int length) => String.fromCharCodes(Iterable.generate(length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
