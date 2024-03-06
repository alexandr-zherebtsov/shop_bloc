import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:shop_bloc/core/router/router.dart';
import 'package:shop_bloc/ui_kit/styles/colors.dart';
import 'package:shop_bloc/ui_kit/widgets/main_button.dart';

@RoutePage()
class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  void _splashRoute() {
    if (context.router.current.name != SplashRoute.name) {
      context.router.replaceAll([const SplashRoute()]);
    }
  }

  bool isAwaitingEmailConfirmation = false;
  bool isEmailConfirmationLoading = false;
  bool isDeleteAccountLoading = false;

  void _sendEmailConfirmation() {
    setState(() {
      isAwaitingEmailConfirmation = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
        title: const Text(
          'Profile',
        ),
        actions: [
          IconButton(
            onPressed: _splashRoute,
            icon: const Icon(Icons.logout),
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
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    isAwaitingEmailConfirmation
                        ? 'A verification email has been sent to your email address. Please check your email and click on the link to verify your email address.'
                        : 'Your email is not verified. Send verification email?',
                  ),
                ),
                if (!isAwaitingEmailConfirmation)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: MainButton(
                      title: 'Send',
                      loading: isEmailConfirmationLoading,
                      onPressed: _sendEmailConfirmation,
                      color: AppColors.orange1,
                    ),
                  ),
              ],
            ),
            MainButton(
              title: 'Delete Account',
              loading: isDeleteAccountLoading,
              onPressed: () {},
              color: AppColors.red1,
            ),
          ],
        ),
      ),
    );
  }
}
