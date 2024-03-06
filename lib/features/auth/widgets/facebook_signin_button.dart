import 'package:flutter/material.dart';
import 'package:shop_bloc/ui_kit/styles/colors.dart';
import 'package:shop_bloc/ui_kit/widgets/button_loader.dart';

class AppFacebookSignInButton extends StatelessWidget {
  final bool? isLoading;
  final VoidCallback? onSubmit;

  const AppFacebookSignInButton({
    this.isLoading,
    this.onSubmit,
    super.key,
  });

  static const String _name = 'Facebook';

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: OutlinedButton(
        onPressed: onSubmit,
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
          children: isLoading ?? false
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
  }
}
