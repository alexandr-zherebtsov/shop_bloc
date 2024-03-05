import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:shop_bloc/features/auth/auth_screen.dart';
import 'package:shop_bloc/features/code_screen/code_screen.dart';
import 'package:shop_bloc/features/main/main_screen.dart';
import 'package:shop_bloc/features/profile/user_screen.dart';
import 'package:shop_bloc/features/splash/splash_screen.dart';

part 'router.gr.dart';

/// The configuration of app routes.
@AutoRouterConfig(replaceInRouteName: 'Tab|View|Screen,Route')
class AppRouter extends _$AppRouter {
  /// router
  AppRouter();

  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: SplashRoute.page, initial: true),
        AutoRoute(page: AuthRoute.page),
        AutoRoute(page: CodeRoute.page),
        AutoRoute(page: UserRoute.page),
        AutoRoute(page: MainRoute.page),
      ];
}
