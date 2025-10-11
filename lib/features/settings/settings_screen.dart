import 'package:flutter/material.dart';
import 'package:tiktok_clone/constants/breakpoints.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() =>
      _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notification = false;
  bool _checkboxValue = false;

  void _onNotificationsChanged(bool? newValue) {
    if (newValue == null) return;
    setState(() {
      _notification = newValue;
    });
  }

  void _onCheckboxChanged(bool? newValue) {
    if (newValue == null) return;
    setState(() {
      _checkboxValue = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    final tiles = [
      SwitchListTile(
        value: _notification,
        onChanged: _onNotificationsChanged,
        title: const Text("Enable notifications"),
      ),
      // CheckboxListTile(
      //   value: _checkboxValue,
      //   onChanged: _onCheckboxChanged,
      //   title: const Text("Enable notifications"),
      //   subtitle: const Text(
      //     "Enable notifications - subtitle",
      //   ),
      // ),
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

    return Scaffold(
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
    );
  }
}
