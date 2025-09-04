import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:qribar_cocina/app/types/repository_error.dart';

part 'biometric_auth_state.freezed.dart';

@freezed
sealed class BiometricAuthState with _$BiometricAuthState {
  const factory BiometricAuthState.initial() = _Initial;

  const factory BiometricAuthState.loading() = _Loading;

  const factory BiometricAuthState.ready({
    @Default(false) bool canAuthenticateWithBiometrics,
    @Default(false) bool hasStoredCredentials,
  }) = _Ready;

  const factory BiometricAuthState.promptForSetup({
    required String email,
    required String password,
  }) = _PromptForSetup;

  const factory BiometricAuthState.credentialsSaved() = _CredentialsSaved;

  const factory BiometricAuthState.biometricLoginSuccess() =
      _BiometricLoginSuccess;

  /// Estado unificado de error para todos los casos.
  const factory BiometricAuthState.error({required RepositoryError error}) =
      _Error;
}
