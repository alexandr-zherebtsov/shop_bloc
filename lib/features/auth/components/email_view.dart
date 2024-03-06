import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:shop_bloc/core/router/router.dart';
import 'package:shop_bloc/core/utils/extensions/context_extension.dart';
import 'package:shop_bloc/core/utils/extensions/string_extension.dart';
import 'package:shop_bloc/features/auth/widgets/apple_signin_button.dart';
import 'package:shop_bloc/features/auth/widgets/facebook_signin_button.dart';
import 'package:shop_bloc/features/auth/widgets/google_signin_button.dart';
import 'package:shop_bloc/features/auth/widgets/twitter_x_signin_button.dart';
import 'package:shop_bloc/ui_kit/styles/colors.dart';
import 'package:shop_bloc/ui_kit/widgets/main_button.dart';

enum AuthActionEnums {
  signUp,
  signIn,
}

class EmailView extends StatefulWidget {
  const EmailView({super.key});

  @override
  State<EmailView> createState() => _EmailViewState();
}

class _EmailViewState extends State<EmailView> {
  AuthActionEnums _authAction = AuthActionEnums.signIn;
  final GlobalKey<FormState> _emailKey = GlobalKey<FormState>();
  final TextEditingController _emailTC = TextEditingController();
  final TextEditingController _passwordTC = TextEditingController();
  final TextEditingController _confirmPasswordTC = TextEditingController();

  void _signedInRoute() {
    if (context.router.current.name != UserRoute.name) {
      context.router.replaceAll([const UserRoute()]);
    }
  }

  void _changeType() {
    setState(() {
      _authAction = _authAction == AuthActionEnums.signIn
          ? AuthActionEnums.signUp
          : AuthActionEnums.signIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            _authAction == AuthActionEnums.signUp ? 'Registration' : 'Sign In',
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(
                right: 4,
              ),
              child: TextButton(
                onPressed: _changeType,
                style: ButtonStyle(
                  overlayColor: MaterialStateProperty.all<Color>(
                    AppColors.white1.withOpacity(.08),
                  ),
                  foregroundColor: MaterialStateProperty.all<Color>(
                    AppColors.white1,
                  ),
                ),
                child: Text(
                  _authAction == AuthActionEnums.signUp
                      ? 'Sign In'
                      : 'Registration',
                ),
              ),
            ),
          ],
        ),
        body: Form(
          key: _emailKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(
              top: 20,
              left: 24,
              right: 24,
              bottom: 32,
            ),
            child: Column(
              children: [
                TextFormField(
                  autocorrect: false,
                  controller: _emailTC,
                  decoration: const InputDecoration(
                    hintText: 'Email',
                  ),
                  validator: (value) {
                    if (!value.isValidEmail()) {
                      return 'Invalid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  autocorrect: false,
                  controller: _passwordTC,
                  obscureText: true,
                  decoration: const InputDecoration(
                    hintText: 'Password',
                  ),
                  validator: (value) {
                    if (!value.isValidPassword()) {
                      return 'Invalid password';
                    }
                    return null;
                  },
                ),
                if (_authAction == AuthActionEnums.signUp)
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 20,
                    ),
                    child: TextFormField(
                      autocorrect: false,
                      controller: _confirmPasswordTC,
                      obscureText: true,
                      decoration: const InputDecoration(
                        hintText: 'Confirm password',
                      ),
                      validator: (value) {
                        if (!value.isValidPassword() ||
                            value != _passwordTC.text) {
                          return 'Invalid password';
                        }
                        return null;
                      },
                    ),
                  ),
                const SizedBox(height: 6),
                Align(
                  alignment: Alignment.topRight,
                  child: TextButton(
                    child: const Text('Forgotten password?'),
                    onPressed: () => context.router.push(
                      const ForgottenPasswordRoute(),
                    ),
                  ),
                ),
                const SizedBox(height: 28),
                MainButton(
                  onPressed: () {
                    if (!(_emailKey.currentState?.validate() ?? false)) {
                      return;
                    }
                    FocusScope.of(context).unfocus();
                    _signedInRoute();
                  },
                  titleColor: AppColors.white1,
                  title: 'Submit',
                  loading: false,
                ),
                const SizedBox(height: 40),
                const AppGoogleSignInButton(),
                const SizedBox(height: 16),
                const AppAppleSignInButton(),
                const SizedBox(height: 16),
                const AppTwitterXSignInButton(),
                const SizedBox(height: 16),
                const AppFacebookSignInButton(),
                SizedBox(height: context.viewBottomPadding()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
