import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomPageRoute {
  static PageRoute build({
    Widget Function(BuildContext) builder,
    RouteSettings settings,
  }) {
    return Platform.isIOS
        ? CupertinoPageRoute(builder: builder, settings: settings)
        : MaterialPageRoute(builder: builder, settings: settings);
  }
}
