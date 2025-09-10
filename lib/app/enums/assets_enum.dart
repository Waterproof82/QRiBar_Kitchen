/// Defines application asset paths as an enum.
///
/// Each enum value represents a distinct asset and is associated with its
/// file path.
enum AssetsEnum {
  /// Path to the menu image asset.
  menu('assets/img/menu-img.jpg'),

  /// OnBoarding assets
  sunYellow('assets/onboarding/Sun-Yellow.png'),
  sunRed('assets/onboarding/Sun-Red.png'),
  moonCrescent('assets/onboarding/Moon-Crescent.png');

  /// The associated file path for the asset.
  final String path;

  /// Private constructor for [AssetsEnum] enum values.
  /// Each asset is initialized with its corresponding path.
  const AssetsEnum(this.path);

  /// Generates the path for the dynamic background asset.
  static String getBgPath(String color) => 'assets/onboarding/Bg-$color.png';

  /// Generates the path for the dynamic illustration asset.
  static String getIllustrationPath(String color) =>
      'assets/onboarding/Illustration-$color.png';

  /// Generates the path for the dynamic slider asset.
  static String getSliderPath(String color) =>
      'assets/onboarding/Slider-$color.png';
}
