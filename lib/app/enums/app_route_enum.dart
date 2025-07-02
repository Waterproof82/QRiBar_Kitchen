enum AppRoute {
  splash('/splash'),
  login('/login'),
  home('/home'),
  cocinaGeneral('/cuentasCocinaGeneral'),
  cocinaPedidos('/cuentasCocina');

  final String path;
  const AppRoute(this.path);
}
