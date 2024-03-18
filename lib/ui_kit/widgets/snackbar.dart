import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shop_bloc/core/utils/extensions/string_extension.dart';

class AppSnackBar {
  static void show({
    required final BuildContext context,
    final String? title,
    final String? subtitle,
    final bool isError = true,
  }) {
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(
        MainSnackBar(
          context: context,
          title: title,
          subtitle: subtitle,
          isError: isError,
        ),
      );
  }

  static SnackBar snackBarBuilder(
    BuildContext context,
    String? title,
    String? subtitle,
    bool? isError,
  ) {
    return MainSnackBar(
      context: context,
      title: title,
      subtitle: subtitle,
      isError: isError ?? true,
    );
  }
}

class MainSnackBar extends SnackBar {
  MainSnackBar({
    required final BuildContext context,
    final String? title,
    final String? subtitle,
    final bool isError = true,
    super.key,
  }) : super(
          width: kIsWeb ? 420 : null,
          behavior: SnackBarBehavior.floating,
          backgroundColor: const Color(0xD31A293D),
          content: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(
                    width: 6,
                    color: isError
                        ? const Color(0x7FE71D12)
                        : const Color(0xD31A293D),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: isError
                      ? const Icon(
                          Icons.cancel,
                          color: Color(0xFFF04248),
                        )
                      : const Icon(
                          Icons.check_circle,
                          color: Color(0xFF00EC50),
                        ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (title.isNotNullOrEmpty()) Text(title ?? ''),
                    if (subtitle.isNotNullOrEmpty()) Text(subtitle ?? ''),
                  ],
                ),
              ),
            ],
          ),
        );
}
