import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomCupertinoNavigationBar extends SliverPersistentHeaderDelegate {

  final Widget trailing;
  final String previousPageTitle;
  final Widget middle;
  final Widget leading;

  CustomCupertinoNavigationBar({
    this.trailing,
    this.previousPageTitle,
    this.middle,
    this.leading,
  });

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {

    return CupertinoNavigationBar(
      padding: EdgeInsetsDirectional.only(end: 0),
      previousPageTitle: '',
      leading: leading,
      middle: middle,
      trailing: trailing,
    );
  }

  @override
  double get maxExtent => 60.0;

  @override
  double get minExtent => 60.0;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}