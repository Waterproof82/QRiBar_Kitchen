import 'package:firebase_auth/firebase_auth.dart';
import 'package:qribar_cocina/features/login/data/data_sources/remote/auth_remote_data_source_contract.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSourceContract {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
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
  Future<void> signOut() async {
    await _auth.signOut();
  }

  @override
  String? getCurrentEmail() {
    return _auth.currentUser?.email;
  }
}
