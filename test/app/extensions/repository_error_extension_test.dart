import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qribar_cocina/app/enums/snack_bar_enum.dart';
import 'package:qribar_cocina/app/extensions/repository_error_extension.dart';
import 'package:qribar_cocina/app/l10n/app_localizations.dart';
import 'package:qribar_cocina/app/types/repository_error.dart';

import '../../helpers/pump_app.dart';

void main() {
  group('RepositoryErrorExtension - translateError', () {
    late BuildContext context;

    Future<void> _pumpWithContext(WidgetTester tester, Locale locale) async {
      await tester.pumpApp(
        Builder(
          builder: (ctx) {
            context = ctx;
            return const SizedBox.shrink();
          },
        ),
        locale: locale,
      );
      await tester.pumpAndSettle();
    }

    testWidgets('authExpired returns localized string', (tester) async {
      await _pumpWithContext(tester, const Locale('en'));
      final result = RepositoryError.authExpired().translateError(context);
      expect(result, AppLocalizations.of(context).authenticationExpired);
    });

    testWidgets('badRequestListErrors returns joined error list', (tester) async {
      await _pumpWithContext(tester, const Locale('en'));
      final result = RepositoryError.badRequestListErrors(['Error 1', 'Error 2']).translateError(context);
      expect(result, 'Error 1\nError 2');
    });

    testWidgets('userNotFound returns localized string', (tester) async {
      await _pumpWithContext(tester, const Locale('en'));
      final result = RepositoryError.userNotFound().translateError(context);
      expect(result, AppLocalizations.of(context).userNotFound);
    });

    testWidgets('notFoundResource returns localized string', (tester) async {
      await _pumpWithContext(tester, const Locale('en'));
      final result = RepositoryError.notFoundResource().translateError(context);
      expect(result, AppLocalizations.of(context).notFound);
    });

    testWidgets('listErrors returns joined string', (tester) async {
      await _pumpWithContext(tester, const Locale('en'));
      final result = RepositoryError.listErrors(['A', 'B']).translateError(context);
      expect(result, 'A\nB');
    });

    testWidgets('badRequest returns localized string', (tester) async {
      await _pumpWithContext(tester, const Locale('en'));
      final result = RepositoryError.badRequest().translateError(context);
      expect(result, AppLocalizations.of(context).badRequest);
    });

    testWidgets('infoNotMatching returns localized string', (tester) async {
      await _pumpWithContext(tester, const Locale('en'));
      final result = RepositoryError.infoNotMatching().translateError(context);
      expect(result, AppLocalizations.of(context).infoNotMatch);
    });

    testWidgets('noAccess returns localized string', (tester) async {
      await _pumpWithContext(tester, const Locale('en'));
      final result = RepositoryError.noAccess().translateError(context);
      expect(result, AppLocalizations.of(context).noAccess);
    });

    testWidgets('noInternetConnection returns localized string', (tester) async {
      await _pumpWithContext(tester, const Locale('en'));
      final result = RepositoryError.noInternetConnection().translateError(context);
      expect(result, AppLocalizations.of(context).noInternetConnection);
    });

    testWidgets('serverError returns localized string', (tester) async {
      await _pumpWithContext(tester, const Locale('en'));
      final result = RepositoryError.serverError().translateError(context);
      expect(result, AppLocalizations.of(context).internalServerError);
    });

    testWidgets('securityError returns localized string', (tester) async {
      await _pumpWithContext(tester, const Locale('en'));
      final result = RepositoryError.securityError().translateError(context);
      expect(result, AppLocalizations.of(context).securityError);
    });

    testWidgets('wrongPassword returns localized string', (tester) async {
      await _pumpWithContext(tester, const Locale('en'));
      final result = RepositoryError.wrongPassword().translateError(context);
      expect(result, AppLocalizations.of(context).wrongPassword);
    });

    testWidgets('unknownError returns localized string (en)', (tester) async {
      await _pumpWithContext(tester, const Locale('en'));
      final result = RepositoryError.badRequest().translateError(context);
      expect(result, AppLocalizations.of(context).badRequest);
    });

    testWidgets('unknownError returns localized string (es)', (tester) async {
      await _pumpWithContext(tester, const Locale('es'));
      final result = RepositoryError.badRequest().translateError(context);
      expect(result, AppLocalizations.of(context).badRequest);
    });

    test('snackBarType returns correct type', () {
      final userNotFoundError = RepositoryError.userNotFound();
      final wrongPasswordError = RepositoryError.wrongPassword();
      final defaultError = RepositoryError.serverError();

      expect(userNotFoundError.snackBarType, SnackBarType.warning);
      expect(wrongPasswordError.snackBarType, SnackBarType.warning);
      expect(defaultError.snackBarType, SnackBarType.error);
    });
  });
}
