import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qribar_cocina/data/data_sources/local/id_bar_data_source.dart';
import 'package:qribar_cocina/data/extensions/string_extension.dart';

import 'login_form_event.dart';
import 'login_form_state.dart';

class LoginFormBloc extends Bloc<LoginFormEvent, LoginFormState> {
  LoginFormBloc() : super(const LoginFormState()) {
    on<EmailChanged>((event, emit) {
      emit(state.copyWith(email: event.email));
    });

    on<PasswordChanged>((event, emit) {
      emit(state.copyWith(password: event.password));
    });

    on<LoginSubmitted>(_handleLogin);
  }

  Future<void> _handleLogin(
    LoginSubmitted event,
    Emitter<LoginFormState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: state.email.trim(),
        password: state.password.trim(),
      );

      final userName = state.email.split('@').first.toTitleCase();
      IdBarDataSource.instance.setIdBar(userName);

      emit(state.copyWith(isLoading: false, loginSuccess: true));
    } on FirebaseAuthException {
      emit(state.copyWith(
        isLoading: false,
        failure: LoginFormFailure.unauthorized(),
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        failure: LoginFormFailure.unknown(),
      ));
    }
  }
}
