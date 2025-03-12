import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:qribar_cocina/models/modifier.dart';
import 'package:qribar_cocina/models/pedidos.dart';
import 'package:qribar_cocina/provider/navegacion_model.dart';
import 'package:qribar_cocina/provider/products_provider.dart';
import 'package:qribar_cocina/services/functions.dart';
import 'package:qribar_cocina/widgets/botones_info_sup.dart';

class CuentaCocinaGeneralScreen extends StatelessWidget {
  static final String routeName = 'cuentasCocinaGeneral';

  @override
  Widget build(BuildContext context) {
    final ancho = MediaQuery.of(context).size.width;

    final itemPedidos = Provider.of<ProductsService>(context, listen: false).pedidosRealizados;
    final navegacionModel = Provider.of<NavegacionModel>(context, listen: false);

    final List<Pedidos> itemPedidosSelected = [];
    // List mesasAct = [];

    if (itemPedidos.isNotEmpty) {
      itemPedidosSelected.addAll(itemPedidos.where((item) => item.estadoLinea != 'bloqueado'));
    }
    return Stack(
      children: [
        BarraSupTiempo(ancho: ancho),
        ListaProductosPedidos(navegacionModel: navegacionModel, itemPedidos: itemPedidosSelected),
      ],
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
    final providerGeneral = Provider.of<NavegacionModel>(context, listen: false);
    final ancho = MediaQuery.of(context).size.width;
    bool notaBar = false;

    return Container(
      color: providerGeneral.colorTema,
      margin: EdgeInsets.only(top: 60),
      child: ListView.builder(
        controller: navegacionModel.pageController,
        physics: BouncingScrollPhysics(),
        itemCount: itemPedidos.length,
        itemBuilder: (_, int index) {
          itemPedidos.sort((a, b) => a.hora.compareTo(b.hora));
          if (itemPedidos[index].nota != null) notaBar = true;
          return (navegacionModel.numero == 0 && itemPedidos[index].envio == 'cocina' && itemPedidos[index].estadoLinea != 'cocinado')
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  child: Column(
                    children: [
                      LineaProducto(itemPedidos: itemPedidos, index: index),
                      if (itemPedidos[index].nota != null && itemPedidos[index].nota != '')
                        Container(
                          width: ancho * 0.95,
                          height: 30,
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 230, 145, 145),
                            borderRadius: BorderRadius.all(Radius.circular(100)),
                            boxShadow: <BoxShadow>[BoxShadow(color: Colors.black, blurRadius: 5, spreadRadius: 0)],
                          ),
                          child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Text('${itemPedidos[index].nota}',
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  textAlign: TextAlign.left,
                                  style: GoogleFonts.notoSans(color: const Color.fromARGB(255, 0, 0, 0), fontSize: 18, fontWeight: FontWeight.w500))),
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

class LineaProducto extends StatefulWidget {
  const LineaProducto({
    required this.index,
    required this.itemPedidos,
  });
  final List<Pedidos> itemPedidos;
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
    final nav = Provider.of<NavegacionModel>(context);
    DateTime now = DateTime.now();

    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String formatted = formatter.format(now);
    final productsService = Provider.of<ProductsService>(context, listen: false);
    String idBar = productsService.idBar;

    final ancho = MediaQuery.of(context).size.width;
    final alto = MediaQuery.of(context).size.height;

    final int listSelCant;
    final String listSelName;
    String? estadoLinea = '';
    bool rst = false;
    Color colorLineaCocina = Colors.grey;
    // ignore: unused_local_variable
    String categoriaProd = '';
    String envioProd = 'barra';
    String hora = '';
    int pedidoNum = 0;
    String mesaVar = '';

    Color marchando = Colors.white38;
    bool varMarchando = false;
    listSelCant = widget.itemPedidos[widget.index].cantidad;
    listSelName = obtenerNombreProducto(context, widget.itemPedidos[widget.index].idProducto!, widget.itemPedidos[widget.index].racion!);

    envioProd = widget.itemPedidos[widget.index].envio!;
    estadoLinea = widget.itemPedidos[widget.index].estadoLinea ?? '';
    hora = (widget.itemPedidos[widget.index].hora.isNotEmpty) ? widget.itemPedidos[widget.index].hora.split(':').sublist(0, 2).join(':') : "--:--";
    pedidoNum = widget.itemPedidos[widget.index].numPedido;
    mesaVar = widget.itemPedidos[widget.index].mesa;
    varMarchando = widget.itemPedidos[widget.index].enMarcha ?? false;
    marchando = (varMarchando == true) ? Color.fromARGB(255, 7, 255, 19) : Colors.white;

    DateTime rstHora = DateTime.parse('$formatted ${widget.itemPedidos[widget.index].hora}');
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
        setState(() {
          if (widget.itemPedidos[widget.index].enMarcha == true) {
            widget.itemPedidos[widget.index].enMarcha = false;
          } else if (widget.itemPedidos[widget.index].enMarcha == false) {
            widget.itemPedidos[widget.index].enMarcha = true;
          }
        });
      },
      child: Column(
        children: [
          Container(
            width: ancho * 0.95,
            decoration: BoxDecoration(
              color: (estadoLinea != 'cocinado') ? Color.fromARGB(255, 255, 255, 255) : Color.fromARGB(255, 23, 82, 47),
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
                  hora = widget.itemPedidos[widget.index].hora;
                  pedidoNum = widget.itemPedidos[widget.index].numPedido;
                  mesaVar = widget.itemPedidos[widget.index].mesa;

                  DatabaseReference _dataStreamGestionPedidos = database.ref('gestion_pedidos/$idBar/$mesaVar/${widget.itemPedidos[widget.index].id}');

                  if (widget.itemPedidos[widget.index].estadoLinea != 'cocinado')
                    await _dataStreamGestionPedidos.update({
                      'cantidad': widget.itemPedidos[widget.index].cantidad,
                      'fecha': widget.itemPedidos[widget.index].fecha,
                      'hora': widget.itemPedidos[widget.index].hora,
                      'idProducto': widget.itemPedidos[widget.index].idProducto,
                      'mesa': widget.itemPedidos[widget.index].mesa,
                      'numPedido': widget.itemPedidos[widget.index].numPedido,
                      'estado_linea': 'cocinado'
                    });
                }
                nav.valRecargaWidget = false; //
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
                    color: (envioProd == 'barra') ? Color.fromARGB(0, 255, 255, 255) : colorLineaCocina, //nav.colorPed,
                    border: Border.all(width: (varMarchando == false) ? 2 : 4, color: marchando),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: <BoxShadow>[BoxShadow(blurRadius: 5, spreadRadius: -5)],
                  ),
                  height: alto * 0.06,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ClipRRect(
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(15), bottomLeft: Radius.circular(15)),
                          child: Container(
                              margin: EdgeInsets.only(top: 0),
                              child: Text(
                                ' x$listSelCant ',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                textAlign: TextAlign.left,
                                style: GoogleFonts.notoSans(color: Colors.black, fontSize: (ancho > 450) ? 26 : 20, fontWeight: FontWeight.w500, backgroundColor: Colors.red[200]),
                              ))),

                      Flexible(
                          fit: FlexFit.tight,
                          child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Text(
                                ' $listSelName',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                textAlign: TextAlign.left,
                                style: GoogleFonts.poiretOne(
                                    color: (envioProd == 'barra') ? Colors.black : Colors.white,
                                    fontSize: (ancho > 450) ? 26 : 20,
                                    fontWeight: FontWeight.bold,
                                    backgroundColor: Colors.transparent),
                              ))),

                      SizedBox(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Row(
                            children: [
                              Text(' $hora ',
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  textAlign: TextAlign.left,
                                  style: GoogleFonts.poiretOne(
                                      color: (envioProd == 'barra') ? Colors.black : Colors.white,
                                      fontSize: (ancho > 450) ? 26 : 20,
                                      fontWeight: FontWeight.bold,
                                      backgroundColor: Colors.transparent)),
                              GestureDetector(
                                onTap: () {
                                  nav.mesaActual = widget.itemPedidos[widget.index].mesa;
                                  nav.idPedidoSelected = widget.itemPedidos[widget.index].numPedido;
                                  nav.categoriaSelected = 'Cocina Pedidos Por Mesa';
                                },
                                child: Text('P$pedidoNum-M${int.parse(mesaVar)}',
                                    maxLines: 1,
                                    textAlign: TextAlign.left,
                                    style: GoogleFonts.poiretOne(
                                        color: (colorLineaCocina != Color.fromARGB(255, 0, 0, 0)) ? Color.fromARGB(255, 0, 0, 0) : Color.fromARGB(255, 255, 94, 1),
                                        fontSize: (ancho > 450) ? 26 : 20,
                                        fontWeight: FontWeight.bold,
                                        backgroundColor: Colors.transparent)),
                              ),
                            ],
                          ),
                        ),
                      ),
                      //),
                    ],
                  ),
                ),
              ),
            ),
          ),
          NotaMultiRadio(ancho: ancho, modifiers: widget.itemPedidos[widget.index].modifiers ?? []),
        ],
      ),
    );
  }
}

class NotaMultiRadio extends StatelessWidget {
  const NotaMultiRadio({
    Key? key,
    required this.ancho,
    required this.modifiers,
  }) : super(key: key);

  final double ancho;
  final List<Modifier> modifiers;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(modifiers.length, (index) {
        final opcion = modifiers[index];
        return Container(
          width: ancho * 0.95,
          height: 30,
          padding: const EdgeInsets.symmetric(horizontal: 2),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.all(Radius.circular(100)),
            boxShadow: const [
              BoxShadow(
                color: Colors.black54,
                blurRadius: 5,
                spreadRadius: -5,
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                ),
                child: FittedBox(
                  fit: BoxFit.fitWidth,
                  child: const Icon(
                    Icons.navigate_next,
                    size: 20,
                    color: Colors.red,
                  ),
                ),
              ),
              // Texto principal con scroll horizontal si es necesario
              Flexible(
                fit: FlexFit.tight,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Text(
                        opcion.name,
                        maxLines: 1,
                        textAlign: TextAlign.left,
                        style: GoogleFonts.poiretOne(color: Colors.black, fontSize: (ancho > 450) ? 22 : 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
