// fingerprint_auth_module/lib/presentation/bloc/biometric_auth_state.dart

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:qribar_cocina/app/types/repository_error.dart'; // Your existing error type

part 'biometric_auth_state.freezed.dart';

@freezed
class BiometricAuthState with _$BiometricAuthState {
  /// Initial state: No operation, ready to check availability.
  const factory BiometricAuthState.initial() = _Initial;

  /// State indicating an operation is in progress (e.g., checking biometrics, authenticating).
  const factory BiometricAuthState.loading() = _Loading;

  /// State indicating that biometric authentication is available and credentials are stored,
  /// but no authentication attempt is in progress.
  const factory BiometricAuthState.ready({
    @Default(false) bool canAuthenticateWithBiometrics,
    @Default(false) bool hasStoredCredentials,
  }) = _Ready;

  /// State indicating that the UI should prompt the user to enable biometric login.
  /// Carries the email and password for saving if the user agrees.
  const factory BiometricAuthState.promptForSetup({
    required String email,
    required String password,
  }) = _PromptForSetup;

  /// State indicating that biometric credentials have been successfully saved.
  const factory BiometricAuthState.credentialsSaved() = _CredentialsSaved;

  /// State indicating that biometric authentication and subsequent login were successful.
  const factory BiometricAuthState.biometricLoginSuccess() =
      _BiometricLoginSuccess;

  /// State indicating that biometric authentication or subsequent login failed.
  const factory BiometricAuthState.biometricLoginFailure({
    required String errorMessage,
  }) = _BiometricLoginFailure;

  /// Generic error state for other issues.
  const factory BiometricAuthState.error({required RepositoryError error}) =
      _Error;
}
