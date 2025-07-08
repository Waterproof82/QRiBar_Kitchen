import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qribar_cocina/app/extensions/date_time_extension.dart';
import 'package:qribar_cocina/features/app/bloc/listener_bloc.dart';
import 'package:qribar_cocina/features/app/providers/navegacion_provider.dart';
import 'package:qribar_cocina/features/cocina/widgets/barra_superior_tiempo.dart';
import 'package:qribar_cocina/features/cocina/widgets/modifiers_options.dart';
import 'package:qribar_cocina/features/cocina/widgets/pedido_dismissible.dart';
import 'package:qribar_cocina/shared/app_exports.dart';

/// A final [StatelessWidget] representing the main kitchen general view.
/// This screen displays a time bar and a list of filtered orders,
/// reacting to changes in the [ListenerBloc] state for orders.
final class CocinaGeneralScreen extends StatelessWidget {
  /// Creates a constant instance of [CocinaGeneralScreen].
  const CocinaGeneralScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double ancho = context.width;
    final double alto = context.height;

    return Stack(
      children: [
        // Top bar displaying time information.
        BarraSuperiorTiempo(ancho: ancho),

        /// Listens to changes in the 'pedidos' list from the [ListenerBloc]'s data state.
        BlocSelector<ListenerBloc, ListenerState, List<Pedido>>(
          selector: (state) => state.maybeWhen(
            data: (productos, pedidos, categorias) => pedidos,
            orElse: () => const [],
          ),
          builder: (context, pedidos) {
            if (pedidos.isEmpty) {
              return const SizedBox.shrink();
            }
            return _buildPedidos(pedidos, ancho, alto);
          },
        ),
      ],
    );
  }

  /// Filters the list of [Pedido]s for display in the general kitchen view.
  Widget _buildPedidos(List<Pedido> pedidos, double ancho, double alto) {
    final List<Pedido> pedidosFiltrados = pedidos
        .where(
          (p) =>
              (p.estadoLinea != EstadoPedidoEnum.bloqueado.name) &&
              p.envio == 'cocina',
        )
        .toList(growable: false);

    return ListaProductosPedidos(
      itemPedidos: pedidosFiltrados,
      ancho: ancho,
      alto: alto,
    );
  }
}

/// A final [StatelessWidget] that displays a scrollable list of order items.
/// It sorts the orders and renders each one using [LineaProducto].
final class ListaProductosPedidos extends StatelessWidget {
  /// The list of order items to display.
  final List<Pedido> itemPedidos;

  /// The available width for responsive calculations.
  final double ancho;

  /// The available height for responsive calculations.
  final double alto;

  /// Creates a constant instance of [ListaProductosPedidos].
  const ListaProductosPedidos({
    super.key,
    required this.itemPedidos,
    required this.ancho,
    required this.alto,
  });

  @override
  Widget build(BuildContext context) {
    final PageController pageController = context
        .read<NavigationProvider>()
        .pageController;

    // Create a mutable copy for sorting.
    final List<Pedido> pedidosOrdenados = [...itemPedidos]
      ..sort((a, b) {
        final int horaCompare = a.hora.compareTo(b.hora);
        if (horaCompare != 0) return horaCompare;

        final int tituloCompare = a.titulo?.compareTo(b.titulo ?? '') ?? 0;
        if (tituloCompare != 0) return tituloCompare;

        return (a.modifiers ?? []).toString().compareTo(
          (b.modifiers ?? []).toString(),
        );
      });

    return Container(
      color: Colors.black,
      margin: const EdgeInsets.only(top: 60),
      child: ListView.builder(
        controller: pageController,
        physics: const BouncingScrollPhysics(),
        itemCount: pedidosOrdenados.length,
        itemBuilder: (_, int index) {
          final Pedido pedido = pedidosOrdenados[index];

          if (pedido.estadoLinea == EstadoPedidoEnum.cocinado.name) {
            return const SizedBox.shrink();
          }

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 8),
            child: Column(
              children: [
                LineaProducto(itemPedido: pedido, ancho: ancho, alto: alto),
                if (pedido.nota != null && pedido.nota!.trim().isNotEmpty)
                  _NotaBar(pedido.nota!, ancho),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// A final [StatelessWidget] that displays a note bar for an order.
final class _NotaBar extends StatelessWidget {
  /// The note text to display.
  final String nota;

  /// The available width for the widget.
  final double ancho;

  /// Creates a constant instance of [_NotaBar].
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
          BoxShadow(blurRadius: 5),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.note_alt_outlined, size: 20, color: Colors.red),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              nota,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: GoogleFonts.notoSans(
                color: Colors.black,
                fontSize: ancho > 450 ? 22 : 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// A final [StatefulWidget] that represents a single product line in an order.
/// This widget displays order details, handles the "in progress" status toggle,
/// and calculates dynamic colors based on time elapsed.
final class LineaProducto extends StatefulWidget {
  /// The single order item data for this line.
  final Pedido itemPedido;

  /// The available width for responsive calculations.
  final double ancho;

  /// The available height for responsive calculations.
  final double alto;

  /// Creates a constant instance of [LineaProducto].
  const LineaProducto({
    super.key,
    required this.itemPedido,
    required this.ancho,
    required this.alto,
  });

  @override
  State<LineaProducto> createState() => _LineaProductoState();
}

/// The state class for [LineaProducto].
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

  /// Determines the color of the order line based on the time difference.
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
    final double ancho = widget.ancho;
    final double alto = widget.alto;

    final Pedido itemPedido = widget.itemPedido;
    final int listSelCant = itemPedido.cantidad;
    final String listSelName = itemPedido.titulo ?? '';
    final String estadoLinea = itemPedido.estadoLinea;
    final int pedidoNum = itemPedido.numPedido;
    final String mesaVar = itemPedido.mesa;
    final bool enMarcha = itemPedido.enMarcha;

    final DateTime rstHora = DateTimeExtension.combineNowWithTime(
      itemPedido.hora,
    );
    final Duration diff = _now.difference(rstHora);
    final Color colorLineaCocina = _getColorLineaCocina(diff);
    final Color marchando = enMarcha
        ? const Color.fromARGB(255, 7, 255, 19)
        : Colors.white;

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
              color: estadoLinea != EstadoPedidoEnum.cocinado.name
                  ? Colors.white
                  : const Color.fromARGB(255, 23, 82, 47),
              borderRadius: BorderRadius.circular(100),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black54,
                  blurRadius: 5,
                  spreadRadius: -5,
                ),
              ],
            ),
            child: PedidoDismissible(
              itemPedido: itemPedido,
              listSelCant: listSelCant,
              listSelName: listSelName,
              pedidoNum: pedidoNum,
              mesaVar: mesaVar,
              enMarcha: enMarcha,
              ancho: ancho,
              alto: alto,
              colorLineaCocina: colorLineaCocina,
              marchando: marchando,
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
