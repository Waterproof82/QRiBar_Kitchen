import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:qribar_cocina/app/types/repository_error.dart';

part 'auth_state.freezed.dart';

@freezed
sealed class AuthState with _$AuthState {
  const factory AuthState.initial() = _Initial;
  const factory AuthState.authenticated() = _Authenticated;
  const factory AuthState.biometricSetupRequired({
    required String email,
    required String password,
  }) = _BiometricSetupRequired;
  const factory AuthState.onboardingRequired({
    required String email,
    required String password,
  }) = _OnboardingRequired;
  const factory AuthState.error({required RepositoryError error}) = _Error;
}
