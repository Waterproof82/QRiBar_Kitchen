part of '../splash_screen.dart';

Future<void> _checkSessionAndNavigate(BuildContext context) async {
  await Future.delayed(const Duration(seconds: 2));
  if (!context.mounted) return;

  final User? user = FirebaseAuth.instance.currentUser;
  final biometricAuthBloc = context.read<BiometricAuthBloc>();

  final bool canAuthenticate = await biometricAuthBloc
      .canAuthenticateWithBiometrics();
  final bool hasStoredCredentials = await biometricAuthBloc
      .hasStoredCredentials();

  final l10n = AppLocalizations.of(context);

  final String localizedReason = l10n.localizedReasonBiometricLogin;

  final authMessages = AndroidAuthMessages(
    signInTitle: l10n.signInTitle,
    cancelButton: l10n.cancelButton,
    biometricHint: l10n.biometricHint,
    biometricNotRecognized: l10n.biometricNotRecognized,
    biometricSuccess: l10n.biometricSuccess,
    goToSettingsButton: l10n.goToSettingsButton,
    goToSettingsDescription: l10n.goToSettingsDescription,
  );

  if (user != null) {
    if (canAuthenticate && hasStoredCredentials) {
      biometricAuthBloc.add(
        BiometricAuthEvent.authenticateForSession(
          localizedReason: localizedReason,
          androidAuthMessages: authMessages,
        ),
      );
    } else {
      context.read<LoginFormBloc>().add(const LoginFormEvent.sessionRestored());
    }
  } else {
    if (canAuthenticate && hasStoredCredentials) {
      biometricAuthBloc.add(
        BiometricAuthEvent.authenticateAndLogin(
          localizedReason: localizedReason,
          androidAuthMessages: authMessages,
        ),
      );
    } else {
      context.goTo(AppRoute.login);
    }
  }
}
