import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/videos/models/playback_config_model.dart';
import 'package:tiktok_clone/features/videos/repos/video_playback_config_repo.dart';

final videoPlaybackConfigRepositoryProvider =
    Provider<VideoPlaybackConfigRepository>((ref) {
      throw UnimplementedError(
        'videoPlaybackConfigRepositoryProvider must be overridden',
      );
    });

class PlaybackConfigViewModel
    extends Notifier<PlaybackConfigModel> {
  late final VideoPlaybackConfigRepository _repository;

  @override
  PlaybackConfigModel build() {
    _repository = ref.read(
      videoPlaybackConfigRepositoryProvider,
    );
    return PlaybackConfigModel(
      muted: _repository.isMuted(),
      autoPlay: _repository.isAutoPlay(),
    );
  }

  Future<void> setMuted(bool value) async {
    await _repository.setMuted(value);
    state = PlaybackConfigModel(
      muted: value,
      autoPlay: state.autoPlay,
    );
  }

  Future<void> setAutoPlay(bool value) async {
    await _repository.setAutoPlay(value);
    state = PlaybackConfigModel(
      muted: state.muted,
      autoPlay: value,
    );
  }
}

final playbackConfigProvider =
    NotifierProvider<
      PlaybackConfigViewModel,
      PlaybackConfigModel
    >(PlaybackConfigViewModel.new);
