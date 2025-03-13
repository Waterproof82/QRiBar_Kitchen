enum AssetsType {
  logoCut('assets/svg/logo_cut.png'),
  logo('assets/svg/logo.png'),
  menu('assets/svg/menu-img.jpg');

  const AssetsType(this.path);
  final String path;
}
