import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/authentication/sign_up_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(const TikTokApp());
}

class TikTokApp extends StatelessWidget {
  const TikTokApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tictok clone',
      themeMode: ThemeMode.system,
      theme: ThemeData(
        brightness: Brightness.light,
        textTheme: TextTheme(
          displayLarge: GoogleFonts.openSans(
            fontSize: 95,
            fontWeight: FontWeight.w300,
            letterSpacing: -1.5,
          ),
          displayMedium: GoogleFonts.openSans(
            fontSize: 59,
            fontWeight: FontWeight.w300,
            letterSpacing: -0.5,
          ),
          displaySmall: GoogleFonts.openSans(
            fontSize: 48,
            fontWeight: FontWeight.w400,
          ),
          headlineLarge: GoogleFonts.openSans(
            fontSize: 34,
            fontWeight: FontWeight.w400,
            letterSpacing: 0.25,
          ),
          headlineMedium: GoogleFonts.openSans(
            fontSize: 24,
            fontWeight: FontWeight.w400,
          ),
          headlineSmall: GoogleFonts.openSans(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.15,
          ),
          titleLarge: GoogleFonts.openSans(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            letterSpacing: 0.15,
          ),
          titleMedium: GoogleFonts.openSans(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.1,
          ),
          bodyLarge: GoogleFonts.roboto(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            letterSpacing: 0.5,
          ),
          bodyMedium: GoogleFonts.roboto(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            letterSpacing: 0.25,
          ),
          labelLarge: GoogleFonts.roboto(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            letterSpacing: 1.25,
          ),
          bodySmall: GoogleFonts.roboto(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            letterSpacing: 0.4,
          ),
          labelSmall: GoogleFonts.roboto(
            fontSize: 10,
            fontWeight: FontWeight.w400,
            letterSpacing: 1.5,
          ),
        ),
        scaffoldBackgroundColor: Colors.white,
        primaryColor: const Color(0xFFE9435A),
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Color(0xFFE9435A),
        ),
        splashColor: Colors.transparent,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: Sizes.size20,
            fontWeight: FontWeight.bold,
          ),
        ),
        bottomAppBarTheme: BottomAppBarTheme(
          color: Colors.grey.shade50,
          elevation: 2,
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        textTheme: TextTheme(
          displayLarge: GoogleFonts.openSans(
            fontSize: 95,
            fontWeight: FontWeight.w300,
            letterSpacing: -1.5,
          ),
          displayMedium: GoogleFonts.openSans(
            fontSize: 59,
            fontWeight: FontWeight.w300,
            letterSpacing: -0.5,
          ),
          displaySmall: GoogleFonts.openSans(
            fontSize: 48,
            fontWeight: FontWeight.w400,
          ),
          headlineLarge: GoogleFonts.openSans(
            fontSize: 34,
            fontWeight: FontWeight.w400,
            letterSpacing: 0.25,
          ),
          headlineMedium: GoogleFonts.openSans(
            fontSize: 24,
            fontWeight: FontWeight.w400,
          ),
          headlineSmall: GoogleFonts.openSans(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.15,
          ),
          titleLarge: GoogleFonts.openSans(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            letterSpacing: 0.15,
          ),
          titleMedium: GoogleFonts.openSans(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.1,
          ),
          bodyLarge: GoogleFonts.roboto(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            letterSpacing: 0.5,
          ),
          bodyMedium: GoogleFonts.roboto(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            letterSpacing: 0.25,
          ),
          labelLarge: GoogleFonts.roboto(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            letterSpacing: 1.25,
          ),
          bodySmall: GoogleFonts.roboto(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            letterSpacing: 0.4,
          ),
          labelSmall: GoogleFonts.roboto(
            fontSize: 10,
            fontWeight: FontWeight.w400,
            letterSpacing: 1.5,
          ),
        ),
        scaffoldBackgroundColor: Colors.black,
        primaryColor: const Color(0xFFE9435A),
        bottomAppBarTheme: BottomAppBarTheme(
          color: Colors.grey.shade900,
          elevation: 2,
        ),
      ),
      home: const SignUpScreen(),
    );
  }
}
