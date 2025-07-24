part of '../custom_navigation_rail.dart';

// Define type aliases for setState callback functions for better readability.
typedef UpdateStateCallback =
    void Function(
      int newCurrentIndex,
      int? newLastIndex,
      String? newLastCategory,
    );
typedef UpdateInitialStateCallback =
    void Function(
      int newCurrentIndex,
      int newLastIndex,
      String newLastCategory,
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
  final l10n = AppLocalizations.of(context);

  return <NavigationRailDestination>[
    _buildNavigationDestination(
      context: context,
      iconData: Icons.kitchen_sharp,
      label: l10n.generalView,
      index: 0,
      currentAnimatedIndex: currentAnimatedIndex,
      defaultColor: AppColors.onPrimary,
      selectedColor: AppColors.primary,
    ),
    _buildNavigationDestination(
      context: context,
      iconData: Icons.soup_kitchen,
      label: l10n.tablesView,
      index: 1,
      currentAnimatedIndex: currentAnimatedIndex,
      defaultColor: AppColors.onPrimary,
      selectedColor: AppColors.secondary,
    ),
    _buildNavigationDestination(
      context: context,
      iconData: Icons.logout_outlined,
      label: l10n.exitApp,
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
void _handleNavigationDestination(
  BuildContext context,
  int index,
  int currentLastActiveSelectedIndex,
  String currentLastActiveCategoriaSelected,
  UpdateStateCallback updateState,
) {
  final NavigationProvider nav = Provider.of<NavigationProvider>(
    context,
    listen: false,
  );

  if (index == 0 || index == 1) {
    final int newCurrentIndex = index;
    final String newCategoriaSelected = (index == 0)
        ? SelectionTypeEnum.generalScreen.name
        : SelectionTypeEnum.pedidosScreen.name;

    updateState(newCurrentIndex, index, newCategoriaSelected);

    if (index == 0) {
      context.goNamed(AppRoute.cocinaGeneral.name);
    } else {
      context.goNamed(AppRoute.cocinaPedidos.name, extra: 1);
    }
    nav.categoriaSelected = newCategoriaSelected;
  } else if (index == 2) {
    updateState(
      2,
      currentLastActiveSelectedIndex,
      currentLastActiveCategoriaSelected,
    );

    nav.categoriaSelected = SelectionTypeEnum.none.name;

    onBackPressed(context).then((didExit) {
      if (didExit != true) {
        updateState(
          currentLastActiveSelectedIndex,
          currentLastActiveSelectedIndex,
          currentLastActiveCategoriaSelected,
        );

        nav.categoriaSelected = currentLastActiveCategoriaSelected;
      } else {
        updateState(-1, null, null);
      }
    });
  }
}
