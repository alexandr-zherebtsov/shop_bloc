import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:shop_bloc/config/firebase/firebase_initialization.dart';
import 'package:shop_bloc/core/router/router.dart';
import 'package:shop_bloc/ui_kit/styles/colors.dart';
import 'package:shop_bloc/ui_kit/widgets/main_button.dart';
import 'package:shop_bloc/ui_kit/widgets/snackbar.dart';

@RoutePage()
class UserScreen extends StatelessWidget {
  const UserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ProfileScreenBuilder(
      auth: FirebaseAuth.instance,
      providers: FirebaseInitialization.providers,
      builder: (
        BuildContext context,
        FirebaseAuth auth,
        Future<bool> Function() onSignInRequired,
        ActionCodeSettings? actionCodeSettings,
      ) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).primaryColor,
            centerTitle: true,
            title: const Text(
              'Profile',
            ),
            actions: [
              SignOutButton(
                showSignOutDialog: true,
                builder: (
                  BuildContext context,
                  VoidCallback signOut,
                ) {
                  return IconButton(
                    onPressed: signOut,
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
            child: Column(
              children: [
                ProfileEmailVerificationBadgeBuilder(
                  auth: auth,
                  actionCodeSettings: actionCodeSettings,
                  useSnackBarExceptions: true,
                  snackBarBuilder: AppSnackBar.snackBarBuilder,
                  builder: (
                    BuildContext context,
                    EmailVerificationState state,
                    bool isLoading,
                    bool isAwaiting,
                    String title,
                    VoidCallback send,
                    VoidCallback dismiss,
                  ) {
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text(title),
                        ),
                        if (!isAwaiting)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: MainButton(
                              title: 'Send',
                              loading: isLoading,
                              onPressed: send,
                              color: AppColors.orange1,
                            ),
                          ),
                      ],
                    );
                  },
                ),
                DeleteAccountButton(
                  auth: auth,
                  onSignInRequired: onSignInRequired,
                  showDeleteConfirmationDialog: true,
                  signInRequired: true,
                  builder: (
                    BuildContext context,
                    bool isLoading,
                    VoidCallback delete,
                  ) {
                    return MainButton(
                      title: 'Delete Account',
                      loading: isLoading,
                      onPressed: delete,
                      color: AppColors.red1,
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
      actions: [
        SignedOutAction((context) {
          context.router.replaceAll([const AuthRoute()]);
        }),
      ],
    );
  }
}
