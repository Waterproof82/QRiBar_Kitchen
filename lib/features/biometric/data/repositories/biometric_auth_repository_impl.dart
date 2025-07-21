import 'package:flutter/services.dart';
import 'package:local_auth_android/local_auth_android.dart';
import 'package:qribar_cocina/app/types/repository_error.dart';
import 'package:qribar_cocina/app/types/result.dart';
import 'package:qribar_cocina/features/biometric/data/data_sources/local/biometric_auth_data_source.dart';
import 'package:qribar_cocina/features/biometric/data/data_sources/local/secure_credential_storage_data_source.dart';
import 'package:qribar_cocina/features/biometric/domain/repositories/biometric_auth_repository.dart';
import 'package:qribar_cocina/features/login/domain/use_cases/login_use_case.dart';

class BiometricAuthRepositoryImpl implements BiometricAuthRepository {
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
  Future<Result<bool>> canAuthenticateWithBiometrics() async {
    try {
      final bool canAuthenticate = await _biometricDataSource.canAuthenticate();
      return Result.success(canAuthenticate);
    } on PlatformException {
      return const Result.failure(error: RepositoryError.securityError());
    } catch (e) {
      return const Result.failure(error: RepositoryError.serverError());
    }
  }

  @override
  Future<Result<bool>> hasStoredCredentials() async {
    try {
      final bool hasCredentials = await _secureStorageDataSource
          .hasCredentials();
      return Result.success(hasCredentials);
    } catch (e) {
      return const Result.failure(error: RepositoryError.serverError());
    }
  }

  @override
  Future<Result<void>> authenticateAndLogin({
    required String localizedReason,
    required AndroidAuthMessages androidAuthMessages,
  }) async {
    try {
      final bool hasCreds = await _secureStorageDataSource.hasCredentials();
      if (!hasCreds) {
        return const Result.failure(error: RepositoryError.badRequest());
      }

      final bool didAuthenticate = await _biometricDataSource.authenticate(
        localizedReason: localizedReason,
        androidAuthMessages: androidAuthMessages,
      );

      if (!didAuthenticate) {
        return const Result.failure(error: RepositoryError.securityError());
      }

      final String? email = await _secureStorageDataSource.getEmail();
      final String? password = await _secureStorageDataSource.getPassword();

      if (email == null ||
          email.isEmpty ||
          password == null ||
          password.isEmpty) {
        return const Result.failure(error: RepositoryError.infoNotMatching());
      }

      final loginResult = await _loginUseCase(email: email, password: password);
      return loginResult;
    } on PlatformException {
      return const Result.failure(error: RepositoryError.securityError());
    } catch (e) {
      return const Result.failure(error: RepositoryError.serverError());
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
      return const Result.failure(error: RepositoryError.serverError());
    }
  }

  @override
  Future<Result<void>> clearBiometricCredentials() async {
    try {
      await _secureStorageDataSource.clearCredentials();
      return const Result.success(null);
    } catch (e) {
      return const Result.failure(error: RepositoryError.serverError());
    }
  }
}
