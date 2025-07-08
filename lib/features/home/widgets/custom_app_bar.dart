import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:qribar_cocina/app/const/app_colors.dart';
import 'package:qribar_cocina/app/enums/selection_type_enum.dart';
import 'package:qribar_cocina/app/extensions/build_context_extension.dart';
import 'package:qribar_cocina/app/extensions/l10n.dart';
import 'package:qribar_cocina/app/extensions/selection_type_enum_extension.dart';
import 'package:qribar_cocina/features/app/providers/navegacion_provider.dart';
import 'package:qribar_cocina/shared/utils/language_dropdown.dart';

/// A final [StatelessWidget] that implements [PreferredSizeWidget] for a custom AppBar.
/// This AppBar displays the current selected category and a language dropdown,
/// adapting its title size based on screen width.
final class CustomAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    final double screenWidthSize = context.width;

    return AppBar(
      toolbarHeight: 60,
      backgroundColor: AppColors.black,
      iconTheme: const IconThemeData(color: AppColors.onPrimary),
      leading: Selector<NavigationProvider, bool>(
        selector: (_, provider) => provider.isRailVisible,
        builder: (context, isRailVisible, _) {
          return IconButton(
            icon: Icon(
              isRailVisible ? Icons.menu_outlined : Icons.menu,
              color: AppColors.onPrimary,
            ),
            onPressed: () {
              context.read<NavigationProvider>().isRailVisible = !isRailVisible;
            },
          );
        },
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Selector<NavigationProvider, String>(
              selector: (_, provider) => provider.categoriaSelected,
              builder: (context, categoriaSelected, _) {
                String displayedLabel = context.l10n.generalView;

                try {
                  final selectionType = SelectionTypeEnum.values.firstWhere(
                    (e) => e.name == categoriaSelected,
                  );
                  displayedLabel = selectionType.localizedLabel(context);
                } catch (_) {
                  debugPrint(
                    'Warning: nav.categoriaSelected "$categoriaSelected" not found in SelectionTypeEnum. Using default.',
                  );
                }

                return FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    displayedLabel,
                    style: GoogleFonts.poiretOne(
                      color: AppColors.onPrimary,
                      fontSize: screenWidthSize > 450 ? 35 : 28,
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
