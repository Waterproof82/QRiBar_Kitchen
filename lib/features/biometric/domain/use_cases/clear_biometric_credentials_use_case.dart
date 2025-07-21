import 'package:qribar_cocina/app/types/result.dart';

/// Abstract contract for the use case that clears securely stored biometric credentials.
abstract class ClearBiometricCredentialsUseCase {
  /// Executes the clearing of stored email and password.
  /// Returns `Result<void>` indicating success or failure of the clear operation.
  Future<Result<void>> call();
}
