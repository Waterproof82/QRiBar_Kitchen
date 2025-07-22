part of '../di.dart';

void _preferencesModule(SharedPreferences preferences) =>
    getIt.registerLazySingleton<PreferencesLocalDataSourceContract>(
      () => Preferences(sharedPreferences: preferences),
    );
