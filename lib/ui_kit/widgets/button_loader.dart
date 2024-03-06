import 'package:flutter/material.dart';
import 'package:shop_bloc/core/utils/utils.dart';

class ButtonLoader extends StatelessWidget {
  final double? buttonHeight;
  final double divide;
  final double strokeWidth;
  final Color? color;

  const ButtonLoader({
    this.buttonHeight,
    this.divide = 1.6,
    this.strokeWidth = 2.8,
    this.color,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: buttonHeight == null ? null : buttonHeight! / divide,
      height: buttonHeight == null ? null : buttonHeight! / divide,
      child: Center(
        child: CircularProgressIndicator.adaptive(
          strokeWidth: strokeWidth,
          backgroundColor: AppUtils.isApple() ? color : null,
          valueColor: color == null
              ? null
              : AlwaysStoppedAnimation<Color>(
                  color!,
                ),
        ),
      ),
    );
  }
}
