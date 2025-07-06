import 'package:qribar_cocina/app/extensions/string_casing_extension.dart';
import 'package:qribar_cocina/app/types/repository_error.dart';
import 'package:qribar_cocina/app/types/result.dart';
import 'package:qribar_cocina/data/data_sources/local/id_bar_data_source.dart';
import 'package:qribar_cocina/features/login/data/data_sources/remote/auth_remote_data_source_contract.dart';

/// A final class providing authentication-related services.
///
/// This class handles checking the current authentication status and
/// extracting user information, interacting with an authentication data source
/// and a local bar ID data source.
final class AuthService {
  /// The contract for the remote authentication data source.
  final AuthRemoteDataSourceContract _authRemoteDataSourceContract;

  /// Creates an instance of [AuthService].
  ///
  /// Requires an [AuthRemoteDataSourceContract] to perform authentication checks.
  AuthService(this._authRemoteDataSourceContract);

  /// Checks the current authentication status.
  ///
  /// Retrieves the current user's email. If no email is found, it returns
  /// a [Result.failure] with an authentication expired error.
  /// If an email exists, it extracts the username, sets it as the bar ID,
  /// and returns a [Result.success] with the username.
  Future<Result<String>> checkAuth() async {
    final String? email = _authRemoteDataSourceContract.getCurrentEmail();

    if (email == null) {
      return Result.failure(error: RepositoryError.authExpired());
    }

    final String userName = email.split('@').first.toTitleCase();
    IdBarDataSource.instance.setIdBar(userName);

    return Result.success(userName);
  }
}
