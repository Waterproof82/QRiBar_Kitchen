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
  /// Defines the preferred height of the AppBar.
  @override
  Size get preferredSize => const Size.fromHeight(60);

  /// A [ValueNotifier] to control the overall visibility of the navigation rail.
  final ValueNotifier<bool> isRailVisible;

  /// Creates a constant instance of [CustomAppBar].
  const CustomAppBar({super.key, required this.isRailVisible});

  @override
  Widget build(BuildContext context) {
    final double screenWidthSize = context.width;

    return AppBar(
      toolbarHeight: 60,
      backgroundColor: AppColors.black,
      iconTheme: const IconThemeData(color: AppColors.onPrimary),
      leading: IconButton(
        icon: ValueListenableBuilder<bool>(
          valueListenable: isRailVisible,
          builder: (context, isVisible, child) {
            return AnimatedRotation(
              turns: isVisible ? 0.25 : 0.0, // Rotate 90 degrees when hidden
              duration: const Duration(milliseconds: 300),
              child: Icon(
                isVisible ? Icons.menu_outlined : Icons.menu,
                color: AppColors.onPrimary,
              ),
            );
          },
        ),
        onPressed: () {
          isRailVisible.value = !isRailVisible.value;
        },
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Consumer<NavigationProvider>(
              builder: (context, nav, child) {
                String displayedLabel =
                    context.l10n.generalView; // Default label

                try {
                  final SelectionTypeEnum selectionType = SelectionTypeEnum
                      .values
                      .firstWhere((e) => e.name == nav.categoriaSelected);
                  displayedLabel = selectionType.localizedLabel(context);
                } catch (e) {
                  debugPrint(
                    'Warning: nav.categoriaSelected "${nav.categoriaSelected}" not found in SelectionTypeEnum. Falling back to default label.',
                  );
                  displayedLabel = context.l10n.generalView;
                }

                return FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    displayedLabel,
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
          const LanguageDropdown(),
        ],
      ),
    );
  }
}
