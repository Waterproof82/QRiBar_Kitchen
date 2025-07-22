import 'package:local_auth_android/local_auth_android.dart';
import 'package:qribar_cocina/app/types/result.dart';
import 'package:qribar_cocina/features/biometric/domain/repositories/biometric_auth_repository.dart';
import 'package:qribar_cocina/features/biometric/domain/use_cases/authenticate_biometric_use_case.dart';

/// Concrete implementation of [AuthenticateBiometricUseCase].
final class AuthenticateWithBiometricsUseCaseImpl
    implements AuthenticateBiometricUseCase {
  final BiometricAuthRepository _repository;

  AuthenticateWithBiometricsUseCaseImpl({
    required BiometricAuthRepository repository,
  }) : _repository = repository;

  @override
  Future<Result<bool>> callCanAuthenticate() {
    return _repository.canAuthenticateWithBiometrics();
  }

  @override
  Future<Result<void>> callAuthenticateAndLogin({
    required String localizedReason,
    required AndroidAuthMessages androidAuthMessages,
  }) {
    return _repository.authenticateAndLogin(
      localizedReason: localizedReason,
      androidAuthMessages: androidAuthMessages,
    );
  }

  @override
  Future<Result<bool>> hasStoredCredentials() {
    return _repository.hasStoredCredentials();
  }
}
