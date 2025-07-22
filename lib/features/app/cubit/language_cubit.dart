import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qribar_cocina/data/data_sources/local/localization_local_datasource_contract.dart';

/// A final class representing the state of language changes.
///
/// This class is immutable and holds the current locale code.
/// Marked as `final` to prevent external extension or implementation,
/// ensuring its structure remains definitive.
final class LanguageChangedState {
  /// The locale code (e.g., 'es', 'en') for the current language.
  final String localeCode;

  /// Creates a constant instance of [LanguageChangedState].
  ///
  /// This constructor is `const` as all its fields are `final`,
  /// allowing instances to be created at compile-time.
  const LanguageChangedState({required this.localeCode});

  /// Creates a copy of this [LanguageChangedState] with optional new values.
  LanguageChangedState copyWith({String? localeCode}) {
    return LanguageChangedState(localeCode: localeCode ?? this.localeCode);
  }
}

/// An [abstract class] that serves as the contract for a Cubit responsible
/// for managing the application's language state.
///
/// It interacts with [LocalizationLocalDataSourceContract] to persist
/// and retrieve the selected language.
/// Concrete implementations will extend this abstract class.
abstract class LanguageCubit extends Cubit<LanguageChangedState> {
  /// The contract for interacting with the local localization data source.
  final LocalizationLocalDataSourceContract _localization;

  /// Creates an instance of [LanguageCubit].
  ///
  /// Initializes the Cubit with the cached language code from [_localization].
  LanguageCubit(LocalizationLocalDataSourceContract localization)
    : _localization = localization,
      super(
        LanguageChangedState(
          localeCode: localization.getCachedLocalLanguageCode(),
        ),
      );

  /// Fetches the current language code from the local data source
  /// and emits a new [LanguageChangedState].
  void fetchLanguage() {
    emit(
      LanguageChangedState(
        localeCode: _localization.getCachedLocalLanguageCode(),
      ),
    );
  }

  /// Provides the current [Locale] based on the Cubit's state.
  Locale get locale => Locale(state.localeCode);

  /// Changes the application's language to the given [localeCode].
  ///
  /// If the [localeCode] is already the current one, no action is taken.
  /// Otherwise, it caches the new language code locally and emits
  /// a new [LanguageChangedState].
  Future<void> changeLanguage(String localeCode) async {
    if (localeCode == state.localeCode) return;
    await _localization.cacheLocalLanguageCode(localeCode);
    emit(LanguageChangedState(localeCode: localeCode));
  }
}
