import 'package:flutter/services.dart';

class AppRegExp {
  static final RegExp emailRegexp = RegExp(
    r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$",
  );

  static final RegExp numRegExp = RegExp(r'[0-9]');

  static final List<TextInputFormatter> phoneFormatter = [
    LengthLimitingTextInputFormatter(12),
    FilteringTextInputFormatter.allow(
      AppRegExp.numRegExp,
    ),
  ];

  static final List<TextInputFormatter> codeFormatter = [
    LengthLimitingTextInputFormatter(6),
    FilteringTextInputFormatter.allow(
      AppRegExp.numRegExp,
    ),
  ];
}
