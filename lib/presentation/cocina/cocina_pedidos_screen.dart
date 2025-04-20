import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:qribar_cocina/presentation/cocina/widgets/modifiers_options.dart';
import 'package:qribar_cocina/providers/bloc/listener_bloc.dart';
import 'package:qribar_cocina/providers/navegacion_provider.dart';
import 'package:qribar_cocina/routes/data_exports.dart';
import 'package:qribar_cocina/services/functions.dart';

class CocinaPedidosScreen extends StatelessWidget {
  const CocinaPedidosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final navegacionModel = Provider.of<NavegacionProvider>(context, listen: false);

    return BlocBuilder<ListenerBloc, ListenerState>(
      builder: (context, state) {
        return state.maybeWhen(
          pedidosUpdated: (pedidos) => _buildFromPedidos(
            pedidos,
            navegacionModel,
          ),
          pedidoRemoved: (pedidos) => _buildFromPedidos(
            pedidos,
            navegacionModel,
          ),
          orElse: () => const SizedBox.shrink(),
        );
      },
    );
  }

  Widget _buildFromPedidos(
    List<Pedido> pedidos,
    NavegacionProvider navegacionModel,
  ) {
    if (pedidos.isEmpty) return const SizedBox.shrink();

    final idMesaActual = navegacionModel.mesaActual;
    final idPedidoSelected = navegacionModel.idPedidoSelected;

    final resultMesas = pedidos.map((pedido) => pedido.mesa).toSet().toList();

    final itemPedidosSelected = pedidos
        .where(
          (pedido) => pedido.mesa == idMesaActual && pedido.numPedido == idPedidoSelected && pedido.estadoLinea != EstadoPedido.bloqueado.name,
        )
        .toList();

    final countMenuPedido = pedidos.where((pedido) => pedido.mesa == idMesaActual).map((pedido) => pedido.numPedido).toList();

    final contadorNumPedido = countMenuPedido.isNotEmpty ? countMenuPedido.reduce(max) : 0;

    return _buildStack(resultMesas, contadorNumPedido, navegacionModel, itemPedidosSelected);
  }

  Widget _buildStack(
    List<String> resultMesas,
    int contadorNumPedido,
    NavegacionProvider navegacionModel,
    List<Pedido> itemPedidosSelected,
  ) {
    return Stack(
      children: [
        PedidosMesasListMenu(
          navegacionModel,
          resultMesas,
        ),
        PedidosListMenu(
          navegacionModel,
          contadorNumPedido,
        ),
        ListaProductosPedidos(
          navegacionModel: navegacionModel,
          itemPedidos: itemPedidosSelected,
        ),
      ],
    );
  }
}

class PedidosListMenu extends StatelessWidget {
  PedidosListMenu(
    this.navegacionModel,
    this.count,
  );
  final NavegacionProvider navegacionModel;
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
              backgroundColor: (navegacionModel.idPedidoSelected == index + 1) ? Color.fromARGB(255, 30, 62, 97) : Colors.white,
              elevation: 1,
              heroTag: 'ListPedido$index',
              child: Text(
                'Pedido ${index + 1}',
                style: GoogleFonts.notoSans(color: (navegacionModel.idPedidoSelected == index + 1) ? Colors.white : Colors.black, fontSize: 15, fontWeight: FontWeight.w500),
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
  PedidosMesasListMenu(
    this.navegacionModel,
    this.resultMesas,
  );

  final NavegacionProvider navegacionModel;
  final List<String> resultMesas;

  final ScrollController _controller = ScrollController();

  void _goToElement(int index) {
    _controller.animateTo(
      (100.0),
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInCubic,
    );
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
          itemPedidos.sort((a, b) {
            final nombreCmp = obtenerNombreProducto(context, a.idProducto, a.racion!).compareTo(obtenerNombreProducto(context, b.idProducto, b.racion!));
            return nombreCmp != 0 ? nombreCmp : (a.modifiers ?? []).toString().compareTo((b.modifiers ?? []).toString());
          });

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

    return GestureDetector(
      onTap: () {
        context.read<ListenerBloc>().add(
              ListenerEvent.updateEnMarchaPedido(
                mesa: itemPedidos[index].mesa,
                idPedido: itemPedidos[index].id,
                enMarcha: !itemPedidos[index].enMarcha,
              ),
            );
      },
      child: Column(
        children: [
          Container(
            width: ancho,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(100)),
              boxShadow: <BoxShadow>[
                BoxShadow(color: Colors.black54, blurRadius: 5, spreadRadius: -5),
              ],
            ),
            child: Dismissible(
              key: UniqueKey(),
              onDismissed: (direction) {},
              confirmDismiss: (direction) async {
                if (direction == DismissDirection.startToEnd) {
                  return false;
                }
                if (direction == DismissDirection.endToStart) {
                  context.read<ListenerBloc>().add(
                        ListenerEvent.updateEstadoPedido(
                          mesa: itemPedidos[index].mesa,
                          idPedido: itemPedidos[index].id,
                          nuevoEstado: EstadoPedido.cocinado.name,
                        ),
                      );
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
                  color: colorLineaCocina,
                  border: Border.all(
                    width: (itemPedidos[index].enMarcha == false) ? 2 : 4,
                    color: (itemPedidos[index].enMarcha == true) ? Color.fromARGB(255, 7, 255, 19) : Colors.white,
                  ),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: <BoxShadow>[BoxShadow(blurRadius: 5, spreadRadius: -5)],
                ),
                height: alto * 0.05,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(5),
                        bottomLeft: Radius.circular(5),
                      ),
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
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(5),
                          bottomRight: Radius.circular(5),
                        ),
                        child: Container(
                          height: double.infinity,
                          width: (ancho > 450) ? 120 : 80,
                          // padding: const EdgeInsets.symmetric(horizontal: 2),
                          color: Colors.red[300],
                          child: Icon(Icons.list_sharp, color: Colors.white, size: 26),
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
      ),
    );
  }
}
