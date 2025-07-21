import 'package:qribar_cocina/app/types/result.dart';

/// Abstract contract for the use case that saves user credentials for biometric login.
abstract class SaveBiometricCredentialsUseCase {
  /// Executes the saving of email and password securely for biometric use.
  /// Returns `Result<void>` indicating success or failure of the save operation.
  Future<Result<void>> call({required String email, required String password});
}
