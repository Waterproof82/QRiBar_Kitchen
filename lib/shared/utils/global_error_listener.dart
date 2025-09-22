import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qribar_cocina/app/extensions/repository_error_extension.dart';
import 'package:qribar_cocina/app/types/repository_error.dart';
import 'package:qribar_cocina/features/app/bloc/listener_bloc.dart';
import 'package:qribar_cocina/app/localization/cubit/language_cubit.dart';
import 'package:qribar_cocina/features/authentication/bloc/auth_bloc.dart';
import 'package:qribar_cocina/features/biometric/presentation/bloc/biometric_auth_bloc.dart';
import 'package:qribar_cocina/features/login/presentation/bloc/login_form_bloc.dart';
import 'package:qribar_cocina/features/onboarding/cubit/onboarding_cubit.dart';
import 'package:qribar_cocina/shared/utils/custom_snack_bar.dart';

/// A final [StatefulWidget] that acts as a global error listener for any BLoC.
/// 
/// It dynamically listens to all defined BLoCs and shows a [CustomSnackBar]
/// if their state contains a `RepositoryError` under the field `error`.
final class GlobalErrorListener extends StatefulWidget {
  final Widget child;

  const GlobalErrorListener({super.key, required this.child});

  @override
  State<GlobalErrorListener> createState() => _GlobalErrorListenerState();
}

final class _GlobalErrorListenerState extends State<GlobalErrorListener> {
  final List<StreamSubscription> _subscriptions = [];
  late final List<BlocBase<dynamic>> _blocsToListen;

  @override
  void initState() {
    super.initState();

    // Initialize blocs list once
    _blocsToListen = [
      context.read<LanguageCubit>(),
      context.read<LoginFormBloc>(),
      context.read<BiometricAuthBloc>(),
      context.read<AuthBloc>(),
      context.read<OnboardingCubit>(),
      context.read<ListenerBloc>(),
    ];

    // Subscribe each bloc
    for (final bloc in _blocsToListen) {
      _subscribeBloc(bloc);
    }
  }

  @override
  void dispose() {
    for (final sub in _subscriptions) {
      sub.cancel();
    }
    super.dispose();
  }

  void _subscribeBloc(BlocBase<dynamic> bloc) {
    try {
      final sub = bloc.stream
          // Only forward states that actually contain a RepositoryError
          .where((state) => _extractError(state) != null)
          .listen((state) {
        final error = _extractError(state);
        if (error != null) {
          _showError(context, error);
        }
      });

      _subscriptions.add(sub);
    } catch (error, stackTrace) {
      // Log unexpected errors in debug mode
      assert(() {
        debugPrint('[GlobalErrorListener] Error subscribing to ${bloc.runtimeType}: $error');
        debugPrint('$stackTrace');
        return true;
      }());
    }
  }

  void _showError(BuildContext context, RepositoryError error) {
    CustomSnackBar.show(
      error.translateError(context),
      type: error.snackBarType,
    );
  }

  /// Automatically extracts a RepositoryError if the state has a field `error`.
  RepositoryError? _extractError(dynamic state) {
    try {
      final dynamic maybeError = (state as dynamic).error;
      if (maybeError is RepositoryError) {
        return maybeError;
      }
    } catch (_) {
      // Safe fallback if the state doesn't have an 'error' field
    }
    return null;
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
