import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qribar_cocina/app/enums/selection_type_enum.dart';
import 'package:qribar_cocina/app/extensions/build_context_extension.dart';
import 'package:qribar_cocina/features/app/providers/navegacion_provider.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(60);
  const CustomAppBar({
    super.key,
    required this.nav,
  });

  final NavegacionProvider nav;

  @override
  Widget build(BuildContext context) {
    final double screenWidthSize = context.width;
    final selectionType = SelectionTypeEnum.values.firstWhere(
      (e) => e.name == nav.categoriaSelected,
    );

    return AppBar(
      toolbarHeight: 60,
      backgroundColor: Colors.black,
      iconTheme: IconThemeData(color: Colors.white),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                selectionType.localizedLabel(context),
                style: GoogleFonts.poiretOne(
                  color: Color.fromARGB(255, 240, 240, 21),
                  fontSize: (screenWidthSize > 450) ? 35 : 28,
                  fontWeight: FontWeight.w600,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
