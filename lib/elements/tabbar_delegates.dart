import 'package:flutter/material.dart';
import 'package:stuedic_app/utils/app_utils.dart';
import 'package:stuedic_app/utils/constants/color_constants.dart';

/// Pinned TabBar Delegate
class TabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;
  final BuildContext context;
  TabBarDelegate(this.tabBar, {required this.context});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: AppUtils.isDarkTheme(context)
          ? ColorConstants.darkColor
          : Colors.white,
      child: tabBar,
    );
  }

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  bool shouldRebuild(covariant TabBarDelegate oldDelegate) {
    return oldDelegate.tabBar != tabBar;
  }
}
