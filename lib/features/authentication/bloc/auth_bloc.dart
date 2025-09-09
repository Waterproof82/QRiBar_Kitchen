import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qribar_cocina/app/types/result.dart';
import 'package:qribar_cocina/features/app/bloc/listener_bloc.dart';
import 'package:qribar_cocina/features/authentication/bloc/auth_event.dart';
import 'package:qribar_cocina/features/authentication/bloc/auth_state.dart';
import 'package:qribar_cocina/features/biometric/domain/use_cases/authenticate_biometric_use_case.dart';

final class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final ListenerBloc _listenerBloc;
  final AuthenticateBiometricUseCase _authenticateBiometricUseCase;

  AuthBloc({
    required ListenerBloc listenerBloc,
    required AuthenticateBiometricUseCase authenticateBiometricUseCase,
  })  : _listenerBloc = listenerBloc,
        _authenticateBiometricUseCase = authenticateBiometricUseCase,
        super(const AuthState.initial()) {
    on<AuthEvent>(_onEvent);
  }

  Future<void> _onEvent(AuthEvent event, Emitter<AuthState> emit) async {
    await event.map(
      loginSucceeded: (e) async {
        emit(const AuthState.authenticated());
        _listenerBloc.add(const ListenerEvent.startListening());

        final hasCredsResult = await _authenticateBiometricUseCase.hasStoredCredentials();
        final hasStoredCredentials = hasCredsResult.when(
          success: (data) => data,
          failure: (_) => false,
        );

        if (!hasStoredCredentials) {
          emit(
            AuthState.biometricSetupRequired(
              email: e.email,
              password: e.password,
            ),
          );
        }
      },

      sessionRestored: (e) async {
        emit(const AuthState.authenticated());
        _listenerBloc.add(const ListenerEvent.startListening());
      },
    );
  }
}
