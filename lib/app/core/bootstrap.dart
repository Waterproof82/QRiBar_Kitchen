import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:qribar_cocina/app/types/errors/network_error.dart';
import 'package:qribar_cocina/app/types/repository_error.dart';
import 'package:qribar_cocina/app/types/result.dart';
import 'package:qribar_cocina/app/di/di.dart';

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

  Bloc.observer = const AppBlocObserver();

  try {
    await initDi();

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
