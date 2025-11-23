import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/authentication/view_models/signup_view_model.dart';
import 'package:tiktok_clone/features/authentication/widgets/form_button.dart';
import 'package:tiktok_clone/features/authentication/widgets/onboarding/interests_screen.dart';

class BirthdayScreen extends ConsumerStatefulWidget {
  const BirthdayScreen({super.key});

  @override
  ConsumerState<BirthdayScreen> createState() =>
      _BirthdayScreenState();
}

class _BirthdayScreenState
    extends ConsumerState<BirthdayScreen> {
  final TextEditingController _birthdayController =
      TextEditingController();

  DateTime initialDate = DateTime.now();
  // code challenge
  late DateTime now;
  late DateTime maxdate;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    now = DateTime.now();
    maxdate = DateTime(now.year - 12, now.month, now.day);
    _selectedDate = maxdate; // 초기 선택 날짜 설정
    _setTextFieldDate(
      maxdate,
    ); // inistate가 실행될 때에 initialDate 값이 참조되므로 에러가 안 남
    // 바깥에서 바로 갖다 써버리면 아직 실행할 단계가 아닌데 실행해서 에러가 남
    // 바깥에서는 타입 체크, 상수 계산 같은 걸 하므로 const 값만 사용 가능
    // 앱이 실제로 실행되는 런타임 시점에 여러 값을 참조할 수 있도록 코드를 짜야 함
  }

  @override
  void dispose() {
    // 데이터가 없으면 메모리도 지워주도록 dispose
    _birthdayController.dispose();
    super.dispose();
  }

  void _onNextTap() {
    // JSON 형태로 저장
    final birthdayData = {
      "birthday": _selectedDate.toIso8601String(),
    };
    final birthdayJson = jsonEncode(birthdayData);

    ref.read(signUpForm.notifier).state = {
      ...ref.read(signUpForm.notifier).state,
      "bio": birthdayJson,
    };

    // interests_screen으로 이동
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const InterestsScreen(),
      ),
    );
  }

  void _setTextFieldDate(DateTime date) {
    _selectedDate = date; // 현재 선택된 날짜 저장
    final textDate = date.toString().split(" ").first;
    _birthdayController.value = TextEditingValue(
      text: textDate,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sign up")),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: Sizes.size24,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Gaps.v20,
            const Text(
              "When's your birthday?",
              style: TextStyle(
                fontSize: Sizes.size20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Gaps.v4,
            const Text(
              "Your birthday won't be shown publicly.",
              style: TextStyle(
                fontSize: Sizes.size16,
                color: Colors.black54,
              ),
            ),
            Gaps.v16,
            TextField(
              enabled: false,
              controller: _birthdayController,
              decoration: InputDecoration(
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey.shade400,
                  ),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey.shade400,
                  ),
                ),
              ),
              cursorColor: Theme.of(context).primaryColor,
            ),
            Gaps.v16,
            GestureDetector(
              onTap: _onNextTap,
              child: FormButton(
                text: "Next",
                disabled: ref
                    .watch(signUpProvider)
                    .isLoading,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        height: 300,
        child: CupertinoDatePicker(
          mode: CupertinoDatePickerMode.date,
          initialDateTime: maxdate,
          maximumDate: maxdate,
          onDateTimeChanged: _setTextFieldDate,
        ),
      ),
    );
  }
}
