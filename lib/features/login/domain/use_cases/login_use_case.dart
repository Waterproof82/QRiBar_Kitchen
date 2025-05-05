import 'package:qribar_cocina/data/types/result.dart';
import 'package:qribar_cocina/features/login/domain/repositories/login_repository_contract.dart';

class LoginUseCase {
  final LoginRepositoryContract repository;

  LoginUseCase(this.repository);

  Future<Result<void>> call({
    required String email,
    required String password,
  }) {
    return repository.loginWithEmailAndPassword(
      email: email,
      password: password,
    );
  }
}
