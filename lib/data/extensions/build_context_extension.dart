import 'package:flutter/material.dart';


extension BuildContextExtension on BuildContext {
  // ThemeData get light => ThemeData(
  //       useMaterial3: true,
  //       primaryColor: StandardColorType.grapeBlue.color,
  //       scaffoldBackgroundColor: StandardColorType.mauiMist.color,
  //       colorScheme: ColorScheme.fromSwatch(
  //           primarySwatch: StandardColorType.grapeBlue.createMaterialColor),
  //       textTheme: typographyLightTheme,
  //       fontFamily: FontType.merryweather.name,
  //       buttonTheme: ButtonThemeData(
  //         buttonColor: StandardColorType.grapeBlue.color,
  //       ),
  //       cardTheme: CardTheme(
  //         color: StandardColorType.white.color,
  //       ),
  //       appBarTheme: AppBarTheme(
  //         color: StandardColorType.grapeBlue.color,
  //       ),
  //       dialogBackgroundColor: StandardColorType.white.color,
  //     );

  double get height => MediaQuery.sizeOf(this).height;

  double get width => MediaQuery.sizeOf(this).width;
  
  bool get isLandscape =>
      MediaQuery.orientationOf(this) == Orientation.landscape;

  bool get isPortrait => MediaQuery.orientationOf(this) == Orientation.portrait;


  ThemeData get theme => Theme.of(this);
}
