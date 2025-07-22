import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:qribar_cocina/app/enums/app_route_enum.dart';
import 'package:qribar_cocina/app/enums/estado_pedido_enum.dart';
import 'package:qribar_cocina/app/enums/selection_type_enum.dart';
import 'package:qribar_cocina/app/extensions/app_route_extension.dart';
import 'package:qribar_cocina/app/l10n/app_localizations.dart';
import 'package:qribar_cocina/data/models/pedido/pedido.dart';
import 'package:qribar_cocina/features/app/bloc/listener_bloc.dart';
import 'package:qribar_cocina/features/app/providers/navegacion_provider.dart';

/// A final [StatelessWidget] that represents a dismissible order item in a list.
///
/// This widget allows users to dismiss an order to change its status (e.g., "cocinado").
/// It displays order details and provides navigation functionality.
final class PedidoDismissible extends StatelessWidget {
  /// The order item data.
  final Pedido itemPedido;

  /// The quantity of the selected item in the order.
  final int listSelCant;

  /// The name of the selected item in the order.
  final String listSelName;

  /// The order number.
  final int pedidoNum;

  /// The table variable associated with the order.
  final String mesaVar;

  /// Indicates if the order is currently "in progress".
  final bool enMarcha;

  /// The available width for the widget.
  final double ancho;

  /// The available height for the widget.
  final double alto;

  /// The background color of the order line.
  final Color colorLineaCocina;

  /// The color indicating if the order is "in progress".
  final Color marchando;

  /// Creates a constant instance of [PedidoDismissible].
  ///
  /// All parameters are required to build the order item display.
  const PedidoDismissible({
    super.key,
    required this.itemPedido,
    required this.listSelCant,
    required this.listSelName,
    required this.pedidoNum,
    required this.mesaVar,
    required this.enMarcha,
    required this.ancho,
    required this.alto,
    required this.colorLineaCocina,
    required this.marchando,
  });

  /// Toggles the category selection in [NavigationProvider] and navigates
  /// to the appropriate screen ([AppRoute.cocinaPedidos] or [AppRoute.cocinaGeneral]).
  ///
  /// [context]: The current build context.
  /// [nav]: The [NavigationProvider] instance.
  void _toggleCategoria(BuildContext context, NavigationProvider nav) {
    final isGeneral =
        nav.categoriaSelected == SelectionTypeEnum.generalScreen.name;

    // Update navigation provider state
    nav
      ..mesaActual = itemPedido.mesa
      ..idPedidoSelected = itemPedido.numPedido
      ..categoriaSelected = isGeneral
          ? SelectionTypeEnum.pedidosScreen.name
          : SelectionTypeEnum.generalScreen.name;

    // Navigate to the corresponding route
    context.goTo(
      isGeneral ? AppRoute.cocinaPedidos : AppRoute.cocinaGeneral,
      extra: isGeneral
          ? itemPedido.numPedido
          : null, // Pass order number as extra if going to pedidos screen
    );
  }

  @override
  Widget build(BuildContext context) {
    // Access NavegacionProvider without listening for changes within build,
    // as changes are handled by _toggleCategoria.
    final nav = Provider.of<NavigationProvider>(context, listen: false);
    final l10n = AppLocalizations.of(context);

    return Dismissible(
      // Use ValueKey for better performance in lists, assuming itemPedido.id is unique and stable.
      key: ValueKey(itemPedido.id),
      // Confirms if the dismiss action should proceed.
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          // Swipe from left to right (e.g., cancel/block)
          return false; // Do not dismiss for this direction (or implement cancel logic)
        }
        if (direction == DismissDirection.endToStart) {
          // Swipe from right to left (e.g., mark as cooked/served)
          context.read<ListenerBloc>().add(
            ListenerEvent.updateEstadoPedido(
              mesa: itemPedido.mesa,
              idPedido: itemPedido.id,
              nuevoEstado: EstadoPedidoEnum.cocinado.name, // Mark as cooked
            ),
          );
          return true; // Allow dismiss
        }
        return false; // Default: do not dismiss
      },
      // onDismissed is called after the dismiss animation completes.
      // The actual state update is handled in confirmDismiss.
      onDismissed: (_) {},
      // Background for swipe from left to right (e.g., cancel)
      background: Container(
        color: Colors.redAccent,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            const Icon(Icons.cancel_outlined, color: Colors.white, size: 24),
            const SizedBox(width: 12),
            Text(
              l10n.cancelOrder,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w400,
                fontSize: 22,
              ),
            ),
          ],
        ),
      ),
      // Background for swipe from right to left (e.g., served)
      secondaryBackground: Container(
        color: Colors.green,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              l10n.served,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w400,
                fontSize: 22,
              ),
            ),
            const SizedBox(width: 12),
            const Icon(Icons.check_sharp, color: Colors.white, size: 24),
          ],
        ),
      ),
      // The actual content of the dismissible item
      child: Container(
        decoration: BoxDecoration(
          color: colorLineaCocina,
          border: Border.all(width: enMarcha ? 4 : 2, color: marchando),
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [BoxShadow(blurRadius: 5, spreadRadius: -5)],
        ),
        height: alto * 0.05, // Responsive height
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Quantity display on the left
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(5),
                bottomLeft: Radius.circular(5),
              ),
              child: Container(
                width: ancho > 450 ? 65 : 45, // Responsive width
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
            // Product name in the middle, takes available space
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
            // Order and table number on the right
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
                      onTap: () => _toggleCategoria(context, nav),
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
    );
  }
}
