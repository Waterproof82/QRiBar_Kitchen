import 'dart:collection';
import 'dart:math';

import 'package:qribar/models/pedidos.dart';
import 'package:qribar/provider/navegacion_model.dart';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:qribar/models/models.dart';
import 'package:qribar/provider/products_provider.dart';
import 'package:google_fonts/google_fonts.dart';

class CuentaCocinaScreen extends StatelessWidget {
  static final String routeName = 'cuentasCocina';

  @override
  Widget build(BuildContext context) {
    // = ProductsService.mesa;
    //final ancho = MediaQuery.of(context).size.width;
    final itemElemento = Provider.of<ProductsService>(context, listen: false).products;
    final itemPedidos = Provider.of<ProductsService>(context, listen: false).pedidosRealizados;
    final productsService = Provider.of<ProductsService>(context, listen: false);
    String idBarSelected = productsService.idBar;
    //final itemMesas = Provider.of<ProductsService>(context, listen: false).salasMesa;
    final navegacionModel = Provider.of<NavegacionModel>(context, listen: false);
    final idMesaActual = navegacionModel.mesaActual;

    final List<Pedidos> itemPedidosSelected = [];
    //double totalLinea = 0;
    //double totalPedidosGrupo = 0;
    List<int> countMenuPedido = [];
    int contadorNumPedido = 0;
    List mesasAct = [];
    List resultMesas = [];
    //initializeDateFormatting('es_ES',null);
/*     var dateFormat = new DateFormat.yMMMMd('es_ES');
    var timeFormat = new DateFormat.Hms('es_ES');
    print(timeFormat); */
    if (itemPedidos.length != 0) {
      for (var i = 0; i < itemPedidos.length; i++) {
        if (itemPedidos[i].idBar == idBarSelected
            //itemPedidos[i].mesa == idMesaActual &&
            //itemPedidos[i].mesaAbierta == true &&
            /*  itemPedidos[i].numPedido == navegacionModel.idPedidoSelected */) {
          mesasAct.add(itemPedidos[i].mesa); /* , itemPedidos[i].hora] */
        }
        resultMesas = LinkedHashSet<String>.from(mesasAct).toList();
      }
      for (var i = 0; i < itemPedidos.length; i++) {
        if (itemPedidos[i].idBar == idBarSelected &&
            itemPedidos[i].mesa == idMesaActual &&
            //itemPedidos[i].mesaAbierta == true &&
            itemPedidos[i].numPedido == navegacionModel.idPedidoSelected) {
          itemPedidosSelected.add(itemPedidos[i]);
        }
      }

      for (var i = 0; i < itemPedidos.length; i++) {
        if (itemPedidos[i].idBar == idBarSelected && itemPedidos[i].mesa == idMesaActual /* && itemPedidos[i].mesaAbierta == 'True' */) {
          //final totalLineaPedidos = itemPedidos[i].cantidad * itemPedidos[i].precioProducto;
          // double rstFinal = totalPedidosGrupo + totalLineaPedidos;
          //totalPedidosGrupo = rstFinal;
          countMenuPedido.add(itemPedidos[i].numPedido);
        }
      }
      if (countMenuPedido.length != 0) {
        contadorNumPedido = countMenuPedido.reduce(max);
      }
    }

    return Stack(
      children: [
        if (navegacionModel.numero == 0) PedidosMesasListMenu(navegacionModel, resultMesas),

/*         SizedBox(
          height: 290,
          child: Divider(thickness: 5, indent: 20, endIndent: 20, color: Colors.black54),
        ), */

        PedidosListMenu(navegacionModel.idPedidoSelected, navegacionModel, contadorNumPedido),
        //PedidosActivos(),
        ListaProductosPedidos(navegacionModel: navegacionModel, itemElemento: itemElemento, itemPedidos: itemPedidosSelected),
        //if (navegacionModel.numero == 0) PrecioPedido(total: totalLinea),

        // precioTotal(itemElemento, ancho, context, navegacionModel, totalPedidosGrupo, contadorNumPedido, itemPedidos),
        //PrinterestMenuLocation(),
      ],
    );
  }
}

