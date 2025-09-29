import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:qribar_cocina/app/types/repository_error.dart';
import 'package:qribar_cocina/app/types/result.dart';
import 'package:qribar_cocina/features/app/bloc/listener_bloc.dart';
import 'package:qribar_cocina/features/login/domain/use_cases/login_use_case.dart';
import 'package:qribar_cocina/features/login/presentation/bloc/login_form_bloc.dart';
import 'package:qribar_cocina/features/login/presentation/bloc/login_form_event.dart';
import 'package:qribar_cocina/features/login/presentation/bloc/login_form_state.dart';

// Mocks
class MockLoginUseCase extends Mock implements LoginUseCase {}

class MockListenerBloc extends Mock implements ListenerBloc {}

void main() {
  late MockLoginUseCase mockLoginUseCase;
  late LoginFormBloc bloc;

  setUp(() {
    mockLoginUseCase = MockLoginUseCase();

    registerFallbackValue(const ListenerEvent.startListening());

    bloc = LoginFormBloc(loginUseCase: mockLoginUseCase);
  });

  tearDown(() {
    bloc.close();
  });

  test('estado inicial es LoginFormState.initial', () {
    expect(bloc.state, const LoginFormState.initial());
  });

  blocTest<LoginFormBloc, LoginFormState>(
    'actualiza email cuando se recibe EmailChanged',
    build: () => bloc,
    act: (bloc) => bloc.add(const EmailChanged('test@example.com')),
    expect: () => [const LoginFormState.initial(email: 'test@example.com')],
  );

  blocTest<LoginFormBloc, LoginFormState>(
    'emite estados loading y authenticated cuando loginUseCase es exitoso',
    build: () {
      when(
        () => mockLoginUseCase(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async => const Success<void>(null));
      return bloc;
    },
    seed: () => const LoginFormState.initial(email: 'test@example.com'),
    act: (bloc) => bloc.add(
      const LoginSubmitted(email: 'test@example.com', password: '123456'),
    ),
    expect: () => [
      const LoginFormState.loading(),
      const LoginFormState.authenticated(
        email: 'test@example.com',
        sessionRestored: false,
      ),
    ],
    verify: (_) {
      verify(
        () => mockLoginUseCase(email: 'test@example.com', password: '123456'),
      ).called(1);
    },
  );

  blocTest<LoginFormBloc, LoginFormState>(
    'emite estados loading y error cuando loginUseCase falla',
    build: () {
      when(
        () => mockLoginUseCase(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer(
        (_) async => const Failure<void>(error: RepositoryError.userNotFound()),
      );
      return bloc;
    },
    seed: () => const LoginFormState.initial(email: 'fail@example.com'),
    act: (bloc) => bloc.add(
      const LoginSubmitted(email: 'fail@example.com', password: 'wrong'),
    ),
    expect: () => [
      const LoginFormState.loading(),
      const LoginFormState.error(
        error: RepositoryError.userNotFound(),
        email: 'fail@example.com',
      ),
    ],
    verify: (_) {
      verify(
        () => mockLoginUseCase(email: 'fail@example.com', password: 'wrong'),
      ).called(1);
    },
  );
}
