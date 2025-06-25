import 'package:qribar_cocina/app/types/result.dart';

abstract class LoginRepositoryContract {
  Future<Result<void>> loginWithEmailAndPassword({
    required String email,
    required String password,
  });
}
