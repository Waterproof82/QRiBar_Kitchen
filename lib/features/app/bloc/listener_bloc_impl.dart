import 'package:qribar_cocina/data/repositories/remote/listener_repository.dart';
import 'package:qribar_cocina/features/app/bloc/listener_bloc.dart';
import 'package:qribar_cocina/features/login/data/data_sources/remote/auth_remote_data_source_contract.dart';

/// A final class that provides the concrete implementation for [ListenerBloc].
///
/// This class extends the abstract [ListenerBloc] and simply passes
/// its required dependencies to the super constructor. This pattern
/// is used to allow [ListenerBloc] to be an abstract contract for testing
/// and dependency inversion while still having a concrete class to instantiate.
final class ListenerBlocImpl extends ListenerBloc {
  /// Creates a constant instance of [ListenerBlocImpl].
  ///
  /// Delegates the injection of [repository] and [authRemoteDataSourceContract]
  /// to the superclass constructor.
  ListenerBlocImpl({
    required ListenerRepository repository,
    required AuthRemoteDataSourceContract authRemoteDataSourceContract,
  }) : super(
         repository: repository,
         authRemoteDataSourceContract: authRemoteDataSourceContract,
       );
}
