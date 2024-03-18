import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:one_day_auth/one_day_auth.dart';
import 'package:shop_bloc/config/environment/environment_data.dart';
import 'package:shop_bloc/core/data/users/users_repository.dart';
import 'package:shop_bloc/core/di/di.dart';
import 'package:shop_bloc/core/router/router.dart';
import 'package:shop_bloc/ui_kit/styles/colors.dart';
import 'package:shop_bloc/ui_kit/widgets/main_button.dart';
import 'package:shop_bloc/ui_kit/widgets/snackbar.dart';
import 'package:shop_bloc/ui_kit/widgets/view_constraint.dart';

@RoutePage()
class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  late final Stream<User?> _userStream;
  final UsersRepository _usersRepository = getIt<UsersRepository>();

  void _unauthorizedRoute() {
    if (context.router.current.name != SplashRoute.name) {
      context.router.replaceAll([const SplashRoute()]);
    }
  }

  Future<void> _deleteUser(final String uid) async {
    await _usersRepository.deleteUser(uid);
  }

  @override
  void initState() {
    super.initState();
    _userStream = FirebaseAuth.instance.userChanges();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: _userStream,
      builder: (BuildContext context, AsyncSnapshot<User?> user) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).primaryColor,
            title: const Text(
              'Profile',
            ),
            actions: [
              SignOutView(
                listener: (OneDayAuthState state) {
                  if (state is OneDayAuthException) {
                    AppSnackBar.show(
                      context: context,
                      subtitle: AuthExceptions.exceptionMessage(
                        context: context,
                        exception: state.exception,
                      ),
                    );
                  } else if (state is OneDayAuthUnauthorized) {
                    _unauthorizedRoute();
                  }
                },
                builder: ({
                  required BuildContext context,
                  required OneDayAuthState state,
                  required bool isLoading,
                  required FutureVoidCallback signOut,
                  required Object? exception,
                }) {
                  return IconButton(
                    onPressed: isLoading ? null : signOut,
                    icon: const Icon(Icons.logout),
                  );
                },
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
            child: ViewConstraint(
              child: Column(
                children: [
                  if (user.data != null) ...[
                    if (user.data?.displayName != null)
                      ListTile(
                        title: Text(user.data?.displayName ?? ''),
                      ),
                    if (user.data?.email != null)
                      ListTile(
                        title: Text(user.data?.email ?? ''),
                      ),
                    if (user.data?.phoneNumber != null)
                      ListTile(
                        title: Text(user.data?.phoneNumber ?? ''),
                      ),
                    const SizedBox(height: 16),
                  ],
                  EmailVerificationView(
                    listener: (OneDayAuthState state) {
                      if (state is OneDayAuthException) {
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
                      required FutureVoidCallback sendMail,
                      required FutureVoidCallback checkVerification,
                      required Object? exception,
                    }) {
                      if (state is EmailVerified ||
                          state is EmailVerificationUnavailable) {
                        return const SizedBox.shrink();
                      }
                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Text(
                              state is EmailVerificationAwaiting
                                  ? 'A verification email has been sent to your email address. Please check your email and click on the link to verify your email address.'
                                  : 'Your email is not verified. Send verification email?',
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: MainButton(
                              title: state is EmailVerificationAwaiting
                                  ? 'Resend'
                                  : 'Send',
                              loading: isLoading,
                              onPressed: sendMail,
                              color: state is EmailVerificationAwaiting
                                  ? AppColors.blue1
                                  : AppColors.orange1,
                            ),
                          ),
                          if (state is EmailVerificationAwaiting)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: MainButton(
                                title: 'Check verification',
                                loading:
                                    state is EmailVerificationCheckAwaiting,
                                onPressed: checkVerification,
                                color: AppColors.green1,
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                  if (AuthUtils.isUserAuthIsPassword(
                      FirebaseAuthService.instance.currentUser))
                    Padding(
                      padding: const EdgeInsets.only(
                        bottom: 16,
                      ),
                      child: MainButton(
                        title: 'Change Password',
                        onPressed: () {
                          AuthDialogs.showChangePasswordDialog(
                            context: context,
                            listener: (OneDayAuthState state) {
                              if (state is ChangePasswordCompleted) {
                                AppSnackBar.show(
                                  context: context,
                                  title: 'Done',
                                  isError: false,
                                );
                              }
                            },
                          );
                        },
                      ),
                    ),
                  DeleteUserView(
                    googleWebClientId: getIt<EnvData>().webClientID,
                    facebookAppId: getIt<EnvData>().facebookClientID,
                    preDeleteAction: (User? user) async {
                      await _deleteUser(user!.uid);
                    },
                    listener: (OneDayAuthState state) {
                      if (state is OneDayAuthException) {
                        AppSnackBar.show(
                          context: context,
                          subtitle: AuthExceptions.exceptionMessage(
                            context: context,
                            exception: state.exception,
                          ),
                        );
                      } else if (state is OneDayAuthUnauthorized) {
                        _unauthorizedRoute();
                      }
                    },
                    builder: ({
                      required BuildContext context,
                      required OneDayAuthState state,
                      required VoidCallback setInitial,
                      required VoidCallback setAwaiting,
                      required bool isLoading,
                      required FutureVoidCallback deleteUser,
                      required Object? exception,
                    }) {
                      return MainButton(
                        title: 'Delete Account',
                        loading: isLoading,
                        onPressed: deleteUser,
                        color: AppColors.red1,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
