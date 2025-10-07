import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: ListWheelScrollView(
        diameterRatio: 1.5,
        offAxisFraction: 2,
        itemExtent: 200,
        children: [
          for (var x in [
            1,
            2,
            3,
            4,
            5,
            1,
            2,
            3,
            4,
            5,
            1,
            2,
            3,
            4,
            5,
            1,
            2,
            3,
            4,
            5,
          ])
            FractionallySizedBox(
              widthFactor: 1,
              child: Container(
                color: Colors.blue,
                alignment: Alignment.center,
                child: const Text("pick me"),
              ),
            ),
        ],
      ),
    );
  }
}
