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

/// A [StatefulWidget] that represents a reusable and modern application side navigation rail.
/// It provides navigation options to different sections of the kitchen app.
/// It can expand to show labels, collapse to show only icons, and be hidden/shown completely.
final class CustomNavigationRail extends StatefulWidget {
  /// A [ValueNotifier] to control the overall visibility of the navigation rail.
  final ValueNotifier<bool> isRailVisible;

  /// Creates a constant instance of [CustomNavigationRail].
  const CustomNavigationRail({super.key, required this.isRailVisible});

  @override
  State<CustomNavigationRail> createState() => _CustomNavigationRailState();
}

class _CustomNavigationRailState extends State<CustomNavigationRail> {
  bool _isExpanded = false;
  int _currentAnimatedIndex =
      0; // Tracks which icon should be rotating (or was last rotating)

  // State variables to store the last active selection before pressing Exit
  int? _lastActiveSelectedIndex;
  String? _lastActiveCategoriaSelected;

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
  void didUpdateWidget(covariant CustomNavigationRail oldWidget) {
    super.didUpdateWidget(oldWidget);
    final NavigationProvider nav = Provider.of<NavigationProvider>(
      context,
      listen: false,
    );

    if (nav.categoriaSelected != _lastActiveCategoriaSelected &&
        nav.categoriaSelected != '') {
      _updateAnimationAndLastSelection(nav, (
        newCurrentIndex,
        newLastIndex,
        newLastCategory,
      ) {
        setState(() {
          _currentAnimatedIndex = newCurrentIndex;
          _lastActiveSelectedIndex = newLastIndex;
          _lastActiveCategoriaSelected = newLastCategory;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final NavigationProvider nav = Provider.of<NavigationProvider>(context);

    // Determine the visual selected index for the NavigationRail itself (highlighting)
    int? visualSelectedIndex;
    if (nav.categoriaSelected == SelectionTypeEnum.pedidosScreen.name) {
      visualSelectedIndex = 1;
    } else if (nav.categoriaSelected == SelectionTypeEnum.generalScreen.name) {
      visualSelectedIndex = 0;
    }

    return ValueListenableBuilder<bool>(
      valueListenable: widget.isRailVisible,
      builder: (context, isVisible, child) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: isVisible ? (_isExpanded ? AppSizes.p200 : AppSizes.p80) : 0,
          color: AppColors.black,
          child: isVisible
              ? NavigationRail(
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
                      (
                        newCurrentIndex,
                        newLastIndex,
                        newLastCategory,
                        shouldSetState,
                      ) {
                        if (shouldSetState) {
                          setState(() {
                            _currentAnimatedIndex = newCurrentIndex;
                            _lastActiveSelectedIndex = newLastIndex;
                            _lastActiveCategoriaSelected = newLastCategory;
                          });
                        }
                      },
                    );
                  },
                  labelType: _isExpanded
                      ? NavigationRailLabelType.all
                      : NavigationRailLabelType.none,
                  minWidth: AppSizes.p80,
                  minExtendedWidth: AppSizes.p200,
                  leading: _buildLeadingWidget(
                    _isExpanded,
                    () => setState(() => _isExpanded = !_isExpanded),
                  ),
                  destinations: _buildDestinationsWidget(
                    context,
                    _currentAnimatedIndex,
                  ),
                )
              : const SizedBox.shrink(),
        );
      },
    );
  }
}
