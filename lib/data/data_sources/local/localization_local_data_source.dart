import 'package:qribar_cocina/app/types/preferences_type.dart';
import 'package:qribar_cocina/data/data_sources/local/localization_local_datasource_contract.dart';
import 'package:qribar_cocina/data/data_sources/local/preferences_local_datasource_contract.dart';

/// A final class that implements [LocalizationLocalDataSourceContract].
///
/// This class handles caching and retrieving the local language code
/// using a [PreferencesLocalDataSourceContract].
final class LocalizationLocalDataSource
    implements LocalizationLocalDataSourceContract {
  /// The contract for interacting with local preferences.
  final PreferencesLocalDataSourceContract _preferences;

  /// Creates an instance of [LocalizationLocalDataSource].
  ///
  /// Requires a [preferences] contract to manage local data storage.
  const LocalizationLocalDataSource({
    required PreferencesLocalDataSourceContract preferences,
  }) : _preferences = preferences;

  @override
  /// Caches the provided [localeCode] in local preferences.
  ///
  /// The locale code is stored using [PreferencesType.localeCode.name] as the key.
  Future<void> cacheLocalLanguageCode(String localeCode) => _preferences
      .write<String>(key: PreferencesType.localeCode.name, value: localeCode);

  @override
  /// Retrieves the cached local language code from preferences.
  ///
  /// If no locale code is found, it defaults to 'es' (Spanish).
  String getCachedLocalLanguageCode() =>
      _preferences.read<String>(key: PreferencesType.localeCode.name) ?? 'es';
}
