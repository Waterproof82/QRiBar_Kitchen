import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qribar_cocina/features/app/bloc/listener_bloc.dart';
import 'package:qribar_cocina/features/login/domain/use_cases/login_use_case.dart';

import 'login_form_event.dart';
import 'login_form_state.dart';

class LoginFormBloc extends Bloc<LoginFormEvent, LoginFormState> {
  final LoginUseCase _loginUseCase;
  final ListenerBloc _listenerBloc;

  LoginFormBloc({
    required LoginUseCase loginUseCase,
    required ListenerBloc listenerBloc,
  }) : _loginUseCase = loginUseCase,
       _listenerBloc = listenerBloc,

       super(const LoginFormState()) {
    on<EmailChanged>((event, emit) => emit(state.copyWith(email: event.email)));
    on<PasswordChanged>(
      (event, emit) => emit(state.copyWith(password: event.password)),
    );
    on<LoginSubmitted>(_handleLogin);

    on<SessionRestored>(_handleSessionRestored);
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
      success: (_) {
        _listenerBloc.add(const ListenerEvent.startListening());
        emit(state.copyWith(isLoading: false, loginSuccess: true));
      },
      failure: (error) =>
          emit(state.copyWith(isLoading: false, failure: error)),
    );
  }

  Future<void> _handleSessionRestored(
    SessionRestored event,
    Emitter<LoginFormState> emit,
  ) async {
    //emit(state.copyWith(isLoading: true, failure: null));

    _listenerBloc.add(const ListenerEvent.startListening());

    emit(state.copyWith(isLoading: false, loginSuccess: true));
  }
}
