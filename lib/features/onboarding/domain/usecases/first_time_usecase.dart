import 'package:qribar_cocina/app/enums/preferences_type_enum.dart';
import 'package:qribar_cocina/data/data_sources/local/preferences_local_datasource_contract.dart';

class FirstTimeUseCase {
  final PreferencesLocalDataSourceContract _preferences;

  FirstTimeUseCase({required PreferencesLocalDataSourceContract preferences})
    : _preferences = preferences;

  Future<bool> isFirstTime() async {
    final value = await _preferences.read<bool>(
      key: PreferencesTypeEnum.firstTime.type,
    );

    return value ?? true;
  }

  Future<void> setFirstTime() async {
    await _preferences.write<bool>(
      key: PreferencesTypeEnum.firstTime.type,
      value: false,
    );
  }

  Future<void> resetFirstTime() async {
    await _preferences.write<bool>(
      key: PreferencesTypeEnum.firstTime.type,
      value: true,
    );
  }
}
