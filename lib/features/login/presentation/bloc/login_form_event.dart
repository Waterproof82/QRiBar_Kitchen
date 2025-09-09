import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_form_event.freezed.dart';

@freezed
sealed class LoginFormEvent with _$LoginFormEvent {
  const factory LoginFormEvent.emailChanged(String email) = EmailChanged;
  const factory LoginFormEvent.loginSubmitted({
    required String email,
    required String password,
  }) = LoginSubmitted;
}
