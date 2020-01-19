import 'package:chat_app/src/widgets/settings_item.dart';
import 'package:flutter/material.dart';

class SettingsContainer extends StatelessWidget {

  final List<SettingsItem> children;

  SettingsContainer({
    @required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 1,
            color: Color(0xFFDDDDDD),
          ),
          top: BorderSide(
            width: 1,
            color: Color(0xFFDDDDDD),
          ),
        ),
      ),
      child: Column(
        children: children.asMap().map((int index, SettingsItem settingsItem) {
          var newSettingsItem = settingsItem;
          if (index == children.length - 1) {
            newSettingsItem = newSettingsItem.copyWith(border: false);
          }
          return MapEntry(index, newSettingsItem);
        }).values.toList(),
      ),
    );
  }
}