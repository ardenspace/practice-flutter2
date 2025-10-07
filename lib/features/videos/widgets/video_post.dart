import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/videos/widgets/video_button.dart';
import 'package:tiktok_clone/features/videos/widgets/video_comments.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

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

class _VideoPostState extends State<VideoPost>
    with SingleTickerProviderStateMixin {
  // with에 mixin을 사용하면 클래스의 메서드와 속성을 전부 가져오겠다는 뜻이 된다.
  late final VideoPlayerController _videoPlayerController;

  bool _isPaused = false;
  final Duration _animataionDuration = const Duration(
    milliseconds: 300,
  );
  late final AnimationController _animatedController;

  bool _isViewMore = false;

  bool _isMuted = false;

  void _onVideoChange() {
    if (_videoPlayerController.value.isInitialized) {
      if (_videoPlayerController.value.duration ==
          _videoPlayerController.value.position) {
        widget.onVideoFinished();
      }
    }
  }

  void _initVideoPlayer() async {
    _videoPlayerController = VideoPlayerController.asset(
      "assets/videos/test_video.mp4",
    );
    await _videoPlayerController.initialize();
    await _videoPlayerController.setLooping(true);

    if (kIsWeb) {
      await _videoPlayerController.setVolume(0);
      _isMuted = true;
    }
    _videoPlayerController.addListener(_onVideoChange);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _initVideoPlayer();

    _animatedController = AnimationController(
      vsync:
          this, // vsync은 쉽게 말하면 위젯이 안 보일 때에는 애니메이션이 작동하지 않게 해준다.
      // 불필요한 리소스 낭비를 막아줌 여기서 this는 _VideoPostState를 뜻함.
      lowerBound: 1.0,
      upperBound: 1.5,
      value: 1.5,
      duration: _animataionDuration,
    );
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }

  void _onVisibilityChanged(VisibilityInfo info) {
    if (!mounted) return;
    if (info.visibleFraction == 1 &&
        !_isPaused &&
        !_videoPlayerController.value.isPlaying) {
      _videoPlayerController.play();
    }
    if (_videoPlayerController.value.isPlaying &&
        info.visibleFraction == 0) {
      _onTogglePause();
    }
  }

  void _onTogglePause() {
    if (_videoPlayerController.value.isPlaying) {
      _videoPlayerController.pause();
      _animatedController.reverse();
    } else {
      _videoPlayerController.play();
      _animatedController.forward();
    }
    setState(() {
      _isPaused = !_isPaused;
    });
  }

  void _onViewMoreTap() {
    setState(() {
      _isViewMore = !_isViewMore;
    });
  }

  void _onCommentsTap(BuildContext context) async {
    if (_videoPlayerController.value.isPlaying) {
      _onTogglePause();
    }
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const VideoComments(),
    );
    _onTogglePause();
  }

  void _onMuteTap() {
    setState(() {
      if (_isMuted) {
        _videoPlayerController.setVolume(1);
        _isMuted = false;
      } else {
        _videoPlayerController.setVolume(0);
        _isMuted = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key("${widget.index}"),
      onVisibilityChanged: _onVisibilityChanged,
      child: Stack(
        children: [
          Positioned.fill(
            child:
                _videoPlayerController.value.isInitialized
                ? VideoPlayer(_videoPlayerController)
                : Container(color: Colors.black),
          ),
          Positioned.fill(
            child: GestureDetector(onTap: _onTogglePause),
          ),
          Positioned.fill(
            child: IgnorePointer(
              child: Center(
                child: AnimatedBuilder(
                  animation: _animatedController,
                  builder: (context, child) {
                    //_animatedController 값이 바뀔 때마다 실행됨
                    return Transform.scale(
                      scale: _animatedController.value,
                      child: child,
                    );
                  },
                  child: AnimatedOpacity(
                    duration: _animataionDuration,
                    opacity: _isPaused ? 1 : 0,
                    child: AnimatedOpacity(
                      opacity: _isPaused ? 1 : 0,
                      duration: _animataionDuration,
                      child: const FaIcon(
                        FontAwesomeIcons.play,
                        color: Colors.white,
                        size: Sizes.size52,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 30,
            left: 10,
            right: 80,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "@hyeono",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: Sizes.size20,
                  ),
                ),
                Gaps.v10,
                const Text(
                  "I got this for free!",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: Sizes.size16,
                  ),
                ),
                Gaps.v10,
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "I got this for free! blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah",
                        maxLines: _isViewMore ? null : 1,
                        overflow: _isViewMore
                            ? null
                            : TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: Sizes.size16,
                        ),
                      ),
                    ),
                    if (!_isViewMore)
                      GestureDetector(
                        onTap: _onViewMoreTap,
                        child: const Text(
                          "View more",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            left: 20,
            top: 20,
            child: GestureDetector(
              onTap: _onMuteTap,
              child: VideoButton(
                icon: _isMuted
                    ? FontAwesomeIcons.volumeXmark
                    : FontAwesomeIcons.volumeHigh,
                text: _isMuted ? "Mute" : "Unmute",
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            right: 10,
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  foregroundImage: NetworkImage(
                    "https://avatars.githubusercontent.com/u/202112113?s=400&u=d44fdf9d52f4e677b0dec4786da0cfde6bed80e7&v=4",
                  ),
                  child: Text("hyeon"),
                ),
                Gaps.v20,
                const VideoButton(
                  icon: FontAwesomeIcons.solidHeart,
                  text: "2.9M",
                ),
                Gaps.v16,
                GestureDetector(
                  onTap: () => _onCommentsTap(context),
                  child: const VideoButton(
                    icon: FontAwesomeIcons.solidComment,
                    text: "33K",
                  ),
                ),
                Gaps.v16,
                const VideoButton(
                  icon: FontAwesomeIcons.share,
                  text: "Share",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
