import 'package:firebase_auth/firebase_auth.dart';
import 'package:qribar_cocina/app/extensions/string_casing_extension.dart';
import 'package:qribar_cocina/app/types/errors/network_error.dart';
import 'package:qribar_cocina/app/types/repository_error.dart';
import 'package:qribar_cocina/app/types/result.dart';
import 'package:qribar_cocina/data/data_sources/local/id_bar_data_source.dart';
import 'package:qribar_cocina/features/login/data/data_sources/remote/auth_remote_data_source_contract.dart';
import 'package:qribar_cocina/features/login/domain/repositories/login_repository_contract.dart';

/// A final class that implements [LoginRepositoryContract].
///
/// This repository handles user login operations, interacting with
/// a remote authentication data source and a local data source for bar ID.
final class LoginRepositoryImpl implements LoginRepositoryContract {
  /// The contract for the remote authentication data source.
  final AuthRemoteDataSourceContract _authDataSource;

  /// The local data source for managing the bar ID.
  final IdBarDataSource _idBarDataSource;

  /// Creates an instance of [LoginRepositoryImpl].
  ///
  /// Requires an [AuthRemoteDataSourceContract] for authentication
  /// and an [IdBarDataSource] for local bar ID management.
  LoginRepositoryImpl(this._authDataSource, this._idBarDataSource);

  @override
  /// Attempts to log in a user with the provided [email] and [password].
  ///
  /// If successful, it extracts the username from the email and sets it
  /// as the bar ID in the local data source.
  /// Returns a [Result<void>] indicating success or a specific [RepositoryError] on failure.
  Future<Result<void>> loginWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await _authDataSource.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Extract username from email and convert to title case.
      final String userName = email.split('@').first.toTitleCase();
      // Set the obtained username as the bar ID.
      _idBarDataSource.setIdBar(userName);

      return const Result.success(null);
    } on FirebaseAuthException catch (error) {
      // Handle Firebase authentication specific errors.
      final RepositoryError repositoryError =
          RepositoryError.fromFirebaseAuthError(error.code);
      return Result.failure(error: repositoryError);
    } catch (error) {
      // Handle any other unexpected errors.
      return Result.failure(
        error: RepositoryError.fromDataSourceError(
          NetworkError.fromException(error),
        ),
      );
    }
  }
}
