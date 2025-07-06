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
      _updateAnimationAndLastSelectionFromProvider(
        Provider.of<NavigationProvider>(context, listen: false),
      );
    });
  }

  void _updateAnimationAndLastSelectionFromProvider(NavigationProvider nav) {
    setState(() {
      if (nav.categoriaSelected == SelectionTypeEnum.pedidosScreen.name) {
        _currentAnimatedIndex = 1;
        _lastActiveSelectedIndex = 1;
        _lastActiveCategoriaSelected = nav.categoriaSelected;
      } else if (nav.categoriaSelected ==
          SelectionTypeEnum.generalScreen.name) {
        _currentAnimatedIndex = 0;
        _lastActiveSelectedIndex = 0;
        _lastActiveCategoriaSelected = nav.categoriaSelected;
      } else {
        // If no category is selected (e.g., after exit or initial state),
        // default to General for animation, but last active can be null.
        _currentAnimatedIndex = 0; // Animation defaults to the first item
        _lastActiveSelectedIndex = null; // No active selection to restore
        _lastActiveCategoriaSelected = null; // No active selection to restore
      }
    });
  }

  @override
  void didUpdateWidget(covariant CustomNavigationRail oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Listen for changes in the NavigationProvider to update animation state
    // We get the provider here because it might have changed from outside the widget tree.
    final NavigationProvider nav = Provider.of<NavigationProvider>(
      context,
      listen: false,
    );

    // Only update if the category has actually changed from the previous frame
    if (nav.categoriaSelected != _lastActiveCategoriaSelected &&
        nav.categoriaSelected != '') {
      _updateAnimationAndLastSelectionFromProvider(nav);
    }
  }

  /// Handles the selection of a navigation rail destination.
  /// This method updates the animated index, last active selection,
  /// and performs navigation based on the selected index.
  void _handleDestinationSelected(int index) {
    final NavigationProvider nav = Provider.of<NavigationProvider>(
      context,
      listen: false,
    );

    if (index == 0 || index == 1) {
      // General or Pedidos
      setState(() {
        _currentAnimatedIndex = index; // Set for animation
        // Update the last active selection when a regular item is chosen
        _lastActiveSelectedIndex = index;
        _lastActiveCategoriaSelected = (index == 0)
            ? SelectionTypeEnum.generalScreen.name
            : SelectionTypeEnum.pedidosScreen.name;
      });
      // Perform navigation and update categorySelected
      if (index == 0) {
        context.goNamed(AppRoute.cocinaGeneral.name);
        nav.categoriaSelected = SelectionTypeEnum.generalScreen.name;
      } else {
        // index == 1
        context.goNamed(AppRoute.cocinaPedidos.name, extra: 1);
        nav.categoriaSelected = SelectionTypeEnum.pedidosScreen.name;
      }
    } else if (index == 2) {
      // Exit App
      setState(() {
        // Trigger only the exit icon animation
        _currentAnimatedIndex = 2;
      });

      // Temporarily clear categorySelected immediately to remove highlight
      nav.categoriaSelected = ''; // This will make selectedIndex null.

      onBackPressed(context).then((didExit) {
        if (mounted) {
          // Ensure widget is still in the tree
          if (didExit != true) {
            // User cancelled exit, restore previous state
            setState(() {
              // Restore the animation state to the last active index
              _currentAnimatedIndex =
                  _lastActiveSelectedIndex ??
                  0; // Fallback to 0 if no last active
            });
            // Restore the provider's category to re-highlight
            nav.categoriaSelected =
                _lastActiveCategoriaSelected ??
                SelectionTypeEnum.generalScreen.name;
          } else {
            // App did exit, ensure _currentAnimatedIndex resets for exit icon
            setState(() {
              _currentAnimatedIndex = -1; // Reset exit icon's animation
            });
          }
        }
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
                  onDestinationSelected: _handleDestinationSelected,
                  labelType: _isExpanded
                      ? NavigationRailLabelType.all
                      : NavigationRailLabelType.none,
                  minWidth: AppSizes.p80,
                  minExtendedWidth: AppSizes.p200,
                  leading: _leadingWidget(),
                  destinations: _destinationsWidget(context),
                )
              : const SizedBox.shrink(),
        );
      },
    );
  }

  //Helpers//
  List<NavigationRailDestination> _destinationsWidget(BuildContext context) {
    return <NavigationRailDestination>[
      _buildNavigationDestination(
        context: context,
        iconData: Icons.kitchen_sharp,
        label: context.l10n.generalView,
        index: 0,
        currentAnimatedIndex: _currentAnimatedIndex,
        defaultColor: AppColors.onPrimary,
        selectedColor: AppColors.primary,
      ),
      _buildNavigationDestination(
        context: context,
        iconData: Icons.soup_kitchen,
        label: context.l10n.tablesView,
        index: 1,
        currentAnimatedIndex: _currentAnimatedIndex,
        defaultColor: AppColors.onPrimary,
        selectedColor: AppColors.secondary,
      ),
      _buildNavigationDestination(
        context: context,
        iconData: Icons.logout_outlined,
        label: context.l10n.exitApp,
        index: 2,
        currentAnimatedIndex: _currentAnimatedIndex,
        defaultColor: AppColors.error,
        selectedColor: AppColors.error,
      ),
    ];
  }

  Column _leadingWidget() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(
            bottom: AppSizes.p20,
            top: AppSizes.p10,
          ),
          child: Container(
            width: _isExpanded ? AppSizes.p160 : AppSizes.p80,
            height: _isExpanded ? AppSizes.p112 : AppSizes.p80,
            decoration: BoxDecoration(
              border: Border.all(
                width: AppSizes.p2,
                color: AppColors.transparent,
              ),
              image: DecorationImage(
                image: AssetImage(AssetsEnum.menu.path),
                fit: BoxFit.fill,
              ),
            ),
            child: Center(
              child: SvgLoader(
                SvgEnum.logo,
                width: _isExpanded ? AppSizes.p56 : AppSizes.p40,
              ),
            ),
          ),
        ),
        IconButton(
          icon: _buildExpandCollapseIcon(_isExpanded),
          color: AppColors.onPrimary,
          onPressed: () {
            setState(() {
              _isExpanded = !_isExpanded;
            });
          },
        ),
      ],
    );
  }
}

