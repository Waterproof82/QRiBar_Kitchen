import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:qribar_cocina/app/const/globals.dart';
import 'package:qribar_cocina/app/enums/app_route_enum.dart';
import 'package:qribar_cocina/features/cocina/cocina_general_screen.dart';
import 'package:qribar_cocina/features/cocina/cocina_pedidos_screen.dart';
import 'package:qribar_cocina/features/home/home_screen.dart';
import 'package:qribar_cocina/features/login/login_screen.dart';
import 'package:qribar_cocina/features/onboarding/onboarding_screen.dart';
import 'package:qribar_cocina/features/splash/splash_screen.dart';

/// A final class that configures and provides the application's [GoRouter] instance.
///
/// This class implements the Singleton pattern to ensure a single instance
/// of the router across the application. It defines all routes,
/// navigation keys, and redirection logic.
final class AppRouter {
  /// The single, private instance of [AppRouter].
  static final AppRouter _instance = AppRouter._internal();

  /// The [GoRouter] instance used for navigation.
  /// It's initialized lazily to ensure all dependencies are ready.
  late final GoRouter _router = GoRouter(
    navigatorKey: Globals.navigatorKey,
    initialLocation: AppRoute.splash.path,
    // redirect: _handleRedirect,
    routes: _routes,
  );

  /// Private constructor for the Singleton pattern.
  AppRouter._internal();

  /// Provides the singleton [GoRouter] instance for navigation.
  /// This is the primary access point for routing throughout the app.
  static GoRouter get router => _instance._router;

  /// Defines all the application's routes.
  ///
  /// Uses [GoRoute] for individual screens and [ShellRoute] for screens
  /// that share a common layout (like [HomeScreen]).
  List<RouteBase> get _routes => [
    GoRoute(
      name: AppRoute.splash.name,
      path: AppRoute.splash.path,
      builder: (BuildContext context, GoRouterState state) => const Splash(),
    ),
    GoRoute(
      name: AppRoute.login.name,
      path: AppRoute.login.path,
      builder: (BuildContext context, GoRouterState state) =>
          const LoginScreen(),
    ),
    GoRoute(
      name: AppRoute.onboarding.name,
      path: AppRoute.onboarding.path,
      builder: (BuildContext context, GoRouterState state) {
        final Map<String, dynamic> extraData =
            state.extra is Map<String, dynamic>
            ? state.extra as Map<String, dynamic>
            : {};

        final String email = extraData['email'];
        final String password = extraData['password'];

        return OnBoardingScreen(email: email, password: password);
      },
    ),
    ShellRoute(
      builder: (BuildContext context, GoRouterState state, Widget child) =>
          HomeScreen(child: child),
      routes: [
        GoRoute(
          name: AppRoute.home.name,
          path: AppRoute.home.path,
          builder: (BuildContext context, GoRouterState state) =>
              const SizedBox.shrink(),
        ),
        GoRoute(
          name: AppRoute.cocinaGeneral.name,
          path: AppRoute.cocinaGeneral.path,
          pageBuilder: (BuildContext context, GoRouterState state) =>
              CustomTransitionPage<void>(
                key: state.pageKey,
                child: const CocinaGeneralScreen(),
                transitionsBuilder:
                    (
                      BuildContext context,
                      Animation<double> animation,
                      Animation<double> secondaryAnimation,
                      Widget child,
                    ) => FadeTransition(opacity: animation, child: child),
              ),
        ),
        GoRoute(
          name: AppRoute.cocinaPedidos.name,
          path: AppRoute.cocinaPedidos.path,
          pageBuilder: (BuildContext context, GoRouterState state) {
            final int? extra = state.extra as int?;
            return CustomTransitionPage<void>(
              key: state.pageKey,
              child: CocinaPedidosScreen(extra: extra),
              transitionsBuilder:
                  (
                    BuildContext context,
                    Animation<double> animation,
                    Animation<double> secondaryAnimation,
                    Widget child,
                  ) {
                    final Animatable<Offset> tween = Tween<Offset>(
                      begin: const Offset(1.0, 0.0),
                      end: Offset.zero,
                    ).chain(CurveTween(curve: Curves.easeInOut));
                    return SlideTransition(
                      position: animation.drive(tween),
                      child: child,
                    );
                  },
            );
          },
        ),
      ],
    ),
  ];
}
