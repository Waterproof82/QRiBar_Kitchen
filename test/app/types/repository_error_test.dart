import 'package:flutter_test/flutter_test.dart';
import 'package:qribar_cocina/app/types/errors/network_error.dart';
import 'package:qribar_cocina/app/types/repository_error.dart';

void main() {
  group('RepositoryError', () {
    test('should create RepositoryError from NetworkError with mapping', () {
      final badRequestList = RepositoryError.fromDataSourceError(
        NetworkError.badRequestListErrors(['error1', 'error2']),
      );
      expect(
        badRequestList,
        isA<BadRequestListErrors>(),
      );
      expect(
        (badRequestList as BadRequestListErrors).listErrors,
        ['error1', 'error2'],
      );

      final infoNotMatching = RepositoryError.fromDataSourceError(NetworkError.infoNotMatching());
      expect(infoNotMatching, isA<InfoNotMatching>());

      final badRequest = RepositoryError.fromDataSourceError(NetworkError.badRequest());
      expect(badRequest, isA<BadRequest>());

      final forbidden = RepositoryError.fromDataSourceError(NetworkError.forbidden());
      expect(forbidden, isA<NoAccess>());

      final notFound = RepositoryError.fromDataSourceError(NetworkError.notFound('resource'));
      expect(notFound, isA<NotFoundResource>());

      final serverError = RepositoryError.fromDataSourceError(NetworkError.internalServerError());
      expect(serverError, isA<ServerError>());

      final noInternet = RepositoryError.fromDataSourceError(NetworkError.noInternetConnection());
      expect(noInternet, isA<NoInternetConnection>());

      final unauthorized = RepositoryError.fromDataSourceError(NetworkError.unauthorizedRequest());
      expect(unauthorized, isA<AuthExpired>());

      final unknownError = RepositoryError.fromDataSourceError(NetworkError.unexpectedError());
      expect(unknownError, isA<ServerError>());
    });

    test('should return correct RepositoryError from FirebaseAuth error codes', () {
      expect(
        RepositoryError.fromFirebaseAuthError('user-not-found'),
        equals(const RepositoryError.userNotFound()),
      );
      expect(
        RepositoryError.fromFirebaseAuthError('wrong-password'),
        equals(const RepositoryError.wrongPassword()),
      );
      expect(
        RepositoryError.fromFirebaseAuthError('invalid-email'),
        equals(const RepositoryError.userNotFound()),
      );
      expect(
        RepositoryError.fromFirebaseAuthError('user-disabled'),
        equals(const RepositoryError.noAccess()),
      );
      expect(
        RepositoryError.fromFirebaseAuthError('too-many-requests'),
        equals(const RepositoryError.securityError()),
      );
      expect(
        RepositoryError.fromFirebaseAuthError('email-already-in-use'),
        equals(const RepositoryError.badRequest()),
      );
      expect(
        RepositoryError.fromFirebaseAuthError('operation-not-allowed'),
        equals(const RepositoryError.serverError()),
      );
      expect(
        RepositoryError.fromFirebaseAuthError('network-request-failed'),
        equals(const RepositoryError.noInternetConnection()),
      );
      expect(
        RepositoryError.fromFirebaseAuthError('invalid-credential'),
        equals(const RepositoryError.authExpired()),
      );

      // Código desconocido retorna badRequest y hace print
      final unknown = RepositoryError.fromFirebaseAuthError('unknown-error-code');
      expect(unknown, equals(const RepositoryError.badRequest()));
    });

    test('should create different RepositoryError constructors', () {
      final listErrors = RepositoryError.listErrors(['error1', 'error2']);
      expect(listErrors, isA<ListErrorsM>());
      expect((listErrors as ListErrorsM).errorList, ['error1', 'error2']);

      expect(const RepositoryError.securityError(), isA<SecurityError>());
      expect(const RepositoryError.noAccess(), isA<NoAccess>());
      expect(const RepositoryError.notFoundResource(), isA<NotFoundResource>());
      expect(const RepositoryError.serverError(), isA<ServerError>());
      expect(const RepositoryError.noInternetConnection(), isA<NoInternetConnection>());
      expect(const RepositoryError.authExpired(), isA<AuthExpired>());
      expect(const RepositoryError.infoNotMatching(), isA<InfoNotMatching>());
      expect(const RepositoryError.userNotFound(), isA<UserNotFound>());
      expect(const RepositoryError.wrongPassword(), isA<WrongPassword>());
      expect(const RepositoryError.badRequest(), isA<BadRequest>());
    });
  });
}
