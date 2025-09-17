import 'package:flutter/material.dart';
import 'package:qribar_cocina/app/enums/snack_bar_enum.dart';
import 'package:qribar_cocina/app/l10n/app_localizations.dart';
import 'package:qribar_cocina/app/types/repository_error.dart';

extension RepositoryErrorExtension on RepositoryError {
  String translateError(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return maybeWhen(
      // Nuevos casos para errores de biometría
      biometricHardwareUnavailable: () =>
          l10n.biometricHardwareUnavailableError,
      noStoredCredentials: () => l10n.noStoredCredentialsError,
      biometricAuthCancelled: () => l10n.biometricAuthCancelledError,
      biometricAuthFailed: () => l10n.biometricAuthFailedError,
      // Casos existentes
      authExpired: () => l10n.authenticationExpired,
      badRequest: () => l10n.badRequest,
      badRequestListErrors: (listErrors) => listErrors.join('\n'),
      infoNotMatching: () => l10n.infoNotMatch,
      noAccess: () => l10n.noAccess,
      noInternetConnection: () => l10n.noInternetConnection,
      notFoundResource: () => l10n.notFound,
      serverError: () => l10n.internalServerError,
      securityError: () => l10n.securityError,
      listErrors: (listErrors) => listErrors.join('\n'),
      userNotFound: () => l10n.userNotFound,
      wrongPassword: () => l10n.wrongPassword,
      orElse: () => l10n.unknownError,
    );
  }

  SnackBarType get snackBarType {
    return maybeWhen(
      // Nuevos casos de biometría
      biometricHardwareUnavailable: () => SnackBarType.error,
      noStoredCredentials: () => SnackBarType.warning,
      biometricAuthCancelled: () => SnackBarType.info,
      biometricAuthFailed: () => SnackBarType.error,
      // Casos existentes
      userNotFound: () => SnackBarType.warning,
      wrongPassword: () => SnackBarType.error,
      orElse: () => SnackBarType.error,
    );
  }
}
