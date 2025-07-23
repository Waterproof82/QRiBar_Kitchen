import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:local_auth_android/local_auth_android.dart';

part 'biometric_auth_event.freezed.dart';

@freezed
sealed class BiometricAuthEvent with _$BiometricAuthEvent {
  /// Event to check initial biometric capabilities and stored credentials
  const factory BiometricAuthEvent.checkAvailabilityAndCredentials() =
      CheckAvailabilityAndCredentials;

  /// Event to perform biometric authentication and then log in (e.g., from splash)
  const factory BiometricAuthEvent.authenticateAndLogin({
    required String localizedReason,
    required AndroidAuthMessages androidAuthMessages,
  }) = AuthenticateAndLogin;

  /// Event to perform biometric authentication for an already active session
  const factory BiometricAuthEvent.authenticateForSession({
    required String localizedReason,
    required AndroidAuthMessages androidAuthMessages,
  }) = AuthenticateForSession;

  /// Event to tell the UI to prompt the user to enable biometric login
  const factory BiometricAuthEvent.promptForSetup({
    required String email,
    required String password,
  }) = PromptForSetup;

  /// Event dispatched by the UI when the user agrees to save credentials
  const factory BiometricAuthEvent.saveCredentialsRequested({
    required String email,
    required String password,
  }) = SaveCredentialsRequested;

  /// Event to clear stored biometric credentials
  const factory BiometricAuthEvent.clearCredentials() = ClearCredentials;
}
