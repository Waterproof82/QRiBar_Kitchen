import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qribar_cocina/features/app/bloc/listener_bloc.dart';
import 'package:qribar_cocina/features/biometric/presentation/bloc/biometric_auth_bloc.dart';
import 'package:qribar_cocina/features/biometric/presentation/bloc/biometric_auth_event.dart';
import 'package:qribar_cocina/features/login/domain/use_cases/login_use_case.dart';
import 'package:qribar_cocina/features/login/presentation/bloc/login_form_event.dart';
import 'package:qribar_cocina/features/login/presentation/bloc/login_form_state.dart';

/// An [abstract class] that serves as the contract for a Bloc responsible
/// for managing the login form's state and logic.
///
/// It handles user input for email and password, attempts login via a use case,
/// and interacts with the [ListenerBloc] to start data listening upon successful login.
/// Concrete implementations will extend this abstract class.

abstract class LoginFormBloc extends Bloc<LoginFormEvent, LoginFormState> {
  final LoginUseCase _loginUseCase;
  final ListenerBloc _listenerBloc;

  final BiometricAuthBloc _biometricAuthBloc;

  LoginFormBloc({
    required LoginUseCase loginUseCase,
    required ListenerBloc listenerBloc,

    required BiometricAuthBloc biometricAuthBloc,
  }) : _loginUseCase = loginUseCase,
       _listenerBloc = listenerBloc,

       _biometricAuthBloc = biometricAuthBloc,
       super(const LoginFormState()) {
    on<EmailChanged>((event, emit) => emit(state.copyWith(email: event.email)));
    on<PasswordChanged>(
      (event, emit) => emit(state.copyWith(password: event.password)),
    );
    on<LoginSubmitted>(_handleLogin);
    on<SessionRestored>(_handleSessionRestored);

    on<ListenerReady>((event, emit) {
      emit(state.copyWith(isLoading: false, loginSuccess: true));
    });
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
      success: (_) async {
        _listenerBloc.add(const ListenerEvent.startListening());

        emit(state.copyWith(isLoading: false, loginSuccess: true));

        // After successful email/password login, check if biometrics are available
        // and prompt the user to enable them if they wish.
        // This could be done by dispatching an event to BiometricAuthBloc,
        // which then triggers a UI prompt.
        final bool canAuthenticate = await _biometricAuthBloc
            .canAuthenticateWithBiometrics();
        if (canAuthenticate) {
          _biometricAuthBloc.add(
            BiometricAuthEvent.promptForSetup(
              email: state.email,
              password: state.password,
            ),
          );
        }
      },
      failure: (error) =>
          emit(state.copyWith(isLoading: false, failure: error)),
    );
  }

  Future<void> _handleSessionRestored(
    SessionRestored event,
    Emitter<LoginFormState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, failure: null));
    _listenerBloc.add(const ListenerEvent.startListening());
  }
}
