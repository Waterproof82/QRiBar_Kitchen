import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qribar_cocina/features/app/bloc/listener_bloc.dart';
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
  /// The use case for performing login operations.
  final LoginUseCase _loginUseCase;

  /// The BLoC responsible for managing real-time data listeners in the application.
  final ListenerBloc _listenerBloc;

  /// Creates an instance of [LoginFormBloc].
  ///
  /// Requires a [LoginUseCase] to handle login business logic and a [ListenerBloc]
  /// to trigger data listening after successful authentication.
  LoginFormBloc({
    required LoginUseCase loginUseCase,
    required ListenerBloc listenerBloc,
  }) : _loginUseCase = loginUseCase,
       _listenerBloc = listenerBloc,
       super(const LoginFormState()) {
    // Event handler for email changes.
    on<EmailChanged>((event, emit) => emit(state.copyWith(email: event.email)));
    // Event handler for password changes.
    on<PasswordChanged>(
      (event, emit) => emit(state.copyWith(password: event.password)),
    );
    // Event handler for login submission.
    on<LoginSubmitted>(_handleLogin);
    // Event handler for session restoration.
    on<SessionRestored>(_handleSessionRestored);
  }

  /// Handles the [LoginSubmitted] event.
  ///
  /// Attempts to log in the user with the current email and password from the state.
  /// Emits loading, success, or failure states based on the login result.
  Future<void> _handleLogin(
    LoginSubmitted event,
    Emitter<LoginFormState> emit,
  ) async {
    // Set loading state and clear previous errors.
    emit(state.copyWith(isLoading: true, failure: null));

    // Execute the login use case.
    final result = await _loginUseCase(
      email: state.email,
      password: state.password,
    );

    // Handle the result of the login attempt.
    result.when(
      success: (_) {
        // If login is successful, trigger the ListenerBloc to start data listening.
        _listenerBloc.add(const ListenerEvent.startListening());

        emit(state.copyWith(isLoading: false, loginSuccess: true));
      },
      failure: (error) =>
          emit(state.copyWith(isLoading: false, failure: error)),
    );
  }

  /// Handles the [SessionRestored] event.
  ///
  /// This event is typically dispatched when a previous session is automatically
  /// restored (e.g., from cached credentials). It triggers data listening.
  Future<void> _handleSessionRestored(
    SessionRestored event,
    Emitter<LoginFormState> emit,
  ) async {
    // Set loading state and clear previous errors.
    emit(state.copyWith(isLoading: true, failure: null));

    // Trigger the ListenerBloc to start data listening.
    _listenerBloc.add(const ListenerEvent.startListening());

    // Emit success state for session restoration.
    emit(state.copyWith(isLoading: false, loginSuccess: true));
  }
}
