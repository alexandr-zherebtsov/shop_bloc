import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shop_bloc/core/utils/extensions/string_extension.dart';
import 'package:shop_bloc/core/utils/utils.dart';
import 'package:shop_bloc/ui_kit/styles/colors.dart';

Future<bool> showActionDialog({
  required final BuildContext context,
  required final String? title,
  required final String? subtitle,
  final String? first,
  final String? second,
  final Color firstColor = AppColors.red1,
  final Color secondColor = AppColors.blue1,
  final bool okType = false,
}) async {
  return await showAdaptiveDialog<bool?>(
        context: context,
        builder: (BuildContext context) {
          return AppActionDialog(
            title: title,
            subtitle: subtitle,
            first: first,
            second: second,
            firstColor: firstColor,
            secondColor: secondColor,
            okType: okType,
          );
        },
      ) ??
      false;
}

class AppActionDialog extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final String? first;
  final String? second;
  final Color firstColor;
  final Color secondColor;
  final bool okType;

  const AppActionDialog({
    this.title,
    this.subtitle,
    this.first,
    this.second,
    this.firstColor = AppColors.red1,
    this.secondColor = AppColors.blue1,
    this.okType = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (AppUtils.isApple()) {
      return CupertinoAlertDialog(
        title: title.isNullOrEmpty()
            ? null
            : Text(
                title ?? '',
              ),
        content: subtitle.isNullOrEmpty()
            ? null
            : Text(
                subtitle ?? '',
              ),
        actions: [
          if (!okType)
            CupertinoDialogAction(
              onPressed: context.router.pop,
              textStyle: TextStyle(
                color: firstColor,
              ),
              child: Text(
                first ?? 'Cancel',
              ),
            ),
          CupertinoDialogAction(
            onPressed: () => context.router.pop(true),
            textStyle: TextStyle(
              color: secondColor,
            ),
            child: Text(
              second ?? 'Yes',
            ),
          ),
        ],
      );
    }
    return AlertDialog(
      title: title.isNullOrEmpty()
          ? null
          : Text(
              title ?? '',
            ),
      content: subtitle.isNullOrEmpty()
          ? null
          : Text(
              subtitle ?? '',
            ),
      actionsAlignment: MainAxisAlignment.spaceEvenly,
      actionsPadding: const EdgeInsets.only(
        bottom: 12,
      ),
      actions: [
        if (!okType)
          TextButton(
            style: Theme.of(context).textButtonTheme.style?.copyWith(
                  overlayColor: MaterialStateProperty.all<Color>(
                    firstColor.withOpacity(.08),
                  ),
                  foregroundColor: MaterialStateProperty.all<Color>(
                    firstColor,
                  ),
                ),
            onPressed: context.router.pop,
            child: Text(
              first ?? 'Cancel',
            ),
          ),
        TextButton(
          style: Theme.of(context).textButtonTheme.style?.copyWith(
                overlayColor: MaterialStateProperty.all<Color>(
                  secondColor.withOpacity(.08),
                ),
                foregroundColor: MaterialStateProperty.all<Color>(
                  secondColor,
                ),
              ),
          child: Text(
            second ?? 'Yes',
          ),
          onPressed: () => context.router.pop(true),
        ),
      ],
    );
  }
}
