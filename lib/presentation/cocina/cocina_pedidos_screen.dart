import 'dart:collection';
import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:qribar_cocina/presentation/cocina/widgets/modifiers_options.dart';
import 'package:qribar_cocina/providers/navegacion_provider.dart';
import 'package:qribar_cocina/providers/products_provider.dart';
import 'package:qribar_cocina/routes/data_exports.dart';
import 'package:qribar_cocina/services/functions.dart';

class CocinaPedidosScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<Pedido> itemPedidos = Provider.of<ProductsService>(context, listen: false).pedidosRealizados;
    final NavegacionProvider navegacionModel = Provider.of<NavegacionProvider>(context, listen: false);

    final idMesaActual = navegacionModel.mesaActual;
    final List<Pedido> itemPedidosSelected = [];

    List<int> countMenuPedido = [];
    int contadorNumPedido = 0;
    List mesasAct = [];
    List resultMesas = [];
    if (itemPedidos.isNotEmpty) {
      mesasAct = itemPedidos.map((pedido) => pedido.mesa).toList();
      resultMesas = LinkedHashSet<String>.from(mesasAct).toList();

      itemPedidosSelected.addAll(
          itemPedidos.where((pedido) => pedido.mesa == idMesaActual && pedido.numPedido == navegacionModel.idPedidoSelected && pedido.estadoLinea != EstadoPedido.bloqueado.name));

      countMenuPedido = itemPedidos.where((pedido) => pedido.mesa == idMesaActual).map((pedido) => pedido.numPedido).toList();

      if (countMenuPedido.isNotEmpty) {
        contadorNumPedido = countMenuPedido.reduce(max);
      }
    }

    return Stack(
      children: [
        PedidosMesasListMenu(navegacionModel, resultMesas),
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
  final ScrollController _controller = ScrollController();

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
                navegacionModel.idPedidoSelected = index + 1;
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

  final ScrollController _controller = ScrollController();

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
                  color: Colors.black,
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                ),
              ),
              onPressed: () async {
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

  final NavegacionProvider navegacionModel;

  final List<Pedido> itemPedidos;

  @override
  Widget build(BuildContext context) {
    final ancho = context.width;
    // ignore: unused_local_variable
    bool notaBar = false;
    double resultPrecio = 0;

    return Container(
      color: Colors.black,
      margin: EdgeInsets.only(top: 140),
      child: ListView.builder(
        controller: navegacionModel.pageController,
        physics: BouncingScrollPhysics(),
        itemCount: itemPedidos.length,
        itemBuilder: (_, int index) {
          itemPedidos.sort((a, b) => a.orden.compareTo(b.orden));

          if (itemPedidos[index].nota != null) notaBar = true;
          return (itemPedidos[index].envio == 'cocina' && itemPedidos[index].estadoLinea != EstadoPedido.cocinado.name)
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 8),
                  child: Column(
                    children: [
                      LineaProducto(itemPedidos: itemPedidos, index: index, resultPrecio: resultPrecio),
                      if (itemPedidos[index].nota != null && itemPedidos[index].nota != '')
                        Container(
                          width: ancho,
                          decoration: BoxDecoration(
                              color: Color.fromARGB(255, 255, 255, 255),
                              borderRadius: BorderRadius.all(Radius.circular(5)),
                              boxShadow: <BoxShadow>[BoxShadow(color: Colors.black, blurRadius: 5, spreadRadius: 0)]),
                          child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.note_alt_outlined,
                                    size: 20,
                                    color: Colors.red,
                                  ),
                                  Text(' ${itemPedidos[index].nota}',
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      textAlign: TextAlign.left,
                                      style: GoogleFonts.notoSans(
                                        color: const Color.fromARGB(255, 0, 0, 0),
                                        fontSize: (ancho > 450) ? 22 : 18,
                                        fontWeight: FontWeight.w500,
                                      )),
                                ],
                              )),
                        ),
                    ],
                  ),
                )
              : SizedBox.shrink();
        },
      ),
    );
  }
}

class LineaProducto extends StatelessWidget {
  const LineaProducto({
    required this.index,
    required this.resultPrecio,
    required this.itemPedidos,
  });

  final List<Pedido> itemPedidos;
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
    final nav = Provider.of<NavegacionProvider>(context, listen: false);
    final database = FirebaseDatabase.instance;
    String idBar = IdBarDataSource.instance.getIdBar();
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
    listSelName = obtenerNombreProducto(context, itemPedidos[index].idProducto, itemPedidos[index].racion!);
    envioProd = itemPedidos[index].envio;
    estadoLinea = itemPedidos[index].estadoLinea;
    hora = (itemPedidos[index].hora.isNotEmpty) ? itemPedidos[index].hora.split(':').sublist(0, 2).join(':') : "--:--";
    pedidoNum = itemPedidos[index].numPedido;
    mesaVar = itemPedidos[index].mesa;

    return Column(
      children: [
        Container(
          width: ancho,
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
                await _dataStreamGestionPedidos.update({'estado_linea': EstadoPedido.cocinado.name});
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
                    Gap.w12,
                    Text('SE CANCELA EN BARRA',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 22,
                        )),
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
                    Text('SERVIDO',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 22,
                        )),
                    Gap.w12,
                    Icon(Icons.check_sharp, color: Colors.white, size: 22)
                  ],
                ),
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                  color: Color.fromARGB(255, 0, 0, 0),
                  border: Border.all(width: 2, color: Colors.white38),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: <BoxShadow>[BoxShadow(blurRadius: 5, spreadRadius: -5)]),
              height: alto * 0.05,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(5), bottomLeft: Radius.circular(5)),
                    child: Container(
                      width: (ancho > 450) ? 60 : 42,
                      height: double.infinity,
                      margin: EdgeInsets.only(top: 0),
                      color: Colors.red[200],
                      child: Center(
                        child: Text(
                          ' x$listSelCant ',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.notoSans(
                            fontSize: (ancho > 450) ? 28 : 20,
                            fontWeight: FontWeight.w500,
                            // backgroundColor: Colors.red[200],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    fit: FlexFit.tight,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Text(
                        ' $listSelName',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        textAlign: TextAlign.left,
                        style: GoogleFonts.notoSans(
                          color: const Color.fromARGB(255, 255, 255, 255),
                          fontSize: (ancho > 450) ? 26 : 18,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      nav.mesaActual = itemPedidos[index].mesa;
                      nav.idPedidoSelected = itemPedidos[index].numPedido;
                      nav.categoriaSelected = SelectionType.generalScreen.path;
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(topRight: Radius.circular(5), bottomRight: Radius.circular(5)),
                      child: Container(
                        height: double.infinity,
                        width: (ancho > 450) ? 120 : 80,
                        // padding: const EdgeInsets.symmetric(horizontal: 2),
                        color: Colors.red[300],
                        child: Icon(Icons.list_sharp, color: Colors.white, size: 26),
                        //  Row(
                        //   children: [
                        //     Text(
                        //       ' $hora ',
                        //       overflow: TextOverflow.ellipsis,
                        //       maxLines: 1,
                        //       textAlign: TextAlign.center,
                        //       style: GoogleFonts.notoSans(
                        //         fontSize: (ancho > 450) ? 26 : 18,
                        //         fontWeight: FontWeight.w500,
                        //       ),
                        //     )
                        //   ],
                        // ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        ModifiersOptions(
          ancho: ancho,
          modifiers: itemPedidos[index].modifiers ?? [],
          mainModifierName: listSelName,
        ),
      ],
    );
  }
}

Future<bool> onDismiss(BuildContext context, List<Pedido> itemPedidos, int index) async {
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
