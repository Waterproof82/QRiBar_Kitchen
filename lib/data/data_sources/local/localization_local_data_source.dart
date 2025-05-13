import 'package:qribar_cocina/app/types/preferences_type.dart';
import 'package:qribar_cocina/data/data_sources/local/localization_local_datasource_contract.dart';
import 'package:qribar_cocina/data/data_sources/local/preferences_local_datasource_contract.dart';

class LocalizationLocalDataSource implements LocalizationLocalDataSourceContract {
  final PreferencesLocalDataSourceContract _preferences;

  LocalizationLocalDataSource({
    required PreferencesLocalDataSourceContract preferences,
  }) : _preferences = preferences;

  @override
  Future<void> cacheLocalLanguageCode(
    String localeCode,
  ) =>
      _preferences.write<String>(
        key: PreferencesType.localeCode.name,
        value: localeCode,
      );

  @override
  String getCachedLocalLanguageCode() =>
      _preferences.read<String>(
        key: PreferencesType.localeCode.name,
      ) ??
      'es';
}
