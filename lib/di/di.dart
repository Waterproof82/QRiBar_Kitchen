// core/di/di.dart
import 'package:dynatrace_flutter_plugin/dynatrace_flutter_plugin.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:qribar_cocina/data/config/svg/precache.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

Future<void> initDi() async {
  await Future.wait([
    Dynatrace().startWithoutWidget(),
    Firebase.initializeApp(),
    initializeDateFormatting('es_ES'),
    WakelockPlus.enable(),
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]),
    precacheSVGs(),
  ]);

  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.manual,
    overlays: [SystemUiOverlay.bottom],
  );
}
