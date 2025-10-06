import 'package:flutter/material.dart';
import 'package:tiktok_clone/constants/sizes.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() =>
      _UserProfileScreenState();
}

class _UserProfileScreenState
    extends State<UserProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      // sliverappbar는 스크롤을 내렸을 때 고정이 되지 않고 함께 딸려 올라간다. 굿 ~~~
      slivers: [
        SliverAppBar(
          pinned: true,
          stretch: true,
          backgroundColor: Colors.teal,
          elevation: 1,
          collapsedHeight: 80,

          expandedHeight: 200,
          flexibleSpace: FlexibleSpaceBar(
            stretchModes: [
              StretchMode.blurBackground,
              StretchMode.zoomBackground,
            ],
            background: Image.asset(
              "assets/images/test-image4.jpg",
              fit: BoxFit.cover,
            ),
            title: const Text("Hello!"),
            centerTitle: true,
          ),
        ),
        const SliverToBoxAdapter(
          child: Column(
            children: [
              CircleAvatar(
                backgroundColor: Colors.blue,
                radius: Sizes.size20,
              ),
            ],
          ),
        ),
        SliverFixedExtentList(
          delegate: SliverChildBuilderDelegate(
            (context, index) => Container(
              decoration: BoxDecoration(
                color: Colors.amber[100 * (index % 9 + 1)],
              ),
              child: Center(
                child: Text(
                  "아이템 ${index + 1}",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            childCount: 50, // 50개의 아이템 생성
          ),
          itemExtent: 100,
        ),
        SliverPersistentHeader(
          delegate: CustomDelegate(),
          pinned: true,
          floating: true,
        ),
        SliverGrid(
          delegate: SliverChildBuilderDelegate(
            childCount: 50,
            (context, index) => Container(
              color: Colors.blue[100 * (index % 9 + 1)],
              child: const Align(
                alignment: Alignment.center,
                child: Text("Hello!"),
              ),
            ),
          ),
          gridDelegate:
              const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 100,
                mainAxisSpacing: Sizes.size20,
                crossAxisSpacing: Sizes.size20,
                childAspectRatio: 1,
              ),
        ),
      ],
    );
  }
}

class CustomDelegate
    extends SliverPersistentHeaderDelegate {
  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: Colors.indigo,
      child: const FractionallySizedBox(
        heightFactor: 1,
        child: Center(
          child: Text(
            "Title!!!!!!!!!!!",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }

  @override
  double get maxExtent => 150;

  @override
  double get minExtent => 80;

  @override
  bool shouldRebuild(
    covariant SliverPersistentHeaderDelegate oldDelegate,
  ) {
    return false;
  }
}
