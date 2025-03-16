import 'dart:collection';
import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:qribar_cocina/data/const/estado_pedido.dart';
import 'package:qribar_cocina/data/enums/selection_type.dart';
import 'package:qribar_cocina/data/extensions/build_context_extension.dart';
import 'package:qribar_cocina/data/models/pedidos.dart';
import 'package:qribar_cocina/presentation/cocina/widgets/modifiers_items.dart';
import 'package:qribar_cocina/providers/listeners_provider.dart';
import 'package:qribar_cocina/providers/navegacion_model.dart';
import 'package:qribar_cocina/providers/products_provider.dart';
import 'package:qribar_cocina/services/functions.dart';

class CocinaPedidosScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Provider.of<ListenersProvider>(context, listen: true); //Actualiza el estado de los pedidos

    final itemPedidos = Provider.of<ProductsService>(context, listen: false).pedidosRealizados;
    final navegacionModel = Provider.of<NavegacionModel>(context, listen: false);

    final idMesaActual = navegacionModel.mesaActual;
    final List<Pedidos> itemPedidosSelected = [];

    ordenaCategorias(context, itemPedidos);

    List<int> countMenuPedido = [];
    int contadorNumPedido = 0;
    List mesasAct = [];
    List resultMesas = [];
    if (itemPedidos.isNotEmpty) {
      mesasAct = itemPedidos.map((pedido) => pedido.mesa).toList();
      resultMesas = LinkedHashSet<String>.from(mesasAct).toList();

      itemPedidosSelected.addAll(itemPedidos.where((pedido) => pedido.mesa == idMesaActual && pedido.numPedido == navegacionModel.idPedidoSelected));

      countMenuPedido = itemPedidos.where((pedido) => pedido.mesa == idMesaActual).map((pedido) => pedido.numPedido).toList();

      if (countMenuPedido.isNotEmpty) {
        contadorNumPedido = countMenuPedido.reduce(max);
      }
    }

    return Stack(
      children: [
        if (navegacionModel.numero == 0) PedidosMesasListMenu(navegacionModel, resultMesas),
        PedidosListMenu(navegacionModel.idPedidoSelected, navegacionModel, contadorNumPedido),
        ListaProductosPedidos(navegacionModel: navegacionModel, itemPedidos: itemPedidosSelected),
      ],
    );
  }
}

class PedidosListMenu extends StatelessWidget {
  PedidosListMenu(this.idPedido, this.navegacionModel, this.count);
  final int idPedido;
  final navegacionModel;
  final int count;
  final ScrollController _controller = new ScrollController();

  void _goToElemento(int index) {
    _controller.animateTo((100.0 * index), duration: const Duration(milliseconds: 100), curve: Curves.easeIn);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 70),
      height: 50,
      child: ListView.builder(
        itemCount: count,
        controller: _controller,
        reverse: false,
        scrollDirection: Axis.horizontal,
        physics: BouncingScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          return Container(
            width: 100,
            margin: EdgeInsets.only(right: 5, left: 10),
            decoration: BoxDecoration(
              border: Border.all(width: 1, color: Colors.black26),
              borderRadius: BorderRadius.circular(10),
            ),
            child: FloatingActionButton(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              backgroundColor: (idPedido == index + 1) ? Color.fromARGB(255, 30, 62, 97) : Colors.white,
              elevation: 1,
              heroTag: 'ListPedido$index',
              child: Text(
                'Pedido ${index + 1}',
                style: GoogleFonts.notoSans(color: (idPedido == index + 1) ? Colors.white : Colors.black, fontSize: 15, fontWeight: FontWeight.w500),
              ),
              onPressed: () {
                if (navegacionModel.numero == 0) navegacionModel.idPedidoSelected = index + 1;
                _goToElemento(index);
              },
            ),
          );
        },
      ),
    );
  }
}

class PedidosMesasListMenu extends StatelessWidget {
  PedidosMesasListMenu(this.navegacionModel, this.resultMesas);

  final navegacionModel;
  final resultMesas;

  final ScrollController _controller = new ScrollController();

