import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qribar_cocina/provider/navegacion_model.dart';

String filtro = '';

class BarraSupTiempo extends StatelessWidget {
  const BarraSupTiempo({
    Key? key,
    required this.ancho,
  }) : super(key: key);

  final double ancho;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: (ancho > 420) ? MainAxisAlignment.spaceEvenly : MainAxisAlignment.spaceBetween,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Color.fromARGB(0, 255, 255, 255), //nav.colorPed,
            border: Border.all(width: 1, color: Color.fromARGB(255, 255, 255, 255)),
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.black,
                blurRadius: 15,
                spreadRadius: -5,
                offset: Offset(1, 5),
              ),
            ],
          ),
          width: (ancho > 420) ? 150 : 90,
          height: 35,
          //color: Color.fromARGB(255, 0, 0, 0),
          child: Text('0-10 min ', style: TextStyle(fontSize: (ancho > 420) ? 24 : 18, color: Color.fromARGB(255, 255, 254, 254))),
          alignment: Alignment.bottomRight,
        ),
        //SizedBox(width: 10),
        Container(
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 255, 193, 7), //Color.fromARGB(255, 242, 242, 64),
            border: Border.all(width: 2, color: Color.fromARGB(255, 255, 255, 255)),
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.black,
                blurRadius: 15,
                spreadRadius: -5,
                offset: Offset(1, 5),
              ),
            ],
          ),
          width: (ancho > 420) ? 150 : 90,
          height: 35,
          child: Text('10-20 min ', style: TextStyle(fontSize: (ancho > 420) ? 24 : 18, color: Color.fromARGB(255, 255, 255, 255))),
          alignment: Alignment.bottomRight,
        ),
        //SizedBox(width: 10),
        Container(
          decoration: BoxDecoration(
            color: Color.fromRGBO(242, 132, 64, 1),
            border: Border.all(width: 2, color: Color.fromARGB(255, 255, 255, 255)),
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.black,
                blurRadius: 15,
                spreadRadius: -5,
                offset: Offset(1, 5),
              ),
            ],
          ),
          width: (ancho > 420) ? 150 : 90,
          height: 35,
          child: Text('20-30 min ', style: TextStyle(fontSize: (ancho > 420) ? 24 : 18, color: Color.fromARGB(255, 255, 255, 255))),
          alignment: Alignment.bottomRight,
        ),
        //SizedBox(width: 10),
        Container(
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 255, 0, 0),
            border: Border.all(width: 2, color: Color.fromARGB(255, 255, 255, 255)),
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.black,
                blurRadius: 15,
                spreadRadius: -5,
                offset: Offset(1, 5),
              ),
            ],
          ),
          width: (ancho > 420) ? 180 : 90,
          height: 35,
          child: Text((ancho > 420) ? 'Más de 30 min ' : '+ 30 min ', style: TextStyle(fontSize: (ancho > 420) ? 24 : 18, color: Color.fromARGB(255, 255, 255, 255))),
          alignment: Alignment.bottomRight,
        )
      ],
    );
  }
}

class BarraSupTipoPedido extends StatelessWidget {
  const BarraSupTipoPedido({
    Key? key,
    required this.ancho,
  }) : super(key: key);

  final double ancho;

  @override
  Widget build(BuildContext context) {
    final providerGeneral = Provider.of<NavegacionModel>(context, listen: false);

    return ((providerGeneral.categoriaSelected != 'Cancelados' && providerGeneral.categoriaSelected != 'Procesados'))
        ? Row(
            mainAxisAlignment: (ancho > 420) ? MainAxisAlignment.spaceBetween : MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  filtro = '';
                  providerGeneral.cambioEstadoProducto = true;
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 255, 255, 255), //nav.colorPed,
                    border: Border.all(width: 1, color: Color.fromARGB(255, 255, 255, 255)),
                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10)),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: Colors.black,
                        blurRadius: 15,
                        spreadRadius: -5,
                        offset: Offset(1, 5),
                      ),
                    ],
                  ),
                  //width: (ancho > 420) ? 200 : 90,
                  height: 45,
                  //color: Color.fromARGB(255, 0, 0, 0),
                  child: Text(
                      (providerGeneral.categoriaSelected == 'Pedidos')
                          ? (ancho > 420)
                              ? 'Pedido de Barra'
                              : ' Barra '
                          : ' Ver Todo ',
                      style: TextStyle(fontSize: (ancho > 420) ? 22 : 18, color: Color.fromARGB(255, 0, 0, 0))),
                  alignment: Alignment.center,
                ),
              ),
              // SizedBox(width: 10),
              GestureDetector(
                onTap: () {
                  filtro = 'pendiente';
                  providerGeneral.cambioEstadoProducto = true;
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 88, 88, 83),
                    border: Border.all(width: 1, color: Color.fromARGB(255, 255, 255, 255)),
                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10)),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: Colors.black,
                        blurRadius: 15,
                        spreadRadius: -5,
                        offset: Offset(1, 5),
                      ),
                    ],
                  ),
                  //width: (ancho > 420) ? 220 : 90,
                  height: 45,
                  child: Text((ancho > 420) ? ' Pedido en Cocina ' : ' En Cocina ', style: TextStyle(fontSize: (ancho > 420) ? 22 : 18, color: Color.fromARGB(255, 255, 255, 255))),
                  alignment: Alignment.center,
                ),
              ),
              // SizedBox(width: 10),
              GestureDetector(
                onTap: () {
                  filtro = 'cocinado';
                  providerGeneral.cambioEstadoProducto = true;
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 20, 148, 82),
                    border: Border.all(width: 1, color: Color.fromARGB(255, 255, 255, 255)),
                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10)),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: Colors.black,
                        blurRadius: 15,
                        spreadRadius: -5,
                        offset: Offset(1, 5),
                      ),
                    ],
                  ),
                  //width: (ancho > 420) ? 220 : 90,
                  height: 45,
                  child: Text((ancho > 420) ? ' Plato Listo ' : ' Plato Listo ', style: TextStyle(fontSize: (ancho > 420) ? 22 : 18, color: Color.fromARGB(255, 255, 255, 255))),
                  alignment: Alignment.center,
                ),
              ),
              //   SizedBox(width: 10),
              GestureDetector(
                onTap: () {
                  filtro = 'bloqueado';
                  providerGeneral.cambioEstadoProducto = true;
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.red,
                    border: Border.all(width: 1, color: Color.fromARGB(255, 255, 255, 255)),
                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10)),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: Colors.black,
                        blurRadius: 15,
                        spreadRadius: -5,
                        offset: Offset(1, 5),
                      ),
                    ],
                  ),
                  //width: (ancho > 420) ? 220 : 90,
                  height: 45,
                  child:
                      Text((ancho > 420) ? ' Bloqueado en Barra ' : ' Bloqueado ', style: TextStyle(fontSize: (ancho > 420) ? 22 : 18, color: Color.fromARGB(255, 255, 255, 255))),
                  alignment: Alignment.center,
                ),
              ),
            ],
          )
        : Container();
  }
}
