import 'package:flutter/material.dart';
import 'package:tiktok_clone/common/widgets/video_config/darkmode_valueNotifier.dart';
import 'package:tiktok_clone/common/widgets/video_config/video_valueNotifier.dart';
import 'package:tiktok_clone/constants/breakpoints.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() =>
      _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notification = false;

  void _onNotificationsChanged(bool? newValue) {
    if (newValue == null) return;
    setState(() {
      _notification = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    final tiles = [
      // SwitchListTile(
      //   value: VideoConfigData.of(context).autoMute,
      //   onChanged: (value) =>
      //       VideoConfigData.of(context).toggelMuted(),
      //   title: const Text("Auto Mute"),
      //   subtitle: const Text(
      //     "Videos will be muted by default",
      //   ),
      // ),
      // It's weird... but it works... 체인지노티파이어는 실시간으로 데이터를 보고 있지 않음
      // 아니 정확히 말하면 value가 실시간으로 업데이트 되지 않음
      // 그럼 어떻게 업데이트를 감지하는가? 그때 쓰이는 게 AnimatedBuilder...
      // 진짜 이상함 근데 공식문서에서는 둘을 같이 쓰라고 말하고 있음...
      // 근데 좋은 건 딱 이 부분만 리렌더링이 된다는 것
      AnimatedBuilder(
        animation: videoValueNotifier,
        builder: (context, child) => SwitchListTile(
          value: videoValueNotifier.value,
          onChanged: (value) {
            videoValueNotifier.value =
                !videoValueNotifier.value;
          },
          title: const Text("Auto Mute"),
          subtitle: const Text(
            "Videos will be muted by default",
          ),
        ),
      ),
      AnimatedBuilder(
        animation: darkmodeValueNotifier,
        builder: (context, child) => SwitchListTile(
          value: darkmodeValueNotifier.value,
          onChanged: (value) {
            darkmodeValueNotifier.value =
                !darkmodeValueNotifier.value;
          },
          title: const Text("Dark Mode"),
          subtitle: const Text(
            "Light mode will be used by default",
          ),
        ),
      ),
      SwitchListTile(
        value: _notification,
        onChanged: _onNotificationsChanged,
        title: const Text("Enable notifications"),
      ),
      const ListTile(title: Text("What is your birthday?")),
      const ListTile(
        title: Text("Log out (IOS)"),
        textColor: Colors.red,
      ),
      const ListTile(
        title: Text("Log out (IOS / Bottom)"),
        textColor: Colors.red,
      ),
      const AboutListTile(),
    ];

    return Localizations.override(
      context: context,
      locale: const Locale("es"),
      child: Scaffold(
        appBar: AppBar(title: const Text("Settings")),
        body: Center(
          child: Container(
            constraints: const BoxConstraints(
              maxWidth: Breakpoints.sm,
            ),
            child: ListView.separated(
              itemCount: tiles.length,
              itemBuilder: (ctx, index) => tiles[index],
              separatorBuilder: (ctx, index) => Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                ),
                child: Divider(
                  color: Colors.grey.shade300,
                  thickness: 1,
                  height: 1,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
