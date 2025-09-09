import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_auth_android/local_auth_android.dart';
import 'package:qribar_cocina/app/enums/app_route_enum.dart';
import 'package:qribar_cocina/app/enums/svg_enum.dart';
import 'package:qribar_cocina/app/extensions/app_route_extension.dart';
import 'package:qribar_cocina/app/l10n/app_localizations.dart';
import 'package:qribar_cocina/features/authentication/bloc/auth_bloc.dart';
import 'package:qribar_cocina/features/authentication/bloc/auth_event.dart';
import 'package:qribar_cocina/features/biometric/presentation/bloc/biometric_auth_bloc.dart';
import 'package:qribar_cocina/features/biometric/presentation/bloc/biometric_auth_event.dart';
import 'package:qribar_cocina/features/biometric/presentation/bloc/biometric_auth_state.dart';
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
      Future.delayed(const Duration(seconds: 3), () {
        _handleInitialNavigation(context);
      });
    });
  }

  void _handleInitialNavigation(BuildContext context) {
    context.read<BiometricAuthBloc>().add(
      const CheckAvailabilityAndCredentials(),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return MultiBlocListener(
      listeners: [
        BlocListener<BiometricAuthBloc, BiometricAuthState>(
          listener: (context, state) {
            state.mapOrNull(
              biometricLoginSuccess: (s) {
                context.read<AuthBloc>().add(const AuthEvent.sessionRestored());
                context.goTo(AppRoute.cocinaGeneral);
              },
              ready: (s) {
                if (!s.hasStoredCredentials) {
                  context.goTo(AppRoute.login);
                } else {
                  context.read<BiometricAuthBloc>().add(
                    AuthenticateAndLogin(
                      localizedReason: l10n.localizedReasonBiometricLogin,

                      androidAuthMessages: AndroidAuthMessages(
                        signInTitle: l10n.signInTitle,
                        cancelButton: l10n.cancelButton,
                        biometricHint: l10n.biometricHint,
                      ),
                    ),
                  );
                }
              },
              error: (_) => context.goTo(AppRoute.login),
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
                    final value = _animation.value;
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
}
