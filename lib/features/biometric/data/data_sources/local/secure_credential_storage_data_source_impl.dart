// lib/features/biometric/data/data_sources/local/secure_credential_storage_data_source_impl.dart

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:qribar_cocina/features/biometric/data/data_sources/local/secure_credential_storage_data_source.dart';

/// Concrete implementation of [SecureCredentialStorageDataSource]
/// using `flutter_secure_storage`.
class SecureCredentialStorageDataSourceImpl
    implements SecureCredentialStorageDataSource {

  final FlutterSecureStorage _secureStorage;

  // Define keys for secure storage
  static const _emailKey = 'biometric_auth_email';
  static const _passwordKey = 'biometric_auth_password';

  SecureCredentialStorageDataSourceImpl({FlutterSecureStorage? secureStorage})
    : _secureStorage = secureStorage ?? const FlutterSecureStorage();

  @override
  Future<void> saveCredentials({
    required String email,
    required String password,
  }) async {
    await _secureStorage.write(key: _emailKey, value: email);
    await _secureStorage.write(key: _passwordKey, value: password);
  }

  @override
  Future<String?> getEmail() async {
    return await _secureStorage.read(key: _emailKey);
  }

  @override
  Future<String?> getPassword() async {
    return await _secureStorage.read(key: _passwordKey);
  }

  @override
  Future<void> clearCredentials() async {
    await _secureStorage.delete(key: _emailKey);
    await _secureStorage.delete(key: _passwordKey);
  }

  @override
  Future<bool> hasCredentials() async {
    final String? email = await _secureStorage.read(key: _emailKey);
    final String? password = await _secureStorage.read(key: _passwordKey);
    return email != null &&
        email.isNotEmpty &&
        password != null &&
        password.isNotEmpty;
  }
}
