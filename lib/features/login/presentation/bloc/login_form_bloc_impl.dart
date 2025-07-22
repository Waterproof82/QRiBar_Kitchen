import 'package:qribar_cocina/features/app/bloc/listener_bloc.dart';
import 'package:qribar_cocina/features/login/domain/use_cases/login_use_case.dart';
import 'package:qribar_cocina/features/login/presentation/bloc/login_form_bloc.dart';

/// A final class that provides the concrete implementation for [LoginFormBloc].
///
/// This class extends the abstract [LoginFormBloc] and simply passes
/// its required dependencies to the super constructor. This pattern
/// is used to allow [LoginFormBloc] to be an abstract contract for testing
/// and dependency inversion while still having a concrete class to instantiate.
final class LoginFormBlocImpl extends LoginFormBloc {
  /// Creates a constant instance of [LoginFormBlocImpl].
  ///
  /// Delegates the injection of [loginUseCase] and [listenerBloc]
  /// to the superclass constructor.
  LoginFormBlocImpl({
    required LoginUseCase loginUseCase,
    required ListenerBloc listenerBloc,
    required dynamic biometricAuthBloc,
  }) : super(
         loginUseCase: loginUseCase,
         listenerBloc: listenerBloc,
         biometricAuthBloc: biometricAuthBloc,
       );
}