/* class NuevoPedidoListMenu extends StatelessWidget {
  const NuevoPedidoListMenu({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 160),
      padding: EdgeInsets.only(top: 10),
      // width: double.infinity,
      height: 50,
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.only(right: 10, left: 10),
        decoration: BoxDecoration(
          border: Border.all(width: 1, color: Colors.black26),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          'Nuevo Pedido',
          style: GoogleFonts.notoSans(
            color: Colors.black,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
} */

class PrecioPedido extends StatelessWidget {
  const PrecioPedido({
    Key? key,
    required this.total,
  }) : super(key: key);

  final double total;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 70,
      right: 3,
      child: Container(
        decoration: BoxDecoration(border: Border.all(color: Colors.black12, width: 1), color: Colors.white, borderRadius: BorderRadius.circular(10)),
        child: Text(
          ' Subtotal  ${total.toStringAsFixed(2)} € ',
          style: GoogleFonts.notoSans(color: Colors.blueGrey, fontSize: 25, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class PedidosListMenu extends StatelessWidget {
  PedidosListMenu(this.idPedido, this.navegacionModel, this.count);
  final int idPedido;
  final navegacionModel;
  final int count;
  final ScrollController _controller = new ScrollController();

  void _goToElemento(int index) {
    _controller.animateTo((100.0 * index), // 100 is the height of container and index of 6th element is 5
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeIn);
  }

  @override
  Widget build(BuildContext context) {
    //print(count);

    return Container(
      margin: EdgeInsets.only(top: 140),
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
                if (navegacionModel.numero == 0) navegacionModel.idPedidoSelected = index + 1;
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

  final ScrollController _controller = new ScrollController();

  void _goToElement(int index) {
    _controller.animateTo((100.0), // 100 is the height of container and index of 6th element is 5
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInCubic);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 70),
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
                style: GoogleFonts.notoSans(color: (navegacionModel.idPedidoSelectedMesas == index + 1) ? Colors.black : Colors.black, fontSize: 17, fontWeight: FontWeight.w500),
              ),
              onPressed: () async {
                if (navegacionModel.numero == 0) navegacionModel.idPedidoSelectedMesas = (index + 1).toString();
                navegacionModel.mesaActual = resultMesas[index];
                navegacionModel.idPedidoSelected = 1;
                _goToElement(index);

/*       numElementos.addDelButton = 1; //Pedido desde fuera 
                  //navegacionModel. = contPed;
                  //numElementos.numPedido = contPed;
                  //});
                }); */
              },
            ),
          );
        },
      ),
    );
  }
}

class ListaProductosPedidos extends StatefulWidget {
  ListaProductosPedidos({
    Key? key,
    required this.navegacionModel,
    required this.itemElemento,
    required this.itemPedidos,
  }) : super(key: key);

  final NavegacionModel navegacionModel;
  final List<Product> itemElemento;
  final List<Pedidos> itemPedidos;

  @override
  State<ListaProductosPedidos> createState() => _ListaProductosPedidosState();
}

