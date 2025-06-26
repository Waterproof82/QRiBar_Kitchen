import 'package:flutter/material.dart';
import 'package:qribar_cocina/app/const/app_sizes.dart';
import 'package:qribar_cocina/app/enums/assets_enum.dart';
import 'package:qribar_cocina/app/enums/selection_type_enum.dart';
import 'package:qribar_cocina/app/enums/svg_enum.dart';
import 'package:qribar_cocina/app/extensions/l10n.dart';
import 'package:qribar_cocina/features/app/providers/navegacion_provider.dart';
import 'package:qribar_cocina/shared/utils/functions.dart';
import 'package:qribar_cocina/shared/utils/svg_loader.dart';

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
                      image: AssetImage(AssetsEnum.menu.path),
                      fit: BoxFit.fill,
                    ),
                  )),
                  Center(
                    child: SvgLoader(
                      SvgEnum.logo,
                    ),
                  )
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
                context.l10n.generalView,
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
              onTap: () {
                Navigator.pop(context);
                nav.categoriaSelected = SelectionTypeEnum.generalScreen.name;
                ;
              }),
          Gap.h10,
          ListTile(
              leading: Icon(
                Icons.soup_kitchen,
                size: 40,
                color: Colors.deepOrange,
              ),
              title: Text(
                context.l10n.tablesView,
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
              onTap: () {
                Navigator.pop(context);
                nav.categoriaSelected = SelectionTypeEnum.pedidosScreen.name;
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
              context.l10n.exitApp,
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
