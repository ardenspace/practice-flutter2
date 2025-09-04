import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPost extends StatefulWidget {
  final Function onVideoFinished;
  const VideoPost({
    super.key,
    required this.onVideoFinished,
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

      if (duration.inMilliseconds > 0 &&
          position.inMilliseconds > 0 &&
          position.inMilliseconds >=
              duration.inMilliseconds * 0.95) {
        widget.onVideoFinished();
      }
    }
  }

  void _initVideoPlayer() async {
    try {
      await _videoPlayerController.initialize();
      _videoPlayerController.play();
      setState(() {});
      _videoPlayerController.addListener(_onVideoChanged);
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
