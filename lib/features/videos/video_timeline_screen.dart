import 'package:flutter/material.dart';
import 'package:tiktok_clone/features/videos/video_post.dart';

class VideoTimelineScreen extends StatefulWidget {
  const VideoTimelineScreen({super.key});

  @override
  State<VideoTimelineScreen> createState() =>
      _VideoTimelineScreenState();
}

class _VideoTimelineScreenState
    extends State<VideoTimelineScreen> {
  int _itemCount = 4;
  final PageController _pageController = PageController();

  List<Color> colors = [
    Colors.amber,
    Colors.blue,
    Colors.pink,
    Colors.deepPurple,
  ];

  void _onChangePages(int page) {
    _pageController.animateToPage(
      page,
      duration: const Duration(microseconds: 150),
      curve: Curves.linear,
    );

    if (page == _itemCount - 1) {
      setState(() {
        _itemCount = _itemCount + 4;
        colors.addAll([
          Colors.amber,
          Colors.blue,
          Colors.pink,
          Colors.deepPurple,
        ]);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: _pageController,
      scrollDirection: Axis.vertical,
      onPageChanged: _onChangePages,
      itemCount: _itemCount,
      itemBuilder: (context, index) => const VidoeoPost(),
    );
  }
}
