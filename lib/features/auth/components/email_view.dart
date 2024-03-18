import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:one_day_auth/one_day_auth.dart';
import 'package:shop_bloc/core/data/users/users_repository.dart';
import 'package:shop_bloc/core/data_models/user_model.dart';
import 'package:shop_bloc/core/di/di.dart';
import 'package:shop_bloc/core/router/router.dart';
import 'package:shop_bloc/core/utils/extensions/context_extension.dart';
import 'package:shop_bloc/core/utils/extensions/string_extension.dart';
import 'package:shop_bloc/features/auth/widgets/anonymously_signin_button.dart';
import 'package:shop_bloc/features/auth/widgets/apple_signin_button.dart';
import 'package:shop_bloc/features/auth/widgets/facebook_signin_button.dart';
import 'package:shop_bloc/features/auth/widgets/github_signin_button.dart';
import 'package:shop_bloc/features/auth/widgets/google_signin_button.dart';
import 'package:shop_bloc/features/auth/widgets/twitter_x_signin_button.dart';
import 'package:shop_bloc/ui_kit/styles/colors.dart';
import 'package:shop_bloc/ui_kit/widgets/main_button.dart';
import 'package:shop_bloc/ui_kit/widgets/snackbar.dart';
import 'package:shop_bloc/ui_kit/widgets/view_constraint.dart';

class AppEmailPasswordView extends StatefulWidget {
  const AppEmailPasswordView({super.key});

  @override
  State<AppEmailPasswordView> createState() => _AppEmailPasswordViewState();
}

class _AppEmailPasswordViewState extends State<AppEmailPasswordView> {
  final UsersRepository _usersRepository = getIt<UsersRepository>();
  final GlobalKey<FormState> _emailKey = GlobalKey<FormState>();
  final TextEditingController _nameTC = TextEditingController();
  final TextEditingController _emailTC = TextEditingController();
  final TextEditingController _passwordTC = TextEditingController();
  final TextEditingController _confirmPasswordTC = TextEditingController();

  void _authorizedRoute() {
    context.router.popUntilRoot();
    if (context.router.current.name != UserRoute.name) {
      context.router.replaceAll([const UserRoute()]);
    }
  }

  void _phoneRoute(final AuthActions authAction) {
    context.router.push(
      PhoneNumberRoute(
        authAction: authAction,
      ),
    );
  }

  Future<void> _createUser({
    required final String? uid,
    required final String? name,
    required final String? email,
  }) async {
    await _usersRepository.createUser(
      UserModel(
        uid: uid,
        name: name,
        email: email,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: EmailPasswordView(
        initialAuthAction: AuthActions.signIn,
        listener: (OneDayAuthState state) {
          if (state is EmailPasswordSignedUp ||
              state is EmailPasswordSignedIn) {
            _authorizedRoute();
          } else if (state is OneDayAuthException) {
            AppSnackBar.show(
              context: context,
              subtitle: AuthExceptions.exceptionMessage(
                context: context,
                exception: state.exception,
              ),
            );
          }
        },
        builder: ({
          required BuildContext context,
          required AuthActions action,
          required OneDayAuthState state,
          required bool isLoading,
          required Object? exception,
          required VoidCallback changeAction,
          required EmailPasswordCallback onSubmit,
        }) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                action == AuthActions.signUp ? 'Registration' : 'Sign In',
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(
                    right: 4,
                  ),
                  child: TextButton(
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      changeAction();
                    },
                    style: ButtonStyle(
                      overlayColor: MaterialStateProperty.all<Color>(
                        AppColors.white1.withOpacity(.08),
                      ),
                      foregroundColor: MaterialStateProperty.all<Color>(
                        AppColors.white1,
                      ),
                    ),
                    child: Text(
                      action == AuthActions.signUp ? 'Sign In' : 'Registration',
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
                child: ViewConstraint(
                  child: Column(
                    children: [
                      if (action == AuthActions.signUp)
                        Padding(
                          padding: const EdgeInsets.only(
                            bottom: 20,
                          ),
                          child: TextFormField(
                            autocorrect: false,
                            controller: _nameTC,
                            decoration: const InputDecoration(
                              hintText: 'Name',
                            ),
                            validator: (value) {
                              if (value.isNullOrEmpty()) {
                                return 'Invalid name';
                              }
                              return null;
                            },
                          ),
                        ),
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
                      if (action == AuthActions.signUp)
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
                      if (action == AuthActions.signIn)
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 6,
                          ),
                          child: Align(
                            alignment: Alignment.topRight,
                            child: TextButton(
                              child: const Text('Forgotten password?'),
                              onPressed: () => context.router.push(
                                const ForgottenPasswordRoute(),
                              ),
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
                          onSubmit(
                            email: _emailTC.text,
                            password: _passwordTC.text,
                            afterSignUpAction: (User? user) async {
                              return _createUser(
                                uid: user?.uid,
                                name: _nameTC.text.trim(),
                                email: user?.email,
                              );
                            },
                          );
                        },
                        titleColor: AppColors.white1,
                        title: 'Submit',
                        loading: isLoading,
                      ),
                      const SizedBox(height: 30),
                      TextButton(
                        onPressed: () => _phoneRoute(action),
                        style: ButtonStyle(
                          textStyle: MaterialStateProperty.all<TextStyle>(
                            const TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ),
                        child: const Text(
                          'Continue with phone number',
                        ),
                      ),
                      const SizedBox(height: 28),
                      AppGoogleSignInButton(),
                      // const SizedBox(height: 16),
                      // AppMicrosoftSignInButton(),
                      const SizedBox(height: 16),
                      AppAppleSignInButton(),
                      const SizedBox(height: 16),
                      AppGitHubSignInButton(),
                      const SizedBox(height: 16),
                      AppTwitterXSignInButton(),
                      const SizedBox(height: 16),
                      AppFacebookSignInButton(),
                      const SizedBox(height: 24),
                      AnonymouslySignInButton(),
                      SizedBox(height: context.viewBottomPadding()),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
