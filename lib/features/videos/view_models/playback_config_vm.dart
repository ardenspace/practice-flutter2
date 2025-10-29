import 'package:flutter/material.dart';
import 'package:tiktok_clone/features/videos/models/playback_config_model.dart';
import 'package:tiktok_clone/features/videos/repos/video_playback_config_repo.dart';

class PlaybackConfigViewModel extends ChangeNotifier {
  final VideoPlaybackConfigRepository _repository;
  late final PlaybackConfigModel _model;

  PlaybackConfigViewModel(this._repository) {
    final mutedValue = _repository.isMuted();
    final autoPlayValue = _repository.isAutoPlay();

    print(
      'Loading saved preferences: muted=$mutedValue, autoPlay=$autoPlayValue',
    );

    _model = PlaybackConfigModel(
      muted: mutedValue,
      autoPlay: autoPlayValue,
    );
  }

  bool get muted => _model.muted;

  bool get autoPlay => _model.autoPlay;

  void setMuted(bool value) {
    print('Saving muted preference: $value');
    _repository.setMuted(value);
    _model.muted = value;
    notifyListeners();
  }

  void setAutoPlay(bool value) {
    print('Saving autoPlay preference: $value');
    _repository.setAutoPlay(value);
    _model.autoPlay = value;
    notifyListeners();
  }
}
