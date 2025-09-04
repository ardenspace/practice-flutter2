import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VidoeoPost extends StatefulWidget {
  const VidoeoPost({super.key});

  @override
  State<VidoeoPost> createState() => _VidoeoPostState();
}

class _VidoeoPostState extends State<VidoeoPost> {
  final VideoPlayerController _videoPlayerController =
      VideoPlayerController.asset(
        "assets/videos/test_video.mp4",
      );

  void _initVideoPlayer() async {
    await _videoPlayerController.initialize();
    _videoPlayerController.play();
  }

  @override
  void initState() {
    super.initState();
    _initVideoPlayer();
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
