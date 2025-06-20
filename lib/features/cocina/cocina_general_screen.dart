import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:qribar_cocina/app/const/globals.dart';
import 'package:qribar_cocina/app/extensions/date_time_extension.dart';
import 'package:qribar_cocina/app/extensions/repository_error_extension.dart';
import 'package:qribar_cocina/app/types/repository_error.dart';
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
          builder: (context, state) => _handleState(context, state),
        ),
      ],
    );
  }

  Widget _handleState(BuildContext context, ListenerState state) {
    return state.maybeWhen(
      pedidosUpdated: _buildPedidos,
      pedidoRemoved: _buildPedidos,
      failure: (error) {
        _showError(context, error);
        return const SizedBox.shrink();
      },
      orElse: () => const SizedBox.shrink(),
    );
  }

  void _showError(BuildContext context, RepositoryError error) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final messenger = Globals.rootScaffoldMessengerKey.currentState;
      if (messenger?.mounted ?? false) {
        messenger!.showSnackBar(
          SnackBar(content: Text('Error: ${error.translateError(context)}')),
        );
      }
    });
  }

  Widget _buildPedidos(List<Pedido> pedidos) {
    final pedidosFiltrados = pedidos
        .where(
          (p) => p.estadoLinea != EstadoPedidoEnum.bloqueado.name,
        )
        .toList();

    return ListaProductosPedidos(itemPedidos: pedidosFiltrados);
  }
}

class ListaProductosPedidos extends StatelessWidget {
  const ListaProductosPedidos({
    Key? key,
    required this.itemPedidos,
  }) : super(key: key);

  final List<Pedido> itemPedidos;

