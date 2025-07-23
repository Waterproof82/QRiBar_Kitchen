import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_form_event.freezed.dart';

@freezed
sealed class LoginFormEvent with _$LoginFormEvent {
  const factory LoginFormEvent.emailChanged(String email) = EmailChanged;
  const factory LoginFormEvent.passwordChanged(String password) =
      PasswordChanged;
  const factory LoginFormEvent.loginSubmitted() = LoginSubmitted;
  const factory LoginFormEvent.sessionRestored() = SessionRestored;
  const factory LoginFormEvent.listenerReady() = ListenerReady;
}

