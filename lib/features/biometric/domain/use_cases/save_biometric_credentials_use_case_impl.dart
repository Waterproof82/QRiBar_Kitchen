import 'package:qribar_cocina/app/types/result.dart';
import 'package:qribar_cocina/features/biometric/domain/repositories/biometric_auth_repository.dart';
import 'package:qribar_cocina/features/biometric/domain/use_cases/save_biometric_credentials_use_case.dart';

/// Concrete implementation of [SaveBiometricCredentialsUseCase].
final class SaveBiometricCredentialsUseCaseImpl
    implements SaveBiometricCredentialsUseCase {
  final BiometricAuthRepository _repository;

  SaveBiometricCredentialsUseCaseImpl({
    required BiometricAuthRepository repository,
  }) : _repository = repository;

  @override
  Future<Result<void>> call({required String email, required String password}) {
    return _repository.saveBiometricCredentials(
      email: email,
      password: password,
    );
  }
}
