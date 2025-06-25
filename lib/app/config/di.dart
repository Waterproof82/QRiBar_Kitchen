// core/di/di.dart
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:qribar_cocina/data/data_sources/local/preferences_local_data_source.dart';
import 'package:qribar_cocina/data/data_sources/local/preferences_local_datasource_contract.dart';
import 'package:qribar_cocina/shared/utils/svg_preloader.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

part 'modules/preferences_module.dart';

GetIt getIt = GetIt.instance;

Future<void> initDi() async {
  final sharedPreferences = await SharedPreferences.getInstance();

  await Future.wait([
    Firebase.initializeApp(),
    initializeDateFormatting('es_ES'),
    WakelockPlus.enable(),
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]),
    precacheSVGs(),
  ]);

  _preferencesModule(sharedPreferences);
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.manual,
    overlays: [SystemUiOverlay.bottom],
  );
}
