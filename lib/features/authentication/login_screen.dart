import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/authentication/widgets/auth_button.dart';

class LogInScreen extends StatelessWidget {
  const LogInScreen({super.key});

  void onSignupTap(BuildContext context) {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Sizes.size80,
            ),
            child: Column(
              children: [
                Gaps.v80,
                const Text(
                  'Log in to Tiktok',
                  style: TextStyle(
                    fontSize: Sizes.size24,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Gaps.v20,
                const Text(
                  'Create a profile, follow other accounts, make your own videos, and more.',
                  style: TextStyle(
                    fontSize: Sizes.size16,
                    color: Colors.black54,
                  ),
                  textAlign: TextAlign.center,
                ),
                Gaps.v40,
                AuthButton(
                  icon: const FaIcon(FontAwesomeIcons.user),
                  text: 'Use email & password',
                  onNavigate: () => {},
                ),
                Gaps.v16,
                AuthButton(
                  icon: const FaIcon(
                    FontAwesomeIcons.apple,
                  ),
                  text: 'Continue with Apple',
                  onNavigate: () => {},
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          boxShadow: const [
            BoxShadow(
              // 위쪽에 그림자가 들어가지 않아 이렇게 .. 표현
              color: Color.fromRGBO(0, 0, 0, 0.1),
              offset: Offset(0, -2),
              blurRadius: 6,
            ),
          ],
        ),
        child: const BottomAppBar(
          color: Colors.transparent,
          elevation: 0,
          child: _BottomNavigationContent(),
        ),
      ),
    );
  }
}

class _BottomNavigationContent extends StatelessWidget {
  const _BottomNavigationContent();

  void _onSignupTap(BuildContext context) {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Don\'t have an account?'),
        const SizedBox(width: 5),
        GestureDetector(
          onTap: () => _onSignupTap(context),
          child: Text(
            'Sign up',
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
