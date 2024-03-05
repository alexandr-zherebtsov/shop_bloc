import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:shop_bloc/config/firebase/firebase_initialization.dart';
import 'package:shop_bloc/core/router/router.dart';
import 'package:shop_bloc/core/utils/extensions/context_extension.dart';
import 'package:shop_bloc/core/utils/extensions/string_extension.dart';
import 'package:shop_bloc/features/auth/widgets/apple_signin_button.dart';
import 'package:shop_bloc/features/auth/widgets/facebook_signin_button.dart';
import 'package:shop_bloc/features/auth/widgets/google_signin_button.dart';
import 'package:shop_bloc/features/auth/widgets/twitter_x_signin_button.dart';
import 'package:shop_bloc/ui_kit/styles/colors.dart';
import 'package:shop_bloc/ui_kit/widgets/main_button.dart';
import 'package:shop_bloc/ui_kit/widgets/snackbar.dart';

class EmailView extends StatelessWidget {
  const EmailView({super.key});

  void _signedInRoute(final BuildContext context) {
    if (context.router.current.name != UserRoute.name) {
      context.router.replaceAll([const UserRoute()]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthScreenBuilder(
      startAction: AuthAction.signIn,
      auth: FirebaseAuth.instance,
      providers: FirebaseInitialization.providers,
      emailPasswordProvider: FirebaseInitialization.emailProvider,
      snackBarBuilder: AppSnackBar.snackBarBuilder,
      useSnackBarExceptions: true,
      actions: [
        AuthStateChangeAction<SignedIn>((context, state) {
          _signedInRoute(context);
        }),
        AuthStateChangeAction<UserCreated>((context, state) {
          _signedInRoute(context);
        }),
      ],
      builder: (
        BuildContext context,
        AuthAction? authAction,
        VoidCallback? handleDifferentAuthAction,
        TextEditingController emailCtrl,
        TextEditingController passwordCtrl,
        TextEditingController confirmPasswordCtrl,
        bool isLoading,
        Exception? exception,
        VoidCallback? onSubmit,
      ) {
        return GestureDetector(
          onTap: FocusScope.of(context).unfocus,
          child: Scaffold(
            appBar: AppBar(
              title: Text(
                authAction == AuthAction.signUp ? 'Registration' : 'Sign In',
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(
                    right: 4,
                  ),
                  child: TextButton(
                    onPressed: handleDifferentAuthAction,
                    style: ButtonStyle(
                      overlayColor: MaterialStateProperty.all<Color>(
                        AppColors.white1.withOpacity(.08),
                      ),
                      foregroundColor: MaterialStateProperty.all<Color>(
                        AppColors.white1,
                      ),
                    ),
                    child: Text(
                      authAction == AuthAction.signUp
                          ? 'Sign In'
                          : 'Registration',
                    ),
                  ),
                ),
              ],
            ),
            body: SingleChildScrollView(
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
                    controller: emailCtrl,
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
                    controller: passwordCtrl,
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
                  if (authAction == AuthAction.signUp)
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 20,
                      ),
                      child: TextFormField(
                        autocorrect: false,
                        controller: confirmPasswordCtrl,
                        obscureText: true,
                        decoration: const InputDecoration(
                          hintText: 'Confirm password',
                        ),
                        validator: (value) {
                          if (!value.isValidPassword() ||
                              value != passwordCtrl.text) {
                            return 'Invalid password';
                          }
                          return null;
                        },
                      ),
                    ),
                  const SizedBox(height: 40),
                  MainButton(
                    onPressed: onSubmit,
                    titleColor: AppColors.white1,
                    title: 'Submit',
                    loading: isLoading,
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
        );
      },
    );
  }
}
