import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/videos/models/video_model.dart';
import 'package:tiktok_clone/features/videos/repos/video_repo.dart';

class TimeLineViewModel
    extends AsyncNotifier<List<VideoModel>> {
  late final VideoRepository _repository;
  List<VideoModel> _list = [];

  @override
  FutureOr<List<VideoModel>> build() async {
    _repository = ref.read(videoRepo);
    final result = await _repository.fetchVideos();
    final newList = result.docs.map(
      (doc) => VideoModel.fromJson(doc.data()),
    );
    _list = newList.toList();
    return _list;
  }
}

final timeLineProvider =
    AsyncNotifierProvider<
      TimeLineViewModel,
      List<VideoModel>
    >(() => TimeLineViewModel());
