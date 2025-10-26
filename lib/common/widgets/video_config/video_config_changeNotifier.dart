import 'package:flutter/material.dart';

// class VideoConfigChangenotifier extends ChangeNotifier {
//   bool autoMute = false;

//   void toggleAutoMute() {
//     autoMute = !autoMute;
//     notifyListeners(); // 이게 setState 같은 역할을 함
//   }
// }

// final videoConfigChangenotifier =
//     VideoConfigChangenotifier();

class VideoConfigChangenotifier extends ChangeNotifier {
  bool isMuted = false;
  bool isAutoPlay = false;

  void toggleIsMuted() {
    isMuted = !isMuted;
    debugPrint("Mute toggled: $isMuted");
    notifyListeners();
  }

  void toggleAutoPlay() {
    isAutoPlay = !isAutoPlay;
    notifyListeners();
  }
}
