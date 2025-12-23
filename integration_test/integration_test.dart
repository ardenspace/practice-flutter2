import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:tiktok_clone/firebase_options.dart';
import 'package:tiktok_clone/main.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    await FirebaseAuth.instance.signOut();
  });

  testWidgets("Create Account Flow", (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const ProviderScope(child: TikTokApp()),
    );
    await tester.pumpAndSettle();
    expect(find.text("Sign up for Tictok"), findsOneWidget);
    final login = find.text("Log in");
    expect(login, findsOneWidget);
    await tester.tap(login);
    await tester.pumpAndSettle();
    final signUp = find.text("Sign up");
    expect(signUp, findsOneWidget);
    await tester.tap(signUp);
    await tester.pumpAndSettle();
    await tester.pumpAndSettle(const Duration(seconds: 10));
    final emailBtn = find.text("Use email & password");
    expect(emailBtn, findsOneWidget);
    await tester.tap(emailBtn);
    await tester.pumpAndSettle();
    await tester.pumpAndSettle(const Duration(seconds: 10));
    final usernameInput = find.byType(TextField).first;
    await tester.enterText(usernameInput, "test");
    await tester.pumpAndSettle();
    await tester.pumpAndSettle(const Duration(seconds: 10));
    await tester.tap(find.text("Next"));
    await tester.pumpAndSettle();
    await tester.pumpAndSettle(const Duration(seconds: 10));
    final emailInput = find.byType(TextField).first;
    await tester.enterText(emailInput, "test@testing.com");
    await tester.pumpAndSettle();
    await tester.pumpAndSettle(const Duration(seconds: 10));
    await tester.tap(find.text("Next"));
    await tester.pumpAndSettle();
    await tester.pumpAndSettle(const Duration(seconds: 10));
    final passwordInput = find.byType(TextField).first;
    await tester.enterText(passwordInput, "asdf123*");
    await tester.pumpAndSettle();
    await tester.pumpAndSettle(const Duration(seconds: 10));
    await tester.tap(find.text("Next"));
    await tester.pumpAndSettle();
    await tester.pumpAndSettle(const Duration(seconds: 10));
    // birthday_screen에서 Next 클릭 (interests_screen으로 이동)
    await tester.tap(find.text("Next"));
    await tester.pumpAndSettle();
    await tester.pumpAndSettle(const Duration(seconds: 10));
    // interests_screen에서 Next 클릭 (실제 회원가입 실행 - Firebase에 저장)
    await tester.tap(find.text("Next"));
    await tester.pumpAndSettle();
    // 회원가입 완료를 기다림 (더 긴 시간 필요)
    await tester.pumpAndSettle(const Duration(seconds: 15));

    // 회원가입이 성공했는지 확인 (tutorial_screen으로 이동했는지 확인)
    // 또는 Firebase Auth에 사용자가 생성되었는지 확인
    final user = FirebaseAuth.instance.currentUser;
    expect(user, isNotNull);
    expect(user?.email, equals("test@testing.com"));
  });
}
