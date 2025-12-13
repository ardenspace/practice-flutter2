import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tiktok_clone/common/widgets/video_config/darkmode_valueNotifier.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/notifications/notification_provider.dart';
import 'package:tiktok_clone/features/videos/repos/video_playback_config_repo.dart';
import 'package:tiktok_clone/features/videos/view_models/playback_config_vm.dart';
import 'package:tiktok_clone/firebase_options.dart';
import 'package:tiktok_clone/generated/l10n.dart';
import 'package:tiktok_clone/router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // usePathUrlStrategy();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  // SharedPreferences 초기화를 기다림
  SharedPreferences? preferences;
  try {
    preferences = await SharedPreferences.getInstance();
    print('SharedPreferences initialized successfully');
    print('SharedPreferences instance: $preferences');
  } catch (e) {
    print('SharedPreferences initialization failed: $e');
    // 실패 시 null로 설정하고 앱은 계속 실행
    preferences = null;
  }

  final repository = VideoPlaybackConfigRepository(
    preferences,
  );
  print(
    'Repository created, preferences is null: ${preferences == null}',
  );

  runApp(
    ProviderScope(
      overrides: [
        videoPlaybackConfigRepositoryProvider
            .overrideWithValue(repository),
      ],
      child: const TikTokApp(),
    ),
  );
}

class TikTokApp extends ConsumerWidget {
  const TikTokApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(notificationProvider);
    // S.load(const Locale("en"));
    // 와 이렇게 하니까 언어 설정이 싹 바뀜
    return ValueListenableBuilder(
      valueListenable: darkmodeValueNotifier,
      builder: (context, value, child) => MaterialApp.router(
        routerConfig: ref.watch(routerProvider),
        debugShowCheckedModeBanner: false,
        title: 'Tictok clone',
        localizationsDelegates: [
          S.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [
          const Locale("en"),
          const Locale("ko"),
        ],
        themeMode: value ? ThemeMode.dark : ThemeMode.light,
        // 근데 이런 themedata title을 뭐 어떻게 외워요?
        // 그래서 나온 패키지가 있음
        // flex_color_scheme / https://pub.dev/packages/flex_color_scheme
        theme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.light,
          textTheme: Typography.blackMountainView,
          scaffoldBackgroundColor: Colors.white,
          primaryColor: const Color(0xFFE9435A),
          textSelectionTheme: const TextSelectionThemeData(
            cursorColor: Color(0xFFE9435A),
          ),
          splashColor: Colors.transparent,
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            surfaceTintColor: Colors.white,
            elevation: 0,
            centerTitle: true,
            titleTextStyle: const TextStyle(
              color: Colors.black,
              fontSize: Sizes.size20,
              fontWeight: FontWeight.bold,
            ),
            actionsIconTheme: IconThemeData(
              color: Colors.grey.shade900,
            ),
            iconTheme: IconThemeData(
              color: Colors.grey.shade900,
            ),
          ),
          tabBarTheme: const TabBarThemeData(
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.black,
          ),
          listTileTheme: const ListTileThemeData(
            iconColor: Colors.black,
          ),
          bottomAppBarTheme: BottomAppBarTheme(
            color: Colors.grey.shade50,
            elevation: 2,
          ),
        ),
        darkTheme: ThemeData(
          brightness: Brightness.dark,
          textTheme: Typography.whiteMountainView,
          scaffoldBackgroundColor: Colors.black,
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.grey.shade900,
            surfaceTintColor: Colors.grey.shade900,
            titleTextStyle: const TextStyle(
              color: Colors.white,
              fontSize: Sizes.size20,
              fontWeight: FontWeight.bold,
            ),
            actionsIconTheme: IconThemeData(
              color: Colors.grey.shade100,
            ),
            iconTheme: IconThemeData(
              color: Colors.grey.shade100,
            ),
          ),
          primaryColor: const Color(0xFFE9435A),
          textSelectionTheme: const TextSelectionThemeData(
            cursorColor: Color(0xFFE9435A),
          ),
          tabBarTheme: TabBarThemeData(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.grey.shade300,
            indicatorColor: Colors.white,
          ),
          bottomAppBarTheme: BottomAppBarTheme(
            color: Colors.grey.shade900,
            elevation: 2,
          ),
        ),
      ),
    );
  }
}
