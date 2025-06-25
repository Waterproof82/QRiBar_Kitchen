import 'package:flutter_svg/flutter_svg.dart';
import 'package:qribar_cocina/app/enums/svg_enum.dart';

Future<void> precacheSVGs() async {
  for (final svgType in SvgEnum.values) {
    final loader = SvgAssetLoader(svgType.path);
    try {
      await svg.cache.putIfAbsent(
        loader.cacheKey(null),
        () => loader.loadBytes(null),
      );
      print('SVG successfully precached: ${svgType.path}');
    } catch (e, stackTrace) {
      print('Error while precaching ${svgType.path}: $e');
      print(stackTrace);
    }
  }
}
