import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:qribar_cocina/app/const/globals.dart';
import 'package:qribar_cocina/app/enums/app_route_enum.dart';
import 'package:qribar_cocina/features/cocina/cocina_general_screen.dart';
import 'package:qribar_cocina/features/cocina/cocina_pedidos_screen.dart';
import 'package:qribar_cocina/features/home/home_screen.dart';
import 'package:qribar_cocina/features/login/login_screen.dart';
import 'package:qribar_cocina/features/splash/splash_screen.dart';

final GoRouter appRouter = GoRouter(
  navigatorKey: Globals.navigatorKey,
  initialLocation: AppRoute.splash.path,
  redirect: (context, state) {
    final user = FirebaseAuth.instance.currentUser;
    final isLoggingIn = state.matchedLocation == AppRoute.login.path;
    final isAtSplash = state.matchedLocation == AppRoute.splash.path;

    if (user == null && !isLoggingIn && !isAtSplash) {
      return AppRoute.login.path;
    }

    return null;
  },
  routes: [
    GoRoute(
      name: AppRoute.splash.name,
      path: AppRoute.splash.path,
      builder: (context, state) => Splash(),
    ),
    GoRoute(
      name: AppRoute.login.name,
      path: AppRoute.login.path,
      builder: (context, state) => LoginScreen(),
    ),
    ShellRoute(
      builder: (context, state, child) => HomeScreen(child: child),
      routes: [
        GoRoute(
          name: AppRoute.home.name,
          path: AppRoute.home.path,
          builder: (_, __) => const SizedBox.shrink(),
        ),
        GoRoute(
          name: AppRoute.cocinaGeneral.name,
          path: AppRoute.cocinaGeneral.path,
          builder: (context, state) => const CocinaGeneralScreen(),
        ),
        GoRoute(
          name: AppRoute.cocinaPedidos.name,
          path: AppRoute.cocinaPedidos.path,
          builder: (context, state) {
            final extra = state.extra as String?;
            return CocinaPedidosScreen(extra: extra);
          },
        ),
      ],
    ),
  ],
);
