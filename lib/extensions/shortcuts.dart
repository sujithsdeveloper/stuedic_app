import 'package:flutter/material.dart';

extension MediaQueryExtension on BuildContext {
  /// Returns the current screen size.
  double get screenHeight => MediaQuery.of(this).size.height;
  double get screenWidth => MediaQuery.of(this).size.width;
}

extension Spacing on int {
  /// Returns a SizedBox with the given height.
  Widget get height => SizedBox(height: this.toDouble());
  Widget get width => SizedBox(width: this.toDouble());
}
