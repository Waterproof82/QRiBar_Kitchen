import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qribar_cocina/app/extensions/repository_error_extension.dart';
import 'package:qribar_cocina/features/app/bloc/listener_bloc.dart';
import 'package:qribar_cocina/features/biometric/presentation/bloc/biometric_auth_bloc.dart';
import 'package:qribar_cocina/features/biometric/presentation/bloc/biometric_auth_state.dart';
import 'package:qribar_cocina/features/login/presentation/bloc/login_form_bloc.dart';
import 'package:qribar_cocina/features/login/presentation/bloc/login_form_state.dart';
import 'package:qribar_cocina/shared/utils/custom_snack_bar.dart';

/// A final [StatelessWidget] that acts as a global error listener for various BLoCs.
///
/// It listens to [LoginFormBloc] and [ListenerBloc] for failure states
/// and displays a [CustomSnackBar] with the translated error message.
final class GlobalErrorListener extends StatelessWidget {
  final Widget child;

  const GlobalErrorListener({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        // LoginFormBloc
        BlocListener<LoginFormBloc, LoginFormState>(
          listenWhen: (previous, current) => previous != current,
          listener: (context, state) {
            state.maybeMap(
              failure: (failureState) {
                CustomSnackBar.show(
                  failureState.error.translateError(context),
                  type: failureState.error.snackBarType,
                );
              },
              orElse: () {},
            );
          },
        ),

        // BiometricAuthBloc
        BlocListener<BiometricAuthBloc, BiometricAuthState>(
          listenWhen: (_, current) =>
              current.maybeMap(error: (_) => true, orElse: () => false),
          listener: (context, state) {
            state.maybeMap(
              error: (errorState) {
                CustomSnackBar.show(
                  errorState.error.translateError(context),
                  type: errorState.error.snackBarType,
                );
              },
              orElse: () {},
            );
          },
        ),
        // ListenerBloc
        BlocListener<ListenerBloc, ListenerState>(
          listenWhen: (_, current) =>
              current.maybeMap(failure: (_) => true, orElse: () => false),
          listener: (context, state) {
            state.maybeMap(
              failure: (failureState) {
                CustomSnackBar.show(
                  failureState.error.translateError(context),
                  type: failureState.error.snackBarType,
                );
              },
              orElse: () {},
            );
          },
        ),
      ],
      child: child,
    );
  }
}
