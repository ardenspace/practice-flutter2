import 'package:flutter/material.dart';

class UserNamScreen extends StatelessWidget {
  const UserNamScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sign up")),
      body: Container(child: const Text("UserNamScreen")),
    );
  }
}
