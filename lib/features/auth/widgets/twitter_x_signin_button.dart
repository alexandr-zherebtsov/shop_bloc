import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shop_bloc/config/firebase/firebase_initialization.dart';
import 'package:shop_bloc/core/assets/generated/assets.gen.dart';
import 'package:shop_bloc/ui_kit/styles/colors.dart';
import 'package:shop_bloc/ui_kit/widgets/button_loader.dart';
import 'package:shop_bloc/ui_kit/widgets/snackbar.dart';

class AppTwitterXSignInButton extends StatelessWidget {
  const AppTwitterXSignInButton({super.key});

  static const String _name = 'X';

  @override
  Widget build(BuildContext context) {
    return OAuthProviderButton(
      provider: FirebaseInitialization.twitterProvider,
      useSnackBarExceptions: true,
      snackBarBuilder: AppSnackBar.snackBarBuilder,
      builder: (
        BuildContext context,
        bool? isLoading,
        Exception? exception,
        VoidCallback? onSubmit,
      ) {
        return SizedBox(
          height: 48,
          child: OutlinedButton(
            onPressed: onSubmit,
            style: Theme.of(context).outlinedButtonTheme.style?.copyWith(
                  side: MaterialStateProperty.all<BorderSide>(
                    BorderSide.none,
                  ),
                  backgroundColor: MaterialStateProperty.all<Color>(
                    AppColors.gray1,
                  ),
                  overlayColor: MaterialStateProperty.all<Color>(
                    AppColors.white1.withOpacity(.08),
                  ),
                ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: isLoading ?? false
                  ? [
                      const ButtonLoader(
                        buttonHeight: 48,
                        color: AppColors.white1,
                      ),
                    ]
                  : [
                      SvgPicture.asset(
                        Assets.svg.twitterX,
                        width: 22,
                        height: 22,
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
      },
    );
  }
}
