import 'package:firebase_auth/firebase_auth.dart';
import 'package:qribar_cocina/app/extensions/string_casing_extension.dart';
import 'package:qribar_cocina/app/types/errors/network_error.dart';
import 'package:qribar_cocina/app/types/repository_error.dart';
import 'package:qribar_cocina/app/types/result.dart';
import 'package:qribar_cocina/data/data_sources/local/id_bar_data_source.dart';
import 'package:qribar_cocina/features/login/data/data_sources/remote/auth_remote_data_source_contract.dart';
import 'package:qribar_cocina/features/login/domain/repositories/login_repository_contract.dart';

class LoginRepositoryImpl implements LoginRepositoryContract {
  final AuthRemoteDataSourceContract _authDataSource;
  final IdBarDataSource _idBarDataSource;

  LoginRepositoryImpl(this._authDataSource, this._idBarDataSource);

  @override
  Future<Result<void>> loginWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await _authDataSource.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final userName = email.split('@').first.toTitleCase();
      _idBarDataSource.setIdBar(userName);

      return const Result.success(null);
    } on FirebaseAuthException catch (error) {
      final repositoryError = RepositoryError.fromFirebaseAuthError(error.code);

      return Result.failure(error: repositoryError);
    } catch (error) {
      return Result.failure(
        error: RepositoryError.fromDataSourceError(NetworkError.fromException(error)),
      );
    }
  }
}
