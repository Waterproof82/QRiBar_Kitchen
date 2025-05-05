abstract class AuthRemoteDataSourceContract {
  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  });
}