  void _goToElement(int index) {
    _controller.animateTo((100.0), duration: const Duration(milliseconds: 200), curve: Curves.easeInCubic);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 5),
      height: 50,
      child: ListView.builder(
        itemCount: resultMesas.length,
        controller: _controller,
        reverse: false,
        scrollDirection: Axis.horizontal,
        physics: BouncingScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          return Container(
            width: 100,
            margin: EdgeInsets.only(right: 5, left: 10),
            decoration: BoxDecoration(
              border: Border.all(width: 1, color: Colors.black26),
              borderRadius: BorderRadius.circular(10),
            ),
            child: FloatingActionButton(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              backgroundColor: (navegacionModel.mesaActual == resultMesas[index]) ? Colors.greenAccent : Colors.white,
              elevation: 1,
              heroTag: 'ListPedidoMesas$index',
              child: Text(
                'Mesa ${int.parse(resultMesas[index])}',
                style: GoogleFonts.notoSans(
                  color: (navegacionModel.idPedidoSelectedMesas == index + 1) ? Colors.black : Colors.black,
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                ),
              ),
              onPressed: () async {
                if (navegacionModel.numero == 0) navegacionModel.idPedidoSelectedMesas = (index + 1).toString();
                navegacionModel.mesaActual = resultMesas[index];
                navegacionModel.idPedidoSelected = 1;
                _goToElement(index);
              },
            ),
          );
        },
      ),
    );
  }
}

class ListaProductosPedidos extends StatelessWidget {
  ListaProductosPedidos({
    Key? key,
    required this.navegacionModel,
    required this.itemPedidos,
  }) : super(key: key);

  final NavegacionModel navegacionModel;

  final List<Pedidos> itemPedidos;

  @override
  Widget build(BuildContext context) {
    
    final ancho = context.width;
    // ignore: unused_local_variable
    bool notaBar = false;
    double resultPrecio = 0;

    return Container(
      color: navegacionModel.colorTema,
      margin: EdgeInsets.only(top: 140),
      child: ListView.builder(
        controller: navegacionModel.pageController,
        physics: BouncingScrollPhysics(),
        itemCount: itemPedidos.length,
        itemBuilder: (_, int index) {
          itemPedidos.sort((a, b) => a.orden.compareTo(b.orden));

          if (itemPedidos[index].nota != null) notaBar = true;
          return (navegacionModel.numero == 0 && itemPedidos[index].envio == 'cocina' && itemPedidos[index].estadoLinea != EstadoPedido.cocinado)
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  child: Column(
                    children: [
                      LineaProducto(itemPedidos: itemPedidos, index: index, resultPrecio: resultPrecio),
                      if (itemPedidos[index].nota != null && itemPedidos[index].nota != '')
                        Container(
                          width: ancho * 0.85,
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              color: Color.fromARGB(255, 230, 145, 145),
                              borderRadius: BorderRadius.all(Radius.circular(100)),
                              boxShadow: <BoxShadow>[BoxShadow(color: Colors.black, blurRadius: 5, spreadRadius: 0)]),
                          child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Text('${itemPedidos[index].nota}',
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  textAlign: TextAlign.left,
                                  style: GoogleFonts.notoSans(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w500))),
                          alignment: Alignment.center,
                        ),
                      Extras(ancho: ancho, item: itemPedidos[index]),
                    ],
                  ),
                )
              : SizedBox.shrink();
        },
      ),
    );
  }
}

class Extras extends StatelessWidget {
  const Extras({
    Key? key,
    required this.ancho,
    required this.item,
  }) : super(key: key);

  final double ancho;
  final Pedidos item;

  @override
  Widget build(BuildContext context) {
    List<String> nuevaListaCorregida = [];
    item.notaExtra!.forEach((cadena) {
      nuevaListaCorregida.add(cadena);
    });

    return (nuevaListaCorregida.length > 0)
        ? Container(
            width: ancho * 0.95,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(100)),
                boxShadow: <BoxShadow>[BoxShadow(color: Colors.redAccent, blurRadius: 5, spreadRadius: -5)]),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Text(('  ${nuevaListaCorregida.join(', ')}'),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.notoSans(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w500)),
            ),
          )
        : SizedBox.shrink();
  }
}

class LineaProducto extends StatelessWidget {
  const LineaProducto({
    required this.index,
    required this.resultPrecio,
    required this.itemPedidos,
  });

  final List<Pedidos> itemPedidos;
  final int index;
  final double resultPrecio;
  static Color colorLineaSinApuntar = Colors.white;
  static Color colorLineaCocina = Colors.grey;
  static String categoriaProd = '';
  static String envioProd = 'barra';
  static String hora = '';
  static int pedidoNum = 0;
  static String mesaVar = '';

