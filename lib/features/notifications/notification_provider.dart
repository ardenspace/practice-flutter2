import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tiktok_clone/features/inbox/chats_screen.dart';
import 'package:tiktok_clone/features/repos/authentication_repos.dart';
import 'package:tiktok_clone/features/videos/views/video_recording_screen.dart';

class NotificationProvider extends AsyncNotifier<void> {
  NotificationProvider(this.context);

  final BuildContext context;
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

    // for Background
    FirebaseMessaging.onMessageOpenedApp.listen((
      notification,
    ) {
      // 위젯 트리가 완전히 빌드된 후에 네비게이션
      SchedulerBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) {
          context.pushNamed(ChatsScreen.routeName);
        }
      });
    });

    // for Terminated
    final notification = await _messaging
        .getInitialMessage();
    if (notification != null) {
      // 위젯 트리가 완전히 빌드된 후에 네비게이션
      SchedulerBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) {
          context.pushNamed(VideoRecordingScreen.routeName);
        }
      });
    }
  }

  @override
  FutureOr<void> build() async {
    final token = await _messaging.getToken();
    if (token == null) return;
    await updateToken(token);
    await initListenders();
    _messaging.onTokenRefresh.listen((newToken) async {
      await updateToken(newToken);
    });
  }
}

final notificationProvider =
    AsyncNotifierProvider.family<
      NotificationProvider,
      void,
      BuildContext
    >(
      (BuildContext context) =>
          NotificationProvider(context),
    );
