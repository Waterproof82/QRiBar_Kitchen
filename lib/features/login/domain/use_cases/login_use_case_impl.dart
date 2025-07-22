import 'package:qribar_cocina/app/types/result.dart';
import 'package:qribar_cocina/features/login/domain/repositories/login_repository_contract.dart';
import 'package:qribar_cocina/features/login/domain/use_cases/login_use_case.dart';

/// A final class that implements the [LoginUseCase] abstract class.
///
/// This concrete implementation provides the business logic for user login,
/// delegating the actual authentication process to a [LoginRepositoryContract].
/// It is marked as `final` to prevent external extension, ensuring this
/// specific implementation remains definitive.
final class LoginUseCaseImpl implements LoginUseCase {
  /// The contract for the login repository, used to perform authentication operations.
  final LoginRepositoryContract _loginRepository;

  /// Creates a constant instance of [LoginUseCaseImpl].
  ///
  /// Requires a [loginRepository] to interact with the data layer.
  const LoginUseCaseImpl(this._loginRepository);

  @override
  /// Executes the login operation with the provided [email] and [password].
  ///
  /// This method calls the `loginWithEmailAndPassword` method on the
  /// injected [LoginRepositoryContract] and returns its [Result].
  /// It acts as an intermediary, applying any necessary domain-specific
  /// logic or validations before or after the repository call (though
  /// none are explicitly shown here).
  Future<Result<void>> call({
    required String email,
    required String password,
  }) async {
    // Delegates the login call to the repository.
    final result = await _loginRepository.loginWithEmailAndPassword(
      email: email,
      password: password,
    );
    return result;
  }
}
