import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:qribar_cocina/app/const/app_colors.dart';
import 'package:qribar_cocina/app/const/app_sizes.dart';
import 'package:qribar_cocina/app/enums/app_route_enum.dart';
import 'package:qribar_cocina/app/enums/assets_enum.dart';
import 'package:qribar_cocina/app/enums/selection_type_enum.dart';
import 'package:qribar_cocina/app/enums/svg_enum.dart';
import 'package:qribar_cocina/app/extensions/l10n.dart';
import 'package:qribar_cocina/features/app/providers/navegacion_provider.dart';
import 'package:qribar_cocina/shared/utils/svg_loader.dart';
import 'package:qribar_cocina/shared/utils/ui_helpers.dart';

part 'custom_navigation_rail_helper.dart';

final class CustomNavigationRail extends StatefulWidget {
  const CustomNavigationRail({super.key});

  @override
  State<CustomNavigationRail> createState() => _CustomNavigationRailState();
}

class _CustomNavigationRailState extends State<CustomNavigationRail> {
  bool _isExpanded = false;
  int _currentAnimatedIndex = 0;

  // These remember the LAST *valid (non-exit)* selected index/category.
  // They SHOULD always reflect the currently selected item if it's 0 or 1.
  int _lastActiveSelectedIndex = 0;
  String _lastActiveCategoriaSelected = SelectionTypeEnum.generalScreen.name;

  // --- Helper Method for State Updates ---

  void _updateInternalState({
    required int newCurrentAnimatedIndex,
    int? newLastActiveIndex,
    String? newLastActiveCategory,
  }) {
    if (mounted) {
      setState(() {
        _currentAnimatedIndex = newCurrentAnimatedIndex;

        if (newLastActiveIndex != null) {
          _lastActiveSelectedIndex = newLastActiveIndex;
        }
        if (newLastActiveCategory != null) {
          _lastActiveCategoriaSelected = newLastActiveCategory;
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateAnimationAndLastSelection(
        Provider.of<NavigationProvider>(context, listen: false),
        (newCurrentIndex, newLastIndex, newLastCategory) {
          _updateInternalState(
            newCurrentAnimatedIndex: newCurrentIndex,
            newLastActiveIndex: newLastIndex,
            newLastActiveCategory: newLastCategory,
          );
        },
      );
    });
  }

  @override
  void didUpdateWidget(covariant CustomNavigationRail oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final NavigationProvider nav = Provider.of<NavigationProvider>(context);

    int targetAnimatedIndex;
    String targetCategoriaSelected;

    if (nav.categoriaSelected == SelectionTypeEnum.pedidosScreen.name) {
      targetAnimatedIndex = 1;
      targetCategoriaSelected = SelectionTypeEnum.pedidosScreen.name;
    } else if (nav.categoriaSelected == SelectionTypeEnum.generalScreen.name) {
      targetAnimatedIndex = 0;
      targetCategoriaSelected = SelectionTypeEnum.generalScreen.name;
    } else {
      targetAnimatedIndex = -1;
      targetCategoriaSelected = nav.categoriaSelected;
    }

    final bool isCurrentlyExiting = _currentAnimatedIndex == 2;
    final bool currentAnimatedIndexNeedsUpdate =
        _currentAnimatedIndex != targetAnimatedIndex;
    final bool lastActiveCategoryNeedsUpdate =
        _lastActiveCategoriaSelected != targetCategoriaSelected;

    if (!isCurrentlyExiting &&
        (currentAnimatedIndexNeedsUpdate || lastActiveCategoryNeedsUpdate)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _updateInternalState(
          newCurrentAnimatedIndex: targetAnimatedIndex,

          newLastActiveIndex:
              (targetAnimatedIndex == 0 || targetAnimatedIndex == 1)
              ? targetAnimatedIndex
              : _lastActiveSelectedIndex,
          newLastActiveCategory:
              (targetAnimatedIndex == 0 || targetAnimatedIndex == 1)
              ? targetCategoriaSelected
              : _lastActiveCategoriaSelected,
        );
      });
    }

    // Determine the visual selected index for the NavigationRail itself (built-in highlighting)
    int? visualSelectedIndex;
    if (nav.categoriaSelected == SelectionTypeEnum.pedidosScreen.name) {
      visualSelectedIndex = 1;
    } else if (nav.categoriaSelected == SelectionTypeEnum.generalScreen.name) {
      visualSelectedIndex = 0;
    } else {
      visualSelectedIndex = null;
    }

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
                        _lastActiveSelectedIndex, // Pass current _lastActiveSelectedIndex
                        _lastActiveCategoriaSelected, // Pass current _lastActiveCategoriaSelected
                        (
                          newCurrentIndex,
                          newLastIndex,
                          newLastCategory,
                          shouldSetState,
                        ) {
                          _updateInternalState(
                            newCurrentAnimatedIndex: newCurrentIndex,
                            newLastActiveIndex: newLastIndex,
                            newLastActiveCategory: newLastCategory,
                          );
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
