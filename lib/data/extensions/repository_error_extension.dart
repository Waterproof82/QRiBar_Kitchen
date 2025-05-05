import 'package:flutter/material.dart';
import 'package:qribar_cocina/data/types/repository_error.dart';
import 'package:qribar_cocina/l10n/l10n.dart';

extension RepositoryErrorExtension on RepositoryError {
  String translateError(BuildContext context) {
    return maybeWhen(
      authExpired: () => context.l10n.authenticationExpired,
      badRequest: () => context.l10n.badRequest,
      badRequestListErrors: (listErrors) => listErrors.join('\n'),
      infoNotMatching: () => context.l10n.infoNotMatch,
      noAccess: () => context.l10n.noAccess,
      noInternetConnection: () => context.l10n.noInternetConnection,
      notFoundResource: () => context.l10n.notFound,
      serverError: () => context.l10n.internalServerError,
      securityError: () => context.l10n.securityError,
      listErrors: (listErrors) => listErrors.join('\n'),
      //Login errors
      userNotFound: () => context.l10n.userNotFound,
      wrongPassword: () => context.l10n.wrongPassword,
      orElse: () => context.l10n.unknownError,
    );
  }
}
