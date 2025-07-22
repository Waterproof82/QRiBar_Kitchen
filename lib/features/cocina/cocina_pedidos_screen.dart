import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:qribar_cocina/features/app/bloc/listener_bloc.dart';
import 'package:qribar_cocina/features/app/providers/navegacion_provider.dart';
import 'package:qribar_cocina/features/cocina/widgets/modifiers_options.dart';
import 'package:qribar_cocina/features/cocina/widgets/pedido_dismissible.dart';
import 'package:qribar_cocina/shared/app_exports.dart';

final class CocinaPedidosScreen extends StatelessWidget {
  const CocinaPedidosScreen({Key? key, this.extra}) : super(key: key);

  final dynamic extra;
  @override
  Widget build(BuildContext context) {
    final navegacionModel = Provider.of<NavigationProvider>(context);

    return BlocBuilder<ListenerBloc, ListenerState>(
      builder: (context, state) {
        return state.maybeWhen(
          data: (productos, pedidos, categorias) =>
              _buildFromPedidos(pedidos, navegacionModel),
          orElse: () => const SizedBox.shrink(),
        );
      },
    );
  }

  Widget _buildFromPedidos(
    List<Pedido> pedidos,
    NavigationProvider navegacionModel,
  ) {
    if (pedidos.isEmpty) return const SizedBox.shrink();

    final idMesaActual = navegacionModel.mesaActual;
    final idPedidoSelected = navegacionModel.idPedidoSelected;

    final resultMesas = pedidos.map((pedido) => pedido.mesa).toSet().toList();

    final itemPedidosSelected = pedidos
        .where(
          (pedido) =>
              pedido.mesa == idMesaActual &&
              pedido.numPedido == idPedidoSelected &&
              pedido.estadoLinea != EstadoPedidoEnum.bloqueado.name &&
              pedido.envio == 'cocina',
        )
        .toList();

    final countMenuPedido = pedidos
        .where((pedido) => pedido.mesa == idMesaActual)
        .map((pedido) => pedido.numPedido)
        .toList();

    final contadorNumPedido = countMenuPedido.isNotEmpty
        ? countMenuPedido.reduce(max)
        : 0;

    return _buildStack(
      resultMesas,
      contadorNumPedido,
      navegacionModel,
      itemPedidosSelected,
    );
  }

  Widget _buildStack(
    List<String> resultMesas,
    int contadorNumPedido,
    NavigationProvider navegacionModel,
    List<Pedido> itemPedidosSelected,
  ) {
    return Stack(
      children: [
        PedidosMesasListMenu(navegacionModel, resultMesas),
        PedidosListMenu(navegacionModel, contadorNumPedido),
        ListaProductosPedidos(
          navegacionModel: navegacionModel,
          itemPedidos: itemPedidosSelected,
        ),
      ],
    );
  }
}

class PedidosListMenu extends StatelessWidget {
  PedidosListMenu(this.navegacionModel, this.count);
  final NavigationProvider navegacionModel;
  final int count;
  final ScrollController _controller = ScrollController();

