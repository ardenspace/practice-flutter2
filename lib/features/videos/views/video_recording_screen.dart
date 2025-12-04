import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/videos/views/video_preview_screen.dart';

class VideoRecordingScreen extends StatefulWidget {
  static const String routeName = "postVideo";
  static const String routeURL = "/upload";
  const VideoRecordingScreen({super.key});

  @override
  State<VideoRecordingScreen> createState() =>
      _VideoRecordingScreenState();
}

class _VideoRecordingScreenState
    extends State<VideoRecordingScreen>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  bool _hasPermission = false;
  bool _isSelfieMode = false;
  double _currentZoom = 1.0;
  double _minZoom = 1.0;
  double _maxZoom = 1.0;

  late final bool _noCamera = kDebugMode && Platform.isIOS;

  late final AnimationController
  _buttonAnimationController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 200),
  );

  late final Animation<double> _buttonAnimation = Tween(
    begin: 1.0,
    end: 1.3,
  ).animate(_buttonAnimationController);

  late final AnimationController
  _progressAnimationController = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 10),
    lowerBound: 0.0,
    upperBound: 1.0,
  );

  late FlashMode _flashMode;
  late CameraController _cameraController;

  Future<void> initCamera() async {
    final cameras = await availableCameras();

    if (cameras.isEmpty) {
      return;
    }

    // 기존 컨트롤러가 있으면 먼저 dispose
    try {
      if (_cameraController.value.isInitialized) {
        await _cameraController.dispose();
      }
    } catch (e) {
      // 첫 초기화인 경우 무시
    }

    _cameraController = CameraController(
      cameras[_isSelfieMode ? 1 : 0],
      ResolutionPreset.ultraHigh,
      enableAudio: false,
    );

    await _cameraController.initialize();
    await _cameraController.prepareForVideoRecording();
    await _cameraController.lockCaptureOrientation(
      DeviceOrientation.portraitUp,
    );

    _minZoom = await _cameraController.getMinZoomLevel();
    _maxZoom = await _cameraController.getMaxZoomLevel();

    _currentZoom = _minZoom;
    await _cameraController.setZoomLevel(_currentZoom);

    _flashMode = _cameraController.value.flashMode;

    if (!mounted) return;
    setState(() {});
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
      await initCamera();
      if (!mounted) return;
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    if (!_noCamera) {
      initPermissions();
    } else {
      _hasPermission = true;
    }

    WidgetsBinding.instance.addObserver(this);
    _progressAnimationController.addListener(() {
      setState(() {});
    });
    _progressAnimationController.addStatusListener((
      status,
    ) {
      if (status == AnimationStatus.completed) {
        _stopRecording();
      }
    });
  }

  Future<void> _toggleSelfieMode() async {
    _isSelfieMode = !_isSelfieMode;
    await initCamera();
    if (!mounted) return;
    setState(() {});
  }

  Future<void> _setFlashMode(FlashMode newFlashMode) async {
    await _cameraController.setFlashMode(newFlashMode);
    _flashMode = newFlashMode;
    if (!mounted) return;
    setState(() {});
  }

  Future<void> _starRecording(TapDownDetails _) async {
    if (_cameraController.value.isRecordingVideo) return;

    await _cameraController.startVideoRecording();

    _buttonAnimationController.forward();
    _progressAnimationController.forward();
  }

  Future<void> _stopRecording() async {
    if (!_cameraController.value.isRecordingVideo) return;

    _buttonAnimationController.reverse();
    _progressAnimationController.reset();

    final video = await _cameraController
        .stopVideoRecording();

    if (!mounted) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VideoPreviewScreen(
          videoFile: video,
          isPicked: false,
        ),
      ),
    );
  }

  @override
  Future<void> didChangeAppLifecycleState(
    AppLifecycleState state,
  ) async {
    if (!_hasPermission) return;
    if (state == AppLifecycleState.inactive) {
      if (_cameraController.value.isInitialized) {
        await _cameraController.dispose();
      }
    } else if (state == AppLifecycleState.resumed) {
      if (!_cameraController.value.isInitialized) {
        await initCamera();
        if (!mounted) return;
        setState(() {});
      }
    }
  }

  @override
  void dispose() {
    _progressAnimationController.dispose();
    _buttonAnimationController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    try {
      if (_cameraController.value.isInitialized) {
        _cameraController.dispose();
      }
    } catch (e) {
      // 컨트롤러가 초기화되지 않은 경우 무시
    }
    super.dispose();
  }

  Future<void> _onZoomUpdate(
    DragUpdateDetails details,
  ) async {
    double newZoom = _currentZoom - details.delta.dy * 0.01;

    // 범위 제한
    newZoom = newZoom.clamp(_minZoom, _maxZoom);
    await _cameraController.setZoomLevel(newZoom);

    if (!mounted) return;
    setState(() {
      _currentZoom = newZoom;
    });
  }

  Future<void> _onPickVideoPressed() async {
    final video = await ImagePicker().pickVideo(
      source: ImageSource.gallery,
    );
    if (video == null) return;

    if (!mounted) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VideoPreviewScreen(
          videoFile: video,
          isPicked: true,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: !_hasPermission
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
                  if (!_noCamera &&
                      _cameraController.value.isInitialized)
                    CameraPreview(_cameraController),
                  const Positioned(
                    top: Sizes.size40,
                    left: Sizes.size20,
                    child: CloseButton(color: Colors.white),
                  ),
                  if (!_noCamera)
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
                          IconButton(
                            color:
                                _flashMode == FlashMode.off
                                ? Colors.amber.shade200
                                : Colors.white,
                            onPressed: () => _setFlashMode(
                              FlashMode.off,
                            ),
                            icon: const Icon(
                              Icons.flash_off_rounded,
                            ),
                          ),
                          Gaps.v10,
                          IconButton(
                            color:
                                _flashMode ==
                                    FlashMode.always
                                ? Colors.amber.shade200
                                : Colors.white,
                            onPressed: () => _setFlashMode(
                              FlashMode.always,
                            ),
                            icon: const Icon(
                              Icons.flash_on_rounded,
                            ),
                          ),
                          Gaps.v10,
                          IconButton(
                            color:
                                _flashMode == FlashMode.auto
                                ? Colors.amber.shade200
                                : Colors.white,
                            onPressed: () => _setFlashMode(
                              FlashMode.auto,
                            ),
                            icon: const Icon(
                              Icons.flash_auto_rounded,
                            ),
                          ),
                          Gaps.v10,
                          IconButton(
                            color:
                                _flashMode ==
                                    FlashMode.torch
                                ? Colors.amber.shade200
                                : Colors.white,
                            onPressed: () => _setFlashMode(
                              FlashMode.torch,
                            ),
                            icon: const Icon(
                              Icons.flashlight_on_rounded,
                            ),
                          ),
                        ],
                      ),
                    ),
                  Positioned(
                    bottom: Sizes.size40,
                    width: MediaQuery.of(
                      context,
                    ).size.width,
                    child: Row(
                      children: [
                        const Spacer(),
                        GestureDetector(
                          onPanUpdate: _onZoomUpdate,
                          onTapDown: _starRecording,
                          onTapUp: (details) =>
                              _stopRecording(),
                          child: ScaleTransition(
                            scale: _buttonAnimation,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                SizedBox(
                                  width:
                                      Sizes.size80 +
                                      Sizes.size14,
                                  height:
                                      Sizes.size80 +
                                      Sizes.size14,
                                  child: CircularProgressIndicator(
                                    color:
                                        Colors.red.shade400,
                                    strokeWidth:
                                        Sizes.size6,
                                    value:
                                        _progressAnimationController
                                            .value,
                                  ),
                                ),
                                Container(
                                  width: Sizes.size80,
                                  height: Sizes.size80,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color:
                                        Colors.red.shade400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            alignment: Alignment.center,
                            child: IconButton(
                              onPressed:
                                  _onPickVideoPressed,
                              icon: const FaIcon(
                                FontAwesomeIcons.image,
                                color: Colors.white,
                              ),
                            ),
                          ),
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
