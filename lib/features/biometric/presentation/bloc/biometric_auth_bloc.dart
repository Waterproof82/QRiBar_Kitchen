import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qribar_cocina/app/types/errors/network_error.dart';
import 'package:qribar_cocina/app/types/repository_error.dart';
import 'package:qribar_cocina/app/types/result.dart';
import 'package:qribar_cocina/features/biometric/domain/use_cases/authenticate_biometric_use_case.dart';
import 'package:qribar_cocina/features/biometric/domain/use_cases/clear_biometric_credentials_use_case.dart';
import 'package:qribar_cocina/features/biometric/domain/use_cases/save_biometric_credentials_use_case.dart';
import 'package:qribar_cocina/features/biometric/presentation/bloc/biometric_auth_event.dart';
import 'package:qribar_cocina/features/biometric/presentation/bloc/biometric_auth_state.dart';

final class BiometricAuthBloc
    extends Bloc<BiometricAuthEvent, BiometricAuthState> {
  final AuthenticateBiometricUseCase _authenticateUseCase;
  final SaveBiometricCredentialsUseCase _saveCredentialsUseCase;
  final ClearBiometricCredentialsUseCase _clearCredentialsUseCase;

  BiometricAuthBloc({
    required AuthenticateBiometricUseCase authenticateUseCase,
    required SaveBiometricCredentialsUseCase saveCredentialsUseCase,
    required ClearBiometricCredentialsUseCase clearCredentialsUseCase,
  }) : _authenticateUseCase = authenticateUseCase,
       _saveCredentialsUseCase = saveCredentialsUseCase,
       _clearCredentialsUseCase = clearCredentialsUseCase,
       super(const BiometricAuthState.initial()) {
    on<CheckAvailabilityAndCredentials>(_onCheckAvailabilityAndCredentials);
    on<PromptForSetup>(_onPromptForSetup);
    on<SaveCredentialsRequested>(_onSaveCredentialsRequested);
    on<ClearCredentials>(_onClearCredentials);
    on<AuthenticateAndLogin>(_onAuthenticateAndLogin);
  }

  Future<void> _onCheckAvailabilityAndCredentials(
    CheckAvailabilityAndCredentials event,
    Emitter<BiometricAuthState> emit,
  ) async {
    emit(const BiometricAuthState.loading());

    try {
      final canAuthResult = await _authenticateUseCase.callCanAuthenticate();
      final hasCredsResult = await _authenticateUseCase.hasStoredCredentials();

      final canAuthenticate = canAuthResult.when(
        success: (data) => data,
        failure: (err) {
          emit(BiometricAuthState.error(error: err));
          return false;
        },
      );

      final hasStoredCredentials = hasCredsResult.when(
        success: (data) => data,
        failure: (err) {
          emit(BiometricAuthState.error(error: err));
          return false;
        },
      );

      emit(
        BiometricAuthState.ready(
          canAuthenticateWithBiometrics: canAuthenticate,
          hasStoredCredentials: hasStoredCredentials,
        ),
      );
    } catch (e) {
      emit(
        BiometricAuthState.error(
          error: RepositoryError.fromDataSourceError(
            NetworkError.fromException(e),
          ),
        ),
      );
    }
  }

  Future<void> _onPromptForSetup(
    PromptForSetup event,
    Emitter<BiometricAuthState> emit,
  ) async {
    try {
      final canAuthResult = await _authenticateUseCase.callCanAuthenticate();
      final canAuthenticate = canAuthResult.when(
        success: (data) => data,
        failure: (err) {
          emit(BiometricAuthState.error(error: err));
          return false;
        },
      );

      if (canAuthenticate) {
        emit(
          BiometricAuthState.promptForSetup(
            email: event.email,
            password: event.password,
          ),
        );
      } else {
        emit(
          BiometricAuthState.error(
            error: RepositoryError.fromDataSourceError(
              NetworkError.fromException('Biometric not available'),
            ),
          ),
        );
      }
    } catch (e) {
      emit(
        BiometricAuthState.error(
          error: RepositoryError.fromDataSourceError(
            NetworkError.fromException(e),
          ),
        ),
      );
    }
  }

  Future<void> _onSaveCredentialsRequested(
    SaveCredentialsRequested event,
    Emitter<BiometricAuthState> emit,
  ) async {
    emit(const BiometricAuthState.loading());

    try {
      final result = await _saveCredentialsUseCase(
        email: event.email,
        password: event.password,
      );

      result.when(
        success: (_) => emit(const BiometricAuthState.credentialsSaved()),
        failure: (err) => emit(BiometricAuthState.error(error: err)),
      );
    } catch (e) {
      emit(
        BiometricAuthState.error(
          error: RepositoryError.fromDataSourceError(
            NetworkError.fromException(e),
          ),
        ),
      );
    }
  }

  Future<void> _onClearCredentials(
    ClearCredentials event,
    Emitter<BiometricAuthState> emit,
  ) async {
    emit(const BiometricAuthState.loading());

    try {
      final result = await _clearCredentialsUseCase();
      result.when(
        success: (_) => add(const CheckAvailabilityAndCredentials()),
        failure: (err) => emit(BiometricAuthState.error(error: err)),
      );
    } catch (e) {
      emit(
        BiometricAuthState.error(
          error: RepositoryError.fromDataSourceError(
            NetworkError.fromException(e),
          ),
        ),
      );
    }
  }

  Future<void> _onAuthenticateAndLogin(
    AuthenticateAndLogin event,
    Emitter<BiometricAuthState> emit,
  ) async {
    emit(const BiometricAuthState.loading());

    try {
      final result = await _authenticateUseCase.callAuthenticateAndLogin(
        localizedReason: event.localizedReason,
        androidAuthMessages: event.androidAuthMessages,
      );

      result.when(
        success: (_) => emit(const BiometricAuthState.biometricLoginSuccess()),
        failure: (err) => emit(BiometricAuthState.error(error: err)),
      );
    } catch (e) {
      emit(
        BiometricAuthState.error(
          error: RepositoryError.fromDataSourceError(
            NetworkError.fromException(e),
          ),
        ),
      );
    }
  }
}
