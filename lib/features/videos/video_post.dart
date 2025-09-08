import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPost extends StatefulWidget {
  final Function onVideoFinished;
  final int index;
  const VideoPost({
    super.key,
    required this.onVideoFinished,
    required this.index,
  });

  @override
  State<VideoPost> createState() => _VideoPostState();
}

class _VideoPostState extends State<VideoPost> {
  final VideoPlayerController _videoPlayerController =
      VideoPlayerController.asset(
        "assets/videos/test_video.mp4",
      );

  void _onVideoChanged() {
    if (_videoPlayerController.value.isInitialized) {
      final duration =
          _videoPlayerController.value.duration;
      final position =
          _videoPlayerController.value.position;

      // 비디오가 끝나기 500ms 전에 다음으로 넘어가기 (로딩 시간 확보)
      if (duration.inMilliseconds > 0 &&
          (duration - position).inMilliseconds <= 500) {
        widget.onVideoFinished();
      }
    }
  }

  void _initVideoPlayer() async {
    try {
      // 비디오를 미리 로드
      await _videoPlayerController.initialize();
      if (mounted) {
        setState(() {});
        _videoPlayerController.play();
        _videoPlayerController.addListener(_onVideoChanged);
      }
    } catch (e) {
      debugPrint('Video initialization error: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _initVideoPlayer();
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: _videoPlayerController.value.isInitialized
              ? VideoPlayer(_videoPlayerController)
              : Container(color: Colors.black),
        ),
      ],
    );
  }
}
