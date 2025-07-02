import 'package:flutter/material.dart';

extension BuildContextExtension on BuildContext {
  double get height => MediaQuery.sizeOf(this).height;

  double get width => MediaQuery.sizeOf(this).width;

  bool get isLandscape =>
      MediaQuery.orientationOf(this) == Orientation.landscape;

  bool get isPortrait => MediaQuery.orientationOf(this) == Orientation.portrait;

  ThemeData get theme => Theme.of(this);
}