class _ListaProductosPedidosState extends State<ListaProductosPedidos> {
  @override
  Widget build(BuildContext context) {
    final providerGeneral = Provider.of<NavegacionModel>(context);
    //final catProductos = Provider.of<ProductsService>(context).categoriasProdLocal;
    // List<CategoriaProducto> unicaCategoriaFiltro = [];
    //ordenaCategorias(catProductos, unicaCategoriaFiltro, widget.itemPedidos);

    final ancho = MediaQuery.of(context).size.width;
    // ignore: unused_local_variable
    bool notaBar = false;
    double resultPrecio = 0;

    return Container(
      color: providerGeneral.colorTema,
      margin: EdgeInsets.only(top: 200),
      child: ListView.builder(
        controller: widget.navegacionModel.pageController,
        physics: BouncingScrollPhysics(),
        itemCount: (widget.navegacionModel.numero != 0) ? widget.itemElemento.length : widget.itemPedidos.length,
        itemBuilder: (_, int index) {
          (widget.navegacionModel.numero != 0)
              ? widget.itemElemento.sort((a, b) => a.categoriaProducto.compareTo(b.categoriaProducto))
              : widget.itemPedidos.sort((a, b) => a.orden.compareTo(b.orden));
          if (widget.navegacionModel.numero != 0 && widget.itemElemento[index].cantidad != 0)
            resultPrecio = (widget.itemElemento[index].cantidad * widget.itemElemento[index].precioProducto!);

          if (widget.navegacionModel.numero == 0) resultPrecio = (widget.itemPedidos[index].cantidad * widget.itemPedidos[index].precioProducto);
          if (widget.itemPedidos[index].nota != null) notaBar = true;
          return (widget.navegacionModel.numero == 0 && widget.itemPedidos[index].envio == 'cocina' && widget.itemPedidos[index].estadoLinea != 'cocinado')
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  child: Column(
                    children: [
                      //if (widget.itemPedidos[index].envio == 'cocina' && widget.itemPedidos[index].estadoLinea != 'cocinado')
                      LineaProducto(itemElemento: widget.itemElemento, itemPedidos: widget.itemPedidos, index: index, resultPrecio: resultPrecio),
                      if (widget.itemPedidos[index].nota != null && widget.itemPedidos[index].nota != '')
                        Container(
                          width: ancho * 0.85,
                          padding: EdgeInsets.all(5),
                          //height: alto * 0.9,
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 230, 145, 145),
                            borderRadius: BorderRadius.all(Radius.circular(100)),
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                color: Colors.black,
                                blurRadius: 5,
                                spreadRadius: 0,
                                //offset: Offset(10, 10),
                              ),
                            ],
                          ),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Text(
                              '${widget.itemPedidos[index].nota}',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              textAlign: TextAlign.left,
                              style: GoogleFonts.notoSans(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w500),
                            ),
                          ),
                          alignment: Alignment.center,
                        )
                    ],
                  ),
                )
              : Container();
        },
      ),
    );
  }
}

/* void ordenaCategorias(List<CategoriaProducto> catProductos, List<CategoriaProducto> unicaCategoriaFiltro, List<Pedidos> itemPedidos) {
  for (var i = 0; i < catProductos.length; i++) {
    catProductos.sort((a, b) => a.orden.compareTo(b.orden));
    unicaCategoriaFiltro = catProductos.toList();
  }
  for (var i = 0; i < itemPedidos.length; i++) {
    for (var ind = 0; ind < unicaCategoriaFiltro.length; ind++) {
      if (itemPedidos[i].categoriaProducto == unicaCategoriaFiltro[ind].categoria) {
        itemPedidos[i].orden = unicaCategoriaFiltro[ind].orden;
        itemPedidos[i].envio = unicaCategoriaFiltro[ind].envio;
        //if (itemPedidos[i].envio == 'barra') itemPedidos.removeWhere((element) => element.envio == 'barra');
      }
    }
  }
} */

class LineaProducto extends StatelessWidget {
  const LineaProducto({
    required this.itemElemento,
    required this.index,
    required this.resultPrecio,
    required this.itemPedidos,
  });
  final List<Product> itemElemento;
  final List<Pedidos> itemPedidos;
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
    final nav = Provider.of<NavegacionModel>(context);
    final productsService = Provider.of<ProductsService>(context, listen: false);
    // final itemPedidosMesaUsuario = Provider.of<ProductsService>(context, listen: false).pedidosRealizadosMesaUsuario;
    //final itemPedidosTotal = Provider.of<ProductsService>(context, listen: false).pedidosRealizados;
    String idBar = productsService.idBar;
    String mesa = nav.mesaActual;

