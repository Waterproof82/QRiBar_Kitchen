import 'package:local_auth_android/local_auth_android.dart';
import 'package:qribar_cocina/app/types/result.dart';

abstract class BiometricAuthDataSource {
  /// Checks if the device supports biometric authentication and if biometrics are enrolled.
  Future<Result<bool>> canAuthenticate();

  /// Prompts the user for biometric authentication.
  ///
  /// [localizedReason] is the message displayed to the user during authentication.
  /// Returns `true` if authentication is successful, `false` otherwise.
  Future<Result<bool>> authenticate({
    required String localizedReason,
    required AndroidAuthMessages androidAuthMessages,
  });
}
