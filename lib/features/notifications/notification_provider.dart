import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/repos/authentication_repos.dart';

class NotificationProvider extends AsyncNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseMessaging _messaging =
      FirebaseMessaging.instance;

  Future<void> updateToken(String token) async {
    final user = ref.read(authRepo).user;
    await _db.collection("users").doc(user!.uid).update({
      "token": token,
    });
  }

  Future<void> initListenders() async {
    final permission = await _messaging.requestPermission();
    if (permission.authorizationStatus ==
        AuthorizationStatus.denied) {
      return;
    }
    // for Forground
    FirebaseMessaging.onMessage.listen((
      RemoteMessage event,
    ) {
      print(
        "I just got a message and im in the foreground",
      );
      print(event.notification?.title);
    });
  }

  @override
  FutureOr build() async {
    final token = await _messaging.getToken();
    if (token == null) return;
    await updateToken(token);
    await initListenders();
    _messaging.onTokenRefresh.listen((newToken) async {
      await updateToken(newToken);
    });
  }
}

final notificationProvider = AsyncNotifierProvider(
  () => NotificationProvider(),
);
