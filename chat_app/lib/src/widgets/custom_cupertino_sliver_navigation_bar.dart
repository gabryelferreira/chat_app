import 'package:flutter/cupertino.dart';

class CustomCupertinoSliverNavigationBar extends StatelessWidget {

  final String previousPageTitle;
  final Widget largeTitle;
  final EdgeInsetsDirectional  padding;
  final Widget trailing;

  CustomCupertinoSliverNavigationBar({
    this.previousPageTitle,
    this.largeTitle,
    this.padding,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoSliverNavigationBar(
      border: Border(
        bottom: BorderSide(
          color: Color(0xFFCCCCCC),
          width: 1,
        ),
      ),
      previousPageTitle: previousPageTitle,
      largeTitle: largeTitle,
      padding: padding,
      trailing: trailing,
    );
  }
}