    DatabaseReference _dataStreamGestionPedidos = new FirebaseDatabase().reference().child('gestion_pedidos/$idBar/$mesa/${itemPedidos[index].id}');
    //DatabaseReference _dataStreamProdAdd = new FirebaseDatabase().reference().child('pedidos_activos/$idBar/$mesa/');

    final ancho = MediaQuery.of(context).size.width;
    final alto = MediaQuery.of(context).size.height;

    final int listSelCant;
    final String listSelName;

    // ignore: unused_local_variable
    String? estadoLinea = '';
    bool rst = false;

    //var now = new DateTime.now();
    //print(DateTime.now().format('MM/yyyy', 'es'));

//output (in minutes): 1725170
    //Color colorPedido = Color.fromARGB(255, 87, 87, 87);
    if (nav.numero != 0) {
      listSelCant = itemElemento[index].cantidad;
      listSelName = itemElemento[index].nombreProducto;
      categoriaProd = itemPedidos[index].categoriaProducto;
      envioProd = itemPedidos[index].envio!;
      estadoLinea = itemPedidos[index].estadoLinea!;
      hora = itemPedidos[index].hora;
      pedidoNum = itemPedidos[index].numPedido;
      mesaVar = itemPedidos[index].mesa;
    } else {
      listSelCant = itemPedidos[index].cantidad;
      listSelName = itemPedidos[index].titulo;
      colorLineaSinApuntar = (itemPedidos[index].mesaAbierta == true) ? Colors.white : Colors.white;
      categoriaProd = itemPedidos[index].categoriaProducto;
      envioProd = itemPedidos[index].envio!;
      estadoLinea = itemPedidos[index].estadoLinea ?? '';
      hora = itemPedidos[index].hora;
      pedidoNum = itemPedidos[index].numPedido;
      mesaVar = itemPedidos[index].mesa;
    }
/*     DateTime now = DateTime.now();
    var horaActual = new DateFormat.Hms(Intl.defaultLocale = 'es_ES');
    //String horaFormateada = horaActual.format(now);
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String formatted = formatter.format(now); */