  @override
  Widget build(BuildContext context) {
    final pageController = context.read<NavegacionProvider>().pageController;
    final ancho = context.width;

    final pedidosOrdenados = [...itemPedidos]..sort((a, b) {
        final horaCompare = a.hora.compareTo(b.hora);
        if (horaCompare != 0) return horaCompare;

        final tituloCompare = a.titulo?.compareTo(b.titulo ?? '') ?? 0;
        if (tituloCompare != 0) return tituloCompare;

        return (a.modifiers ?? []).toString().compareTo((b.modifiers ?? []).toString());
      });

    return Container(
      color: Colors.black,
      margin: const EdgeInsets.only(top: 60),
      child: ListView.builder(
        controller: pageController,
        physics: const BouncingScrollPhysics(),
        itemCount: pedidosOrdenados.length,
        itemBuilder: (_, index) {
          final pedido = pedidosOrdenados[index];

          if (pedido.estadoLinea == EstadoPedidoEnum.cocinado.name) {
            return const SizedBox.shrink();
          }

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 8),
            child: Column(
              children: [
                LineaProducto(itemPedidos: pedidosOrdenados, index: index),
                if (pedido.nota != null && pedido.nota!.trim().isNotEmpty) _NotaBar(pedido.nota!, ancho),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _NotaBar extends StatelessWidget {
  final String nota;
  final double ancho;

  const _NotaBar(this.nota, this.ancho);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ancho,
      height: 30,
      padding: const EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        boxShadow: const [
          BoxShadow(color: Colors.black, blurRadius: 5, spreadRadius: 0),
        ],
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            const Icon(Icons.note_alt_outlined, size: 20, color: Colors.red),
            Text(
              ' $nota',
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: GoogleFonts.notoSans(
                color: Colors.black,
                fontSize: ancho > 450 ? 22 : 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LineaProducto extends StatefulWidget {
  const LineaProducto({
    Key? key,
    required this.index,
    required this.itemPedidos,
  }) : super(key: key);

  final List<Pedido> itemPedidos;
  final int index;

  @override
  State<LineaProducto> createState() => _LineaProductoState();
}

class _LineaProductoState extends State<LineaProducto> {
  late DateTime _now;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _now = DateTime.now();
    _timer = Timer.periodic(const Duration(minutes: 1), (_) {
      if (mounted) {
        setState(() {
          _now = DateTime.now();
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Color _getColorLineaCocina(Duration diff) {
    if (diff.inMinutes > 30) {
      return const Color.fromARGB(255, 255, 0, 0);
    } else if (diff.inMinutes > 20) {
      return const Color.fromRGBO(242, 132, 64, 1);
    } else if (diff.inMinutes > 9) {
      return Colors.amber;
    }
    return Colors.black;
  }

  @override
  Widget build(BuildContext context) {
    final nav = Provider.of<NavegacionProvider>(context, listen: false);
    final ancho = context.width;
    final alto = context.height;

    final Pedido itemPedido = widget.itemPedidos[widget.index];
    final int listSelCant = itemPedido.cantidad;
    final String listSelName = itemPedido.titulo ?? '';
    final String estadoLinea = itemPedido.estadoLinea;
    final int pedidoNum = itemPedido.numPedido;
    final String mesaVar = itemPedido.mesa;
    final bool enMarcha = itemPedido.enMarcha;

    final DateTime rstHora = DateTimeExtension.combineNowWithTime(itemPedido.hora);
    final Duration diff = _now.difference(rstHora);
    final Color colorLineaCocina = _getColorLineaCocina(diff);
    final Color marchando = enMarcha ? const Color.fromARGB(255, 7, 255, 19) : Colors.white;

    return GestureDetector(
      onTap: () {
        context.read<ListenerBloc>().add(
              ListenerEvent.updateEnMarchaPedido(
                mesa: itemPedido.mesa,
                idPedido: itemPedido.id,
                enMarcha: !enMarcha,
              ),
            );
      },
      child: Column(
        children: [
          Container(
            width: ancho,
            decoration: BoxDecoration(
              color: estadoLinea != EstadoPedidoEnum.cocinado.name ? Colors.white : const Color.fromARGB(255, 23, 82, 47),
              borderRadius: BorderRadius.circular(100),
              boxShadow: const [BoxShadow(color: Colors.black54, blurRadius: 5, spreadRadius: -5)],
            ),
            child: Dismissible(
              key: UniqueKey(),
              confirmDismiss: (direction) async {
                if (direction == DismissDirection.startToEnd) return false;
                if (direction == DismissDirection.endToStart) {
                  context.read<ListenerBloc>().add(
                        ListenerEvent.updateEstadoPedido(
                          mesa: itemPedido.mesa,
                          idPedido: itemPedido.id,
                          nuevoEstado: EstadoPedidoEnum.cocinado.name,
                        ),
                      );
                  return true;
                }
                return false;
              },
              onDismissed: (direction) {},
              background: Container(
                color: Colors.redAccent,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: const [
                    SizedBox(width: 12),
                    Icon(Icons.cancel_outlined, color: Colors.white, size: 24),
                    SizedBox(width: 12),
                    Text(
                      'Cancelar',
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.w400, fontSize: 22),
                    ),
                  ],
                ),
              ),
              secondaryBackground: Container(
                color: Colors.green,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: const [
                    Text(
                      'Servido',
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.w400, fontSize: 22),
                    ),
                    SizedBox(width: 12),
                    Icon(Icons.check_sharp, color: Colors.white, size: 24),
                    SizedBox(width: 12),
                  ],
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: colorLineaCocina,
                  border: Border.all(width: enMarcha ? 4 : 2, color: marchando),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: const [BoxShadow(blurRadius: 5, spreadRadius: -5)],
                ),
                height: alto * 0.05,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(5),
                        bottomLeft: Radius.circular(5),
                      ),
                      child: Container(
                        width: ancho > 450 ? 65 : 45,
                        height: double.infinity,
                        color: Colors.red[200],
                        child: Center(
                          child: Text(
                            ' x$listSelCant ',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.notoSans(
                              fontSize: ancho > 450 ? 28 : 20,
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
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.left,
                          style: GoogleFonts.notoSans(
                            color: Colors.white,
                            fontSize: ancho > 450 ? 26 : 18,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(5),
                        bottomRight: Radius.circular(5),
                      ),
                      child: Container(
                        height: double.infinity,
                        color: Colors.red[300],
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                nav.mesaActual = itemPedido.mesa;
                                nav.idPedidoSelected = itemPedido.numPedido;
                                nav.categoriaSelected = SelectionTypeEnum.pedidosScreen.name;
                              },
                              child: Container(
                                width: ancho > 450 ? 120 : 90,
                                alignment: Alignment.center,
                                child: RichText(
                                  maxLines: 1,
                                  textAlign: TextAlign.center,
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: 'P$pedidoNum/',
                                        style: GoogleFonts.notoSans(
                                          color: Colors.black,
                                          fontSize: ancho > 450 ? 24 : 20,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      TextSpan(
                                        text: 'M${int.tryParse(mesaVar) ?? mesaVar}',
                                        style: GoogleFonts.notoSans(
                                          fontSize: ancho > 450 ? 24 : 20,
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
              ),
            ),
          ),
          ModifiersOptions(
            ancho: ancho,
            modifiers: itemPedido.modifiers ?? const [],
            mainModifierName: listSelName,
          ),
        ],
      ),
    );
  }
}
