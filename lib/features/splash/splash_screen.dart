import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qribar_cocina/app/enums/app_route_enum.dart';
import 'package:qribar_cocina/app/enums/svg_enum.dart';
import 'package:qribar_cocina/app/extensions/app_route_extension.dart';
import 'package:qribar_cocina/features/biometric/presentation/bloc/biometric_auth_bloc.dart';
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

    // 🚀 Verificación inicial para no quedarnos colgados en el splash
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _handleInitialNavigation(context);
    });
  }

  void _handleInitialNavigation(BuildContext context) {
    final loginState = context.read<LoginFormBloc>().state;
    final biometricState = context.read<BiometricAuthBloc>().state;

    // Si ya hay sesión activa en LoginFormBloc → navegar directo
    loginState.mapOrNull(
      authenticated: (_) => context.goTo(AppRoute.cocinaGeneral),
    );

    // Si biometría está lista pero sin credenciales → ir al login
    biometricState.mapOrNull(
      ready: (s) {
        if (!s.hasStoredCredentials) {
          context.goTo(AppRoute.login);
        }
      },
      error: (_) => context.goTo(AppRoute.login),
    );

    // Si nada de lo anterior aplica → ir a login por defecto
    context.goTo(AppRoute.login);
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
        // Listener de login
        BlocListener<LoginFormBloc, LoginFormState>(
          listener: (context, state) {
            state.map(
              initial: (_) => context.goTo(AppRoute.login),
              loading: (_) {},
              authenticated: (_) => context.goTo(AppRoute.cocinaGeneral),
              failure: (_) => context.goTo(AppRoute.login),
            );
          },
        ),

        // Listener de biométrica
        BlocListener<BiometricAuthBloc, BiometricAuthState>(
          listener: (context, state) {
            state.mapOrNull(
              biometricLoginSuccess: (_) =>
                  context.read<LoginFormBloc>().add(const SessionRestored()),
              ready: (s) {
                if (!s.hasStoredCredentials) {
                  context.goTo(AppRoute.login);
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
