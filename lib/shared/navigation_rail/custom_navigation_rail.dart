import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:qribar_cocina/app/const/app_colors.dart';
import 'package:qribar_cocina/app/const/app_sizes.dart';
import 'package:qribar_cocina/app/enums/app_route_enum.dart';
import 'package:qribar_cocina/app/enums/assets_enum.dart';
import 'package:qribar_cocina/app/enums/selection_type_enum.dart';
import 'package:qribar_cocina/app/enums/svg_enum.dart';
import 'package:qribar_cocina/app/l10n/app_localizations.dart';
import 'package:qribar_cocina/features/app/providers/navegacion_provider.dart';
import 'package:qribar_cocina/shared/utils/svg_loader.dart';
import 'package:qribar_cocina/shared/utils/ui_helpers.dart';

part 'helpers/custom_navigation_rail_helper.dart';
part 'helpers/custom_navigation_rail_leading_helper.dart';
part 'helpers/custom_navigation_rail_state_helper.dart';

/// A custom NavigationRail widget that integrates with a [NavigationProvider]
/// to manage navigation state and UI updates.
final class CustomNavigationRail extends StatefulWidget {
  const CustomNavigationRail({super.key});

  @override
  State<CustomNavigationRail> createState() => _CustomNavigationRailState();
}

class _CustomNavigationRailState extends State<CustomNavigationRail> {
  // Controls the expansion state of the navigation rail.
  bool _isExpanded = false;

  // The currently animated index, which drives the visual selection and transitions.
  // - 0: General Screen
  // - 1: Pedidos Screen
  // - 2: Exit state (when navigating away from 0 or 1)
  int _currentAnimatedIndex = 0;

  // These store the LAST *valid (non-exit)* selected index and category.
  // They are used to revert to the correct state if an "exit" route is selected.
  int _lastActiveSelectedIndex = 0;
  String _lastActiveCategoriaSelected = SelectionTypeEnum.generalScreen.name;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateAnimationAndLastSelection(
        Provider.of<NavigationProvider>(context, listen: false),
        (newCurrentIndex, newLastIndex, newLastCategory) {
          setState(() {
            _currentAnimatedIndex = newCurrentIndex;
            _lastActiveSelectedIndex = newLastIndex;
            _lastActiveCategoriaSelected = newLastCategory;
          });
        },
      );
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final nav = Provider.of<NavigationProvider>(context, listen: false);
    _updateStateBasedOnNavigationProviderInHelper(
      nav,
      (newCurrentIndex, newLastIndex, newLastCategory) {
        if (!mounted) return;
        setState(() {
          _currentAnimatedIndex = newCurrentIndex;
          if (newLastIndex != null) {
            _lastActiveSelectedIndex = newLastIndex;
          }
          if (newLastCategory != null) {
            _lastActiveCategoriaSelected = newLastCategory;
          }
        });
      },
      _currentAnimatedIndex, // Pass current state values
      _lastActiveSelectedIndex,
      _lastActiveCategoriaSelected,
    );
  }

  @override
  Widget build(BuildContext context) {
    final NavigationProvider nav = Provider.of<NavigationProvider>(context);

    final int? visualSelectedIndex =
        nav.categoriaSelected == SelectionTypeEnum.pedidosScreen.name
        ? 1
        : nav.categoriaSelected == SelectionTypeEnum.generalScreen.name
        ? 0
        : null;

    const double dividerWidth = 1.0;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: nav.isRailVisible
          ? (_isExpanded
                ? AppSizes.p200 + dividerWidth
                : AppSizes.p80 + dividerWidth)
          : 0,
      color: AppColors.black,
      child: nav.isRailVisible
          ? Row(
              children: [
                Flexible(
                  child: NavigationRail(
                    backgroundColor: AppColors.black,
                    elevation: AppSizes.p10,
                    selectedIndex: visualSelectedIndex,
                    indicatorColor: AppColors.transparent,
                    onDestinationSelected: (int index) {
                      _handleNavigationDestination(
                        context,
                        index,
                        _lastActiveSelectedIndex,
                        _lastActiveCategoriaSelected,
                        (newCurrentIndex, newLastIndex, newLastCategory) {
                          if (!mounted) return;
                          setState(() {
                            _currentAnimatedIndex = newCurrentIndex;
                            if (newLastIndex != null) {
                              _lastActiveSelectedIndex = newLastIndex;
                            }
                            if (newLastCategory != null) {
                              _lastActiveCategoriaSelected = newLastCategory;
                            }
                          });
                        },
                      );
                    },
                    labelType: _isExpanded
                        ? NavigationRailLabelType.all
                        : NavigationRailLabelType.none,
                    minWidth: AppSizes.p80,
                    minExtendedWidth: AppSizes.p200,
                    leading: _buildLeadingWidget(_isExpanded, () {
                      if (mounted) {
                        setState(() => _isExpanded = !_isExpanded);
                      }
                    }),
                    destinations: _buildDestinationsWidget(
                      context,
                      _currentAnimatedIndex,
                    ),
                  ),
                ),
                const VerticalDivider(color: Colors.grey, width: dividerWidth),
              ],
            )
          : const SizedBox.shrink(),
    );
  }
}
