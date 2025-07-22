import 'package:qribar_cocina/data/data_sources/local/preferences_local_datasource_contract.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A final class that implements [PreferencesLocalDataSourceContract].
///
/// This class acts as a wrapper for `shared_preferences`, providing a
/// simplified and type-safe interface for local data persistence.

final class Preferences implements PreferencesLocalDataSourceContract {
  /// The underlying `SharedPreferences` instance used for data storage.
  final SharedPreferences _sharedPreferences;

  /// Creates an instance of [Preferences].
  ///
  /// Requires an initialized [sharedPreferences] instance to perform
  /// read and write operations.
  Preferences({required SharedPreferences sharedPreferences})
    : _sharedPreferences = sharedPreferences;

  /// Writes a [value] of type `T` to the shared preferences using the given [key].
  ///
  /// Supports `String`, `int`, `double`, `bool`, and `List<String>`.
  /// Throws an [ArgumentError] if the value type is not supported.
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
    throw ArgumentError(
      'Unsupported value type: $T for key $key',
    ); // Added type and key to error message
  }

  /// Reads a value of type `T` from the shared preferences using the given [key].
  ///
  /// Supports `String`, `int`, `double`, `bool`, and `List<String>`.
  /// Returns the value of type `T` if it exists, `null` otherwise.
  /// Throws an [ArgumentError] if the requested type `T` is not supported.
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
    throw ArgumentError(
      'Unsupported type: $T for key $key',
    ); // Added type and key to error message
  }

  /// Clears all data stored in the shared preferences.
  ///
  /// Returns `true` if all preferences were successfully cleared, `false` otherwise.
  @override
  Future<bool> clearAll() => _sharedPreferences.clear();

  /// Clears the value associated with the given [key] from shared preferences.
  ///
  /// Returns `true` if the value for the given [key] was successfully removed, `false` otherwise.
  @override
  Future<bool> clear({required String key}) => _sharedPreferences.remove(key);
}
