import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/breakpoints.dart';
import 'package:tiktok_clone/constants/sizes.dart';

class PersistentTabBar
    extends SliverPersistentHeaderDelegate {
  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      child: Center(
        child: Container(
          constraints: const BoxConstraints(
            maxWidth: Breakpoints.sm,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.symmetric(
              horizontal: BorderSide(
                color: Colors.grey.shade200,
                width: 0.5,
              ),
            ),
          ),
          child: const TabBar(
            indicatorSize: TabBarIndicatorSize.label,
            indicatorColor: Colors.black,
            labelPadding: EdgeInsets.symmetric(
              vertical: Sizes.size10,
            ),
            labelColor: Colors.black,
            tabs: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: Sizes.size20,
                ),
                child: Icon(Icons.grid_4x4_rounded),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: Sizes.size20,
                ),
                child: FaIcon(FontAwesomeIcons.heart),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  double get maxExtent => 47;

  @override
  double get minExtent => 47;

  @override
  bool shouldRebuild(
    covariant SliverPersistentHeaderDelegate oldDelegate,
  ) {
    return true;
  }
}
