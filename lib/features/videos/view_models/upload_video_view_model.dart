import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tiktok_clone/features/repos/authentication_repos.dart';
import 'package:tiktok_clone/features/users/view_models/users_view_model.dart';
import 'package:tiktok_clone/features/videos/models/video_model.dart';
import 'package:tiktok_clone/features/videos/repos/video_repo.dart';

class UploadVideoViewModel extends AsyncNotifier<void> {
  late final VideoRepository _repository;

  @override
  FutureOr<void> build() {
    _repository = ref.read(videoRepo);
  }

  Future<void> uploadVideo(
    File video,
    BuildContext context,
  ) async {
    final user = ref.read(authRepo).user;
    final userProfile = ref.read(usersProvider).value;

    if (userProfile != null) {
      state = const AsyncValue.loading();
      state = await AsyncValue.guard(() async {
        final task = await _repository.uploadVideoFile(
          video,
          user!.uid,
        );

        if (task.metadata != null) {
          await _repository.saveVideo(
            VideoModel(
              title: "Happy flutter!",
              fileUrl: await task.ref.getDownloadURL(),
              creatorUid: user.uid,
              description: "I'm happy with flutter",
              thumbnailUrl: "",
              likes: 0,
              comments: 0,
              createdAt:
                  DateTime.now().millisecondsSinceEpoch,
              creator: userProfile.name,
            ),
          );

          context.pushReplacement("/home");
        }
      });
    }
  }
}

final uploadVideoProvider =
    AsyncNotifierProvider<UploadVideoViewModel, void>(
      () => UploadVideoViewModel(),
    );
