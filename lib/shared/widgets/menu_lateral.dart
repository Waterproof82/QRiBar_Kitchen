import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:qribar_cocina/app/const/app_sizes.dart';
import 'package:qribar_cocina/app/enums/app_route_enum.dart';
import 'package:qribar_cocina/app/enums/assets_enum.dart';
import 'package:qribar_cocina/app/enums/selection_type_enum.dart';
import 'package:qribar_cocina/app/enums/svg_enum.dart';
import 'package:qribar_cocina/app/extensions/app_route_extension.dart';
import 'package:qribar_cocina/app/extensions/l10n.dart';
import 'package:qribar_cocina/features/app/providers/navegacion_provider.dart';
import 'package:qribar_cocina/shared/utils/svg_loader.dart';
import 'package:qribar_cocina/shared/utils/ui_helpers.dart';

class MenuLateral extends StatelessWidget {
  const MenuLateral({super.key});

  @override
  Widget build(BuildContext context) {
    final nav = Provider.of<NavegacionProvider>(context, listen: false);

    return Drawer(
      backgroundColor: Colors.black,
      elevation: 10,
      child: ListView(
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.black,
              border: Border.all(width: 1, color: Colors.white60),
            ),
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(AssetsEnum.menu.path),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                const Center(child: SvgLoader(SvgEnum.logo)),
              ],
            ),
          ),
          Gap.h10,
          ListTile(
            leading: const Icon(
              Icons.kitchen_sharp,
              size: 40,
              color: Color.fromARGB(255, 212, 176, 0),
            ),
            title: Text(
              context.l10n.generalView,
              style: const TextStyle(fontSize: 20, color: Colors.white),
            ),
            onTap: () {
              context.pop();
              context.goTo(AppRoute.cocinaGeneral);
              nav.categoriaSelected = SelectionTypeEnum.generalScreen.name;
            },
          ),
          Gap.h10,
          ListTile(
            leading: const Icon(
              Icons.soup_kitchen,
              size: 40,
              color: Colors.deepOrange,
            ),
            title: Text(
              context.l10n.tablesView,
              style: const TextStyle(fontSize: 20, color: Colors.white),
            ),
            onTap: () {
              context.pop();

              context.goTo(AppRoute.cocinaPedidos, extra: '12345');

              nav.categoriaSelected = SelectionTypeEnum.pedidosScreen.name;
            },
          ),
          const Divider(
            thickness: 5,
            indent: 20,
            endIndent: 20,
            color: Colors.black,
          ),
          ListTile(
            leading: const Icon(
              Icons.login_outlined,
              color: Color.fromARGB(255, 255, 0, 0),
              size: 40,
            ),
            title: Text(
              context.l10n.exitApp,
              style: const TextStyle(fontSize: 20, color: Colors.red),
            ),
            onTap: () {
              onBackPressed(context);
            },
          ),
          const Divider(
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
