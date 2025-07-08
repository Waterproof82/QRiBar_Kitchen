part of 'custom_navigation_rail.dart';

// Define type aliases for setState callback functions for better readability.
// No changes here, these are good.
typedef UpdateStateCallback =
    void Function(
      int newCurrentIndex,
      int? newLastIndex,
      String? newLastCategory,
      bool shouldSetState,
    );
typedef UpdateInitialStateCallback =
    void Function(
      int newCurrentIndex,
      int newLastIndex,
      String newLastCategory,
    );

// Helper function to create a NavigationRailDestination with animated icons.
// No changes here.
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

// Builds the list of NavigationRailDestinations.
// No changes here.
List<NavigationRailDestination> _buildDestinationsWidget(
  BuildContext context,
  int currentAnimatedIndex,
) {
  return <NavigationRailDestination>[
    _buildNavigationDestination(
      context: context,
      iconData: Icons.kitchen_sharp,
      label: context.l10n.generalView,
      index: 0,
      currentAnimatedIndex: currentAnimatedIndex,
      defaultColor: AppColors.onPrimary,
      selectedColor: AppColors.primary,
    ),
    _buildNavigationDestination(
      context: context,
      iconData: Icons.soup_kitchen,
      label: context.l10n.tablesView,
      index: 1,
      currentAnimatedIndex: currentAnimatedIndex,
      defaultColor: AppColors.onPrimary,
      selectedColor: AppColors.secondary,
    ),
    _buildNavigationDestination(
      context: context,
      iconData: Icons.logout_outlined,
      label: context.l10n.exitApp,
      index: 2,
      currentAnimatedIndex: currentAnimatedIndex,
      defaultColor: AppColors.error,
      selectedColor: AppColors.error,
    ),
  ];
}

// Helper for initial state setup.
void _updateAnimationAndLastSelection(
  NavigationProvider nav,
  UpdateInitialStateCallback updateInitialState,
) {
  if (nav.categoriaSelected == SelectionTypeEnum.pedidosScreen.name) {
    updateInitialState(1, 1, nav.categoriaSelected);
  } else {
    updateInitialState(0, 0, SelectionTypeEnum.generalScreen.name);
  }
}

// Handles navigation destination selection and updates state accordingly.
// THIS IS WHERE THE 'LAST ACTIVE' STATE IS PRIMARILY DETERMINED.
void _handleNavigationDestination(
  BuildContext context,
  int index,
  // These are the *current* _lastActive values from the State,
  // passed so the exit logic can reliably revert to them.
  int currentLastActiveSelectedIndex,
  String currentLastActiveCategoriaSelected,
  UpdateStateCallback updateState,
) {
  final NavigationProvider nav = Provider.of<NavigationProvider>(
    context,
    listen: false,
  );

  if (index == 0 || index == 1) {
    // General or Pedidos (Direct User Selection)
    final int newCurrentIndex = index;
    final String newCategoriaSelected = (index == 0)
        ? SelectionTypeEnum.generalScreen.name
        : SelectionTypeEnum.pedidosScreen.name;

    // When a user directly selects an item, this IS the new 'last active'.
    updateState(
      newCurrentIndex,
      index, // This is the new _lastActiveSelectedIndex
      newCategoriaSelected, // This is the new _lastActiveCategoriaSelected
      true,
    );

    // Perform navigation and update categorySelected in provider
    if (index == 0) {
      context.goNamed(AppRoute.cocinaGeneral.name);
    } else {
      context.goNamed(AppRoute.cocinaPedidos.name, extra: 1);
    }
    nav.categoriaSelected = newCategoriaSelected; // Update provider
  } else if (index == 2) {
    // Exit App (Transient State)
    // 1. Animate the exit button.
    updateState(
      2, // Set _currentAnimatedIndex to 2 for exit animation
      currentLastActiveSelectedIndex, // Use the last known active index for revert
      currentLastActiveCategoriaSelected, // Use the last known active category for revert
      true,
    );

    // Temporarily clear categorySelected immediately to remove built-in highlight
    nav.categoriaSelected = '';

    onBackPressed(context).then((didExit) {
      if (didExit != true) {
        // User cancelled exit, restore previous state using the captured values
        updateState(
          currentLastActiveSelectedIndex,
          currentLastActiveSelectedIndex,
          currentLastActiveCategoriaSelected,
          true,
        );

        // Restore nav.categoriaSelected so the NavigationRail highlights correctly
        nav.categoriaSelected = currentLastActiveCategoriaSelected;
      } else {
        // User confirmed exit, clear all animations and 'last active' state
        updateState(
          -1, // Clear _currentAnimatedIndex animation
          null, // Clear _lastActiveSelectedIndex
          null, // Clear _lastActiveCategoriaSelected
          true,
        );
      }
    });
  }
}

// No changes to leading or expand/collapse icons, they are good.
Column _buildLeadingWidget(bool isExpanded, VoidCallback onToggleExpand) {
  return Column(
    children: [
      Padding(
        padding: const EdgeInsets.only(bottom: AppSizes.p20, top: AppSizes.p10),
        child: Container(
          width: isExpanded ? AppSizes.p160 : AppSizes.p80,
          height: isExpanded ? AppSizes.p112 : AppSizes.p80,
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
              width: isExpanded ? AppSizes.p56 : AppSizes.p40,
            ),
          ),
        ),
      ),
      IconButton(
        icon: _buildExpandCollapseIcon(isExpanded),
        color: AppColors.onPrimary,
        onPressed: onToggleExpand,
      ),
    ],
  );
}

Widget _buildExpandCollapseIcon(bool expanded) {
  return AnimatedRotation(
    turns: expanded ? 0.5 : 0.0,
    duration: const Duration(milliseconds: 300),
    child: const Icon(
      Icons.arrow_back_ios_new,
      size: AppSizes.p24,
      color: AppColors.onPrimary,
    ),
  );
}
