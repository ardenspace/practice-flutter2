import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';

class ChatDetailScreen extends StatefulWidget {
  const ChatDetailScreen({super.key});

  @override
  State<ChatDetailScreen> createState() =>
      _ChatDetailScreenState();
}

class _ChatDetailScreenState
    extends State<ChatDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ListTile(
          contentPadding: EdgeInsets.zero,
          horizontalTitleGap: Sizes.size8,
          leading: Stack(
            clipBehavior: Clip.none,
            children: [
              const CircleAvatar(
                foregroundImage: NetworkImage(
                  "https://avatars.githubusercontent.com/u/202112113?s=400&u=d44fdf9d52f4e677b0dec4786da0cfde6bed80e7&v=4",
                ),
              ),
              Positioned(
                bottom: -3,
                right: -3,
                child: Container(
                  width: Sizes.size16,
                  height: Sizes.size16,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white,
                      width: Sizes.size3,
                    ),
                  ),
                ),
              ),
            ],
          ),
          title: const Text(
            "Yeon Koung",
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          subtitle: const Text("Active now"),
          trailing: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              FaIcon(
                FontAwesomeIcons.flag,
                color: Colors.black,
                size: Sizes.size20,
              ),
              Gaps.h32,
              FaIcon(
                FontAwesomeIcons.ellipsis,
                color: Colors.black,
                size: Sizes.size20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
