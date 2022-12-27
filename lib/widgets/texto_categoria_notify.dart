import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:qribar/provider/navegacion_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:qribar/provider/products_provider.dart';

class TextoCategoriaYnotificador extends StatelessWidget {
  const TextoCategoriaYnotificador({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final providerGeneral = Provider.of<NavegacionModel>(context);
    final catProductos = Provider.of<ProductsService>(context, listen: false).categoriasProdLocal;
    final sala = Provider.of<ProductsService>(context, listen: false).salasMesa;
    final double screenWidthSize = MediaQuery.of(context).size.width;
    String urlQR = '';

    return Container(
      color: providerGeneral.colorTema,
      width: double.infinity,
      margin: EdgeInsets.only(top: 50),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 5),
            child: Container(
              //margin: EdgeInsets.only(right: 10, left: 10),
              decoration: BoxDecoration(
                color: providerGeneral.colorTema,
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
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        int existe = catProductos.indexWhere((item) => item.categoria == '${providerGeneral.categoriaSelected}');
                        if (existe == -1) {
                          print('No existe');
                        } else {
                          for (var i = 0; i < catProductos.length; i++) {
                            if (catProductos[i].categoria == providerGeneral.categoriaSelected) {
                              providerGeneral.nombreCategoria = catProductos[i].categoria;
                              providerGeneral.nombreCategoriaEn = catProductos[i].categoriaEn ?? '';
                              providerGeneral.nombreCategoriaDe = catProductos[i].categoriaDe ?? '';
                              providerGeneral.envio = catProductos[i].envio;
                              providerGeneral.orden = catProductos[i].orden;
                              providerGeneral.disponible = catProductos[i].imgVertical;
                              providerGeneral.nombreIcon = catProductos[i].icono!;
                            }
                          }
                          providerGeneral.updateAvailability(providerGeneral.disponible);
                          Navigator.pushNamed(context, 'newCategory', arguments: 'Editar'); //si existe
                        }
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(0)),
                        child: Container(
                          decoration: BoxDecoration(
                            //color: Color.fromARGB(0, 255, 255, 255), //nav.colorPed,
                            border: Border.all(width: 2, color: Color.fromARGB(97, 255, 255, 255)),
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: <BoxShadow>[BoxShadow(color: Colors.black, blurRadius: 2, spreadRadius: 0)],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Text(
                                '· ${providerGeneral.categoriaSelected} ·',
                                style: GoogleFonts.poiretOne(color: Color.fromARGB(255, 240, 240, 21), fontSize: (screenWidthSize > 450) ? 35 : 28, fontWeight: FontWeight.w600),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    // ((providerGeneral.categoriaSelected == 'Cuenta') || (providerGeneral.categoriaSelected == 'Pedidos'))
                    /* ? */ GestureDetector(
                      onTap: () {
                        for (var i = 0; i < sala.length; i++) {
                          if (sala[i].mesa == providerGeneral.mesaActual) urlQR = sala[i].qrLink ?? '';
                        }
                      },
                      child: (providerGeneral.categoriaSelected != 'Cocina Estado Pedidos' && providerGeneral.categoriaSelected != 'Cocina Pedidos')
                          ? Row(
                              children: [
                                SizedBox(width: 20),
                                Text(
                                  'Mesa ',
                                  style: GoogleFonts.poiretOne(color: Color.fromARGB(255, 255, 128, 0), fontSize: (screenWidthSize > 450) ? 40 : 30, fontWeight: FontWeight.bold),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  '${int.parse(providerGeneral.mesaActual)}',
                                  style: GoogleFonts.poiretOne(
                                      color: (providerGeneral.colorTema != Colors.black) ? Color.fromARGB(255, 0, 0, 0) : Colors.white,
                                      fontSize: (screenWidthSize > 450) ? 40 : 30,
                                      fontWeight: FontWeight.bold),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(width: 10),
                                /* (ancho > 400)
                              ?  */
                                Container(
                                  //color: Colors.amber,
                                  width: 60,
                                  height: 60,
                                  child: FloatingActionButton(
                                    elevation: 0,
                                    heroTag: 'BotonCuenta',
                                    onPressed: () {
                                      providerGeneral.categoriaSelected = 'Cuenta';
                                      providerGeneral.itemSeleccionado = 99;
                                      // providerGeneral.idPedidoSelected = providerGeneral.numPedido;
                                    },
                                    backgroundColor: Colors.transparent, //providerGeneral.color,
                                    child: Stack(
                                      children: [
                                        NotificacionIco(providerGeneral: providerGeneral),
                                        Positioned(
                                          bottom: 5,
                                          right: 0,
                                          child: FaIcon(FontAwesomeIcons.cartShopping,
                                              size: (providerGeneral.itemSeleccionado != 99) ? 35 : 35, color: Color.fromARGB(255, 0, 114, 167)),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                //   : Container(),
                                SizedBox(width: 10),
                              ],
                            )
                          : Container(),
                    )
                    /*  : Container(
                            //color: Colors.amber,
                            width: 60,
                            height: 60,
                            child: FloatingActionButton(
                              elevation: 0,
                              heroTag: 'BotonCuenta',
                              onPressed: () {
                                providerGeneral.categoriaSelected = 'Cuenta';
                                providerGeneral.itemSeleccionado = 99;
                                // providerGeneral.idPedidoSelected = providerGeneral.numPedido;
                              },
                              backgroundColor: Colors.transparent, //providerGeneral.color,
                              child: Stack(
                                children: [
                                  NotificacionIco(providerGeneral: providerGeneral),
                                  Positioned(
                                    bottom: 6,
                                    right: 0,
                                    child: FaIcon(FontAwesomeIcons.cartShopping, size: (providerGeneral.itemSeleccionado != 99) ? 35 : 35, color: Color.fromARGB(255, 3, 146, 212)),
                                  ),
                                ],
                              ),
                            ),
                          ), */
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class NotificacionIco extends StatelessWidget {
  const NotificacionIco({
    Key? key,
    required this.providerGeneral,
  }) : super(key: key);

  final NavegacionModel providerGeneral;

  @override
  Widget build(BuildContext context) {
    //providerGeneral.numero = 0;
    return /*  (providerGeneral.numero != 0)
        ? */
        Positioned(
      top: 0,
      right: 5,
      child: BounceInDown(
        from: 75,
        animate: true, //oculta si numero es 0
        child: Bounce(
          from: 40,
          controller: (controller) => Provider.of<NavegacionModel>(context).bounceController = controller,
          child: Padding(
            padding: const EdgeInsets.only(left: 0.0),
            child: Container(
              child: Text('${providerGeneral.numero}', style: GoogleFonts.notoSans(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
              alignment: Alignment.center,
              width: 28,
              height: 28,
              decoration: BoxDecoration(color: Color.fromARGB(255, 253, 72, 33), shape: BoxShape.circle),
            ),
          ),
        ),
      ),
    );
    // : Container();
  }
}
