import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';

class PostVideoButton extends StatelessWidget {
  PostVideoButton({
    super.key,
    this.isPressed = false,
    this.inverted = false,
  });

  bool isPressed;
  final bool inverted;

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: isPressed ? 0.9 : 1.0,
      duration: const Duration(milliseconds: 150),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            right: 18,
            child: Container(
              width: 30,
              height: 30,
              padding: const EdgeInsets.symmetric(
                horizontal: Sizes.size8,
              ),
              decoration: BoxDecoration(
                color: Colors.lightBlueAccent,
                borderRadius: BorderRadius.circular(
                  Sizes.size8,
                ),
              ),
            ),
          ),
          Positioned(
            left: 17,
            child: Container(
              width: 30,
              height: 30,
              padding: const EdgeInsets.symmetric(
                horizontal: Sizes.size8,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(
                  Sizes.size8,
                ),
              ),
            ),
          ),
          Gaps.h24,
          Container(
            height: 30,
            padding: const EdgeInsets.symmetric(
              horizontal: Sizes.size12,
            ),
            decoration: BoxDecoration(
              color: inverted ? Colors.white : Colors.black,
              borderRadius: BorderRadius.circular(
                Sizes.size6,
              ),
            ),
            child: Center(
              child: FaIcon(
                FontAwesomeIcons.plus,
                color: inverted
                    ? Colors.black
                    : Colors.white,
                size: Sizes.size20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
