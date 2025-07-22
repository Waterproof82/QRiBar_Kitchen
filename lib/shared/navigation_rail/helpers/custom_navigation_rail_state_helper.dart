part of '../custom_navigation_rail.dart';

// Determines the target animated index and category based on the [NavigationProvider]'s state.
(int targetAnimatedIndex, String targetCategoriaSelected) _getNavigationTargets(
  NavigationProvider nav,
) {
  if (nav.categoriaSelected == SelectionTypeEnum.pedidosScreen.name) {
    return (1, SelectionTypeEnum.pedidosScreen.name);
  } else if (nav.categoriaSelected == SelectionTypeEnum.generalScreen.name) {
    return (0, SelectionTypeEnum.generalScreen.name);
  } else {
    return (-1, nav.categoriaSelected);
  }
}

// Updates the internal state based on the current [NavigationProvider].
void _updateStateBasedOnNavigationProviderInHelper(
  // Renamed to avoid conflict with the State class method
  NavigationProvider nav,
  Function(int, int?, String?) setStateCallback, // Callback to update state
  int currentAnimatedIndex,
  int lastActiveSelectedIndex,
  String lastActiveCategoriaSelected,
) {
  final (targetAnimatedIndex, targetCategoriaSelected) = _getNavigationTargets(
    nav,
  );

  final bool isCurrentlyExiting = currentAnimatedIndex == 2;
  final bool currentAnimatedIndexNeedsUpdate =
      currentAnimatedIndex != targetAnimatedIndex;
  final bool lastActiveCategoryNeedsUpdate =
      lastActiveCategoriaSelected != targetCategoriaSelected;

  if (!isCurrentlyExiting &&
      (currentAnimatedIndexNeedsUpdate || lastActiveCategoryNeedsUpdate)) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setStateCallback(
        targetAnimatedIndex,
        (targetAnimatedIndex == 0 || targetAnimatedIndex == 1)
            ? targetAnimatedIndex
            : lastActiveSelectedIndex,
        (targetAnimatedIndex == 0 || targetAnimatedIndex == 1)
            ? targetCategoriaSelected
            : lastActiveCategoriaSelected,
      );
    });
  }
}
