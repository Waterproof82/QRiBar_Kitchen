import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qribar_cocina/app/extensions/repository_error_extension.dart';
import 'package:qribar_cocina/features/app/bloc/listener_bloc.dart';
import 'package:qribar_cocina/features/login/presentation/bloc/login_form_bloc.dart';
import 'package:qribar_cocina/features/login/presentation/bloc/login_form_state.dart';
import 'package:qribar_cocina/shared/utils/custom_snack_bar.dart';

/// A final [StatelessWidget] that acts as a global error listener for various BLoCs.
///
/// It listens to [LoginFormBloc] and [ListenerBloc] for failure states
/// and displays a [CustomSnackBar] with the translated error message.
final class GlobalErrorListener extends StatelessWidget {
  /// The child widget to be rendered below the error listeners.
  final Widget child;

  /// Creates a constant instance of [GlobalErrorListener].
  const GlobalErrorListener({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<LoginFormBloc, LoginFormState>(
          listenWhen: (previous, current) =>
              previous.failure != current.failure,
          listener: (context, state) {
            final error = state.failure;
            if (error != null) {
              CustomSnackBar.show(
                error.translateError(context),
                type: error.snackBarType,
              );
            }
          },
        ),

        BlocListener<ListenerBloc, ListenerState>(
          listenWhen: (_, current) =>
              current.maybeWhen(failure: (_) => true, orElse: () => false),
          listener: (context, state) {
            state.maybeWhen(
              failure: (error) {
                CustomSnackBar.show(
                  error.translateError(context),
                  type: error.snackBarType,
                );
              },
              orElse: () {
                // No action needed for other states.
              },
            );
          },
        ),
      ],
      child: child,
    );
  }
}
