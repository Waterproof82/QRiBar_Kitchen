import 'package:qribar_cocina/app/types/result.dart';
import 'package:qribar_cocina/features/biometric/domain/repositories/biometric_auth_repository.dart';
import 'package:qribar_cocina/features/biometric/domain/use_cases/clear_biometric_credentials_use_case.dart';

/// Concrete implementation of [ClearBiometricCredentialsUseCase].
final class ClearBiometricCredentialsUseCaseImpl
    implements ClearBiometricCredentialsUseCase {
  final BiometricAuthRepository _repository;

  ClearBiometricCredentialsUseCaseImpl({
    required BiometricAuthRepository repository,
  }) : _repository = repository;

  @override
  Future<Result<void>> call() {
    return _repository.clearBiometricCredentials();
  }
}
