import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/authentication/sign_up_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Optimize system UI for better performance
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  // Set preferred orientations for better UX
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const TikTokApp());
}

class TikTokApp extends StatelessWidget {
  const TikTokApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TikTok Clone',
      debugShowCheckedModeBanner: false,
      theme: _buildTheme(),
      home: const SignUpScreen(),
      // Performance optimizations
      builder: (context, child) {
        return MediaQuery(
          // Disable animations on lower-end devices for better performance
          data: MediaQuery.of(context).copyWith(
            textScaler: const TextScaler.linear(1.0), // Prevent font scaling issues
          ),
          child: child!,
        );
      },
    );
  }

  ThemeData _buildTheme() {
    return ThemeData(
      // Use Material 3 for better performance and modern design
      useMaterial3: true,
      scaffoldBackgroundColor: Colors.white,
      
      // Optimized app bar theme
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        titleTextStyle: TextStyle(
          color: Colors.black,
          fontSize: Sizes.size20,
          fontWeight: FontWeight.bold,
          letterSpacing: -0.5, // Improved readability
        ),
      ),
      
      // Brand colors
      primaryColor: const Color(0xFFE9435A),
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFFE9435A),
        brightness: Brightness.light,
      ),
      
      // Optimized text theme for better performance
      textTheme: const TextTheme(
        bodyLarge: TextStyle(
          fontSize: Sizes.size16,
          fontWeight: FontWeight.normal,
          letterSpacing: -0.2,
        ),
        bodyMedium: TextStyle(
          fontSize: Sizes.size14,
          fontWeight: FontWeight.normal,
          letterSpacing: -0.1,
        ),
        titleLarge: TextStyle(
          fontSize: Sizes.size24,
          fontWeight: FontWeight.bold,
          letterSpacing: -0.5,
        ),
      ),
      
      // Optimized visual density for touch targets
      visualDensity: VisualDensity.adaptivePlatformDensity,
      
      // Material state properties for better performance
      splashFactory: InkRipple.splashFactory,
      
      // Disable expensive animations on low-end devices
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.windows: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.linux: FadeUpwardsPageTransitionsBuilder(),
        },
      ),
    );
  }
}
