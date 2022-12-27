import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:qribar/models/product.dart';
import 'package:qribar/provider/navegacion_model.dart';
import 'package:qribar/provider/products_provider.dart';
import 'package:qribar/services/functions.dart';

class MenuWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final providerGeneral = Provider.of<NavegacionModel>(context);
    final productsService = Provider.of<ProductsService>(context, listen: false);
    String idBar = productsService.idBar;

    return Drawer(
      backgroundColor: providerGeneral.colorTema,
      elevation: 10,
      //ListView para hacer Scroll
      child: ListView(
        children: <Widget>[
          DrawerHeader(
              decoration: BoxDecoration(color: Color.fromARGB(255, 0, 0, 0), border: Border.all(width: 1, color: Color.fromARGB(66, 255, 255, 255))
                  //borderRadius: BorderRadius.circular(0),
                  ),
              child: Stack(
                children: [
                  Container(decoration: BoxDecoration(image: DecorationImage(image: AssetImage('assets/svg/menu-img.jpg'), fit: BoxFit.fill))),
                  Center(child: Image.asset('assets/svg/logo_cut.png', height: 100.0, fit: BoxFit.scaleDown))
                ],
              )),
/*           ListTile(
              leading: Container(
                //margin: EdgeInsets.only(top: 10),
                child: FaIcon(
                  FontAwesomeIcons.houseUser,
                  size: 40,
                  color: Color.fromARGB(255, 246, 6, 6),
                ),
              ),
              title: Text('Sala', style: TextStyle(fontSize: 20, color: (providerGeneral.colorTema == Colors.black) ? Colors.white : Colors.black)),
              onTap: () {
                Navigator.popAndPushNamed(context, 'salas', arguments: '');
              }), */
          SizedBox(height: 10),
          /*     ListTile(
              leading: Icon(Icons.table_bar_outlined, size: 40, color: Color.fromARGB(255, 162, 0, 0)),
              title: Text('Todas las Mesas info', style: TextStyle(fontSize: 20, color: (providerGeneral.colorTema == Colors.black) ? Colors.white : Colors.black)),
              onTap: () {
                Navigator.popAndPushNamed(context, 'sala', arguments: 'Todo');
              }),
          SizedBox(height: 10),
          ListTile(
              leading: FaIcon(FontAwesomeIcons.locationCrosshairs, size: 35, color: Color.fromARGB(255, 112, 1, 247)),
              title: Text('Mapa de la Sala', style: TextStyle(fontSize: 20, color: (providerGeneral.colorTema == Colors.black) ? Colors.white : Colors.black)),
              onTap: () {
                Navigator.pushNamed(context, 'mapaSala', arguments: '');
              }),
          Divider(thickness: 5, indent: 20, endIndent: 20, color: (providerGeneral.colorTema == Colors.black) ? Colors.white : Colors.black),
          ListTile(
              leading: FaIcon(FontAwesomeIcons.martiniGlass, size: 35, color: Color.fromARGB(255, 242, 133, 0)),
              title: Text('Barra Estado Pedidos', style: TextStyle(fontSize: 20, color: (providerGeneral.colorTema == Colors.black) ? Colors.white : Colors.black)),
              onTap: () {
                Navigator.pop(context);
                providerGeneral.categoriaSelected = 'Barra Estado Pedidos';
              }),
          SizedBox(height: 10), */
/*           ListTile(
              leading: FaIcon(FontAwesomeIcons.listUl, size: 35, color: Color.fromARGB(255, 1, 79, 247)),
              title: Text('Cocina Estado Pedidos', style: TextStyle(fontSize: 20, color: (providerGeneral.colorTema == Colors.black) ? Colors.white : Colors.black)),
              onTap: () {
                Navigator.pop(context);
                providerGeneral.categoriaSelected = 'Situación Cocina';
              }),
          Divider(thickness: 5, indent: 20, endIndent: 20, color: (providerGeneral.colorTema == Colors.black) ? Colors.white : Colors.black), 
          SizedBox(height: 10),
          ListTile(
              leading: Icon(Icons.apple, size: 40, color: Color.fromARGB(255, 0, 125, 4)),
              title: Text('Todos los Productos', style: TextStyle(fontSize: 20, color: (providerGeneral.colorTema == Colors.black) ? Colors.white : Colors.black)),
              onTap: () {
                Navigator.pop(context);
                providerGeneral.categoriaSelected = 'Todos los productos';
                providerGeneral.itemSeleccionado = 99;
              }),
          SizedBox(height: 10),
          ListTile(
              leading: Icon(Icons.hide_image_outlined, size: 40, color: Color.fromARGB(255, 134, 0, 0)),
              title: Text('Productos Ocultos', style: TextStyle(fontSize: 20, color: (providerGeneral.colorTema == Colors.black) ? Colors.white : Colors.black)),
              onTap: () {
                Navigator.pop(context);
                providerGeneral.categoriaSelected = 'Productos ocultos';
                providerGeneral.itemSeleccionado = 99;
              }),
          SizedBox(height: 10),
          Divider(thickness: 5, indent: 20, endIndent: 20, color: (providerGeneral.colorTema == Colors.black) ? Colors.white : Colors.black),*/
          ListTile(
              leading: Icon(Icons.kitchen_sharp, size: 40, color: Color.fromARGB(255, 212, 176, 0)),
              title: Text('Cocina Vista General', style: TextStyle(fontSize: 20, color: (providerGeneral.colorTema == Colors.black) ? Colors.white : Colors.black)),
              onTap: () {
                Navigator.pop(context);
                providerGeneral.categoriaSelected = 'Cocina Estado Pedidos';
              }),
          SizedBox(height: 10),
          ListTile(
              leading: Icon(Icons.soup_kitchen, size: 40, color: Colors.deepOrange),
              title: Text('Cocina Vista Mesas', style: TextStyle(fontSize: 20, color: (providerGeneral.colorTema == Colors.black) ? Colors.white : Colors.black)),
              onTap: () {
                Navigator.pop(context);
                providerGeneral.categoriaSelected = 'Cocina Pedidos';
              }),
          Divider(thickness: 5, indent: 20, endIndent: 20, color: (providerGeneral.colorTema == Colors.black) ? Colors.white : Colors.black),
          /*    ListTile(
              leading: Icon(Icons.cancel, size: 40, color: Colors.red),
              title: Text('Pedidos Cancelados', style: TextStyle(fontSize: 20, color: (providerGeneral.colorTema == Colors.black) ? Colors.white : Colors.black)),
              onTap: () {
                Navigator.pop(context);
                providerGeneral.categoriaSelected = 'Cancelados';
              }

              //Si queremos que no deje retornar como al hacer Login por ej. usar:
              //onTap: () => Navigator.pushReplacementNamed(context, SettingsPage.routeName),
              ),
          SizedBox(height: 10),
          ListTile(
              leading: Icon(Icons.archive, size: 40, color: Color.fromARGB(255, 0, 255, 38)),
              title: Text('Pedidos Procesados', style: TextStyle(fontSize: 20, color: (providerGeneral.colorTema == Colors.black) ? Colors.white : Colors.black)),
              onTap: () {
                Navigator.pop(context);
                providerGeneral.categoriaSelected = 'Procesados';
              }

              //Si queremos que no deje retornar como al hacer Login por ej. usar:
              //onTap: () => Navigator.pushReplacementNamed(context, SettingsPage.routeName),
              ),
          Divider(thickness: 5, indent: 20, endIndent: 20, color: (providerGeneral.colorTema == Colors.black) ? Colors.white : Colors.black),
          ListTile(
              leading: Icon(Icons.camera, size: 40, color: (providerGeneral.colorTema == Colors.black) ? Colors.white : Colors.black),
              title: Text('Crear Nuevo Producto', style: TextStyle(fontSize: 20, color: (providerGeneral.colorTema == Colors.black) ? Colors.white : Colors.black)),
              onTap: () {
                Navigator.pop(context);

                productsService.selectedProduct = new Product(
                  disponible: true,
                  nombreProducto: '',
                  precioProducto: 0,
                  precioProducto2: 0,
                  costeProducto: 0,
                  categoriaProducto: '',
                  idBar: '$idBar',
                );
                Navigator.pushNamed(context, 'producto');
              }

              //Si queremos que no deje retornar como al hacer Login por ej. usar:
              //onTap: () => Navigator.pushReplacementNamed(context, SettingsPage.routeName),
              ),
          SizedBox(height: 10),
          ListTile(
            leading: Icon(Icons.category, color: Color.fromARGB(255, 208, 35, 58), size: 40),
            title: Text('Nueva Categoria Menú', style: TextStyle(fontSize: 20, color: (providerGeneral.colorTema == Colors.black) ? Colors.white : Colors.black)),
            onTap: () {
              Navigator.pop(context);
              providerGeneral.nombreCategoria = '';
              providerGeneral.nombreCategoriaEn = '';
              providerGeneral.nombreCategoriaDe = '';
              //providerGeneral.categoriaSelected = '';
              //providerGeneral.itemSeleccionado = 0;
              providerGeneral.envio = '';
              providerGeneral.nombreIcon = '';
              providerGeneral.disponible = false;
              providerGeneral.orden = 0;
              Navigator.pushNamed(context, 'iconos');
            },
          ),
          Divider(thickness: 5, indent: 20, endIndent: 20, color: Color.fromARGB(137, 255, 0, 0)),
          Container(
            margin: EdgeInsets.only(bottom: 5),
            child: ListTile(
              leading: Icon(Icons.reset_tv, color: Color.fromARGB(255, 16, 65, 179), size: 40),
              title: Text('Cerrar Menú', style: TextStyle(fontSize: 20, color: (providerGeneral.colorTema == Colors.black) ? Colors.white : Colors.black)),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ),
          SizedBox(height: 10), */
          ListTile(
            leading: Icon(Icons.login_outlined, color: Color.fromARGB(255, 255, 0, 0), size: 40),
            title: Text('Salir de la aplicación', style: TextStyle(fontSize: 20, color: Colors.red)),
            onTap: () {
              onBackPressed(context);
            },
          ),
          Divider(thickness: 5, indent: 20, endIndent: 20, color: Color.fromARGB(137, 255, 0, 0)),
          SizedBox(height: 15),
          ListTile(
            leading: Icon(Icons.lightbulb, color: Color.fromARGB(255, 226, 203, 27), size: 40),
            title: Text('Cambiar Tema', style: TextStyle(fontSize: 20, color: (providerGeneral.colorTema == Colors.black) ? Colors.white : Colors.black)),
            onTap: () {
              //providerGeneral.colorTema = Colors.black;
              if (providerGeneral.colorTema == Colors.white)
                providerGeneral.colorTema = Colors.black;
              else
                providerGeneral.colorTema = Colors.white;
              //Navigator.pop(context);
            },
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}
