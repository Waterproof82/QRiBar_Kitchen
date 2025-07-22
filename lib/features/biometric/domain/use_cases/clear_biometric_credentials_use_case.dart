import 'package:qribar_cocina/app/types/result.dart';

abstract class ClearBiometricCredentialsUseCase {
  /// Executes the clearing of stored email and password.
  /// Returns `Result<void>` indicating success or failure of the clear operation.
  Future<Result<void>> call();
}
