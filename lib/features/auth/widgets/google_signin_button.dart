import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shop_bloc/core/assets/generated/assets.gen.dart';
import 'package:shop_bloc/ui_kit/styles/colors.dart';
import 'package:shop_bloc/ui_kit/widgets/button_loader.dart';

class AppGoogleSignInButton extends StatelessWidget {
  final bool? isLoading;
  final VoidCallback? onSubmit;

  const AppGoogleSignInButton({
    this.isLoading,
    this.onSubmit,
    super.key,
  });

  static const String _name = 'Google';

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: OutlinedButton(
        onPressed: onSubmit,
        style: Theme.of(context).outlinedButtonTheme.style?.copyWith(
              side: MaterialStateProperty.all<BorderSide>(
                const BorderSide(
                  color: AppColors.gray1,
                ),
              ),
              backgroundColor: MaterialStateProperty.all<Color>(
                AppColors.white1,
              ),
              overlayColor: MaterialStateProperty.all<Color>(
                AppColors.gray1.withOpacity(.06),
              ),
            ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: isLoading ?? false
              ? [
                  const ButtonLoader(buttonHeight: 48),
                ]
              : [
                  SvgPicture.asset(
                    Assets.svg.google,
                    width: 24,
                    height: 24,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Continue with $_name',
                    style: TextStyle(
                      color: AppColors.gray1,
                    ),
                  ),
                ],
        ),
      ),
    );
  }
}
