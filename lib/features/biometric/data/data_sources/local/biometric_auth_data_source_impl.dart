import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/local_auth_android.dart';
import 'package:qribar_cocina/app/types/errors/network_error.dart';
import 'package:qribar_cocina/app/types/repository_error.dart';
import 'package:qribar_cocina/app/types/result.dart';
import 'package:qribar_cocina/features/biometric/data/data_sources/local/biometric_auth_data_source.dart';

final class BiometricAuthDataSourceImpl implements BiometricAuthDataSource {
  final LocalAuthentication _auth;

  BiometricAuthDataSourceImpl({LocalAuthentication? auth})
    : _auth = auth ?? LocalAuthentication();

  @override
  Future<Result<bool>> canAuthenticate() async {
    try {
      final bool canCheckBiometrics = await _auth.canCheckBiometrics;
      if (!canCheckBiometrics) {
        return const Result.failure(
          error: RepositoryError.biometricHardwareUnavailable(),
        );
      }

      final List<BiometricType> availableBiometrics = await _auth
          .getAvailableBiometrics();

      if (availableBiometrics.isEmpty) {
        return const Result.success(false);
      }

      return const Result.success(true);
    } on PlatformException catch (e) {
      log('PlatformException during canAuthenticate: ${e.code} - ${e.message}');
      return Result.failure(
        error: RepositoryError.fromDataSourceError(
          NetworkError.fromException(e),
        ),
      );
    } catch (e) {
      log('Unexpected error during canAuthenticate: $e');
      return Result.failure(
        error: RepositoryError.fromDataSourceError(
          NetworkError.fromException(e),
        ),
      );
    }
  }

  @override
  Future<Result<bool>> authenticate({
    required String localizedReason,
    required AndroidAuthMessages androidAuthMessages,
  }) async {
    try {
      final bool didAuthenticate = await _auth.authenticate(
        localizedReason: localizedReason,
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
        authMessages: [androidAuthMessages],
      );

      return Result.success(didAuthenticate);
    } on PlatformException catch (e) {
      log('PlatformException during authenticate: ${e.code} - ${e.message}');
      return Result.failure(
        error: RepositoryError.fromDataSourceError(
          NetworkError.fromException(e),
        ),
      );
    } catch (e) {
      log('Unexpected error during authenticate: $e');
      return Result.failure(
        error: RepositoryError.fromDataSourceError(
          NetworkError.fromException(e),
        ),
      );
    }
  }
}
