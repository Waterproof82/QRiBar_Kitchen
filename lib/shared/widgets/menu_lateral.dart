import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:qribar_cocina/app/const/app_colors.dart';
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

/// A final [StatelessWidget] that represents the application's side navigation menu (Drawer).
/// It provides navigation options to different sections of the kitchen app
/// and handles app exit functionality.
final class MenuLateral extends StatelessWidget {
  /// Creates a constant instance of [MenuLateral].
  const MenuLateral({super.key});

  @override
  Widget build(BuildContext context) {
    final NavegacionProvider nav = Provider.of<NavegacionProvider>(
      context,
      listen: false,
    );

    return Drawer(
      backgroundColor: AppColors.black,
      elevation: AppSizes.p10,
      child: ListView(
        children: <Widget>[
          // Drawer header with an image and app logo.
          DrawerHeader(
            decoration: BoxDecoration(
              color: AppColors.black,
              border: Border.all(
                width: AppSizes.p2,
                color: AppColors.onPrimary,
              ),
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
          Gap.h10, // Vertical spacing
          // ListTile for navigating to the General View.
          ListTile(
            leading: const Icon(
              Icons.kitchen_sharp,
              size: AppSizes.p40,
              color: AppColors.onPrimary,
            ),
            title: Text(
              context.l10n.generalView,
              style: const TextStyle(
                fontSize: AppSizes.p20,
                color: AppColors.onPrimary,
              ),
            ),
            onTap: () {
              context.pop();
              context.goTo(
                AppRoute.cocinaGeneral,
              ); // Navigate to general kitchen view
              nav.categoriaSelected = SelectionTypeEnum.generalScreen.name;
            },
          ),
          Gap.h10,
          // ListTile for navigating to the Tables View (Pedidos).
          ListTile(
            leading: const Icon(
              Icons.soup_kitchen,
              size: AppSizes.p40,
              color: AppColors.secondary,
            ),
            title: Text(
              context.l10n.tablesView,
              style: const TextStyle(
                fontSize: AppSizes.p20,
                color: AppColors.onPrimary,
              ),
            ),
            onTap: () {
              context.pop();

              context.goTo(AppRoute.cocinaPedidos, extra: 1);
              nav.categoriaSelected = SelectionTypeEnum.pedidosScreen.name;
            },
          ),
          // Divider for visual separation.
          const Divider(
            thickness: AppSizes.p2,
            indent: AppSizes.p20,
            endIndent: AppSizes.p20,
            color: AppColors.onPrimary,
          ),
          // ListTile for exiting the application.
          ListTile(
            leading: const Icon(
              Icons.login_outlined,
              color: AppColors.error,
              size: AppSizes.p40,
            ),
            title: Text(
              context.l10n.exitApp,
              style: const TextStyle(
                fontSize: AppSizes.p20,
                color: AppColors.error,
              ),
            ),
            onTap: () {
              onBackPressed(context);
            },
          ),
          // Another divider.
          Divider(
            thickness: AppSizes.p2,
            indent: AppSizes.p20,
            endIndent: AppSizes.p20,
            color: AppColors.error,
          ),
          Gap.h10,
        ],
      ),
    );
  }
}
