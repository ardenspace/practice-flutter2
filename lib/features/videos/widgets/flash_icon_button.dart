import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class FlashIconButton extends StatelessWidget {
  final FlashMode currentFlashMode; // 현재 플래시 모드 (비교용)
  final FlashMode targetFlashMode; // 이 버튼의 플래시 모드
  final IconData icon; // 각 버튼마다 다른 아이콘
  final Function(FlashMode) onPressed; // 플래시 모드를 전달하는 콜백

  const FlashIconButton({
    super.key,
    required this.currentFlashMode,
    required this.targetFlashMode,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      color: currentFlashMode == targetFlashMode
          ? Colors.amber
          : Colors.white,
      onPressed: () => onPressed(targetFlashMode),
      icon: Icon(icon),
    );
  }
}
