import 'package:firebase_auth/firebase_auth.dart';
import 'package:qribar_cocina/features/login/data/data_sources/remote/auth_remote_data_source_contract.dart';

/// A final class that implements [AuthRemoteDataSourceContract].
///
/// This class provides the concrete implementation for authentication operations
/// using Firebase Authentication.
final class AuthRemoteDataSourceImpl implements AuthRemoteDataSourceContract {
  /// The instance of [FirebaseAuth] used for authentication.
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Creates an instance of [AuthRemoteDataSourceImpl].
  ///
  /// This constructor initializes the Firebase Authentication instance.
  AuthRemoteDataSourceImpl();

  @override
  /// Signs in a user with the provided [email] and [password].
  ///
  /// The email and password strings are trimmed before being used.
  /// Throws a [FirebaseAuthException] on failure.
  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) {
    return _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password.trim(),
    );
  }

  @override
  /// Signs out the currently authenticated user.
  ///
  /// Throws a [FirebaseAuthException] on failure.
  Future<void> signOut() async {
    await _auth.signOut();
  }

  @override
  /// Retrieves the email of the currently authenticated user.
  ///
  /// Returns the user's email as a [String] if a user is signed in,
  /// otherwise returns `null`.
  String? getCurrentEmail() {
    return _auth.currentUser?.email;
  }
}
