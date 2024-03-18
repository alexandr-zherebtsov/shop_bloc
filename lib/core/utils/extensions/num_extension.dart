/// [num]? extension
extension NumNullableExtension on num? {
  /// get 0 or greater number
  num get zeroOrGreater {
    if (this?.isNegative ?? true) return 0;
    return this ?? 0;
  }
}

/// [double]? extension
extension DoubleNullableExtension on double? {
  /// get 0 or greater number
  double get doubleZeroOrGreater => zeroOrGreater.toDouble();
}

/// [int]? extension
extension IntNullableExtension on int? {
  /// get 0 or greater number
  int get intZeroOrGreater => zeroOrGreater.toInt();
}
