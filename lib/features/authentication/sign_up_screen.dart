import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/authentication/login_screen.dart';
import 'package:tiktok_clone/features/authentication/widgets/auth_button.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  void onLoginTap(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const LogInScreen(),
      ),
    );
  }
  // 뒤로 갈 페이지가 없는 signup 에서는 push를 써 뒤로 갈 페이지를 만들어주고
  // 로그인 페이지에서는 pop을 써 페이지가 쌓이지 않게 한다! 굿!

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: Sizes.size80,
            ),
            child: Column(
              children: [
                Gaps.v80,
                Text(
                  "Sign up for Tiktok",
                  style: TextStyle(
                    fontSize: Sizes.size24,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Gaps.v20,
                Text(
                  "Create a profile, follow other accounts, make your own videos, and more.",
                  style: TextStyle(
                    fontSize: Sizes.size16,
                    color: Colors.black54,
                  ),
                  textAlign: TextAlign.center,
                ),
                Gaps.v40,
                AuthButton(
                  icon: FaIcon(FontAwesomeIcons.user),
                  text: "Use email & password",
                ),
                Gaps.v16,
                AuthButton(
                  icon: FaIcon(FontAwesomeIcons.apple),
                  text: "Continue with Apple",
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.grey[100],
          boxShadow: [
            BoxShadow(
              // 위쪽에 그림자가 들어가지 않아 이렇게 .. 표현
              color: Colors.black.withValues(alpha: 0.1),
              offset: const Offset(0, -2),
              blurRadius: 6,
            ),
          ],
        ),
        child: BottomAppBar(
          color: Colors.transparent,
          elevation: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Already have an account?'),
              const SizedBox(width: 5),
              GestureDetector(
                onTap: () => onLoginTap(context),
                child: Text(
                  "Log in",
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
