import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:tiktok_clone/common/widgets/main_navigation/main_navigation_screen.dart';
import 'package:tiktok_clone/features/authentication/login_screen.dart';
import 'package:tiktok_clone/features/authentication/sign_up_screen.dart';
import 'package:tiktok_clone/features/authentication/widgets/onboarding/interests_screen.dart';
import 'package:tiktok_clone/features/inbox/activity_screen.dart';
import 'package:tiktok_clone/features/inbox/chat_detail_screen.dart';
import 'package:tiktok_clone/features/inbox/chats_screen.dart';
import 'package:tiktok_clone/features/videos/views/video_recording_screen.dart';

final router = GoRouter(
  initialLocation: "/home",
  routes: [
    GoRoute(
      name: SignUpScreen.routeName,
      path: SignUpScreen.routeURL,
      builder: (context, state) => const SignUpScreen(),
    ),
    GoRoute(
      name: LogInScreen.routeName,
      path: LogInScreen.routeURL,
      builder: (context, state) => const LogInScreen(),
    ),
    GoRoute(
      name: InterestsScreen.routeName,
      path: InterestsScreen.routeURL,
      builder: (context, state) => const InterestsScreen(),
    ),
    GoRoute(
      path: "/:tab(home|discover|postVideo|inbox|profile)",
      name: MainNavigationScreen.routeName,
      builder: (context, state) {
        final tab = state.pathParameters["tab"]!;
        return MainNavigationScreen(tab: tab);
      },
    ),
    GoRoute(
      name: ActivityScreen.routeName,
      path: ActivityScreen.routeURL,
      builder: (context, state) => const ActivityScreen(),
    ),
    GoRoute(
      name: ChatsScreen.routeName,
      path: ChatsScreen.routeURL,
      builder: (context, state) => const ChatsScreen(),
      routes: [
        GoRoute(
          path: ChatDetailScreen.routeURL,
          name: ChatDetailScreen.routeName,
          builder: (context, state) {
            final chatId = state.pathParameters["chatId"]!;
            return ChatDetailScreen(chatId: chatId);
          },
        ),
      ],
    ),
    GoRoute(
      path: VideoRecordingScreen.routeURL,
      name: VideoRecordingScreen.routeName,
      pageBuilder: (context, state) => CustomTransitionPage(
        // transitionDuration: const Duration(
        //   milliseconds: 300,
        // ),
        child: const VideoRecordingScreen(),
        transitionsBuilder:
            (
              context,
              animation,
              secondaryAnimation,
              child,
            ) {
              final position = Tween(
                begin: const Offset(0, 1),
                end: Offset.zero,
              ).animate(animation);
              return SlideTransition(
                position: position,
                child: child,
              );
            },
      ),
    ),
  ],
);
