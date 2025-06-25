import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:qribar_cocina/app/types/result.dart';
import 'package:qribar_cocina/features/login/domain/repositories/login_repository_contract.dart';
import 'package:qribar_cocina/features/login/domain/use_cases/login_use_case.dart';

// Mock del repositorio
class MockLoginRepository extends Mock implements LoginRepositoryContract {}

void main() {
  late LoginUseCase useCase;
  late MockLoginRepository mockRepository;

  setUp(() {
    mockRepository = MockLoginRepository();
    useCase = LoginUseCase(mockRepository);
  });

  test('should call loginWithEmailAndPassword and return Result<void>', () async {
    // Arrange
    const email = 'test@example.com';
    const password = '123456';
    final expectedResult = const Result<void>.success(null);

    when(() => mockRepository.loginWithEmailAndPassword(
          email: email,
          password: password,
        )).thenAnswer((_) async => expectedResult);

    // Act
    final result = await useCase.call(email: email, password: password);

    // Assert
    expect(result, expectedResult);
    verify(() => mockRepository.loginWithEmailAndPassword(
          email: email,
          password: password,
        )).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}
