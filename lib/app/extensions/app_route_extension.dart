import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:qribar_cocina/app/enums/app_route_enum.dart';

extension AppRouteExtension on BuildContext {
  void goTo(
    AppRouteEnum route, {
    Map<String, String> pathParams = const {},
    Map<String, String> queryParams = const {},
    Object? extra,
  }) {
    goNamed(
      route.name,
      pathParameters: pathParams,
      queryParameters: queryParams,
      extra: extra,
    );
  }

  void pushTo(
    AppRouteEnum route, {
    Map<String, String> pathParams = const {},
    Map<String, String> queryParams = const {},
    Object? extra,
  }) {
    pushNamed(
      route.name,
      pathParameters: pathParams,
      queryParameters: queryParams,
      extra: extra,
    );
  }
}
