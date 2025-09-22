import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qribar_cocina/app/types/errors/network_error.dart';
import 'package:qribar_cocina/app/types/repository_error.dart';
import 'package:qribar_cocina/data/data_sources/local/localization_local_datasource_contract.dart';
import 'package:qribar_cocina/app/localization/cubit/language_state.dart';

/// An [abstract class] that serves as the contract for a Cubit responsible
/// for managing the application's language state.
///
/// It interacts with [LocalizationLocalDataSourceContract] to persist
/// and retrieve the selected language. Concrete implementations will extend this class.
abstract class LanguageCubit extends Cubit<LanguageState> {
  /// The contract for interacting with the local localization data source.
  final LocalizationLocalDataSourceContract _localization;

  /// Creates an instance of [LanguageCubit].
  ///
  /// Initializes the Cubit with the cached language code from [_localization].
  LanguageCubit(LocalizationLocalDataSourceContract localization)
    : _localization = localization,
      super(
        LanguageState(localeCode: localization.getCachedLocalLanguageCode()),
      );

  /// Fetches the current language code from the local data source
  /// and emits a new [LanguageState].
  void fetchLanguage() {
    try {
      emit(
        LanguageState(localeCode: _localization.getCachedLocalLanguageCode()),
      );
    } catch (e) {
      emit(
        LanguageState.error(
          error: RepositoryError.fromDataSourceError(
            NetworkError.fromException(e),
          ),
        ),
      );
    }
  }

  /// Provides the current [Locale] based on the Cubit's state.
  Locale get locale => Locale(
    state.maybeWhen(
      // Normal state callback (unnamed constructor)
      (localeCode) => localeCode,
      // Error state callback
      error: (error, localeCode) => localeCode,
      // Fallback just in case
      orElse: () => 'es',
    ),
  );

  /// Changes the application's language to the given [localeCode].
  ///
  /// If the [localeCode] is already the current one, no action is taken.
  /// Otherwise, it caches the new language code locally and emits
  /// a new [LanguageState].
  Future<void> changeLanguage(String localeCode) async {
    final current = state.maybeWhen(
      // Normal state callback
      (currentLocale) => currentLocale,
      // Error state callback
      error: (_, errorLocale) => errorLocale,
      // Fallback seguro
      orElse: () => 'es',
    );

    if (localeCode == current) return;

    try {
      await _localization.cacheLocalLanguageCode(localeCode);
      emit(LanguageState(localeCode: localeCode));
    } catch (e) {
      emit(
        LanguageState.error(
          error: RepositoryError.fromDataSourceError(
            NetworkError.fromException(e),
          ),
        ),
      );
    }
  }
}
