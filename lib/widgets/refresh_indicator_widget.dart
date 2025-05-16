import 'package:flutter/material.dart';
import 'package:stuedic_app/utils/constants/color_constants.dart';

/// Note: The child widget must be a scrollable (e.g., ListView, NestedScrollView)
/// and should use `AlwaysScrollableScrollPhysics` to ensure pull-to-refresh works
/// even when the content is not enough to scroll.
RefreshIndicator customRefreshIndicator(
    {required Widget child, required Future<void> Function() onRefresh}) {
  return RefreshIndicator(
    child: child,
    onRefresh: onRefresh,
    backgroundColor: Colors.white,
    color: ColorConstants.secondaryColor,
    elevation: 2,
    // No changes to implementation, but ensure your scrollable uses AlwaysScrollableScrollPhysics
  );
}
