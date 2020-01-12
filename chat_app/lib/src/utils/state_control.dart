import 'dart:async';

import 'package:chat_app/src/utils/state_abstract_control.dart';

class StateControl implements StateAbstractControl {
  final StreamController streamController;

  StateControl() : streamController = StreamController();

  void notifyListeners() {
    streamController.add('change');
  }

  void init() {
  }

  void dispose() {
    streamController.close();
  }
}
