import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart'; // <-- necesario para Consumer
import 'package:qribar_cocina/app/enums/selection_type_enum.dart';
import 'package:qribar_cocina/app/extensions/build_context_extension.dart';
import 'package:qribar_cocina/app/extensions/selection_type_enum_extension.dart';
import 'package:qribar_cocina/features/app/providers/navegacion_provider.dart';
import 'package:qribar_cocina/shared/utils/language_dropdown.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(60);
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidthSize = context.width;

    return AppBar(
      toolbarHeight: 60,
      backgroundColor: Colors.black,
      iconTheme: const IconThemeData(color: Colors.white),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Consumer<NavegacionProvider>(
              builder: (context, nav, child) {
                final selectionType = SelectionTypeEnum.values.firstWhere(
                  (e) => e.name == nav.categoriaSelected,
                );

                return FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    selectionType.localizedLabel(context),
                    style: GoogleFonts.poiretOne(
                      color: const Color.fromARGB(255, 240, 240, 21),
                      fontSize: (screenWidthSize > 450) ? 35 : 28,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              },
            ),
          ),
          const LanguageDropdown(),
        ],
      ),
    );
  }
}
