/// Enum representing the different types of SVG files used in the application.
enum SvgType {
  logo('assets/svg/logo.svg'),
  logoName('assets/svg/logo_name.svg');

  /// The file path of the SVG.
  final String path;

  /// Constructs a [SvgType] with the given [path].
  const SvgType(this.path);
}
