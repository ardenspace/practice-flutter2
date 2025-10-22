import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPreviewScreen extends StatefulWidget {
  final XFile videoFile;

  const VideoPreviewScreen({
    super.key,
    required this.videoFile,
  });

  @override
  State<VideoPreviewScreen> createState() =>
      _VideoPreviewScreenState();
}

class _VideoPreviewScreenState
    extends State<VideoPreviewScreen> {
  VideoPlayerController? _videoPlayerController;

  Future<void> initVideo() async {
    _videoPlayerController = VideoPlayerController.file(
      File(widget.videoFile.path),
    );
    await _videoPlayerController!.initialize();
    await _videoPlayerController!.setLooping(true);
    await _videoPlayerController!.play();
  }

  @override
  void initState() {
    super.initState();
    initVideo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(title: const Text("Preview Video")),
      body:
          _videoPlayerController?.value.isInitialized ==
              true
          ? Center(
              child: AspectRatio(
                aspectRatio: _videoPlayerController!
                    .value
                    .aspectRatio,
                child: VideoPlayer(_videoPlayerController!),
              ),
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
