import 'package:flutter/material.dart';
import 'package:shop_bloc/ui_kit/styles/colors.dart';
import 'package:shop_bloc/ui_kit/widgets/button_loader.dart';

class MainButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool useWidth;
  final bool useHeight;
  final double width;
  final double height;
  final Color? color;
  final Widget? child;
  final String? title;
  final TextStyle? titleStyle;
  final double titleSize;
  final FontWeight titleFontWeight;
  final Color titleColor;
  final bool loading;
  final Color? progressIndicatorColor;

  const MainButton({
    required this.onPressed,
    this.useWidth = true,
    this.useHeight = true,
    this.width = double.infinity,
    this.height = 48,
    this.color,
    this.child,
    this.title,
    this.titleStyle,
    this.titleSize = 18,
    this.titleFontWeight = FontWeight.w600,
    this.titleColor = AppColors.white1,
    this.loading = false,
    this.progressIndicatorColor = AppColors.white1,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: useWidth ? width : null,
      height: useHeight ? height : null,
      child: MaterialButton(
        color: color ?? Theme.of(context).primaryColor,
        elevation: 0,
        focusElevation: 0,
        hoverElevation: 0,
        disabledElevation: 0,
        highlightElevation: 0,
        disabledColor:
            (color ?? Theme.of(context).primaryColor).withOpacity(.3),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        onPressed: loading ? null : onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 6,
            horizontal: 8,
          ),
          child: loading
              ? ButtonLoader(
                  color: progressIndicatorColor,
                  buttonHeight: useHeight ? height : null,
                )
              : child ??
                  Text(
                    title ?? '',
                    style: titleStyle ??
                        TextStyle(
                          fontSize: titleSize,
                          color: titleColor,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
        ),
      ),
    );
  }
}
