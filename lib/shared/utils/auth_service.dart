import 'package:qribar_cocina/app/extensions/string_casing_extension.dart';
import 'package:qribar_cocina/app/types/repository_error.dart';
import 'package:qribar_cocina/app/types/result.dart';
import 'package:qribar_cocina/data/data_sources/local/id_bar_data_source.dart';
import 'package:qribar_cocina/features/login/data/data_sources/remote/auth_remote_data_source_contract.dart';

class AuthService {
  final AuthRemoteDataSourceContract _authRemoteDataSourceContract;

  AuthService(this._authRemoteDataSourceContract);

  Future<Result<String>> checkAuth() async {
    final email = _authRemoteDataSourceContract.getCurrentEmail();

    if (email == null) {
      return Result.failure(error: RepositoryError.authExpired());
    }

    final userName = email.split('@').first.toTitleCase();
    IdBarDataSource.instance.setIdBar(userName);

    return Result.success(userName);
  }
}
