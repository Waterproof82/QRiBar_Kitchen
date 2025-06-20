import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:qribar_cocina/app/types/repository_error.dart';
import 'package:qribar_cocina/app/types/result.dart';
import 'package:qribar_cocina/features/login/domain/use_cases/login_use_case.dart';
import 'package:qribar_cocina/features/login/presentation/bloc/login_form_bloc.dart';
import 'package:qribar_cocina/features/login/presentation/bloc/login_form_event.dart';
import 'package:qribar_cocina/features/login/presentation/bloc/login_form_state.dart';

class MockLoginUseCase extends Mock implements LoginUseCase {}

void main() {
  late MockLoginUseCase mockLoginUseCase;
  late LoginFormBloc bloc;

  setUp(() {
    mockLoginUseCase = MockLoginUseCase();
    bloc = LoginFormBloc(loginUseCase: mockLoginUseCase);
  });

  test('initial state is LoginFormState()', () {
    expect(bloc.state, const LoginFormState());
  });

  blocTest<LoginFormBloc, LoginFormState>(
    'emits state with updated email when EmailChanged is added',
    build: () => bloc,
    act: (bloc) => bloc.add(const EmailChanged('test@email.com')),
    expect: () => [
      const LoginFormState(email: 'test@email.com'),
    ],
  );

  blocTest<LoginFormBloc, LoginFormState>(
    'emits state with updated password when PasswordChanged is added',
    build: () => bloc,
    act: (bloc) => bloc.add(const PasswordChanged('123456')),
    expect: () => [
      const LoginFormState(password: '123456'),
    ],
  );

  blocTest<LoginFormBloc, LoginFormState>(
    'emits loading and success when LoginSubmitted succeeds',
    build: () {
      when(() => mockLoginUseCase(
            email: any(named: 'email'),
            password: any(named: 'password'),
          )).thenAnswer((_) async => const Result.success(null));
      return LoginFormBloc(loginUseCase: mockLoginUseCase);
    },
    seed: () => const LoginFormState(email: 'a@b.com', password: 'pw'),
    act: (bloc) => bloc.add(LoginSubmitted()),
    expect: () => [
      const LoginFormState(email: 'a@b.com', password: 'pw', isLoading: true, failure: null),
      const LoginFormState(email: 'a@b.com', password: 'pw', isLoading: false, loginSuccess: true, failure: null),
    ],
    verify: (_) {
      verify(() => mockLoginUseCase(email: 'a@b.com', password: 'pw')).called(1);
    },
  );

  blocTest<LoginFormBloc, LoginFormState>(
    'emits loading and failure when LoginSubmitted fails',
    build: () {
      when(() => mockLoginUseCase(
            email: any(named: 'email'),
            password: any(named: 'password'),
          )).thenAnswer((_) async => Result.failure(error: RepositoryError.noAccess()));
      return LoginFormBloc(loginUseCase: mockLoginUseCase);
    },
    seed: () => const LoginFormState(email: 'fail@b.com', password: 'badpw'),
    act: (bloc) => bloc.add(LoginSubmitted()),
    expect: () => [
      const LoginFormState(email: 'fail@b.com', password: 'badpw', isLoading: true, failure: null),
      LoginFormState(
        email: 'fail@b.com',
        password: 'badpw',
        isLoading: false,
        failure: RepositoryError.noAccess(),
      ),
    ],
    verify: (_) {
      verify(() => mockLoginUseCase(email: 'fail@b.com', password: 'badpw')).called(1);
    },
  );
}
