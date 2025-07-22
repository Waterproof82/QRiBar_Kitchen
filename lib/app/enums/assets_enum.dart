/// Defines application asset paths as an enum.
///
/// Each enum value represents a distinct asset and is associated with its
/// file path.
enum AssetsEnum {
  /// Path to the menu image asset.
  menu('assets/img/menu-img.jpg');

  /// The associated file path for the asset.
  final String path;

  /// Private constructor for [AssetsEnum] enum values.
  /// Each asset is initialized with its corresponding path.
  const AssetsEnum(this.path);
}
