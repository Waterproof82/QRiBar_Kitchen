import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:qribar_cocina/app/const/app_colors.dart';
import 'package:qribar_cocina/app/enums/selection_type_enum.dart';
import 'package:qribar_cocina/app/extensions/build_context_extension.dart';
import 'package:qribar_cocina/app/extensions/selection_type_enum_extension.dart';
import 'package:qribar_cocina/features/app/providers/navegacion_provider.dart';
import 'package:qribar_cocina/shared/utils/language_dropdown.dart';

/// A final [StatelessWidget] that implements [PreferredSizeWidget] for a custom AppBar.
/// This AppBar displays the current selected category and a language dropdown,
/// adapting its title size based on screen width.
final class CustomAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  /// Defines the preferred height of the AppBar.
  @override
  Size get preferredSize => const Size.fromHeight(60);

  /// Creates a constant instance of [CustomAppBar].
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidthSize = context.width;

    return AppBar(
      toolbarHeight: 60,
      backgroundColor: AppColors.black,
      iconTheme: const IconThemeData(color: AppColors.onPrimary),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Consumer<NavegacionProvider>(
              builder: (context, nav, child) {
                // Determine the current selection type based on the navigation provider.
                final SelectionTypeEnum selectionType = SelectionTypeEnum.values
                    .firstWhere((e) => e.name == nav.categoriaSelected);

                return FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    selectionType.localizedLabel(context),
                    style: GoogleFonts.poiretOne(
                      color: AppColors.onPrimary,
                      fontSize: (screenWidthSize > 450) ? 35 : 28,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              },
            ),
          ),
          // Widget for language selection.
          const LanguageDropdown(),
        ],
      ),
    );
  }
}
