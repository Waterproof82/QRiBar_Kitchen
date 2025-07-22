import 'dart:developer';

import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/local_auth_android.dart';
import 'package:qribar_cocina/features/biometric/data/data_sources/local/biometric_auth_data_source.dart';

/// Concrete implementation of [BiometricAuthDataSource] using `local_auth`.
final class BiometricAuthDataSourceImpl implements BiometricAuthDataSource {
  final LocalAuthentication _auth;

  BiometricAuthDataSourceImpl({LocalAuthentication? auth})
    : _auth = auth ?? LocalAuthentication();

  @override
  Future<bool> canAuthenticate() async {
    try {
      final bool canCheckBiometrics = await _auth.canCheckBiometrics;
      if (!canCheckBiometrics)
        return false; // Device doesn't support biometrics

      final List<BiometricType> availableBiometrics = await _auth
          .getAvailableBiometrics();
      if (availableBiometrics.isEmpty) return false; // No biometrics enrolled

      // bool face = availableBiometrics.contains(BiometricType.face);
      // bool fingerprint = availableBiometrics.contains(BiometricType.fingerprint);
      // bool iris = availableBiometrics.contains(BiometricType.iris);

      return true; // Biometrics are supported and enrolled
    } catch (e) {
      // Handle platform exceptions or other errors (e.g., no biometric hardware)
      log('Error checking biometrics: $e');
      return false;
    }
  }

  @override
  Future<bool> authenticate({
    required String localizedReason,
    required AndroidAuthMessages androidAuthMessages,
  }) async {
    try {
      final bool didAuthenticate = await _auth.authenticate(
        localizedReason: localizedReason,
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
        authMessages: [androidAuthMessages],
      );
      return didAuthenticate;
    } catch (e) {
      log('Error during biometric authentication: $e');
      return false;
    }
  }
}
