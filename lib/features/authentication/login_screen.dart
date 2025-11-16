import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/authentication/view_models/social_auth_view_model.dart';
import 'package:tiktok_clone/features/authentication/widgets/auth_button.dart';
import 'package:tiktok_clone/features/authentication/widgets/login_form_screen.dart';
import 'package:tiktok_clone/utils.dart';

class LogInScreen extends ConsumerWidget {
  static String routeName = "/login";
  static String routeURL = "/login";
  const LogInScreen({super.key});

  void onSignupTap(BuildContext context) {
    context.pop();
  }

  void _onEmailLoginTop(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginFormScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                Text(
                  "Log in to Tiktok",
                  style: Theme.of(
                    context,
                  ).textTheme.headlineMedium,
                ),
                Gaps.v20,
                Text(
                  "Create a profile, follow other accounts, make your own videos, and more.",
                  style: TextStyle(
                    fontSize: Sizes.size16,
                    color: isDarkMode(context)
                        ? Colors.grey.shade300
                        : Colors.black54,
                  ),
                  textAlign: TextAlign.center,
                ),
                Gaps.v40,
                AuthButton(
                  icon: const FaIcon(FontAwesomeIcons.user),
                  text: "Use email & password",
                  onNavigate: () =>
                      _onEmailLoginTop(context),
                ),
                Gaps.v16,
                AuthButton(
                  icon: const FaIcon(
                    FontAwesomeIcons.github,
                  ),
                  text: "Continue with Github",
                  onNavigateAsync: () => ref
                      .read(socialAuthProvider.notifier)
                      .githubSignIn(context),
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
          elevation: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Don't have an account?"),
              const SizedBox(width: 5),
              GestureDetector(
                onTap: () => onSignupTap(context),
                child: Text(
                  "Sign up",
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
