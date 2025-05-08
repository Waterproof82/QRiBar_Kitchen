/// Enum representing the different types of SVG files used in the application.
enum SvgEnum {
  logo('assets/svg/logo.svg'),
  logoName('assets/svg/logo_name.svg');

  /// The file path of the SVG.
  final String path;

  /// Constructs a [SvgEnum] with the given [path].
  const SvgEnum(this.path);
}
