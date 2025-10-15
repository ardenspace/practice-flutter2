// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a ko locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'ko';

  static String m0(value) => "${value}";

  static String m1(value) => "2276 comments";

  static String m2(value) => "${value}";

  static String m3(gender) =>
      "${Intl.gender(gender, female: '로그인 하세요', male: '로그인 하세요', other: '로그인')}";

  static String m5(nameOfTheApp) => "${nameOfTheApp}에 가입하세요";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "alreayAccount": MessageLookupByLibrary.simpleMessage("계정이 이미 있나요?"),
    "appleButton": MessageLookupByLibrary.simpleMessage("애플로 함께하기"),
    "commentCount": m0,
    "commentTitle": m1,
    "emailPasswordButton": MessageLookupByLibrary.simpleMessage(
      "Use email & password",
    ),
    "likeCount": m2,
    "logIn": m3,
    "signUpSubtitle": MessageLookupByLibrary.simpleMessage(
      "프로필을 만들고 친구와 소통하세요. 그리고 나만의 비디오를 만들어 보세요.",
    ),
    "signUpTitle": m5,
  };
}
