import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingsItem extends StatelessWidget {
  final Function onTap;
  final Color iconBackgroundColor;
  final IconData icon;
  final String title;
  final bool border;

  SettingsItem({
    @required this.icon,
    @required this.title,
    @required this.onTap,
    @required this.iconBackgroundColor,
    this.border = true,
  });

  SettingsItem copyWith({
    Function onTap,
    Color iconBackgroundColor,
    IconData icon,
    String title,
    bool border,
  }) {
    return SettingsItem(
      onTap: onTap ?? this.onTap,
      iconBackgroundColor: iconBackgroundColor ?? this.iconBackgroundColor,
      icon: icon ?? this.icon,
      title: title ?? this.title,
      border: border ?? this.border,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.only(
            left: 15,
            top: 10,
            bottom: 0,
          ),
          child: Container(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: 20,
                  width: 20,
                  decoration: BoxDecoration(
                    color: iconBackgroundColor,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Icon(icon, color: Colors.white, size: 14),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 15,
                    ),
                    child: Container(
                      child: Column(
                        children: <Widget>[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                child: Text(
                                  title,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              // Padding(
                              //   padding: EdgeInsets.only(right: 15, left: 30),
                              //   child: trailing,
                              // ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            width: double.infinity,
                            height: border ? 1 : 0,
                            color: Color(0xFFDDDDDD),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
