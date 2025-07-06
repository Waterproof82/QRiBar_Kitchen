import 'package:qribar_cocina/app/types/result.dart';

/// An abstract class defining the contract for the login use case.
///
/// This use case represents the business logic for user login.
/// Any concrete implementation of this use case must provide the
/// implementation for the `call` method.
abstract class LoginUseCase {
  /// Executes the login operation with the provided [email] and [password].
  ///
  /// Returns a [Future] that completes with a [Result<void>], indicating
  /// whether the login was successful or if an error occurred.
  Future<Result<void>> call({required String email, required String password});
}
