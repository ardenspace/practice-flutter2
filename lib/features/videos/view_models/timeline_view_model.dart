import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/videos/models/video_model.dart';
import 'package:tiktok_clone/features/videos/repos/video_repo.dart';

class TimeLineViewModel
    extends AsyncNotifier<List<VideoModel>> {
  late final VideoRepository _repository;
  List<VideoModel> _list = [];

  Future<List<VideoModel>> _fetchVideos({
    int? lastItemCreatedAt,
  }) async {
    final result = await _repository.fetchVideos(
      lastItemCreatedAt: null,
    );
    final videos = result.docs.map(
      (doc) => VideoModel.fromJson(
        json: doc.data(),
        videoId: doc.id,
      ),
    );

    return videos.toList();
  }

  @override
  FutureOr<List<VideoModel>> build() async {
    _repository = ref.read(videoRepo);

    _list = await _fetchVideos(lastItemCreatedAt: null);
    return _list;
  }

  Future<void> fetchNextPage() async {
    final nextPage = await _fetchVideos(
      lastItemCreatedAt: _list.last.createdAt,
    );
    state = AsyncValue.data([..._list, ...nextPage]);
  }

  Future<void> refresh() async {
    final videos = await _fetchVideos(
      lastItemCreatedAt: null,
    );
    _list = videos;
    state = AsyncValue.data(videos);
  }
}

final timeLineProvider =
    AsyncNotifierProvider<
      TimeLineViewModel,
      List<VideoModel>
    >(() => TimeLineViewModel());
