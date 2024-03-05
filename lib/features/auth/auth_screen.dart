import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:shop_bloc/config/firebase/firebase_initialization.dart';
import 'package:shop_bloc/core/router/router.dart';
import 'package:shop_bloc/features/auth/components/email_view.dart';
import 'package:shop_bloc/features/auth/components/phone_view.dart';
import 'package:shop_bloc/features/auth/components/phone_with_code_view.dart';

enum StartAuthType {
  defaultAuth,
  email,
  phone,
  phoneWithCode,
}

@RoutePage()
class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  void _signedInRoute(final BuildContext context) {
    if (context.router.current.name != UserRoute.name) {
      context.router.replaceAll([const UserRoute()]);
    }
  }

  StartAuthType get _authType => StartAuthType.email;

  @override
  Widget build(BuildContext context) {
    return switch (_authType) {
      StartAuthType.defaultAuth => SignInScreen(
          providers: FirebaseInitialization.providers,
          auth: FirebaseAuth.instance,
          actions: [
            AuthStateChangeAction<SignedIn>((context, state) {
              _signedInRoute(context);
            }),
            AuthStateChangeAction<UserCreated>((context, state) {
              _signedInRoute(context);
            }),
          ],
        ),
      StartAuthType.email => const EmailView(),
      StartAuthType.phone => const PhoneView(),
      StartAuthType.phoneWithCode => const PhoneWithCodeView(),
    };
  }
}
