part of '../widgets/login_form.dart';

void showBiometricSetupDialog({
  required GlobalKey<NavigatorState> navigatorKey,
  required BiometricAuthBloc bloc,
  required AppLocalizations l10n,
  required String email,
  required String password,
}) {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    final context = navigatorKey.currentContext;
    if (context == null) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(l10n.enableBiometricLoginTitle),
          content: Text(l10n.enableBiometricLoginContent),
          actions: [
            TextButton(
              child: Text(l10n.noThanksButton),
              onPressed: () =>
                  Navigator.of(dialogContext, rootNavigator: true).pop(),
            ),
            TextButton(
              child: Text(l10n.yesEnableButton),
              onPressed: () {
                bloc.add(
                  BiometricAuthEvent.saveCredentialsRequested(
                    email: email,
                    password: password,
                  ),
                );
                showBiometricsEnabledSnackBar(context, l10n);
                Navigator.of(dialogContext, rootNavigator: true).pop();
              },
            ),
          ],
        );
      },
    );
  });
}