    //DateTime rstHora = DateTime.parse('$formatted ${itemPedidos[index].hora}');
    // Duration diff = now.difference(rstHora);
/*     print('$formatted $horaFormateada');
    print(diff.inMinutes);
    print(rstHora); */
    // if (diff.inMinutes > 0) nav.colorPed = Colors.amber;
    //if (diff.inMinutes > 0) nav.colorPed = Colors.amber;
    //print(horaFormateada);
    return Container(
      width: ancho * 0.95,
      //height: alto * 0.9,
      decoration: BoxDecoration(
        //color: (estadoLinea != 'cocinado') ? Color.fromARGB(255, 255, 255, 255) : Color.fromARGB(255, 23, 82, 47),
        borderRadius: BorderRadius.all(Radius.circular(100)),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black54,
            blurRadius: 5,
            spreadRadius: -5,
            //offset: Offset(10, 10),
          ),
        ],
      ),
      child: Dismissible(
/*         onTap: () {
          /*      _dataStreamPedidos.update(
            {'mesaAbierta': false},
          ); */
          itemPedidos[index].mesaAbierta = false;
        }, */
        key: UniqueKey(),
        onDismissed: (direction) {
          // Remove the item from the data source.

          // itemPedidos.removeAt(index);

          //Modificar BBDD estado
        },
        confirmDismiss: (direction) async {
          if (direction == DismissDirection.startToEnd) {
            return false;
          }
          if (direction == DismissDirection.endToStart) {
            hora = itemPedidos[index].hora;
            pedidoNum = itemPedidos[index].numPedido;
            mesaVar = itemPedidos[index].mesa;

            itemPedidos[index].estadoLinea = 'cocinado';
            await _dataStreamGestionPedidos.update({
              'cantidad': itemPedidos[index].cantidad,
              'categoria_producto': itemPedidos[index].categoriaProducto,
              'fecha': itemPedidos[index].fecha,
              'hora': itemPedidos[index].hora,
              'idProducto': itemPedidos[index].idProducto,
              'id_bar': itemPedidos[index].idBar,
              'mesa': itemPedidos[index].mesa,
              'mesaAbierta': itemPedidos[index].mesaAbierta,
              'numPedido': itemPedidos[index].numPedido,
              'precio_producto': itemPedidos[index].precioProducto,
              'titulo': itemPedidos[index].titulo,
              'estado_linea': 'cocinado'
            });
            nav.valRecargaWidget = false;
            //nav.valRecargaWidget = true;
            //nav.colorPed = Colors.greenAccent;
            //itemPedidosMesaUsuario.removeWhere((element) => element.)
          }
          // }
          //await _dataStreamGestionPedidos.remove();
          //
          nav.valRecargaWidget = false;

          //return true;
          // }
          //}
          return rst;
        },
        background: Container(
          color: Colors.redAccent,
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(
                  Icons.cancel_outlined,
                  color: Colors.white,
                  size: 22,
                ),
                SizedBox(width: 10),
                Text(
                  'SE CANCELA EN BARRA',
                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
                ),
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
                Text(
                  'SERVIDO',
                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
                ),
                SizedBox(width: 10),
                Icon(
                  Icons.check_sharp,
                  color: Colors.white,
                  size: 22,
                )
              ],
            ),
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          child: Container(
            //color: (envioProd == 'barra') ? Color.fromARGB(0, 255, 255, 255) : nav.colorPed,
            decoration: BoxDecoration(
              color: (envioProd == 'barra') ? Color.fromARGB(0, 255, 255, 255) : nav.colorPed, //nav.colorPed,
              border: Border.all(width: 2, color: Colors.white38),
              borderRadius: BorderRadius.circular(10),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  //color: Colors.white,
                  blurRadius: 5,
                  spreadRadius: -5,
                  //offset: Offset(10, 10),
                ),
              ],
            ),
            height: alto * 0.07,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(15), bottomLeft: Radius.circular(15)),
                  child: Container(
                      //margin: EdgeInsets.only(top: 0),
                      //height: 21,
                      //width: 35,
                      child: Text(
                    ' x$listSelCant ',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    textAlign: TextAlign.left,
                    style: GoogleFonts.notoSans(color: Colors.black, fontSize: 26, fontWeight: FontWeight.w500, backgroundColor: Colors.red[200]),
                  )),
                ),
/*                 Container(
                  //color: Colors.red,
                  width: ancho * 0.65, */
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
                          color: (envioProd == 'barra') ? Colors.black : Colors.white, fontSize: 26, fontWeight: FontWeight.bold, backgroundColor: Colors.transparent),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    nav.mesaActual = itemPedidos[index].mesa;
                    nav.idPedidoSelected = itemPedidos[index].numPedido;
                    nav.categoriaSelected = 'Cocina Estado Pedidos';
                  },
                  child: SizedBox(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Row(
                        children: [
                          Text(
                            ' $hora ',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            textAlign: TextAlign.left,
                            style: GoogleFonts.poiretOne(color: Colors.orange, fontSize: 26, fontWeight: FontWeight.bold, backgroundColor: Colors.transparent),
                          ),
                          /*                         GestureDetector(
                            onTap: () {
                              nav.mesaActual = itemPedidos[index].mesa;
                              nav.idPedidoSelected = itemPedidos[index].numPedido;
                              nav.categoriaSelected = 'Cocina Estado Pedidos';
                            },
                            child: Text(
                              'P$pedidoNum-M${int.parse(mesaVar)}',
                              maxLines: 1,
                              textAlign: TextAlign.left,
                              style: GoogleFonts.poiretOne(color: Colors.orange, fontSize: 26, fontWeight: FontWeight.bold, backgroundColor: Colors.transparent),
                            ),
                          ), */
                        ],
                      ),
                    ),
                  ),
                ),
              ],
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
                      child: Text(
                        'Sí',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
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
                      child: Text(
                        'No',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
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
