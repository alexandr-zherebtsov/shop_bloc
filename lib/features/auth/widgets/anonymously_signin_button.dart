import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:one_day_auth/one_day_auth.dart';
import 'package:shop_bloc/core/data/users/users_repository.dart';
import 'package:shop_bloc/core/data_models/user_model.dart';
import 'package:shop_bloc/core/di/di.dart';
import 'package:shop_bloc/core/router/router.dart';
import 'package:shop_bloc/ui_kit/widgets/snackbar.dart';

class AnonymouslySignInButton extends StatelessWidget {
  final UsersRepository _usersRepository;

  AnonymouslySignInButton({
    UsersRepository? usersRepository,
    super.key,
  }) : _usersRepository = usersRepository ?? getIt<UsersRepository>();

  void _authorizedRoute(final BuildContext context) {
    if (context.router.current.name != UserRoute.name) {
      context.router.replaceAll([const UserRoute()]);
    }
  }

  Future<void> _checkUser(User? user) async {
    await _usersRepository.createOAuthUser(
      UserModel(
        uid: user!.uid,
        name: user.displayName,
        email: user.email,
        phone: user.phoneNumber,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AuthAnonymouslyView(
      listener: (OneDayAuthState state) {
        if (state is AuthAnonymouslyAuthorized) {
          _authorizedRoute(context);
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
        required OneDayAuthState state,
        required bool isLoading,
        required SignInCallback signIn,
        required Object? exception,
      }) {
        return SizedBox(
          height: 36,
          child: isLoading
              ? const Center(
                  child: CircularProgressIndicator.adaptive(),
                )
              : TextButton(
                  onPressed: () => signIn(
                    afterAuthAction: (User? user) => _checkUser(user),
                  ),
                  style: ButtonStyle(
                    textStyle: MaterialStateProperty.all<TextStyle>(
                      const TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                  child: const Text(
                    'Sign in anonymously',
                  ),
                ),
        );
      },
    );
  }
}
