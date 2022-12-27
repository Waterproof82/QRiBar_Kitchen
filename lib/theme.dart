import 'dart:math';

import 'package:flutter/material.dart';

class AppTheme {
  static LinearGradient bgGradient = const LinearGradient(colors: []);
  static LinearGradient iconGradient = const LinearGradient(colors: []);
  static LinearGradient borderGradient = const LinearGradient(colors: []);
  static LinearGradient rotatedBorderGradient = const LinearGradient(colors: []);
  static LinearGradient innerBoxGradient = const LinearGradient(colors: <Color>[]);
  static LinearGradient innerIconGradient = const LinearGradient(colors: []);
  static List<BoxShadow> outerShadow = <BoxShadow>[];

  static BorderRadius boxBorderRadius = const BorderRadius.all(Radius.circular(16));

  ThemeData getTheme(bool isDark) {
    if (!isDark) {
      bgGradient = const LinearGradient(
        colors: <Color>[
          Color(0xFF262B2F),
          Color(0xFF1D2125),
          Color(0xFF16191D),
        ],
        transform: GradientRotation(pi / 2),
        tileMode: TileMode.clamp,
      );
      iconGradient = const LinearGradient(
        colors: <Color>[
          Color(0xFF2D3134),
          Color(0xFF57636E),
          Color(0xFFEBEFF3),
          Color(0xFFAFBBC7),
          Color(0xFF768BA2),
        ],
        stops: [0.0, 0.6, 0.8, 0.95, 1.0],
        transform: GradientRotation(pi + pi / 6),
      );
      borderGradient = LinearGradient(
        colors: <Color>[
          const Color(0xFF646E78).withOpacity(0.4),
          const Color(0xFF000000),
        ],
      );
      rotatedBorderGradient = LinearGradient(
        colors: <Color>[
          const Color(0xFF646E78).withOpacity(0.4),
          const Color(0xFF000000),
        ],
        stops: const [0.3, 1.2],
        transform: const GradientRotation(pi / 3),
      );
      innerBoxGradient = LinearGradient(
        colors: <Color>[
          const Color(0xFF121416),
          const Color(0xFF2C333A).withOpacity(0.4),
        ],
        transform: const GradientRotation(pi / 4),
      );
      innerIconGradient = const LinearGradient(
        colors: <Color>[
          Color(0xFF33393D),
          Color(0xFF889199),
        ],
        transform: GradientRotation(pi / 4),
        //stops: [0.35, 1.25],
      );
      outerShadow = <BoxShadow>[
        const BoxShadow(
          blurRadius: 8.0,
          offset: Offset(2.5, 1.5),
          color: Color(0xFF000000),
        ),
        BoxShadow(
          blurRadius: 8.0,
          offset: const Offset(-2.5, -1.5),
          color: const Color(0xFF646E78).withOpacity(0.4),
        ),
      ];
      return _darkTheme;
    }
    bgGradient = const LinearGradient(
      colors: <Color>[
        Color(0xFFF1F5F8),
        Color(0xFFDDE7F3),
        Color(0xFFE5F0F9),
      ],
      transform: GradientRotation(pi / 2),
      tileMode: TileMode.clamp,
    );
    iconGradient = const LinearGradient(
      colors: <Color>[
        Color(0xFF48647D),
        Color(0xFF6B8299),
        Color(0xFFDAE2EB),
        Color(0xFF8CA2B7),
        Color(0xFFEDF2F7),
      ],
      stops: [0.0, 0.6, 0.8, 0.95, 1.0],
      transform: GradientRotation(pi + pi / 6),
    );
    borderGradient = LinearGradient(
      colors: <Color>[
        const Color(0xFFFFFFFF),
        const Color(0xFF8CA2B7).withOpacity(0.4),
      ],
    );
    rotatedBorderGradient = LinearGradient(
      colors: <Color>[
        const Color(0xFFFFFFFF),
        const Color(0xFF8CA2B7).withOpacity(0.4),
      ],
      stops: const [0.3, 1.2],
      transform: const GradientRotation(pi / 3),
    );
    innerBoxGradient = LinearGradient(
      colors: <Color>[
        const Color(0xFFB9CCE2).withOpacity(0.4),
        const Color(0xFFFFFFFF),
      ],
      transform: const GradientRotation(pi / 4),
    );
    innerIconGradient = const LinearGradient(
      colors: <Color>[
        Color(0xFF5F83AD),
        Color(0xFFDEE9F3),
      ],
      transform: GradientRotation(pi / 4),
      stops: [0.35, 1.25],
    );
    outerShadow = <BoxShadow>[
      BoxShadow(
        blurRadius: 8.0,
        offset: const Offset(3.5, 2.5),
        color: const Color(0xFF8CA2B7).withOpacity(0.4),
      ),
      const BoxShadow(
        blurRadius: 8.0,
        offset: Offset(-3.5, -2.5),
        color: Color(0xFFFFFFFF),
      ),
    ];
    return _lightTheme;
  }

  final ThemeData _lightTheme = ThemeData(
    fontFamily: 'Poppins',
    primaryColor: const Color(0xFFEDF2F8),
    scaffoldBackgroundColor: Colors.transparent,
    appBarTheme: const AppBarTheme(
      elevation: 0.0,
      color: Colors.transparent,
    ),
    colorScheme: ColorScheme.fromSwatch().copyWith(secondary: const Color(0xFF31456A)),
  );

  final ThemeData _darkTheme = ThemeData(
    fontFamily: 'Poppins',
    primaryColor: const Color(0xFF272B30),
    scaffoldBackgroundColor: Colors.transparent,
    appBarTheme: const AppBarTheme(
      elevation: 0.0,
      color: Colors.transparent,
    ),
    colorScheme: ColorScheme.fromSwatch().copyWith(secondary: const Color(0xFFD6E1EF)),
  );
}
