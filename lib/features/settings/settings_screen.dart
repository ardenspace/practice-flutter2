import 'package:flutter/material.dart';
import 'package:tiktok_clone/common/widgets/video_config/video_config.dart';
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
      SwitchListTile(
        value: VideoConfigData.of(context).autoMute,
        onChanged: (value) =>
            VideoConfigData.of(context).toggelMuted(),
        title: const Text("Auto Mute"),
        subtitle: const Text(
          "Videos will be muted by default",
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
