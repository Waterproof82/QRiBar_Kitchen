import 'package:flutter/material.dart';
import 'package:qribar_cocina/data/const/app_sizes.dart';
import 'package:qribar_cocina/data/enums/assets_type.dart';
import 'package:qribar_cocina/data/enums/selection_type.dart';
import 'package:qribar_cocina/providers/navegacion_provider.dart';
import 'package:qribar_cocina/services/functions.dart';

class MenuLateral extends StatelessWidget {
  final NavegacionProvider nav;

  const MenuLateral({super.key, required this.nav});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.black,
      elevation: 10,
      child: ListView(
        children: <Widget>[
          DrawerHeader(
              decoration: BoxDecoration(
                  color: Color.fromARGB(255, 0, 0, 0),
                  border: Border.all(
                    width: 1,
                    color: Color.fromARGB(66, 255, 255, 255),
                  )),
              child: Stack(
                children: [
                  Container(
                      decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(AssetsType.menu.path),
                      fit: BoxFit.fill,
                    ),
                  )),
                  Center(
                      child: Image.asset(
                    AssetsType.logoCut.path,
                    height: 100.0,
                    fit: BoxFit.scaleDown,
                  ))
                ],
              )),
          Gap.h10,
          ListTile(
              leading: Icon(
                Icons.kitchen_sharp,
                size: 40,
                color: Color.fromARGB(255, 212, 176, 0),
              ),
              title: Text(
                'Cocina Vista General',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
              onTap: () {
                Navigator.pop(context);
                nav.categoriaSelected = 'Cocina Estado Pedidos';
              }),
          Gap.h10,
          ListTile(
              leading: Icon(
                Icons.soup_kitchen,
                size: 40,
                color: Colors.deepOrange,
              ),
              title: Text(
                'Cocina Vista Mesas',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
              onTap: () {
                Navigator.pop(context);
                nav.categoriaSelected = SelectionType.pedidosScreen.path;
              }),
          Divider(
            thickness: 5,
            indent: 20,
            endIndent: 20,
            color: Colors.black,
          ),
          ListTile(
            leading: Icon(
              Icons.login_outlined,
              color: Color.fromARGB(255, 255, 0, 0),
              size: 40,
            ),
            title: Text(
              'Salir de la aplicación',
              style: TextStyle(fontSize: 20, color: Colors.red),
            ),
            onTap: () {
              onBackPressed(context);
            },
          ),
          Divider(
            thickness: 5,
            indent: 20,
            endIndent: 20,
            color: Color.fromARGB(137, 255, 0, 0),
          ),
          Gap.h10,
        ],
      ),
    );
  }
}
