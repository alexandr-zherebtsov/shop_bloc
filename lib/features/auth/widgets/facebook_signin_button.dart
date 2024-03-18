import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:one_day_auth/one_day_auth.dart';
import 'package:shop_bloc/config/environment/environment_data.dart';
import 'package:shop_bloc/core/data/users/users_repository.dart';
import 'package:shop_bloc/core/data_models/user_model.dart';
import 'package:shop_bloc/core/di/di.dart';
import 'package:shop_bloc/core/router/router.dart';
import 'package:shop_bloc/ui_kit/widgets/snackbar.dart';

class AppFacebookSignInButton extends StatelessWidget {
  final UsersRepository _usersRepository;

  AppFacebookSignInButton({
    UsersRepository? usersRepository,
    super.key,
  }) : _usersRepository = usersRepository ?? getIt<UsersRepository>();

  // static const String _name = 'Facebook';

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
    return FacebookSignInView(
      appId: getIt<EnvData>().facebookClientID,
      listener: (OneDayAuthState state) {
        if (state is OAuthAuthorized) {
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
        return FacebookSignInButton(
          onPressed: () => signIn(
            afterAuthAction: _checkUser,
          ),
          isLoading: isLoading,
        );
        /*
        return SizedBox(
          height: 48,
          child: OutlinedButton(
            onPressed: () => signIn(
              afterAuthAction: _checkUser,
            ),
            style: Theme.of(context).outlinedButtonTheme.style?.copyWith(
                  side: MaterialStateProperty.all<BorderSide>(
                    BorderSide.none,
                  ),
                  backgroundColor: MaterialStateProperty.all<Color>(
                    AppColors.blue2,
                  ),
                  overlayColor: MaterialStateProperty.all<Color>(
                    Colors.white.withOpacity(.1),
                  ),
                ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: isLoading
                  ? [
                      const ButtonLoader(
                        buttonHeight: 48,
                        color: AppColors.white1,
                      ),
                    ]
                  : [
                      const Icon(
                        Icons.facebook,
                        size: 24,
                        color: AppColors.white1,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Continue with $_name',
                        style: TextStyle(
                          color: AppColors.white1,
                        ),
                      ),
                    ],
            ),
          ),
        );
        */
      },
    );
  }
}