  void _goToElemento(int index) {
    _controller.animateTo(
      (100.0 * index),
      duration: const Duration(milliseconds: 100),
      curve: Curves.easeIn,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 70),
      height: 50,
      child: ListView.builder(
        itemCount: count,
        controller: _controller,
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          return Container(
            width: 100,
            margin: const EdgeInsets.only(right: 5, left: 10),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black26),
              borderRadius: BorderRadius.circular(10),
            ),
            child: FloatingActionButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              backgroundColor: (navegacionModel.idPedidoSelected == index + 1)
                  ? const Color.fromARGB(255, 30, 62, 97)
                  : Colors.white,
              elevation: 1,
              heroTag: 'ListPedido$index',
              child: Text(
                'Pedido ${index + 1}',
                style: GoogleFonts.notoSans(
                  color: (navegacionModel.idPedidoSelected == index + 1)
                      ? Colors.white
                      : Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
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

  final NavigationProvider navegacionModel;
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
      margin: const EdgeInsets.only(top: 5),
      height: 50,
      child: ListView.builder(
        itemCount: resultMesas.length,
        controller: _controller,
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          return Container(
            width: 100,
            margin: const EdgeInsets.only(right: 5, left: 10),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black26),
              borderRadius: BorderRadius.circular(10),
            ),
            child: FloatingActionButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              backgroundColor:
                  (navegacionModel.mesaActual == resultMesas[index])
                  ? Colors.greenAccent
                  : Colors.white,
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
  const ListaProductosPedidos({
    Key? key,
    required this.navegacionModel,
    required this.itemPedidos,
  }) : super(key: key);

  final NavigationProvider navegacionModel;
  final List<Pedido> itemPedidos;

  @override
  Widget build(BuildContext context) {
    final ancho = context.width;
    // ignore: unused_local_variable
    bool notaBar = false;
    const double resultPrecio = 0;

    return Container(
      color: Colors.black,
      margin: const EdgeInsets.only(top: 140),
      child: ListView.builder(
        controller: navegacionModel.pageController,
        physics: const BouncingScrollPhysics(),
        itemCount: itemPedidos.length,
        itemBuilder: (_, int index) {
          itemPedidos.sort((a, b) {
            final nombreCmp = a.titulo!.compareTo(b.titulo!);
            return nombreCmp != 0
                ? nombreCmp
                : (a.modifiers ?? []).toString().compareTo(
                    (b.modifiers ?? []).toString(),
                  );
          });

          if (itemPedidos[index].nota != null) notaBar = true;
          return (itemPedidos[index].estadoLinea !=
                  EstadoPedidoEnum.cocinado.name)
              ? Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 2,
                    vertical: 8,
                  ),
                  child: Column(
                    children: [
                      LineaProducto(
                        itemPedidos: itemPedidos,
                        index: index,
                        resultPrecio: resultPrecio,
                      ),
                      if (itemPedidos[index].nota != null &&
                          itemPedidos[index].nota != '')
                        Container(
                          width: ancho,
                          decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 255, 255, 255),
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            boxShadow: <BoxShadow>[BoxShadow(blurRadius: 5)],
                          ),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.note_alt_outlined,
                                  size: 20,
                                  color: Colors.red,
                                ),
                                Text(
                                  ' ${itemPedidos[index].nota}',
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  textAlign: TextAlign.left,
                                  style: GoogleFonts.notoSans(
                                    color: const Color.fromARGB(255, 0, 0, 0),
                                    fontSize: (ancho > 450) ? 22 : 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                )
              : const SizedBox.shrink();
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
    final ancho = context.width;
    final alto = context.height;
    final int listSelCant;
    final String listSelName;

    final bool enMarcha = itemPedidos[index].enMarcha;
    final Color marchando = enMarcha
        ? const Color.fromARGB(255, 7, 255, 19)
        : Colors.white;

    listSelCant = itemPedidos[index].cantidad;
    listSelName = itemPedidos[index].titulo ?? '';
    envioProd = itemPedidos[index].envio;
    hora = (itemPedidos[index].hora.isNotEmpty)
        ? itemPedidos[index].hora.split(':').sublist(0, 2).join(':')
        : '--:--';
    pedidoNum = itemPedidos[index].numPedido;
    mesaVar = itemPedidos[index].mesa;

    return GestureDetector(
      onTap: () {
        context.read<ListenerBloc>().add(
          ListenerEvent.updateEnMarchaPedido(
            mesa: itemPedidos[index].mesa,
            idPedido: itemPedidos[index].id,
            enMarcha: !enMarcha,
          ),
        );
      },
      child: Column(
        children: [
          Container(
            width: ancho,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(100)),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.black54,
                  blurRadius: 5,
                  spreadRadius: -5,
                ),
              ],
            ),
            child: PedidoDismissible(
              itemPedido: itemPedidos[index],
              listSelCant: listSelCant,
              listSelName: listSelName,
              pedidoNum: pedidoNum,
              mesaVar: mesaVar,
              enMarcha: itemPedidos[index].enMarcha,
              ancho: ancho,
              alto: alto,
              colorLineaCocina: colorLineaCocina,
              marchando: marchando,
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
