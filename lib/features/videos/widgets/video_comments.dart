import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/sizes.dart';

class VideoComments extends StatefulWidget {
  const VideoComments({super.key});

  @override
  State<VideoComments> createState() =>
      _VideoCommentsState();
}

void _onClosePressed(BuildContext context) {
  Navigator.of(context).pop();
}

class _VideoCommentsState extends State<VideoComments> {
  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Sizes.size14),
      ),
      child: Scaffold(
        backgroundColor: Colors.grey.shade50,
        appBar: AppBar(
          backgroundColor: Colors.grey.shade50,
          automaticallyImplyLeading: false,
          title: const Text("2276 comments"),
          actions: [
            IconButton(
              onPressed: () => _onClosePressed(context),
              icon: const FaIcon(FontAwesomeIcons.xmark),
            ),
          ],
        ),
        body: ListView.builder(
          itemCount: 10,
          itemBuilder: (context, index) =>
              Text("Comment $index"),
        ),
      ),
    );
  }
}
