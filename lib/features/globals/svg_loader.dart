import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qribar_cocina/data/types/svg_type.dart';

class SvgLoaderType extends StatelessWidget {
  const SvgLoaderType(SvgType svgType, {super.key, double? height, double? width, BoxFit fit = BoxFit.contain, Color? color})
      : _svgType = svgType,
        _height = height,
        _width = width,
        _fit = fit,
        _color = color;

  final SvgType _svgType;
  final double? _height;
  final double? _width;
  final BoxFit _fit;
  final Color? _color;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      _svgType.path,
      height: _height,
      width: _width,
      excludeFromSemantics: true,
      fit: _fit,
      colorFilter: _color != null ? ColorFilter.mode(_color, BlendMode.srcIn) : null,
      placeholderBuilder: (context) => const CircularProgressIndicator.adaptive(),
    );
  }
}
