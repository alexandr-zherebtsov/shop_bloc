import 'package:shop_bloc/core/utils/reg_exp.dart';

/// [String]? Extension
extension StringNullableExtension on String? {
  /// is null or isEmpty
  bool isNullOrEmpty() => this?.trim().isEmpty ?? true;

  /// is not null or isEmpty
  bool isNotNullOrEmpty() => !isNullOrEmpty();

  /// Uppercase first letter inside string and let the others lowercase
  String capitalize() {
    if (isNullOrEmpty()) return '';
    return this![0].toUpperCase() + this!.substring(1).toLowerCase();
  }

  /// add ? to end
  String questionMark() {
    if (isNullOrEmpty()) return '';
    return '$this?';
  }

  /// is email valid
  bool isValidEmail() {
    if (isNullOrEmpty()) return false;
    return AppRegExp.emailRegexp.hasMatch(this!);
  }

  /// is password valid
  bool isValidPassword() {
    if (isNullOrEmpty()) return false;
    if (this!.contains(' ')) return false;
    return this!.length >= 4;
  }

  /// is phone number valid
  bool isValidPhoneNumber() {
    if (isNullOrEmpty()) return false;
    if (this!.length < 9) return false;
    return AppRegExp.numRegExp.hasMatch(this!);
  }

  /// is code valid
  bool isValidCode() {
    if (isNullOrEmpty()) return false;
    if (this!.length < 6) return false;
    return AppRegExp.numRegExp.hasMatch(this!);
  }

  /// clear phone number
  String clearPhoneNumber({final bool usePlus = true}) {
    if (isNullOrEmpty()) return '';
    final String prefix = this!.contains('+') ? '' : '+';
    return (usePlus ? prefix : '') + this!.replaceAll(' ', '');
  }
}
