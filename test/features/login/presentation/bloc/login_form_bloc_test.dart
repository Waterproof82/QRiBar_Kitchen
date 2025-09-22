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
  late MockListenerBloc mockListenerBloc;
  late LoginFormBloc bloc;

  setUp(() {
    mockLoginUseCase = MockLoginUseCase();
    mockListenerBloc = MockListenerBloc();

    registerFallbackValue(const ListenerEvent.startListening());

    bloc = LoginFormBloc(loginUseCase: mockLoginUseCase);
  });

  tearDown(() {
    bloc.close();
  });

  test('estado inicial es LoginFormState vacío', () {
    expect(bloc.state, const LoginFormState());
  });

  blocTest<LoginFormBloc, LoginFormState>(
    'actualiza email cuando se recibe EmailChanged',
    build: () => bloc,
    act: (bloc) => bloc.add(const EmailChanged('test@example.com')),
    expect: () => [const LoginFormState(email: 'test@example.com')],
  );

  blocTest<LoginFormBloc, LoginFormState>(
    'emite estados loading y success cuando loginUseCase es exitoso y llama a ListenerBloc',
    build: () {
      when(
        () => mockLoginUseCase(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async => const Success<void>(null));
      when(() => mockListenerBloc.add(any())).thenReturn(null);
      return bloc;
    },
    seed: () =>
        const LoginFormState(email: 'test@example.com', password: '123456'),
    act: (bloc) => bloc.add(const LoginSubmitted()),
    expect: () => [
      const LoginFormState(
        email: 'test@example.com',
        password: '123456',
        isLoading: true,
      ),
      const LoginFormState(
        email: 'test@example.com',
        password: '123456',
        loginSuccess: true,
      ),
    ],
    verify: (_) {
      verify(
        () => mockListenerBloc.add(const ListenerEvent.startListening()),
      ).called(1);
      verify(
        () => mockLoginUseCase(email: 'test@example.com', password: '123456'),
      ).called(1);
    },
  );

  blocTest<LoginFormBloc, LoginFormState>(
    'emite estados loading y failure cuando loginUseCase falla',
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
    seed: () =>
        const LoginFormState(email: 'fail@example.com', password: 'wrong'),
    act: (bloc) => bloc.add(const LoginSubmitted()),
    expect: () => [
      const LoginFormState(
        email: 'fail@example.com',
        password: 'wrong',
        isLoading: true,
      ),
      const LoginFormState(
        email: 'fail@example.com',
        password: 'wrong',
        failure: RepositoryError.userNotFound(),
      ),
    ],
    verify: (_) {
      verify(
        () => mockLoginUseCase(email: 'fail@example.com', password: 'wrong'),
      ).called(1);
    },
  );
}
