abstract class AuthRemoteDataSourceContract {
  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<void> signOut();

  String? getCurrentEmail();

  // Biometric re-authentication.
  Future<void> signInWithStoredCredentials({
    required String email,
    required String password,
  });
}
