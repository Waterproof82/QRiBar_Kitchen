part of 'custom_navigation_rail.dart';

// Define type aliases for setState callback functions for better readability.
typedef UpdateStateCallback = void Function(
  int newCurrentIndex,
  int? newLastIndex,
  String? newLastCategory,
  bool shouldSetState,
);
typedef UpdateInitialStateCallback = void Function(
  int newCurrentIndex,
  int? newLastIndex,
  String? newLastCategory,
);

// Helper function to create a NavigationRailDestination with animated icons.
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

// --- Extracted methods with callbacks for setState ---

// Updates animation and last selection based on navigation provider's category.
void _updateAnimationAndLastSelection(
  NavigationProvider nav,
  UpdateInitialStateCallback updateState, // Uses the type alias
) {
  if (nav.categoriaSelected == SelectionTypeEnum.pedidosScreen.name) {
    updateState(1, 1, nav.categoriaSelected);
  } else if (nav.categoriaSelected == SelectionTypeEnum.generalScreen.name) {
    updateState(0, 0, nav.categoriaSelected);
  } else {
    updateState(0, null, null);
  }
}

// Handles navigation destination selection and updates state accordingly.
void _handleNavigationDestination(
  BuildContext context,
  int index,
  int? lastActiveSelectedIndex, // Passed as argument
  String? lastActiveCategoriaSelected, // Passed as argument
  UpdateStateCallback updateState, // Uses the type alias
) {
  final NavigationProvider nav = Provider.of<NavigationProvider>(
    context,
    listen: false,
  );

  if (index == 0 || index == 1) {
    // General or Pedidos
    int newCurrentIndex = index;
    int? newLastActiveSelectedIndex = index;
    String? newLastActiveCategoriaSelected = (index == 0)
        ? SelectionTypeEnum.generalScreen.name
        : SelectionTypeEnum.pedidosScreen.name;

    updateState(
      newCurrentIndex,
      newLastActiveSelectedIndex,
      newLastActiveCategoriaSelected,
      true,
    );

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
    // First, update the state for the exit button animation.
    updateState(2, lastActiveSelectedIndex, lastActiveCategoriaSelected, true);

    // Temporarily clear categorySelected immediately to remove highlight
    nav.categoriaSelected = '';

    onBackPressed(context).then((didExit) {
      // Here we use a 'shouldSetState' flag to control whether setState is called,
      // as 'mounted' is not directly accessible here.
      if (didExit != true) {
        // User cancelled exit, restore previous state
        updateState(
          lastActiveSelectedIndex ?? 0,
          lastActiveSelectedIndex,
          lastActiveCategoriaSelected ?? SelectionTypeEnum.generalScreen.name,
          true, // Call setState to restore
        );

        nav.categoriaSelected =
            lastActiveCategoriaSelected ?? SelectionTypeEnum.generalScreen.name;
      } else {
        updateState(
          -1,
          null,
          null,
          true,
        ); // Call setState to reset animation
      }
    });
  }
}

// Builds the leading widget for the navigation rail, including a logo and expand/collapse button.
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

// Builds the animated icon for expanding/collapsing the navigation rail.
Widget _buildExpandCollapseIcon(bool expanded) {
  return AnimatedRotation(
    turns: expanded ? 0.5 : 0.0,
    duration: const Duration(milliseconds: 300),
    child: Icon(
      Icons.arrow_back_ios_new,
      size: AppSizes.p24,
      color: AppColors.onPrimary,
    ),
  );
}