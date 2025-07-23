import 'package:local_auth_android/local_auth_android.dart';
import 'package:qribar_cocina/app/types/errors/network_error.dart';
import 'package:qribar_cocina/app/types/repository_error.dart';
import 'package:qribar_cocina/app/types/result.dart';
import 'package:qribar_cocina/features/biometric/data/data_sources/local/biometric_auth_data_source.dart';
import 'package:qribar_cocina/features/biometric/data/data_sources/local/secure_credential_storage_data_source.dart';
import 'package:qribar_cocina/features/biometric/domain/repositories/biometric_auth_repository.dart';
import 'package:qribar_cocina/features/login/domain/use_cases/login_use_case.dart';

final class BiometricAuthRepositoryImpl implements BiometricAuthRepository {
  final BiometricAuthDataSource _biometricDataSource;
  final SecureCredentialStorageDataSource _secureStorageDataSource;
  final LoginUseCase _loginUseCase;

  BiometricAuthRepositoryImpl({
    required BiometricAuthDataSource biometricDataSource,
    required SecureCredentialStorageDataSource secureStorageDataSource,
    required LoginUseCase loginUseCase,
  }) : _biometricDataSource = biometricDataSource,
       _secureStorageDataSource = secureStorageDataSource,
       _loginUseCase = loginUseCase;

  @override
  Future<Result<bool>> canAuthenticateWithBiometrics() {
    return _biometricDataSource.canAuthenticate();
  }

  @override
  Future<Result<bool>> hasStoredCredentials() async {
    try {
      return Result.success(await _secureStorageDataSource.hasCredentials());
    } catch (e) {
      return const Result.failure(error: RepositoryError.noStoredCredentials());
    }
  }

  @override
  Future<Result<void>> authenticateAndLogin({
    required String localizedReason,
    required AndroidAuthMessages androidAuthMessages,
  }) async {
    try {
      final hasCreds = await _secureStorageDataSource.hasCredentials();
      if (!hasCreds) {
        return const Result.failure(error: RepositoryError.badRequest());
      }

      final authResult = await _biometricDataSource.authenticate(
        localizedReason: localizedReason,
        androidAuthMessages: androidAuthMessages,
      );

      return await authResult.when(
        success: (isAuthenticated) async {
          if (!isAuthenticated) {
            return const Result.failure(
              error: RepositoryError.biometricAuthFailed(),
            );
          }

          final email = await _secureStorageDataSource.getEmail();
          final password = await _secureStorageDataSource.getPassword();

          if (email == null ||
              email.isEmpty ||
              password == null ||
              password.isEmpty) {
            return const Result.failure(
              error: RepositoryError.infoNotMatching(),
            );
          }

          return _loginUseCase(email: email, password: password);
        },
        failure: (error) => Result.failure(error: error),
      );
    } catch (e) {
      return Result.failure(
        error: RepositoryError.fromDataSourceError(
          NetworkError.fromException(e),
        ),
      );
    }
  }

  @override
  Future<Result<void>> saveBiometricCredentials({
    required String email,
    required String password,
  }) async {
    try {
      await _secureStorageDataSource.saveCredentials(
        email: email,
        password: password,
      );
      return const Result.success(null);
    } catch (e) {
      return const Result.failure(error: RepositoryError.securityError());
    }
  }

  @override
  Future<Result<void>> clearBiometricCredentials() async {
    try {
      await _secureStorageDataSource.clearCredentials();
      return const Result.success(null);
    } catch (e) {
      return const Result.failure(error: RepositoryError.securityError());
    }
  }
}
