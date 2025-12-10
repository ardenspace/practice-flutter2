import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/repos/authentication_repos.dart';
import 'package:tiktok_clone/features/videos/repos/video_repo.dart';

class VideoPostViewModel extends AsyncNotifier<void> {
  VideoPostViewModel(this._videoId);

  final String _videoId;
  late final VideoRepository _repository;

  @override
  FutureOr<void> build() {
    _repository = ref.read(videoRepo);
  }

  Future<void> likeVideo() async {
    final user = ref.read(authRepo).user;
    if (user == null) {
      throw Exception("User is not logged in");
    }
    if (_videoId.isEmpty) {
      throw Exception("Video ID is empty");
    }
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () async =>
          await _repository.likeVideo(_videoId, user.uid),
    );
  }
}

final videoPostProvider =
    AsyncNotifierProvider.family<
      VideoPostViewModel,
      void,
      String
    >((String videoId) => VideoPostViewModel(videoId));
