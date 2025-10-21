import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/videos/widgets/flash_icon_button.dart';

class VideoRecordingScreen extends StatefulWidget {
  const VideoRecordingScreen({super.key});

  @override
  State<VideoRecordingScreen> createState() =>
      _VideoRecordingScreenState();
}

class _VideoRecordingScreenState
    extends State<VideoRecordingScreen> {
  bool _hasPermission = false;
  bool _isSelfieMode = false;
  late FlashMode _flashMode;
  CameraController? _cameraController;

  Future<void> initCamera() async {
    final cameras = await availableCameras();

    if (cameras.isEmpty) {
      return;
    }

    _cameraController = CameraController(
      cameras[_isSelfieMode ? 1 : 0],
      ResolutionPreset.ultraHigh,
    );
    await _cameraController!.initialize();
    _flashMode = _cameraController!.value.flashMode;
  }

  Future<void> initPermissions() async {
    final cameraPermission = await Permission.camera
        .request();
    final micPermission = await Permission.microphone
        .request();

    final cameraDenied =
        cameraPermission.isDenied ||
        cameraPermission.isPermanentlyDenied;
    final micDenied =
        micPermission.isDenied ||
        micPermission.isPermanentlyDenied;

    if (!cameraDenied && !micDenied) {
      _hasPermission = true;
      initCamera();
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    initPermissions();
  }

  Future<void> _toggleSelfieMode() async {
    _isSelfieMode = !_isSelfieMode;
    await initCamera();
    setState(() {});
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  Future<void> _setFlashMode(FlashMode newFlashMode) async {
    await _cameraController!.setFlashMode(newFlashMode);
    setState(() {
      _flashMode = newFlashMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: !_hasPermission
            ? const Column(
                children: [
                  Text(
                    "There is no camera permission...",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: Sizes.size20,
                    ),
                  ),
                  Gaps.v20,
                  CircularProgressIndicator.adaptive(),
                ],
              )
            : _cameraController == null ||
                  !_cameraController!.value.isInitialized
            ? const Column(
                crossAxisAlignment:
                    CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Initializing...",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: Sizes.size20,
                    ),
                  ),
                  Gaps.v20,
                  CircularProgressIndicator.adaptive(),
                ],
              )
            : Stack(
                alignment: Alignment.center,
                children: [
                  CameraPreview(_cameraController!),
                  Positioned(
                    top: Sizes.size20,
                    right: Sizes.size20,
                    child: Column(
                      children: [
                        IconButton(
                          color: Colors.white,
                          onPressed: _toggleSelfieMode,
                          icon: const Icon(
                            Icons.cameraswitch,
                          ),
                        ),
                        Gaps.v10,
                        FlashIconButton(
                          currentFlashMode: _flashMode,
                          targetFlashMode: FlashMode.off,
                          icon: Icons.flash_off_rounded,
                          onPressed: (newFlashMode) =>
                              _setFlashMode(newFlashMode),
                        ),
                        FlashIconButton(
                          currentFlashMode: _flashMode,
                          targetFlashMode: FlashMode.always,
                          icon: Icons.flash_on_rounded,
                          onPressed: (newFlashMode) =>
                              _setFlashMode(newFlashMode),
                        ),
                        FlashIconButton(
                          currentFlashMode: _flashMode,
                          targetFlashMode: FlashMode.auto,
                          icon: Icons.flash_auto_rounded,
                          onPressed: (newFlashMode) =>
                              _setFlashMode(newFlashMode),
                        ),
                        FlashIconButton(
                          currentFlashMode: _flashMode,
                          targetFlashMode: FlashMode.torch,
                          icon: Icons.flashlight_on_rounded,
                          onPressed: (newFlashMode) =>
                              _setFlashMode(newFlashMode),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
