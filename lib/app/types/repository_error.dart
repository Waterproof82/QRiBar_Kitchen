import 'dart:developer';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:qribar_cocina/app/types/errors/network_error.dart';

part 'repository_error.freezed.dart';

@freezed
sealed class RepositoryError with _$RepositoryError {
  const factory RepositoryError.badRequestListErrors(List<String> listErrors) =
      BadRequestListErrors;

  const factory RepositoryError.securityError() = SecurityError;

  const factory RepositoryError.badRequest() = BadRequest;

  const factory RepositoryError.noAccess() = NoAccess;

  const factory RepositoryError.notFoundResource() = NotFoundResource;

  const factory RepositoryError.serverError() = ServerError;

  const factory RepositoryError.noInternetConnection() = NoInternetConnection;

  const factory RepositoryError.authExpired() = AuthExpired;

  const factory RepositoryError.infoNotMatching() = InfoNotMatching;

  const factory RepositoryError.listErrors(List<String> errorList) =
      ListErrorsM;

  const factory RepositoryError.userNotFound() = UserNotFound;

  const factory RepositoryError.wrongPassword() = WrongPassword;

  // Biometrics
  const factory RepositoryError.noStoredCredentials() = _NoStoredCredentials;
  const factory RepositoryError.biometricAuthFailed() = _BiometricAuthFailed;
  const factory RepositoryError.biometricHardwareUnavailable() =
      _BiometricHardwareUnavailable;

  static RepositoryError fromDataSourceError(NetworkError error) {
    return error.maybeWhen(
      badRequestListErrors: (errors) =>
          RepositoryError.badRequestListErrors(errors),
      infoNotMatching: RepositoryError.infoNotMatching,
      badRequest: () => const RepositoryError.badRequest(),
      forbidden: () => const RepositoryError.noAccess(),
      notFound: (_) => const RepositoryError.notFoundResource(),
      internalServerError: () => const RepositoryError.serverError(),
      noInternetConnection: () => const RepositoryError.noInternetConnection(),
      unauthorizedRequest: () => const RepositoryError.authExpired(),
      noStoredCredentials: () => const RepositoryError.noStoredCredentials(),
      biometricAuthFailed: () => const RepositoryError.biometricAuthFailed(),
      biometricHardwareUnavailable: () =>
          const RepositoryError.biometricHardwareUnavailable(),
      orElse: () => const RepositoryError.serverError(),
    );
  }

  static final Map<String, RepositoryError> _firebaseAuthErrorMap = {
    'user-not-found': const RepositoryError.userNotFound(),
    'wrong-password': const RepositoryError.wrongPassword(),
    'invalid-email': const RepositoryError.userNotFound(),
    'user-disabled': const RepositoryError.noAccess(),
    'too-many-requests': const RepositoryError.securityError(),
    'email-already-in-use': const RepositoryError.badRequest(),
    'operation-not-allowed': const RepositoryError.serverError(),
    'network-request-failed': const RepositoryError.noInternetConnection(),
    'invalid-credential': const RepositoryError.authExpired(),
  };

  static RepositoryError fromFirebaseAuthError(String errorCode) {
    final error = _firebaseAuthErrorMap[errorCode];
    if (error == null) {
      log('[FirebaseAuth] Código desconocido: $errorCode');
    }
    return error ?? const RepositoryError.badRequest();
  }
}
