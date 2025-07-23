import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:qribar_cocina/app/types/repository_error.dart';

part 'login_form_state.freezed.dart';

@freezed
sealed class LoginFormState with _$LoginFormState {
  const factory LoginFormState({
    @Default('') String email,
    @Default('') String password,
    @Default(false) bool isLoading,
    @Default(false) bool loginSuccess,
    RepositoryError? failure,
  }) = _LoginFormState;
}
