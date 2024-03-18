import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:shop_bloc/features/auth/components/email_view.dart';
import 'package:shop_bloc/features/auth/components/phone_view.dart';
import 'package:shop_bloc/features/auth/components/phone_with_code_view.dart';

enum StartAuthType {
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
  StartAuthType get _authType => StartAuthType.email;

  @override
  Widget build(BuildContext context) {
    return switch (_authType) {
      StartAuthType.email => const AppEmailPasswordView(),
      StartAuthType.phone => const AppPhoneView(),
      StartAuthType.phoneWithCode => const AppPhoneWithCodeView(),
    };
  }
}