  @override
  Widget build(BuildContext context) {
    final nav = Provider.of<NavegacionModel>(context,listen: false);
    final productsService = Provider.of<ProductsService>(context, listen: false);
    final database = FirebaseDatabase.instance;
    String idBar = productsService.idBar;
    String mesa = nav.mesaActual;

    DatabaseReference _dataStreamGestionPedidos = database.ref('gestion_pedidos/$idBar/$mesa/${itemPedidos[index].id}');
    final ancho = context.width;
    final alto = context.height;
    final int listSelCant;
    final String listSelName;
    // ignore: unused_local_variable
    String? estadoLinea = '';
    bool rst = false;

    listSelCant = itemPedidos[index].cantidad;
    listSelName = obtenerNombreProducto(context, itemPedidos[index].idProducto!, itemPedidos[index].racion!);
    envioProd = itemPedidos[index].envio!;
    estadoLinea = itemPedidos[index].estadoLinea ?? '';
    hora = (itemPedidos[index].hora.isNotEmpty) ? itemPedidos[index].hora.split(':').sublist(0, 2).join(':') : "--:--";
    pedidoNum = itemPedidos[index].numPedido;
    mesaVar = itemPedidos[index].mesa;

    return Column(
      children: [
        Container(
          width: ancho * 0.95,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(100)),
            boxShadow: <BoxShadow>[BoxShadow(color: Colors.black54, blurRadius: 5, spreadRadius: -5)],
          ),
          child: Dismissible(
            key: UniqueKey(),
            onDismissed: (direction) {},
            confirmDismiss: (direction) async {
              if (direction == DismissDirection.startToEnd) {
                return false;
              }
              if (direction == DismissDirection.endToStart) {
                await _dataStreamGestionPedidos.update({'estado_linea': EstadoPedido.cocinado});
              }

              return rst;
            },
            background: Container(
              color: Colors.redAccent,
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.cancel_outlined, color: Colors.white, size: 22),
                    SizedBox(width: 10),
                    Text('SE CANCELA EN BARRA', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
            ),
            secondaryBackground: Container(
              color: Colors.green,
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text('SERVIDO', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500)),
                    SizedBox(width: 10),
                    Icon(Icons.check_sharp, color: Colors.white, size: 22)
                  ],
                ),
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(15)),
              child: Container(
                decoration: BoxDecoration(
                    color: (envioProd == 'barra') ? Color.fromARGB(0, 255, 255, 255) : nav.colorPed,
                    border: Border.all(width: 2, color: Colors.white38),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: <BoxShadow>[BoxShadow(blurRadius: 5, spreadRadius: -5)]),
                height: alto * 0.06,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(15), bottomLeft: Radius.circular(15)),
                      child: Container(
                          child: Text(
                        ' x$listSelCant ',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        textAlign: TextAlign.left,
                        style: GoogleFonts.notoSans(color: Colors.black, fontSize: (ancho > 450) ? 26 : 20, fontWeight: FontWeight.w500, backgroundColor: Colors.red[200]),
                      )),
                    ),
                    Flexible(
                      fit: FlexFit.tight,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text(' $listSelName',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            textAlign: TextAlign.left,
                            style: GoogleFonts.poiretOne(
                                color: (envioProd == 'barra') ? Colors.black : Colors.white,
                                fontSize: (ancho > 450) ? 26 : 20,
                                fontWeight: FontWeight.bold,
                                backgroundColor: Colors.transparent)),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        nav.mesaActual = itemPedidos[index].mesa;
                        nav.idPedidoSelected = itemPedidos[index].numPedido;
                        nav.categoriaSelected = SelectionType.generalScreen.path;
                      },
                      child: SizedBox(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Row(
                            children: [
                              Text(
                                ' $hora ',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                textAlign: TextAlign.left,
                                style: GoogleFonts.poiretOne(
                                  color: Color.fromARGB(255, 255, 94, 1),
                                  fontSize: (ancho > 450) ? 26 : 20,
                                  fontWeight: FontWeight.w600,
                                  backgroundColor: Colors.transparent,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        ModifiersItems(ancho: ancho, modifiers: itemPedidos[index].modifiers ?? []),
      ],
    );
  }
}

Future<bool> onDismiss(BuildContext context, List<Pedidos> itemPedidos, int index) async {
  return await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Container(
          child: AlertDialog(
            alignment: Alignment.center,
            title: Text(
              'Eliminando pedido...',
              textAlign: TextAlign.center,
            ),
            content: Text("¿Cancelar la línea  x${itemPedidos[index].cantidad}  ${itemPedidos[index].titulo}?"),
            actions: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  MaterialButton(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    disabledColor: Colors.grey,
                    elevation: 1,
                    color: Colors.black26,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 8),
                      child: Text('Sí', style: TextStyle(color: Colors.white, fontSize: 18)),
                    ),
                  ),
                  MaterialButton(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    disabledColor: Colors.grey,
                    elevation: 1,
                    color: Colors.black26,
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 8),
                      child: Text('No', style: TextStyle(color: Colors.white, fontSize: 18)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ) ??
      true;
}
