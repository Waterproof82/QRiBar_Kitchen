import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qribar_cocina/app/types/result.dart';
import 'package:qribar_cocina/features/login/domain/use_cases/login_use_case.dart';
import 'package:qribar_cocina/features/login/presentation/bloc/login_form_event.dart';
import 'package:qribar_cocina/features/login/presentation/bloc/login_form_state.dart';

class LoginFormBloc extends Bloc<LoginFormEvent, LoginFormState> {
  final LoginUseCase _loginUseCase;

  LoginFormBloc({required LoginUseCase loginUseCase})
    : _loginUseCase = loginUseCase,
      super(const LoginFormState.initial()) {
    on<EmailChanged>(_onEmailChanged);
    on<PasswordChanged>(_onPasswordChanged);
    on<LoginSubmitted>(_handleLogin);
    on<SessionRestored>(_handleSessionRestored);
  }

  String get _email =>
      state.whenOrNull(
        initial: (email, _) => email,
        loading: (email, _) => email,
        authenticated: (email, _) => email,
      ) ??
      '';

  String get _password =>
      state.whenOrNull(
        initial: (_, password) => password,
        loading: (_, password) => password,
      ) ??
      '';

  void _onEmailChanged(EmailChanged event, Emitter<LoginFormState> emit) {
    state.mapOrNull(
      initial: (s) => emit(s.copyWith(email: event.email)),
      loading: (s) => emit(s.copyWith(email: event.email)),
    );
  }

  void _onPasswordChanged(PasswordChanged event, Emitter<LoginFormState> emit) {
    state.mapOrNull(
      initial: (s) => emit(s.copyWith(password: event.password)),
      loading: (s) => emit(s.copyWith(password: event.password)),
    );
  }

  Future<void> _handleLogin(
    LoginSubmitted event,
    Emitter<LoginFormState> emit,
  ) async {
    emit(LoginFormState.loading(email: _email, password: _password));

    final result = await _loginUseCase(email: _email, password: _password);

    switch (result) {
      case Success():
        emit(
          LoginFormState.authenticated(email: _email, sessionRestored: false),
        );
      case Failure(:final error):
        emit(LoginFormState.failure(error: error));
    }
  }

  void _handleSessionRestored(
    SessionRestored event,
    Emitter<LoginFormState> emit,
  ) {
    emit(LoginFormState.authenticated(email: _email, sessionRestored: true));
  }
}