// Helper function for the expand/collapse button icon
Widget _buildExpandCollapseIcon(bool expanded) {
  return AnimatedRotation(
    turns: expanded ? 0.5 : 0.0, // Rotate 180 degrees when expanded
    duration: const Duration(milliseconds: 300),
    child: Icon(
      Icons.arrow_back_ios_new,
      size: AppSizes.p24,
      color: AppColors.onPrimary,
    ),
  );
}

/// Helper function to create a NavigationRailDestination with animated icons.
NavigationRailDestination _buildNavigationDestination({
  required BuildContext context,
  required IconData iconData,
  required String label,
  required int index,
  required int currentAnimatedIndex,
  required Color defaultColor,
  required Color selectedColor,
}) {
  final bool isSelected = currentAnimatedIndex == index;

  return NavigationRailDestination(
    icon: Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSizes.p20),
      child: TweenAnimationBuilder<double>(
        key: ValueKey(
          'icon_${index}_${isSelected ? 'selected' : 'unselected'}',
        ),
        tween: Tween<double>(begin: 0.0, end: isSelected ? 1.0 : 0.0),
        duration: const Duration(milliseconds: 500),
        builder: (context, turns, child) {
          return RotationTransition(
            turns: AlwaysStoppedAnimation(turns),
            child: Icon(iconData, size: AppSizes.p32, color: defaultColor),
          );
        },
      ),
    ),
    selectedIcon: Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSizes.p20),
      child: TweenAnimationBuilder<double>(
        key: ValueKey(
          'selected_icon_${index}_${isSelected ? 'selected' : 'unselected'}',
        ),
        tween: Tween<double>(begin: 0.0, end: isSelected ? 1.0 : 0.0),
        duration: const Duration(milliseconds: 500),
        builder: (context, turns, child) {
          return RotationTransition(
            turns: AlwaysStoppedAnimation(turns),
            child: Icon(iconData, size: AppSizes.p40, color: selectedColor),
          );
        },
      ),
    ),
    label: Text(
      label,
      style: const TextStyle(
        fontSize: AppSizes.p16,
        color: AppColors.onPrimary,
      ).copyWith(color: isSelected ? selectedColor : AppColors.onPrimary),
    ),
  );
}
