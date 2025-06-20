import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qribar_cocina/features/login/domain/use_cases/login_use_case.dart';

import 'login_form_event.dart';
import 'login_form_state.dart';

class LoginFormBloc extends Bloc<LoginFormEvent, LoginFormState> {
  final LoginUseCase _loginUseCase;

  LoginFormBloc({required LoginUseCase loginUseCase})
      : _loginUseCase = loginUseCase,
        super(const LoginFormState()) {
    on<EmailChanged>(
      (event, emit) => emit(
        state.copyWith(email: event.email),
      ),
    );
    on<PasswordChanged>(
      (event, emit) => emit(
        state.copyWith(password: event.password),
      ),
    );
    on<LoginSubmitted>(_handleLogin);
  }

  Future<void> _handleLogin(
    LoginSubmitted event,
    Emitter<LoginFormState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, failure: null));

    final result = await _loginUseCase(
      email: state.email,
      password: state.password,
    );

    result.when(
      success: (_) => emit(state.copyWith(isLoading: false, loginSuccess: true)),
      failure: (error) => emit(state.copyWith(
        isLoading: false,
        failure: error,
      )),
    );
  }
}
