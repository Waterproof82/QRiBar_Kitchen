import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qribar_cocina/app/types/errors/network_error.dart';
import 'package:qribar_cocina/app/types/repository_error.dart';
import 'package:qribar_cocina/app/types/result.dart';
import 'package:qribar_cocina/features/app/bloc/listener_bloc.dart';
import 'package:qribar_cocina/features/biometric/domain/use_cases/authenticate_biometric_use_case.dart';
import 'package:qribar_cocina/features/biometric/domain/use_cases/clear_biometric_credentials_use_case.dart';
import 'package:qribar_cocina/features/biometric/domain/use_cases/save_biometric_credentials_use_case.dart';
import 'package:qribar_cocina/features/biometric/presentation/bloc/biometric_auth_event.dart';
import 'package:qribar_cocina/features/biometric/presentation/bloc/biometric_auth_state.dart';

class BiometricAuthBloc extends Bloc<BiometricAuthEvent, BiometricAuthState> {
  final AuthenticateBiometricUseCase _authenticateUseCase;
  final SaveBiometricCredentialsUseCase _saveCredentialsUseCase;
  final ClearBiometricCredentialsUseCase _clearCredentialsUseCase;
  final ListenerBloc _listenerBloc;

  BiometricAuthBloc({
    required AuthenticateBiometricUseCase authenticateUseCase,
    required SaveBiometricCredentialsUseCase saveCredentialsUseCase,
    required ClearBiometricCredentialsUseCase clearCredentialsUseCase,
    required ListenerBloc listenerBloc,
  }) : _authenticateUseCase = authenticateUseCase,
       _saveCredentialsUseCase = saveCredentialsUseCase,
       _clearCredentialsUseCase = clearCredentialsUseCase,

       _listenerBloc = listenerBloc,
       super(const BiometricAuthState.initial()) {
    on<CheckAvailabilityAndCredentials>(_onCheckAvailabilityAndCredentials);
    on<AuthenticateAndLogin>(_onAuthenticateAndLogin);
    on<PromptForSetup>(_onPromptForSetup);
    on<SaveCredentialsRequested>(_onSaveCredentialsRequested);
    on<ClearCredentials>(_onClearCredentials);
    on<AuthenticateForSession>(_onAuthenticateForSession);
  }

  Future<void> _onCheckAvailabilityAndCredentials(
    CheckAvailabilityAndCredentials event,
    Emitter<BiometricAuthState> emit,
  ) async {
    emit(const BiometricAuthState.loading());

    final canAuthResult = await _authenticateUseCase.callCanAuthenticate();
    final hasCredsResult = await _authenticateUseCase.hasStoredCredentials();

    bool canAuthenticate = false;
    bool hasCredentials = false;
    RepositoryError? error;

    canAuthResult.when(
      success: (data) => canAuthenticate = data,
      failure: (err) => error = err,
    );

    if (error != null) {
      emit(BiometricAuthState.error(error: error!));
      return;
    }

    hasCredsResult.when(
      success: (data) => hasCredentials = data,
      failure: (err) => error = err,
    );

    if (error != null) {
      emit(BiometricAuthState.error(error: error!));
      return;
    }

    emit(
      BiometricAuthState.ready(
        canAuthenticateWithBiometrics: canAuthenticate,
        hasStoredCredentials: hasCredentials,
      ),
    );
  }

  Future<void> _onAuthenticateAndLogin(
    AuthenticateAndLogin event,
    Emitter<BiometricAuthState> emit,
  ) async {
    emit(const BiometricAuthState.loading());

    final authAndLoginResult = await _authenticateUseCase
        .callAuthenticateAndLogin(
          localizedReason: event.localizedReason,
          androidAuthMessages: event.androidAuthMessages,
        );

    await authAndLoginResult.when(
      success: (_) async {
        // Biometric authentication and internal login in use case were successful
        emit(const BiometricAuthState.biometricLoginSuccess());
      },
      failure: (err) {
        emit(
          BiometricAuthState.biometricLoginFailure(
            errorMessage: err.toString(),
          ),
        );
        // _clearCredentialsUseCase.call();
      },
    );
  }

  Future<void> _onPromptForSetup(
    PromptForSetup event,
    Emitter<BiometricAuthState> emit,
  ) async {
    // Before prompting, ensure biometrics are available.
    final canAuthResult = await _authenticateUseCase.callCanAuthenticate();
    bool canAuthenticate = false;

    canAuthResult.when(
      success: (data) => canAuthenticate = data,
      failure: (err) => emit(BiometricAuthState.error(error: err)),
    );

    if (canAuthenticate) {
      // Emit the prompt state, carrying the credentials for the UI dialog.
      emit(
        BiometricAuthState.promptForSetup(
          email: event.email,
          password: event.password,
        ),
      );
    } else {
      // Emit an error if biometrics are not available.
      emit(
        BiometricAuthState.error(
          error: RepositoryError.fromDataSourceError(
            const NetworkError.badRequest(),
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

    final result = await _saveCredentialsUseCase(
      email: event.email,
      password: event.password,
    );

    await result.when(
      success: (_) {
        emit(const BiometricAuthState.credentialsSaved());
      },
      failure: (err) {
        emit(BiometricAuthState.error(error: err));
      },
    );
  }

  Future<void> _onClearCredentials(
    ClearCredentials event,
    Emitter<BiometricAuthState> emit,
  ) async {
    emit(const BiometricAuthState.loading());

    final result = await _clearCredentialsUseCase();

    await result.when(
      success: (_) {
        // After clearing, return to a ready state, but with no stored credentials.
        // Re-check `canAuthenticate` to keep the state accurate.
        _onCheckAvailabilityAndCredentials(
          const CheckAvailabilityAndCredentials(),
          emit,
        );
      },
      failure: (err) {
        emit(BiometricAuthState.error(error: err));
      },
    );
  }

  Future<void> _onAuthenticateForSession(
    AuthenticateForSession event,
    Emitter<BiometricAuthState> emit,
  ) async {
    emit(const BiometricAuthState.loading());

    // This use case will typically perform biometric check and then re-authenticate
    // with Firebase using stored credentials.
    final result = await _authenticateUseCase.callAuthenticateAndLogin(
      localizedReason: event.localizedReason,
      androidAuthMessages: event.androidAuthMessages,
    );

    await result.when(
      success: (_) {
        emit(const BiometricAuthState.biometricLoginSuccess());
        _listenerBloc.add(const ListenerEvent.startListening());
      },
      failure: (err) {
        emit(BiometricAuthState.error(error: err));
      },
    );
  }

  // Helper methods for direct checks (used by _checkSessionAndNavigate)
  Future<bool> canAuthenticateWithBiometrics() async {
    final result = await _authenticateUseCase.callCanAuthenticate();
    return result.when(success: (data) => data, failure: (_) => false);
  }

  Future<bool> hasStoredCredentials() async {
    final result = await _authenticateUseCase.hasStoredCredentials();
    return result.when(success: (data) => data, failure: (_) => false);
  }
}
