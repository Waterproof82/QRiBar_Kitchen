import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qribar_cocina/app/types/errors/network_error.dart';
import 'package:qribar_cocina/app/types/repository_error.dart';
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
        try {
          final isFirstTime = await _onboardingCubit.isFirstTime();

          if (isFirstTime) {
            emit(
              AuthState.onboardingRequired(
                email: e.email,
                password: e.password,
              ),
            );
            await _onboardingCubit.setFirstTime();
            return;
          }

          emit(const AuthState.authenticated());
          _listenerBloc.add(const ListenerEvent.startListening());

          await _checkBiometricSetup(e.email, e.password, emit);
        } catch (err) {
          final repoErr = RepositoryError.fromDataSourceError(
            NetworkError.fromException(err),
          );
          emit(AuthState.error(error: repoErr));
        }
      },

      sessionRestored: (e) async {
        try {
          emit(const AuthState.authenticated());
          _listenerBloc.add(const ListenerEvent.startListening());
        } catch (err) {
          final repoErr = RepositoryError.fromDataSourceError(
            NetworkError.fromException(err),
          );
          emit(AuthState.error(error: repoErr));
        }
      },

      onboardingCompleted: (e) async {
        try {
          // Usuario ya completó onboarding, lo autenticamos
          emit(const AuthState.authenticated());
          _listenerBloc.add(const ListenerEvent.startListening());

          await _checkBiometricSetup(e.email, e.password, emit);
        } catch (err) {
          final repoErr = RepositoryError.fromDataSourceError(
            NetworkError.fromException(err),
          );
          emit(AuthState.error(error: repoErr));
        }
      },
    );
  }

  /// Verifica si el usuario necesita configurar biometría
  Future<void> _checkBiometricSetup(
    String email,
    String password,
    Emitter<AuthState> emit,
  ) async {
    try {
      final hasCredsResult = await _authenticateBiometricUseCase
          .hasStoredCredentials();

      final hasStoredCredentials = hasCredsResult.when(
        success: (data) => data,
        failure: (err) {
          emit(AuthState.error(error: err));
          return false;
        },
      );

      if (!hasStoredCredentials) {
        emit(
          AuthState.biometricSetupRequired(email: email, password: password),
        );
      }
    } catch (err) {
      final repoErr = RepositoryError.fromDataSourceError(
        NetworkError.fromException(err),
      );
      emit(AuthState.error(error: repoErr));
    }
  }
}
