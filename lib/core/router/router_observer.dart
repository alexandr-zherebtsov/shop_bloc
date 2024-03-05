import 'dart:developer' show log;

import 'package:flutter/material.dart' show Route;
import 'package:auto_route/auto_route.dart'
    show AutoRouterObserver, TabPageRoute;
import 'package:shop_bloc/core/di/di.dart';
import 'package:shop_bloc/core/router/router.dart';

class RouterObserver extends AutoRouterObserver {
  static const String _name = 'ROUTE INFO';
  final AppRouter _router = getIt<AppRouter>();

  @override
  void didPush(
    final Route<dynamic> route,
    final Route<dynamic>? previousRoute,
  ) {
    log(
      'Current path: ${_router.current.parent?.router.currentPath}',
      name: _name,
    );
    log(
      'New route pushed: ${route.settings.name}',
      name: _name,
    );
    log(
      'Previous route: ${previousRoute?.settings.name}',
      name: _name,
    );
  }

  @override
  void didInitTabRoute(
    final TabPageRoute route,
    final TabPageRoute? previousRoute,
  ) {
    log(
      'Current path: ${_router.current.parent?.router.currentPath}',
      name: _name,
    );
    log(
      'Tab route visited: ${route.name}',
      name: _name,
    );
    log(
      'Previous tab route: ${previousRoute?.name}',
      name: _name,
    );
  }

  @override
  void didChangeTabRoute(
    final TabPageRoute route,
    final TabPageRoute previousRoute,
  ) {
    log(
      'Current path: ${_router.current.parent?.router.currentPath}',
      name: _name,
    );
    log(
      'Tab route re-visited: ${route.name}',
      name: _name,
    );
    log(
      'Previous tab route: ${previousRoute.name}',
      name: _name,
    );
  }

  @override
  void didPop(
    final Route<dynamic>? route,
    final Route<dynamic>? previousRoute,
  ) {
    log(
      'Current path: ${_router.current.parent?.router.currentPath}',
      name: _name,
    );
    log(
      'Route is pop: ${route?.settings.name}',
      name: _name,
    );
    log(
      'Previous route: ${previousRoute?.settings.name}',
      name: _name,
    );
  }
}
