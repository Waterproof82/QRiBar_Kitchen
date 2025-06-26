import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:qribar_cocina/app/extensions/l10n.dart';
import 'package:qribar_cocina/features/app/bloc/listener_bloc.dart';
import 'package:qribar_cocina/features/app/providers/navegacion_provider.dart';
import 'package:qribar_cocina/shared/app_exports.dart';

class PedidoDismissible extends StatelessWidget {
  final Pedido itemPedido;
  final int listSelCant;
  final String listSelName;
  final int pedidoNum;
  final String mesaVar;
  final bool enMarcha;
  final double ancho;
  final double alto;
  final Color colorLineaCocina;
  final Color marchando;

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

  void _toggleCategoria(NavegacionProvider nav) {
    nav.mesaActual = itemPedido.mesa;
    nav.idPedidoSelected = itemPedido.numPedido;

    if (nav.categoriaSelected == SelectionTypeEnum.generalScreen.name) {
      nav.categoriaSelected = SelectionTypeEnum.pedidosScreen.name;
    } else {
      nav.categoriaSelected = SelectionTypeEnum.generalScreen.name;
    }
  }

  @override
  Widget build(BuildContext context) {
    final nav = Provider.of<NavegacionProvider>(context, listen: false);

    return Dismissible(
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
      onDismissed: (_) {},
      background: Container(
        color: Colors.redAccent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(width: 12),
            const Icon(Icons.cancel_outlined, color: Colors.white, size: 24),
            const SizedBox(width: 12),
            Text(
              context.l10n.cancelOrder,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w400,
                fontSize: 22,
              ),
            ),
          ],
        ),
      ),
      secondaryBackground: Container(
        color: Colors.green,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              context.l10n.served,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w400,
                fontSize: 22,
              ),
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
                      onTap: () => _toggleCategoria(nav),
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
