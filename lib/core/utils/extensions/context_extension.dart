import 'package:flutter/material.dart';
import 'package:shop_bloc/core/utils/utils.dart';

/// [BuildContext] extension
extension BuildContextX on BuildContext {
  /// bottom padding for [Scaffold] with extendBody
  double extendBodyBottomHeight({
    final double extraHeightIos = 60,
    final double extraHeightAndroid = 30,
    final double navBarHeight = kBottomNavigationBarHeight,
  }) =>
      MediaQuery.viewPaddingOf(this).bottom +
      navBarHeight +
      (AppUtils.isApple() ? extraHeightIos : extraHeightAndroid);

  /// MediaQuery.viewPaddingOf
  double viewBottomPadding([final double extraHeight = 16]) =>
      MediaQuery.viewPaddingOf(this).bottom + extraHeight;
}
