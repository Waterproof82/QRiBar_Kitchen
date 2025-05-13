
import 'package:qribar_cocina/data/data_sources/local/preferences_local_datasource_contract.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Wrapper class for the shared preferences.
class Preferences implements PreferencesLocalDataSourceContract {
  Preferences({required SharedPreferences sharedPreferences})
      : _sharedPreferences = sharedPreferences;
  final SharedPreferences _sharedPreferences;

  /// Writes the value to the shared preferences.
  ///
  /// Returns `true` if the value was successfully written, `false` otherwise.
  @override
  Future<bool> write<T>({required String key, required T value}) async {
    if (T == String) {
      return await _sharedPreferences.setString(key, value as String);
    }
    if (T == int) {
      return await _sharedPreferences.setInt(key, value as int);
    }
    if (T == double) {
      return await _sharedPreferences.setDouble(key, value as double);
    }
    if (T == bool) {
      return await _sharedPreferences.setBool(key, value as bool);
    }
    if (T == List<String>) {
      return await _sharedPreferences.setStringList(key, value as List<String>);
    }
    throw ArgumentError('Unsupported value type');
  }

  /// Reads the value from the shared preferences.
  ///
  /// Returns the value of type `T` if it exists, `null` otherwise.
  @override
  T? read<T>({required String key}) {
    if (T == String) {
      return _sharedPreferences.getString(key) as T?;
    }
    if (T == int) {
      return _sharedPreferences.getInt(key) as T?;
    }
    if (T == double) {
      return _sharedPreferences.getDouble(key) as T?;
    }
    if (T == bool) {
      return _sharedPreferences.getBool(key) as T?;
    }
    if (T == List<String>) {
      return _sharedPreferences.getStringList(key) as T?;
    }
    throw ArgumentError('Unsupported value type');
  }

  /// Clears all the shared preferences.
  ///
  /// Returns `true` if the shared preferences were successfully cleared, `false` otherwise.
  @override
  Future<bool> clearAll() => _sharedPreferences.clear();

  /// Clears the shared preferences for the given [key].
  ///
  /// Returns `true` if the shared preferences for the given [key] were successfully cleared, `false` otherwise.
  @override
  Future<bool> clear({required String key}) => _sharedPreferences.remove(key);
}
