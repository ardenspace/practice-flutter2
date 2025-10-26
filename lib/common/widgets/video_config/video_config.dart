import 'package:flutter/material.dart';

// 근데 이 방식 ... 납득은 되는데 너무 장황함 지금 이 비디오 뮤트 버튼만으로 코드를 몇 줄을 썼으며 이렇게 가다간 전역 관리 위젯만 50개는 되것다 ;;;

class VideoConfigData extends InheritedWidget {
  // VideoConfigData가 하는 역할: 데이터를 받아오고 내보내는 것만 함
  // 그래서 다른 데에서 나가 쓰일 때에는 Config가 나가는 게 아니라 ConfigData가 나가는 거임
  // 이게 자식들에게 데이터 조회와 데이터 변경 메소드 접근 권한을 주는 것
  final bool autoMute;
  final void Function() toggelMuted;

  const VideoConfigData({
    super.key,
    required this.autoMute,
    required this.toggelMuted,
    required super.child,
  });

  // 어디서든 쓸 수 있도록 생성자 함수 생성
  static VideoConfigData of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<
          VideoConfigData
        >()!;
  }

  @override
  bool updateShouldNotify(
    covariant InheritedWidget oldWidget,
  ) {
    return true;
  }
}

// 왜 이렇게 위젯을 나누었냐면 inheritedWidget의 단점은 데이터를 업데이트할 수 없다는 것이다.
// 너무 큰 단점 .. 흠 그럼 어떻게 해요?
// inheritedWidget과 statefulWidget을 합쳐 사용하면 되잖아!
class VideoConfig extends StatefulWidget {
  // 여기서 어떤 데이터가 필요한지 정의하고 업데이트하는 역할을 함
  final Widget child;
  const VideoConfig({super.key, required this.child});

  @override
  State<VideoConfig> createState() => _VideoConfigState();
}

class _VideoConfigState extends State<VideoConfig> {
  bool autoMute = true;

  void toggelMuted() {
    setState(() {
      autoMute = !autoMute;
    });
  }

  @override
  Widget build(BuildContext context) {
    return VideoConfigData(
      toggelMuted: toggelMuted,
      autoMute: autoMute,
      child: widget.child,
    );
  }
}
