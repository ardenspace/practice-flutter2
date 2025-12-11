import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/repos/authentication_repos.dart';
import 'package:tiktok_clone/features/videos/repos/video_repo.dart';

class VideoPostViewModel extends AsyncNotifier<bool> {
  VideoPostViewModel(this._videoId);

  final String _videoId;
  late final VideoRepository _repository;

  @override
  FutureOr<bool> build() async {
    _repository = ref.read(videoRepo);
    final user = ref.read(authRepo).user;
    if (user == null || _videoId.isEmpty) {
      return false;
    }
    return await _repository.isLiked(_videoId, user.uid);
  }

  Future<bool> likeVideo() async {
    final user = ref.read(authRepo).user;
    if (user == null) {
      throw Exception("User is not logged in");
    }
    if (_videoId.isEmpty) {
      throw Exception("Video ID is empty");
    }
    state = const AsyncValue.loading();
    final result = await AsyncValue.guard(
      () async =>
          await _repository.likeVideo(_videoId, user.uid),
    );

    if (result.hasValue) {
      final isLiked = result.value!;
      state = AsyncValue.data(isLiked);
      return isLiked;
    } else {
      // 에러 발생 시 현재 상태 유지
      return state.value ?? false;
    }
  }
}

final videoPostProvider =
    AsyncNotifierProvider.family<
      VideoPostViewModel,
      bool,
      String
    >((String videoId) => VideoPostViewModel(videoId));

final videoLikesProvider =
    StreamProvider.family<int, String>((ref, videoId) {
      final repository = ref.read(videoRepo);
      return repository.watchVideoLikes(videoId);
    });
