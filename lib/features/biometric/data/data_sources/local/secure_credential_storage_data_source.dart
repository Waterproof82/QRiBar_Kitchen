/// Abstract contract for a local data source handling secure storage of credentials for biometrics.
abstract class SecureCredentialStorageDataSource {
  /// Stores the user's email and password securely.
  Future<void> saveCredentials({
    required String email,
    required String password,
  });

  /// Retrieves the securely stored email.
  Future<String?> getEmail();

  /// Retrieves the securely stored password.
  Future<String?> getPassword();

  /// Clears all securely stored credentials.
  Future<void> clearCredentials();

  /// Checks if credentials are currently stored.
  Future<bool> hasCredentials();
}
