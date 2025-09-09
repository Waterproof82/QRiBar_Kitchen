import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qribar_cocina/app/types/result.dart';
import 'package:qribar_cocina/features/login/domain/use_cases/login_use_case.dart';
import 'package:qribar_cocina/features/login/presentation/bloc/login_form_event.dart';
import 'package:qribar_cocina/features/login/presentation/bloc/login_form_state.dart'
    hide Failure;

final class LoginFormBloc extends Bloc<LoginFormEvent, LoginFormState> {
  final LoginUseCase _loginUseCase;

  LoginFormBloc({required LoginUseCase loginUseCase})
    : _loginUseCase = loginUseCase,
      super(const LoginFormState.initial()) {
    on<EmailChanged>(_onEmailChanged);
    on<LoginSubmitted>(_handleLogin);
  }

  void _onEmailChanged(EmailChanged event, Emitter<LoginFormState> emit) {
    emit(LoginFormState.initial(email: event.email));
  }

  Future<void> _handleLogin(
    LoginSubmitted event,
    Emitter<LoginFormState> emit,
  ) async {
    emit(const LoginFormState.loading());

    final result = await _loginUseCase(
      email: event.email,
      password: event.password,
    );

    result.when(
      success: (_) {
        emit(
          LoginFormState.authenticated(
            email: event.email,
            sessionRestored: false,
          ),
        );
      },
      failure: (error) {
        emit(LoginFormState.failure(error: error, email: event.email));
      },
    );
  }
}
