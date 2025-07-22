import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qribar_cocina/app/enums/svg_enum.dart';

/// A final [StatelessWidget] that loads and displays SVG assets.
/// It provides options for sizing, fitting, and applying color filters.
final class SvgLoader extends StatelessWidget {
  /// The SVG asset type to load.
  final SvgEnum _svgType;

  /// The desired height of the SVG.
  final double? _height;

  /// The desired width of the SVG.
  final double? _width;

  /// How the SVG should be inscribed into the space allocated during layout.
  final BoxFit _fit;

  /// An optional color to blend with the SVG.
  final Color? _color;

  /// Creates a constant instance of [SvgLoader].
  ///
  /// [svgType]: The specific SVG asset to load.
  /// [height]: Optional height for the SVG.
  /// [width]: Optional width for the SVG.
  /// [fit]: How the SVG should fit its bounds (defaults to [BoxFit.contain]).
  /// [color]: Optional color to apply as a [ColorFilter].
  const SvgLoader(
    this._svgType, {
    super.key,
    double? height,
    double? width,
    BoxFit fit = BoxFit.contain,
    Color? color,
  }) : _height = height,
       _width = width,
       _fit = fit,
       _color = color;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      _svgType.path, // Path to the SVG asset from the enum
      height: _height,
      width: _width,
      excludeFromSemantics:
          true, // Exclude from semantics tree for accessibility if decorative
      fit: _fit,
      colorFilter: _color != null
          ? ColorFilter.mode(_color, BlendMode.srcIn)
          : null,
      // Placeholder widget to display while the SVG is loading.
      placeholderBuilder: (BuildContext context) =>
          const CircularProgressIndicator.adaptive(),
    );
  }
}
