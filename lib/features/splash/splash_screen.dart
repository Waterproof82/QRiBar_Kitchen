import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qribar_cocina/app/enums/app_route_enum.dart';
import 'package:qribar_cocina/app/enums/svg_enum.dart';
import 'package:qribar_cocina/app/extensions/app_route_extension.dart';
import 'package:qribar_cocina/features/login/presentation/bloc/login_form_bloc.dart';
import 'package:qribar_cocina/features/login/presentation/bloc/login_form_event.dart';
import 'package:qribar_cocina/features/login/presentation/bloc/login_form_state.dart';
import 'package:qribar_cocina/shared/utils/svg_loader.dart';

class Splash extends StatefulWidget {
  @override
  SplashState createState() => SplashState();
}

class SplashState extends State<Splash> with SingleTickerProviderStateMixin {
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
      _checkSessionAndNavigate();
    });
  }

  void _checkSessionAndNavigate() async {
    await Future.delayed(const Duration(seconds: 1));
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final bloc = context.read<LoginFormBloc>();
      bloc.add(const LoginFormEvent.sessionRestored());
    } else {
      context.goTo(AppRoute.login);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginFormBloc, LoginFormState>(
      listenWhen: (previous, current) =>
          previous.loginSuccess != current.loginSuccess,
      listener: (context, state) {
        if (state.loginSuccess) {
          context.goTo(AppRoute.cocinaGeneral);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 30.0),
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
    );
  }
}
