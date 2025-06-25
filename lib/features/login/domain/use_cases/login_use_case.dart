import 'package:qribar_cocina/app/types/result.dart';
import 'package:qribar_cocina/features/login/domain/repositories/login_repository_contract.dart';

class LoginUseCase {
  final LoginRepositoryContract _repository;

  LoginUseCase(this._repository);

  Future<Result<void>> call({
    required String email,
    required String password,
  }) {
    return _repository.loginWithEmailAndPassword(
      email: email,
      password: password,
    );
  }
}
