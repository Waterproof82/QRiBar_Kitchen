import 'package:intl/intl.dart';
import 'package:qribar/models/pedidos.dart';
import 'package:qribar/provider/navegacion_model.dart';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:qribar/provider/products_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qribar/widgets/botones_info_sup.dart';

class CuentaCocinaGeneralScreen extends StatelessWidget {
  static final String routeName = 'cuentasCocinaGeneral';

  @override
  Widget build(BuildContext context) {
    final ancho = MediaQuery.of(context).size.width;

    final itemPedidos = Provider.of<ProductsService>(context, listen: false).pedidosRealizados;
    final navegacionModel = Provider.of<NavegacionModel>(context, listen: false);

    final List<Pedidos> itemPedidosSelected = [];
    final productsService = Provider.of<ProductsService>(context, listen: false);
    String idBarSelected = productsService.idBar;
    List mesasAct = [];

    if (itemPedidos.isNotEmpty) {
      for (var itemPedido in itemPedidos) {
        if (itemPedido.idBar == idBarSelected) {
          mesasAct.add(itemPedido.mesa);
          if (itemPedido.estadoLinea != 'bloqueado') {
            itemPedidosSelected.add(itemPedido);
          }
        }
      }
    }

    return Stack(
      children: [
        BarraSupTiempo(ancho: ancho),
        ListaProductosPedidos(navegacionModel: navegacionModel, itemPedidos: itemPedidosSelected),
      ],
    );
  }
}

class ListaProductosPedidos extends StatefulWidget {
  ListaProductosPedidos({
    Key? key,
    required this.navegacionModel,
    required this.itemPedidos,
  }) : super(key: key);

  final NavegacionModel navegacionModel;
  final List<Pedidos> itemPedidos;

  @override
  State<ListaProductosPedidos> createState() => _ListaProductosPedidosState();
}

class _ListaProductosPedidosState extends State<ListaProductosPedidos> {
  @override
  Widget build(BuildContext context) {
    final providerGeneral = Provider.of<NavegacionModel>(context);
    final ancho = MediaQuery.of(context).size.width;
    // ignore: unused_local_variable
    bool notaBar = false;
/*     String notaOpciones = '';
    List<String> notasMultiOption = [];
    int type = 1; */

    return Container(
      color: providerGeneral.colorTema,
      margin: EdgeInsets.only(top: 60),
      child: ListView.builder(
        controller: widget.navegacionModel.pageController,
        physics: BouncingScrollPhysics(),
        itemCount: widget.itemPedidos.length,
        itemBuilder: (_, int index) {
          widget.itemPedidos.sort((a, b) => a.hora.compareTo(b.hora));
          if (widget.itemPedidos[index].nota != null) notaBar = true;
          return (widget.navegacionModel.numero == 0 && widget.itemPedidos[index].envio == 'cocina' && widget.itemPedidos[index].estadoLinea != 'cocinado')
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  child: Column(
                    children: [
                      LineaProducto(itemPedidos: widget.itemPedidos, index: index),
                      if (widget.itemPedidos[index].nota != null && widget.itemPedidos[index].nota != '')
                        Container(
                          width: ancho * 0.85,
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 230, 145, 145),
                            borderRadius: BorderRadius.all(Radius.circular(100)),
                            boxShadow: <BoxShadow>[BoxShadow(color: Colors.black, blurRadius: 5, spreadRadius: 0)],
                          ),
                          child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Text('${widget.itemPedidos[index].nota}',
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  textAlign: TextAlign.left,
                                  style: GoogleFonts.notoSans(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w500))),
                          alignment: Alignment.center,
                        ),
                      Extras(ancho: ancho, widget: widget, ind: index),
                    ],
                  ),
                )
              : Container();
        },
      ),
    );
  }
}

class Extras extends StatelessWidget {
  const Extras({
    Key? key,
    required this.ancho,
    required this.widget,
    required this.ind,
  }) : super(key: key);

  final double ancho;
  final ListaProductosPedidos widget;
  final int ind;

  @override
  Widget build(BuildContext context) {
    List<String> nuevaListaCorregida = [];
    widget.itemPedidos[ind].notaExtra!.forEach((cadena) {
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
        : Container();
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
  @override
  Widget build(BuildContext context) {
    final nav = Provider.of<NavegacionModel>(context);
    DateTime now = DateTime.now();
    final dataBase = FirebaseDatabase.instance.reference();

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
    listSelName = widget.itemPedidos[widget.index].titulo;

    categoriaProd = widget.itemPedidos[widget.index].categoriaProducto;
    envioProd = widget.itemPedidos[widget.index].envio!;
    estadoLinea = widget.itemPedidos[widget.index].estadoLinea ?? '';
    hora = widget.itemPedidos[widget.index].hora;
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
      child: Container(
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

              DatabaseReference _dataStreamGestionPedidos = dataBase.child('gestion_pedidos/$idBar/$mesaVar/${widget.itemPedidos[widget.index].id}');

              if (widget.itemPedidos[widget.index].estadoLinea != 'cocinado')
                await _dataStreamGestionPedidos.update({
                  'cantidad': widget.itemPedidos[widget.index].cantidad,
                  'categoria_producto': widget.itemPedidos[widget.index].categoriaProducto,
                  'fecha': widget.itemPedidos[widget.index].fecha,
                  'hora': widget.itemPedidos[widget.index].hora,
                  'idProducto': widget.itemPedidos[widget.index].idProducto,
                  'id_bar': widget.itemPedidos[widget.index].idBar,
                  'mesa': widget.itemPedidos[widget.index].mesa,
                  'mesaAbierta': widget.itemPedidos[widget.index].mesaAbierta,
                  'numPedido': widget.itemPedidos[widget.index].numPedido,
                  'precio_producto': widget.itemPedidos[widget.index].precioProducto,
                  'titulo': widget.itemPedidos[widget.index].titulo,
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
    );
  }
}

Future<bool> onDismiss(BuildContext context, List<Pedidos> itemPedidos, int index) async {
  return await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Container(
          child: new AlertDialog(
            alignment: Alignment.center,
            title: new Text(
              'Eliminando pedido...',
              textAlign: TextAlign.center,
            ),
            content: Text("¿Cancelar la línea  x${itemPedidos[index].cantidad}  ${itemPedidos[index].titulo}?"),
            actions: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  new MaterialButton(
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
                  new MaterialButton(
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
