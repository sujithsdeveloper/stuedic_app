
import 'package:flutter/material.dart';

/// Pinned TabBar Delegate
class TabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;
  TabBarDelegate(this.tabBar);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      // padding: EdgeInsets.only(top: 15),
      color: Colors.white,
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
