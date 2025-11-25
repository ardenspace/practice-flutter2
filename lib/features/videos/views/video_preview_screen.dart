import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:tiktok_clone/features/videos/view_models/upload_video_view_model.dart';
import 'package:video_player/video_player.dart';

class VideoPreviewScreen extends ConsumerStatefulWidget {
  final XFile videoFile;
  final bool isPicked;

  const VideoPreviewScreen({
    super.key,
    required this.videoFile,
    required this.isPicked,
  });

  @override
  VideoPreviewScreenState createState() =>
      VideoPreviewScreenState();
}

class VideoPreviewScreenState
    extends ConsumerState<VideoPreviewScreen> {
  VideoPlayerController? _videoPlayerController;
  bool _savedVideo = false;

  Future<void> initVideo() async {
    try {
      print('Video file path: ${widget.videoFile.path}');
      print(
        'File exists: ${File(widget.videoFile.path).existsSync()}',
      );

      _videoPlayerController = VideoPlayerController.file(
        File(widget.videoFile.path),
      );

      await _videoPlayerController!.initialize();

      print(
        'Video initialized: ${_videoPlayerController!.value.isInitialized}',
      );
      print(
        'Video duration: ${_videoPlayerController!.value.duration}',
      );

      if (_videoPlayerController!.value.isInitialized) {
        await _videoPlayerController!.setLooping(true);
        await _videoPlayerController!.play();
        setState(() {}); // UI 업데이트
      }
    } catch (e) {
      print('Error initializing video: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    initVideo();
  }

  @override
  void dispose() {
    _videoPlayerController?.dispose();
    super.dispose();
  }

  Future<void> _saveToGallery() async {
    if (_savedVideo) {
      print("✨✨✨✨✨✨✨✨");
      return;
    }

    try {
      // 권한 확인
      final PermissionState permission =
          await PhotoManager.requestPermissionExtend();
      if (!permission.isAuth) {
        print('Gallery permission denied');
        return;
      }

      // 비디오 파일을 복사하여 저장
      final File videoFile = File(widget.videoFile.path);
      final String fileName =
          'Tiktok_Clone_${DateTime.now().millisecondsSinceEpoch}.mp4';

      final AssetEntity asset = await PhotoManager.editor
          .saveVideo(
            videoFile,
            title: fileName,
            relativePath: "TikTok Clone",
          );

      print('Video saved✨✨✨: $asset');

      _savedVideo = true;
      setState(() {});
    } catch (e) {
      print('Error saving video: $e');

      // 대안 방법: path_provider 사용
      try {
        await _saveVideoAlternative();
      } catch (e2) {
        print('Alternative save method also failed: $e2');
      }
    }
  }

  Future<void> _saveVideoAlternative() async {
    // 대안 저장 방법
    final Directory? directory =
        await getExternalStorageDirectory();
    if (directory != null) {
      final String fileName =
          'Tiktok_Clone_${DateTime.now().millisecondsSinceEpoch}.mp4';
      final File newFile = File(
        '${directory.path}/$fileName',
      );
      await File(widget.videoFile.path).copy(newFile.path);
      print('Video saved to: ${newFile.path}');
      _savedVideo = true;
      setState(() {});
    }
  }

  void _onUploadPressed() {
    ref
        .read(uploadVideoProvider.notifier)
        .uploadVideo(File(widget.videoFile.path), context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Preview Video"),
        actions: [
          if (!widget.isPicked)
            IconButton(
              onPressed: _saveToGallery,
              icon: FaIcon(
                _savedVideo
                    ? FontAwesomeIcons.check
                    : FontAwesomeIcons.download,
              ),
            ),
          IconButton(
            onPressed:
                ref.watch(uploadVideoProvider).isLoading
                ? () {}
                : _onUploadPressed,
            icon: ref.watch(uploadVideoProvider).isLoading
                ? const CircularProgressIndicator()
                : const FaIcon(
                    FontAwesomeIcons.cloudArrowUp,
                  ),
          ),
        ],
      ),
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
