import 'package:go_router/go_router.dart';
import 'package:tiktok_clone/features/authentication/login_screen.dart';
import 'package:tiktok_clone/features/authentication/sign_up_screen.dart';
import 'package:tiktok_clone/features/authentication/widgets/email_screen.dart';
import 'package:tiktok_clone/features/authentication/widgets/username_screen.dart';
import 'package:tiktok_clone/features/users/user_profile_screen.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: SignUpScreen.routeName,
      builder: (context, state) => const SignUpScreen(),
    ),
    GoRoute(
      path: LogInScreen.routeName,
      builder: (context, state) => const LogInScreen(),
    ),
    GoRoute(
      path: UserNameScreen.routeName,
      builder: (context, state) => const UserNameScreen(),
    ),
    GoRoute(
      path: EmailScreen.routeName,
      builder: (context, state) => const EmailScreen(),
    ),
    GoRoute(
      path: "/users/:username",
      builder: (context, state) {
        final username = state.params['username']!;
        return UserProfileScreen(username: username);
      },
    ),
  ],
);
