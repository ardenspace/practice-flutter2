import 'package:go_router/go_router.dart';
import 'package:tiktok_clone/features/authentication/sign_up_screen.dart';
import 'package:tiktok_clone/features/authentication/widgets/email_screen.dart';
import 'package:tiktok_clone/features/authentication/widgets/username_screen.dart';
import 'package:tiktok_clone/features/users/user_profile_screen.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      name: SignUpScreen.routeName,
      path: SignUpScreen.routeURL,
      builder: (context, state) => const SignUpScreen(),
      routes: [
        GoRoute(
          path: UserNameScreen.routerURL,
          name: UserNameScreen.routerName,
          builder: (context, state) =>
              const UserNameScreen(),
          routes: [
            GoRoute(
              name: EmailScreen.routerName,
              path: EmailScreen.routerURL,
              builder: (context, state) {
                final args = state.extra as EmailScreenArgs;
                return EmailScreen(username: args.username);
              },
            ),
          ],
        ),
      ],
    ),
    // GoRoute(
    //   path: LogInScreen.routeName,
    //   builder: (context, state) => const LogInScreen(),
    // ),
    // GoRoute(
    //   name: "username_screen",
    //   path: UserNameScreen.routeName,
    //   pageBuilder: (context, state) {
    //     return CustomTransitionPage(
    //       child: const UserNameScreen(),
    //       transitionsBuilder:
    //           (
    //             context,
    //             animation,
    //             secondaryAnimation,
    //             child,
    //           ) {
    //             return FadeTransition(
    //               opacity: animation,
    //               child: ScaleTransition(
    //                 scale: animation,
    //                 child: child,
    //               ),
    //             );
    //           },
    //     );
    //   },
    // ),
    GoRoute(
      path: "/users/:username",
      builder: (context, state) {
        final username = state.params['username']!;
        final tab = state.queryParams['show'] ?? '';
        return UserProfileScreen(
          username: username,
          tab: tab,
        );
      },
    ),
  ],
);
