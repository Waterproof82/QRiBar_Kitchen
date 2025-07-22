import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_auth_android/local_auth_android.dart';
import 'package:qribar_cocina/app/enums/app_route_enum.dart';
import 'package:qribar_cocina/app/enums/svg_enum.dart';
import 'package:qribar_cocina/app/extensions/app_route_extension.dart';
import 'package:qribar_cocina/app/l10n/app_localizations.dart';
import 'package:qribar_cocina/features/app/bloc/listener_bloc.dart';
import 'package:qribar_cocina/features/biometric/presentation/bloc/biometric_auth_bloc.dart';
import 'package:qribar_cocina/features/biometric/presentation/bloc/biometric_auth_event.dart';
import 'package:qribar_cocina/features/biometric/presentation/bloc/biometric_auth_state.dart';
import 'package:qribar_cocina/features/login/presentation/bloc/login_form_bloc.dart';
import 'package:qribar_cocina/features/login/presentation/bloc/login_form_event.dart';
import 'package:qribar_cocina/features/login/presentation/bloc/login_form_state.dart';
import 'package:qribar_cocina/shared/utils/svg_loader.dart';

final class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  SplashState createState() => SplashState();
}

final class SplashState extends State<Splash>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    );

    _animationController.forward();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkSessionAndNavigate(context);
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<ListenerBloc, ListenerState>(
          listenWhen: (previous, current) {
            final wasSuccess = previous.maybeWhen(
              success: () => true,
              orElse: () => false,
            );
            final isSuccess = current.maybeWhen(
              success: () => true,
              orElse: () => false,
            );
            return !wasSuccess && isSuccess;
          },
          listener: (context, state) {
            state.maybeWhen(
              success: () {
                context.read<LoginFormBloc>().add(
                  const LoginFormEvent.listenerReady(),
                );
              },
              orElse: () {},
            );
          },
        ),

        BlocListener<LoginFormBloc, LoginFormState>(
          listenWhen: (previous, current) =>
              previous.loginSuccess != current.loginSuccess,
          listener: (context, state) {
            if (state.loginSuccess) {
              context.pushTo(AppRoute.cocinaGeneral);
            }
          },
        ),
        BlocListener<BiometricAuthBloc, BiometricAuthState>(
          listener: (context, state) {
            state.mapOrNull(
              biometricLoginSuccess: (_) {
                context.read<LoginFormBloc>().add(
                  const LoginFormEvent.sessionRestored(),
                );
              },
              biometricLoginFailure: (_) {
                context.goTo(AppRoute.login);
              },
              error: (_) {
                context.goTo(AppRoute.login);
              },
            );
          },
        ),
      ],
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Stack(
            fit: StackFit.expand,
            children: [
              const Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.only(bottom: 30.0),
                  child: SvgLoader(
                    SvgEnum.logo,
                    height: 25.0,
                    fit: BoxFit.scaleDown,
                  ),
                ),
              ),
              Center(
                child: AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    final double value = _animation.value;
                    return SvgLoader(
                      SvgEnum.logoName,
                      width: value * 250,
                      height: value * 250,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _checkSessionAndNavigate(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    final User? user = FirebaseAuth.instance.currentUser;
    final biometricAuthBloc = context.read<BiometricAuthBloc>();

    final bool canAuthenticate = await biometricAuthBloc
        .canAuthenticateWithBiometrics();
    final bool hasStoredCredentials = await biometricAuthBloc
        .hasStoredCredentials();
        
    final l10n = AppLocalizations.of(context);

    final String localizedReason = l10n.localizedReasonBiometricLogin;

    final authMessages = AndroidAuthMessages(
      signInTitle: l10n.signInTitle,
      cancelButton: l10n.cancelButton,
      biometricHint: l10n.biometricHint,
      biometricNotRecognized: l10n.biometricNotRecognized,
      biometricSuccess: l10n.biometricSuccess,
      goToSettingsButton: l10n.goToSettingsButton,
      goToSettingsDescription: l10n.goToSettingsDescription,
    );

    if (user != null) {
      if (canAuthenticate && hasStoredCredentials) {
        biometricAuthBloc.add(
          BiometricAuthEvent.authenticateForSession(
            localizedReason: localizedReason,
            androidAuthMessages: authMessages,
          ),
        );
      } else {
        context.read<LoginFormBloc>().add(
          const LoginFormEvent.sessionRestored(),
        );
      }
    } else {
      if (canAuthenticate && hasStoredCredentials) {
        biometricAuthBloc.add(
          BiometricAuthEvent.authenticateAndLogin(
            localizedReason: localizedReason,
            androidAuthMessages: authMessages,
          ),
        );
      } else {
        context.goTo(AppRoute.login);
      }
    }
  }
}
