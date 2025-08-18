import 'package:flutter/material.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/authentication/widgets/email_screen.dart';
import 'package:tiktok_clone/features/authentication/widgets/form_button.dart';

class UserNamScreen extends StatefulWidget {
  const UserNamScreen({super.key});

  @override
  State<UserNamScreen> createState() =>
      _UserNamScreenState();
}

class _UserNamScreenState extends State<UserNamScreen> {
  final TextEditingController _usernameController =
      TextEditingController();

  String _username = "";

  @override
  void initState() {
    super.initState();

    _usernameController.addListener(() {
      setState(() {
        _username = _usernameController.text;
      });
    });
  }

  @override
  void dispose() {
    // 데이터가 없으면 메모리도 지워주도록 dispose
    _usernameController.dispose();
    super.dispose();
  }

  void _onNextTap() {
    if (_username.isEmpty) return;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const EmailScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sign up")),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: Sizes.size24,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Gaps.v20,
            const Text(
              "Create username",
              style: TextStyle(
                fontSize: Sizes.size20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Gaps.v4,
            const Text(
              "You can always change this later.",
              style: TextStyle(
                fontSize: Sizes.size16,
                color: Colors.black54,
              ),
            ),
            Gaps.v16,
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                hintText: "Username",
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey.shade400,
                  ),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey.shade400,
                  ),
                ),
              ),
              cursorColor: Theme.of(context).primaryColor,
            ),
            Gaps.v16,
            GestureDetector(
              onTap: _onNextTap,
              child: FormButton(
                disabled: _username.isEmpty,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
