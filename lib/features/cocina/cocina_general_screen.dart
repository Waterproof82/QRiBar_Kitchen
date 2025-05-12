import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:qribar_cocina/app/const/globals.dart';
import 'package:qribar_cocina/app/extensions/date_time_extension.dart';
import 'package:qribar_cocina/app/extensions/repository_error_extension.dart';
import 'package:qribar_cocina/features/app/bloc/listener_bloc.dart';
import 'package:qribar_cocina/features/app/providers/navegacion_provider.dart';
import 'package:qribar_cocina/features/cocina/widgets/barra_superior_tiempo.dart';
import 'package:qribar_cocina/features/cocina/widgets/modifiers_options.dart';
import 'package:qribar_cocina/shared/app_exports.dart';

class CocinaGeneralScreen extends StatelessWidget {
  const CocinaGeneralScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ancho = context.width;

    return Stack(
      children: [
        BarraSuperiorTiempo(ancho: ancho),
        BlocBuilder<ListenerBloc, ListenerState>(
          builder: (context, state) {
            return state.maybeWhen(
              pedidosUpdated: (pedidos) => _buildContent(pedidos),
              pedidoRemoved: (pedidos) => _buildContent(pedidos),
              failure: (error) {
                // Mostrar SnackBar global
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  Globals.rootScaffoldMessengerKey.currentState?.showSnackBar(
                    SnackBar(content: Text('Error: ${error.translateError(context)}')),
                  );
                });
                return const SizedBox.shrink();
              },
              orElse: () => const SizedBox.shrink(),
            );
          },
        ),
      ],
    );
  }

  Widget _buildContent(List<Pedido> pedidos) {
    final pedidosFiltrados = pedidos
        .where(
          (item) => item.estadoLinea != EstadoPedidoEnum.bloqueado.name,
        )
        .toList();

    return ListaProductosPedidos(itemPedidos: pedidosFiltrados);
  }
}

class ListaProductosPedidos extends StatelessWidget {
  ListaProductosPedidos({Key? key, required this.itemPedidos}) : super(key: key);

  final List<Pedido> itemPedidos;

  @override
  Widget build(BuildContext context) {
    final pageController = Provider.of<NavegacionProvider>(
      context,
      listen: false,
    ).pageController;
    final ancho = context.width;
    // ignore: unused_local_variable
    bool notaBar = false;

    return Container(
      color: Colors.black,
      margin: EdgeInsets.only(top: 60),
      child: ListView.builder(
        controller: pageController,
        physics: BouncingScrollPhysics(),
        itemCount: itemPedidos.length,
        itemBuilder: (_, int index) {
          itemPedidos.sort((a, b) {
            return a.hora.compareTo(b.hora) != 0
                ? a.hora.compareTo(b.hora)
                : a.titulo!.compareTo(b.titulo!) != 0
                    ? a.titulo!.compareTo(b.titulo!)
                    : (a.modifiers ?? []).toString().compareTo((b.modifiers ?? []).toString());
          });

          if (itemPedidos[index].nota != null) notaBar = true;
          return (itemPedidos[index].estadoLinea != EstadoPedidoEnum.cocinado.name)
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 8),
                  child: Column(
                    children: [
                      LineaProducto(itemPedidos: itemPedidos, index: index),
                      if (itemPedidos[index].nota != null && itemPedidos[index].nota != '')
                        Container(
                          width: ancho,
                          padding: const EdgeInsets.symmetric(horizontal: 2),
                          height: 30,
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 255, 255, 255),
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            boxShadow: <BoxShadow>[BoxShadow(color: Colors.black, blurRadius: 5, spreadRadius: 0)],
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
                          // alignment: Alignment.center,
                        ),
                      // Extras(ancho: ancho, item: itemPedidos[index]),
                    ],
                  ),
                )
              : SizedBox.shrink();
        },
      ),
    );
  }
}

class LineaProducto extends StatefulWidget {
  const LineaProducto({
    required this.index,
    required this.itemPedidos,
  });
  final List<Pedido> itemPedidos;
  final int index;

  @override
  State<LineaProducto> createState() => _LineaProductoState();
}

class _LineaProductoState extends State<LineaProducto> {
  late DateTime now;
  late Timer timer = Timer(Duration(), () {});
  final database = FirebaseDatabase.instance;

