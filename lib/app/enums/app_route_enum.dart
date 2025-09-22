/// Defines the application's routes as an enum.
///
/// Each enum value represents a distinct route in the application
/// and is associated with a specific URL path.
enum AppRouteEnum {
  /// The splash screen route.
  splash('/splash'),

  /// The login screen route.
  login('/login'),

  /// The onboarding screen route.
  onboarding('/onboarding'),

  /// The main home screen route.
  home('/home'),

  /// The general kitchen accounts route.
  cocinaGeneral('/cuentasCocinaGeneral'),

  /// The kitchen orders accounts route.
  cocinaPedidos('/cuentasCocina');

  /// The associated URL path for the route.
  final String path;

  /// Private constructor for [AppRouteEnum] enum values.
  /// Each route is initialized with its corresponding path.
  const AppRouteEnum(this.path);
}
