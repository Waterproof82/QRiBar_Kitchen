import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qribar_cocina/provider/navegacion_model.dart';
import 'package:qribar_cocina/services/functions.dart';

class MenuWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final providerGeneral = Provider.of<NavegacionModel>(context);

    return Drawer(
      backgroundColor: providerGeneral.colorTema,
      elevation: 10,
      child: ListView(
        children: <Widget>[
          DrawerHeader(
              decoration: BoxDecoration(color: Color.fromARGB(255, 0, 0, 0), border: Border.all(width: 1, color: Color.fromARGB(66, 255, 255, 255))),
              child: Stack(
                children: [
                  Container(decoration: BoxDecoration(image: DecorationImage(image: AssetImage('assets/svg/menu-img.jpg'), fit: BoxFit.fill))),
                  Center(child: Image.asset('assets/svg/logo_cut.png', height: 100.0, fit: BoxFit.scaleDown))
                ],
              )),
          SizedBox(height: 10),
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
                providerGeneral.categoriaSelected = 'Cocina Pedidos Por Mesa';
              }),
          Divider(thickness: 5, indent: 20, endIndent: 20, color: (providerGeneral.colorTema == Colors.black) ? Colors.white : Colors.black),
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
