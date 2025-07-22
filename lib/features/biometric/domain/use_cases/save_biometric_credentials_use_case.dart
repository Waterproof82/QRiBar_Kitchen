import 'package:qribar_cocina/app/types/result.dart';

abstract class SaveBiometricCredentialsUseCase {
  /// Executes the saving of email and password securely for biometric use.
  /// Returns `Result<void>` indicating success or failure of the save operation.
  Future<Result<void>> call({required String email, required String password});
}
