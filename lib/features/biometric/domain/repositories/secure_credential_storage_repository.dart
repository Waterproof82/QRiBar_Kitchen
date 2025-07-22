abstract class SecureCredentialStorageRepository {
  Future<void> saveCredentials(String email, String password);
  Future<Map<String, String>?> readCredentials();
  Future<void> deleteCredentials();
}
