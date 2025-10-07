import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/breakpoints.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';

final tabs = [
  "Top",
  "Users",
  "Videos",
  "Sounds",
  "LIVE",
  "Shopping",
  "Brands",
];

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});

  @override
  State<DiscoverScreen> createState() =>
      _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _textEditingController =
      TextEditingController(text: "initial text");
  bool _isWriting = false;

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  void _onDismissKeyboard(BuildContext context) {
    _textEditingController.clear();
    FocusScope.of(context).unfocus();
    setState(() {
      _isWriting = false;
    });
  }

  void _onStartWriting() {
    setState(() {
      _isWriting = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return DefaultTabController(
      length: tabs.length,
      child: Builder(
        builder: (context) {
          final tabController = DefaultTabController.of(
            context,
          );
          tabController.addListener(() {
            if (tabController.index !=
                tabController.previousIndex) {
              FocusScope.of(context).unfocus();
            }
          });

          return Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              elevation: 1,
              title: Expanded(
                child: Row(
                  children: [
                    FaIcon(
                      FontAwesomeIcons.arrowLeft,
                      color: Colors.grey.shade900,
                      size: 20,
                    ),
                    Gaps.h10,
                    Expanded(
                      child: TextField(
                        controller: _textEditingController,
                        onTap: _onStartWriting,
                        minLines: null,
                        maxLines: null,
                        textInputAction:
                            TextInputAction.newline,
                        decoration: InputDecoration(
                          hintText: "Add a comment...",
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(Sizes.size20),
                            ),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.grey.shade200,
                          contentPadding:
                              const EdgeInsets.symmetric(
                                horizontal: Sizes.size16,
                                vertical: Sizes.size8,
                              ),
                          suffix: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (_isWriting)
                                GestureDetector(
                                  onTap: () =>
                                      _onDismissKeyboard(
                                        context,
                                      ),
                                  child: FaIcon(
                                    FontAwesomeIcons
                                        .solidCircleXmark,
                                    color: Colors
                                        .grey
                                        .shade500,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Gaps.h10,
                    FaIcon(
                      FontAwesomeIcons.coins,
                      color: Colors.grey.shade900,
                      size: 20,
                    ),
                  ],
                ),
              ),
              bottom: TabBar(
                splashFactory: NoSplash.splashFactory,
                tabAlignment: TabAlignment.start,
                padding: const EdgeInsets.symmetric(
                  horizontal: Sizes.size16,
                ),
                isScrollable: true,
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: Sizes.size16,
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorColor: Colors.black,
                labelColor: Colors.black,
                unselectedLabelColor: Colors.grey[500],
                tabs: [
                  for (var tab in tabs) Tab(text: tab),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                GridView.builder(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior
                          .onDrag,
                  itemCount: 20,
                  padding: const EdgeInsets.all(
                    Sizes.size6,
                  ),
                  gridDelegate:
                      SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount:
                            width > Breakpoints.lg
                            ? 5
                            : width > Breakpoints.md
                            ? 3
                            : 2,
                        crossAxisSpacing: Sizes.size10,
                        mainAxisSpacing: Sizes.size10,
                        childAspectRatio: 9 / 21,
                      ),
                  itemBuilder: (context, index) => LayoutBuilder(
                    builder: (context, constraints) => Column(
                      children: [
                        Container(
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(
                                  Sizes.size10,
                                ),
                          ),
                          child: AspectRatio(
                            aspectRatio: 9 / 15,
                            child: FadeInImage.assetNetwork(
                              fit: BoxFit.cover,
                              placeholder:
                                  "assets/images/test-image4.jpg",
                              image:
                                  "https://images.unsplash.com/photo-1758723208958-c18fa48aaff3?q=80&w=687&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                            ),
                          ),
                        ),
                        Gaps.v10,
                        Text(
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          "${constraints.maxWidth} This is a very long caption for my tiktok that im upload just now currently.",
                          style: const TextStyle(
                            fontSize: Sizes.size16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Gaps.v8,
                        if (constraints.maxWidth < 200 ||
                            constraints.maxWidth > 250)
                          DefaultTextStyle(
                            style: TextStyle(
                              color: Colors.grey[500],
                              fontWeight: FontWeight.w600,
                            ),
                            child: Row(
                              children: [
                                const CircleAvatar(
                                  radius: 13,
                                  backgroundImage: NetworkImage(
                                    "https://avatars.githubusercontent.com/u/202112113?s=400&u=d44fdf9d52f4e677b0dec4786da0cfde6bed80e7&v=4",
                                  ),
                                ),
                                Gaps.h4,
                                const Expanded(
                                  child: Text(
                                    "My avatar is going to be very very long",
                                    maxLines: 1,
                                    overflow: TextOverflow
                                        .ellipsis,
                                  ),
                                ),
                                Gaps.h4,
                                FaIcon(
                                  FontAwesomeIcons.heart,
                                  size: Sizes.size16,
                                  color: Colors.grey[500],
                                ),
                                Gaps.h4,
                                const Text("2.9M"),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                for (var tab in tabs.skip(1))
                  Center(
                    child: Text(
                      tab,
                      style: const TextStyle(fontSize: 28),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
