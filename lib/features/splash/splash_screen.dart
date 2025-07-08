import 'dart:async'; // For Timer and Future.delayed

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

/// A final [StatefulWidget] that displays the splash screen.
/// It handles initial animations and checks the user's session status
/// to navigate to the appropriate screen (login or main app).
final class Splash extends StatefulWidget {
  /// Creates a constant instance of [Splash].
  const Splash({super.key});

  @override
  SplashState createState() => SplashState();
}

/// The state class for the [Splash] widget.
/// Manages animation and navigation logic after session check.
final class SplashState extends State<Splash>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _animation;
  bool _navigated = false; // Flag to prevent multiple navigations

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

    // Start the animation immediately.
    _animationController.forward();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkSessionAndNavigate();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginFormBloc, LoginFormState>(
      // Listen only when loginSuccess state changes to trigger navigation.
      listenWhen: (previous, current) =>
          previous.loginSuccess != current.loginSuccess,
      listener: (context, state) {
        // If login is successful (e.g., after session restoration) and not already navigated,
        // navigate to the main kitchen screen.
        if (state.loginSuccess && !_navigated) {
          _navigated = true; // Mark as navigated to prevent further attempts
          context.goTo(AppRoute.cocinaGeneral);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          fit: StackFit.expand,
          children: [
            // Logo at the bottom of the screen.
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
            // Animated logo name in the center.
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
    );
  }

  /// Checks the user's Firebase session and navigates accordingly.
  ///
  /// Waits for an initial delay, then checks if a user is logged in.
  /// If a user exists, it dispatches a [SessionRestored] event to [LoginFormBloc].
  /// Otherwise, it navigates to the login screen.
  Future<void> _checkSessionAndNavigate() async {
    // Ensure a minimum display time for the splash screen.
    await Future.delayed(const Duration(seconds: 2));

    final User? user = FirebaseAuth.instance.currentUser;

    // Prevent navigation if the widget is no longer mounted or already navigated.
    if (!mounted || _navigated) return;

    if (user != null) {
      // If user exists, restore session via LoginFormBloc.
      // Navigation to cocinaGeneral will be handled by LoginFormBloc's BlocListener.
      context.read<LoginFormBloc>().add(const LoginFormEvent.sessionRestored());
    } else {
      // If no user, navigate to the login screen.
      _navigated = true; // Mark as navigated to prevent further attempts
      context.goTo(AppRoute.login);
    }
  }
}
