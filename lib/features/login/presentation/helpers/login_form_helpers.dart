part of '../widgets/login_form.dart';

void 
_showBiometricSetupDialog(
  BuildContext context,
  AppLocalizations l10n,
  String email,
  String password,
) {
  showDialog(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        title: Text(l10n.enableBiometricLoginTitle),
        content: Text(l10n.enableBiometricLoginContent),
        actions: [
          TextButton(
            child: Text(l10n.noThanksButton),
            onPressed: () {
              Navigator.of(dialogContext).pop();
            },
          ),
          TextButton(
            child: Text(l10n.yesEnableButton),
            onPressed: () {
              context.read<BiometricAuthBloc>().add(
                BiometricAuthEvent.saveCredentialsRequested(
                  email: email,
                  password: password,
                ),
              );
              Navigator.of(dialogContext).pop();
            },
          ),
        ],
      );
    },
  );
}

void _showBiometricsEnabledSnackBar(
  BuildContext context,
  AppLocalizations l10n,
) {
  CustomSnackBar.show(
    l10n.biometricsEnabledMessage,
    type: SnackBarType.success,
  );
}

void _dispatchSessionRestored(BuildContext context) {
  context.read<LoginFormBloc>().add(const LoginFormEvent.sessionRestored());
}
