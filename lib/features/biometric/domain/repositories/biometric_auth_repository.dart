import 'package:local_auth_android/local_auth_android.dart';
import 'package:qribar_cocina/app/types/result.dart';

/// Abstract contract for a repository handling biometric authentication.
///
/// This contract defines the operations related to checking biometric availability,
/// authenticating via biometrics, and securely managing credentials for biometric login.
abstract class BiometricAuthRepository {
  /// Checks if biometric authentication is available on the device.
  /// Returns a `Result<bool>` indicating whether biometric auth can be used.
  Future<Result<bool>> canAuthenticateWithBiometrics();

  /// Attempts to authenticate the user using biometrics and, if successful,
  /// signs them into Firebase using stored credentials.
  ///
  /// [localizedReason] is the localized message shown to the user during biometric prompt.
  /// Returns a `Result<void>` indicating success or failure of the login process.
  Future<Result<void>> authenticateAndLogin({
    required String localizedReason,
    required AndroidAuthMessages androidAuthMessages,
  });

  /// Saves the provided email and password securely for future biometric logins.
  /// Returns a `Result<void>`.
  Future<Result<void>> saveBiometricCredentials({
    required String email,
    required String password,
  });

  /// Clears any securely stored biometric credentials.
  /// Returns a `Result<void>`.
  Future<Result<void>> clearBiometricCredentials();

  /// Checks if biometric credentials (email and password) are currently stored.
  /// Returns a `Result<bool>`.
  Future<Result<bool>> hasStoredCredentials();

  /// Retrieves the email of the user stored securely for biometric login.
  /// Returns a `Result<String>` with the email, or a failure if not available.
  Future<Result<String>> getStoredEmail();
}
