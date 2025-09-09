import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_event.freezed.dart';

@freezed
sealed class AuthEvent with _$AuthEvent {
  const factory AuthEvent.loginSucceeded({
    required String email,
    required String password,
  }) = _LoginSucceeded;

  const factory AuthEvent.sessionRestored() = _SessionRestored;
}
