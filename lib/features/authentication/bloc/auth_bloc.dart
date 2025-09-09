import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qribar_cocina/app/types/result.dart';
import 'package:qribar_cocina/features/app/bloc/listener_bloc.dart';
import 'package:qribar_cocina/features/authentication/bloc/auth_event.dart';
import 'package:qribar_cocina/features/authentication/bloc/auth_state.dart';
import 'package:qribar_cocina/features/biometric/domain/use_cases/authenticate_biometric_use_case.dart';
import 'package:qribar_cocina/features/onboarding/cubit/onboarding_cubit.dart';

final class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final ListenerBloc _listenerBloc;
  final AuthenticateBiometricUseCase _authenticateBiometricUseCase;
  final OnboardingCubit _onboardingCubit;

  AuthBloc({
    required ListenerBloc listenerBloc,
    required AuthenticateBiometricUseCase authenticateBiometricUseCase,
    required OnboardingCubit onboardingCubit,
  }) : _listenerBloc = listenerBloc,
       _authenticateBiometricUseCase = authenticateBiometricUseCase,
       _onboardingCubit = onboardingCubit,
       super(const AuthState.initial()) {
    on<AuthEvent>(_onEvent);
  }
  Future<void> _onEvent(AuthEvent event, Emitter<AuthState> emit) async {
    await event.map(
      loginSucceeded: (e) async {
        final isFirstTime = await _onboardingCubit.isFirstTime();

        if (isFirstTime) {
          emit(
            AuthState.onboardingRequired(email: e.email, password: e.password),
          );
          await _onboardingCubit.setFirstTime();
          return;
        }

        // Si no es la primera vez, el usuario está autenticado y se puede
        // empezar a escuchar.
        emit(const AuthState.authenticated());
        _listenerBloc.add(const ListenerEvent.startListening());

        final hasCredsResult = await _authenticateBiometricUseCase
            .hasStoredCredentials();
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
          return;
        }
      },

      sessionRestored: (e) async {
        emit(const AuthState.authenticated());
        _listenerBloc.add(const ListenerEvent.startListening());
      },

      onboardingCompleted: (e) async {
        // Después de completar el onboarding, el usuario está autenticado.
        // Se puede emitir el estado y empezar a escuchar los datos.
        // emit(const AuthState.authenticated());
        _listenerBloc.add(const ListenerEvent.startListening());

        // La lógica de biometría se ejecuta después de que el usuario
        // haya llegado a la pantalla principal.
        final hasCredsResult = await _authenticateBiometricUseCase
            .hasStoredCredentials();
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
          return;
        }
      },
    );
  }
}
