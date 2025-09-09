import 'package:local_auth_android/local_auth_android.dart';
import 'package:qribar_cocina/app/types/result.dart';

/// Abstract contract for the use case that orchestrates biometric authentication and login.
abstract class AuthenticateBiometricUseCase {
  /// Checks if biometric authentication is possible (device support + enrollment)
  /// and if secure credentials are stored.
  /// Returns `Result<bool>` indicating if biometric login is available.
  Future<Result<bool>> callCanAuthenticate();

  /// Executes the biometric authentication and subsequent Firebase login.
  /// Returns `Result<void>` indicating success or failure of the login attempt.
  Future<Result<void>> callAuthenticateAndLogin({
    required String localizedReason,
    required AndroidAuthMessages androidAuthMessages,
  });

  /// Checks if biometric credentials (e.g., email/password) are stored locally.
  /// Returns `Result<bool>` indicating if credentials exist.
  Future<Result<bool>> hasStoredCredentials();

  /// Retrieves the email of the user stored locally with biometric credentials.
  /// Returns `Result<String>` with the email, or failure if not available.
  Future<Result<String>> getStoredEmail();
}
