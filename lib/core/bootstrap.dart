import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:qribar_cocina/data/config/svg/precache.dart';
import 'package:qribar_cocina/data/types/errors/network_error.dart';
import 'package:qribar_cocina/data/types/repository_error.dart';
import 'package:qribar_cocina/data/types/result.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

/// A [BlocObserver] which observes all [Bloc] state changes.
class AppBlocObserver extends BlocObserver {
  /// Creates an instance of [AppBlocObserver].
  const AppBlocObserver();

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    log('onChange(${bloc.runtimeType}, $change)');
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    log('onError(${bloc.runtimeType}, $error, $stackTrace)');
    super.onError(bloc, error, stackTrace);
  }
}

/// Bootstraps the application.
Future<Result<void>> bootstrap(FutureOr<Widget> Function() builder) async {
  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };
  WidgetsFlutterBinding.ensureInitialized();

  try {
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

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.bottom]);

    Bloc.observer = const AppBlocObserver();

    runApp(await builder());
    return const Result.success(null);
  } catch (e, stackTrace) {
    log('Error during app bootstrap: $e', stackTrace: stackTrace);
    return Result.failure(
      error: RepositoryError.fromDataSourceError(
        NetworkError.fromException(e),
      ),
    );
  }
}
