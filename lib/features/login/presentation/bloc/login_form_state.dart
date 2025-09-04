import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:qribar_cocina/app/types/repository_error.dart';

part 'login_form_state.freezed.dart';

@freezed
sealed class LoginFormState with _$LoginFormState {
  const factory LoginFormState.initial({
    @Default('') String email,
    @Default('') String password,
  }) = _Initial;

  const factory LoginFormState.loading({
    required String email,
    required String password,
  }) = _Loading;
  const factory LoginFormState.authenticated({
    required String email,
    required bool sessionRestored,
  }) = _Authenticated;
  const factory LoginFormState.failure({required RepositoryError error}) =
      _Failure;
}
