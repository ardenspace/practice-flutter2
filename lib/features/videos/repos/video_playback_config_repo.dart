import 'package:shared_preferences/shared_preferences.dart';

class VideoPlaybackConfigRepository {
  final SharedPreferences? _prefs;

  static const _mutedKey = 'muted';
  static const _autoPlayKey = 'autoPlay';

  VideoPlaybackConfigRepository(this._prefs);

  bool isMuted() {
    final value = _prefs?.getBool(_mutedKey);
    print('loading muted: $value');
    return value ?? false;
  }

  bool isAutoPlay() {
    final value = _prefs?.getBool(_autoPlayKey);
    print('loading autoPlay: $value');
    return value ?? true;
  }

  Future<void> setMuted(bool value) async {
    if (_prefs == null) {
      print('setMuted: _prefs is null, cannot save');
      return;
    }
    print('saving muted: $value');
    final success = await _prefs.setBool(_mutedKey, value);
    if (!success) {
      print('setMuted: failed to save');
      throw Exception('Failed to save muted preference');
    }
    print('setMuted: saved successfully');
  }

  Future<void> setAutoPlay(bool value) async {
    if (_prefs == null) {
      print('setAutoPlay: _prefs is null, cannot save');
      return;
    }
    print('saving autoPlay: $value');
    final success = await _prefs.setBool(
      _autoPlayKey,
      value,
    );
    if (!success) {
      print('setAutoPlay: failed to save');
      throw Exception('Failed to save autoplay preference');
    }
    print('setAutoPlay: saved successfully');
  }
}
