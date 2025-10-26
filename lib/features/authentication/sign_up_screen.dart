import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/authentication/login_screen.dart';
import 'package:tiktok_clone/features/authentication/widgets/auth_button.dart';
import 'package:tiktok_clone/features/authentication/widgets/username_screen.dart';
import 'package:tiktok_clone/generated/l10n.dart';
import 'package:tiktok_clone/utils.dart';

class SignUpScreen extends StatelessWidget {
  static const routeURL = "/";
  static const routeName = "signUp";
  const SignUpScreen({super.key});

  void onLoginTap(BuildContext context) async {
    context.pushNamed(LogInScreen.routeName);
  }
  // 뒤로 갈 페이지가 없는 signup 에서는 push를 써 뒤로 갈 페이지를 만들어주고
  // 로그인 페이지에서는 pop을 써 페이지가 쌓이지 않게 한다! 굿!

  void _onEmailTap(BuildContext context) {
    // context.pushNamed(UserNameScreen.routerName);
    // 👆 위와 같이 하지 않고 아래처럼 하는 이유는
    // Navigator.push는 url을 바꾸지 않고 사용자가 보는 화면만 바꿔 주기 때문에
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const UserNameScreen(),
      ),
    );
  }

  void _onPressUserName(BuildContext context) {
    // context.pushNamed(UserNameScreen.routerName);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const UserNameScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        // if (orientation == Orientation.landscape) {
        //   return const Scaffold(
        //     body: Center(
        //       child: Text("Plz rotate your device"),
        //     ),
        //   );
        // }
        return Scaffold(
          body: SafeArea(
            child: Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: Sizes.size40,
                ),
                child: Column(
                  children: [
                    Gaps.v80,
                    Text(
                      S
                          .of(context)
                          .signUpTitle(
                            "Tiktok",
                            DateTime.now(),
                          ),
                      style: Theme.of(
                        context,
                      ).textTheme.headlineMedium,
                    ),
                    Gaps.v20,
                    Text(
                      S.of(context).signUpSubtitle,
                      style: TextStyle(
                        fontSize: Sizes.size16,
                        color: isDarkMode(context)
                            ? Colors.grey.shade300
                            : Colors.black54,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Gaps.v40,
                    if (orientation ==
                        Orientation.portrait) ...[
                      AuthButton(
                        icon: const FaIcon(
                          FontAwesomeIcons.user,
                        ),
                        text: S
                            .of(context)
                            .emailPasswordButton,
                        onNavigate: () =>
                            _onEmailTap(context),
                      ),
                      Gaps.v16,
                      AuthButton(
                        icon: const FaIcon(
                          FontAwesomeIcons.apple,
                        ),
                        text: S.of(context).appleButton,
                        onNavigate: () =>
                            _onPressUserName(context),
                      ),
                    ],
                    if (orientation ==
                        Orientation.landscape)
                      Row(
                        children: [
                          Expanded(
                            child: AuthButton(
                              icon: const FaIcon(
                                FontAwesomeIcons.user,
                              ),
                              text: "Use email & password",
                              onNavigate: () =>
                                  _onEmailTap(context),
                            ),
                          ),
                          Gaps.h10,
                          Expanded(
                            child: AuthButton(
                              icon: const FaIcon(
                                FontAwesomeIcons.apple,
                              ),
                              text: "Continue with Apple",
                              onNavigate: () =>
                                  _onPressUserName(context),
                            ),
                          ),
                        ],
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
                  color: Colors.black.withValues(
                    alpha: 0.1,
                  ),
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
                  Text(S.of(context).alreayAccount),
                  const SizedBox(width: 5),
                  GestureDetector(
                    onTap: () => onLoginTap(context),
                    child: Text(
                      S.of(context).logIn("female"),
                      style: TextStyle(
                        color: Theme.of(
                          context,
                        ).primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
