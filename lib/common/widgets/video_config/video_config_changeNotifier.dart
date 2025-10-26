import 'package:flutter/material.dart';

class VideoConfigChangenotifier extends ChangeNotifier {
  bool autoMute = false;

  void toggleAutoMute() {
    autoMute = !autoMute;
    notifyListeners(); // 이게 setState 같은 역할을 함
  }
}

final videoConfigChangenotifier =
    VideoConfigChangenotifier();
