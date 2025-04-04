import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_form_state.freezed.dart';

@freezed
class LoginFormState with _$LoginFormState {
  const factory LoginFormState({
    @Default('') String email,
    @Default('') String password,
    @Default(false) bool isLoading,
    @Default(false) bool loginSuccess,
    LoginFormFailure? failure,
  }) = _LoginFormState;
}

@freezed
class LoginFormFailure with _$LoginFormFailure {
  const factory LoginFormFailure.notFound() = _NotFound;
  const factory LoginFormFailure.unauthorized() = _Unauthorized;
  const factory LoginFormFailure.network() = _Network;
  const factory LoginFormFailure.unknown() = _Unknown;
}
