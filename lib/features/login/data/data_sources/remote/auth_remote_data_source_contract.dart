abstract class AuthRemoteDataSourceContract {
  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<void> signOut();

  String? getCurrentEmail();
}