  @override
  void initState() {
    super.initState();
    now = DateTime.now();
    timer = Timer.periodic(Duration(minutes: 1), (Timer t) {
      if (mounted) {
        setState(() {
          now = DateTime.now();
        });
      }
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final nav = Provider.of<NavegacionProvider>(context, listen: false);
    final ancho = context.width;
    final alto = context.height;

    final int listSelCant;
    final String listSelName;

    String? estadoLinea = '';
    bool rst = false;
    Color colorLineaCocina = Colors.grey;
    int pedidoNum = 0;
    String mesaVar = '';
    Color marchando = Colors.white38;
    Pedido itemPedido = widget.itemPedidos[widget.index];

    listSelCant = itemPedido.cantidad;
    listSelName = itemPedido.titulo ?? '';

    estadoLinea = itemPedido.estadoLinea;
    pedidoNum = itemPedido.numPedido;
    mesaVar = itemPedido.mesa;
    marchando = (itemPedido.enMarcha == true) ? Color.fromARGB(255, 7, 255, 19) : Colors.white;

    DateTime rstHora = DateTimeExtension.combineNowWithTime(itemPedido.hora);

    Duration diff = now.difference(rstHora);
    if (diff.inMinutes > 9 && diff.inMinutes < 21)
      colorLineaCocina = Colors.amber;
    else if (diff.inMinutes > 20 && diff.inMinutes < 31)
      colorLineaCocina = Color.fromRGBO(242, 132, 64, 1);
    else if (diff.inMinutes > 30)
      colorLineaCocina = Color.fromARGB(255, 255, 0, 0);
    else
      colorLineaCocina = Color.fromARGB(255, 0, 0, 0);

    return GestureDetector(
      onTap: () {
        context.read<ListenerBloc>().add(
              ListenerEvent.updateEnMarchaPedido(
                mesa: itemPedido.mesa,
                idPedido: itemPedido.id,
                enMarcha: !itemPedido.enMarcha,
              ),
            );
      },
      child: Column(
        children: [
          Container(
            width: ancho,
            decoration: BoxDecoration(
              color: (estadoLinea != EstadoPedidoEnum.cocinado.name) ? Color.fromARGB(255, 255, 255, 255) : Color.fromARGB(255, 23, 82, 47),
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
                    context.read<ListenerBloc>().add(
                          ListenerEvent.updateEstadoPedido(
                            mesa: itemPedido.mesa,
                            idPedido: itemPedido.id,
                            nuevoEstado: EstadoPedidoEnum.cocinado.name,
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
                        Gap.w12,
                        Icon(Icons.cancel_outlined, color: Colors.white, size: 24),
                        Gap.w12,
                        Text('SE CANCELA EN BARRA',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
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
                              fontWeight: FontWeight.w400,
                              fontSize: 22,
                            )),
                        Gap.w12,
                        Icon(Icons.check_sharp, color: Colors.white, size: 24),
                        Gap.w12,
                      ],
                    ),
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: colorLineaCocina,
                    border: Border.all(width: (itemPedido.enMarcha == false) ? 2 : 4, color: marchando),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: <BoxShadow>[BoxShadow(blurRadius: 5, spreadRadius: -5)],
                  ),
                  height: alto * 0.05,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(5), bottomLeft: Radius.circular(5)),
                        child: Container(
                          width: (ancho > 450) ? 65 : 45,
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
                      ClipRRect(
                        borderRadius: BorderRadius.only(topRight: Radius.circular(5), bottomRight: Radius.circular(5)),
                        child: Container(
                          height: double.infinity,
                          color: Colors.red[300],
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  nav.mesaActual = widget.itemPedidos[widget.index].mesa;
                                  nav.idPedidoSelected = widget.itemPedidos[widget.index].numPedido;
                                  nav.categoriaSelected = SelectionTypeEnum.pedidosScreen.path;
                                },
                                child: Container(
                                  width: (ancho > 450) ? 120 : 90,
                                  child: RichText(
                                    textAlign: TextAlign.center,
                                    maxLines: 1,
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: 'P$pedidoNum/',
                                          style: GoogleFonts.notoSans(
                                            color: Colors.black,
                                            fontSize: (ancho > 450) ? 24 : 20,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        TextSpan(
                                          text: 'M${int.parse(mesaVar)}',
                                          style: GoogleFonts.notoSans(
                                            fontSize: (ancho > 450) ? 24 : 20,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
          ),
          ModifiersOptions(
            ancho: ancho,
            modifiers: widget.itemPedidos[widget.index].modifiers ?? [],
            mainModifierName: listSelName,
          ),
        ],
      ),
    );
  }
}
