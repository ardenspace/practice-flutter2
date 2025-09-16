import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';

class VideoComments extends StatefulWidget {
  const VideoComments({super.key});

  @override
  State<VideoComments> createState() =>
      _VideoCommentsState();
}

class _VideoCommentsState extends State<VideoComments> {
  bool _isWriting = false;

  void _onClosePressed(BuildContext context) {
    Navigator.of(context).pop();
  }

  void _onDismissKeyboard(BuildContext context) {
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
    final size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.8,
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
        body: GestureDetector(
          onTap: () => _onDismissKeyboard(context),
          child: Stack(
            children: [
              ListView.separated(
                itemCount: 10,
                padding: const EdgeInsets.only(
                  top: Sizes.size10,
                  left: Sizes.size16,
                  right: Sizes.size16,
                  bottom:
                      Sizes.size10 +
                      kBottomNavigationBarHeight,
                ),
                separatorBuilder: (context, index) =>
                    Gaps.v20,
                itemBuilder: (context, index) => Row(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    const CircleAvatar(
                      radius: 18,
                      child: Text("som"),
                    ),
                    Gaps.h10,
                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Text(
                            "somda",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: Sizes.size14,
                              color: Colors.grey.shade500,
                            ),
                          ),
                          Gaps.v3,
                          const Text(
                            "I'm somda. It's time to take my laundry. I don't want to go outside.",
                          ),
                        ],
                      ),
                    ),
                    Gaps.h20,
                    Column(
                      children: [
                        FaIcon(
                          FontAwesomeIcons.heart,
                          size: Sizes.size20,
                          color: Colors.grey.shade500,
                        ),
                        Gaps.v2,
                        Text(
                          "52.2K",
                          style: TextStyle(
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  color: Colors.white,
                  padding: const EdgeInsets.only(
                    top: Sizes.size10,
                    left: Sizes.size16,
                    bottom: Sizes.size10,
                  ),
                  child: SafeArea(
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 18,
                          backgroundColor:
                              Colors.grey.shade500,
                          foregroundColor: Colors.white,
                          child: const Text("som"),
                        ),
                        Gaps.h10,
                        Expanded(
                          child: TextField(
                            onTap: _onStartWriting,
                            // expands: true, // 선생님은 이걸 추가했는데 난 하니까 바로 에러 나서 제거했다. 커서 말로는 maxLines와 충돌되어서 그렇다고 한다... 삭제하니까 바로 잘 된다. 선생님보다 내가 한 게 더 원했던 것이기도 하다.
                            minLines: null,
                            maxLines: null,
                            textInputAction:
                                TextInputAction.newline,
                            decoration: InputDecoration(
                              hintText: "Add a comment...",
                              border:
                                  const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(
                                          Radius.circular(
                                            Sizes.size20,
                                          ),
                                        ),
                                    borderSide:
                                        BorderSide.none,
                                  ),
                              filled: true,
                              fillColor:
                                  Colors.grey.shade100,
                              contentPadding:
                                  const EdgeInsets.symmetric(
                                    horizontal:
                                        Sizes.size16,
                                    vertical: Sizes.size8,
                                  ),
                              suffix: Row(
                                mainAxisSize:
                                    MainAxisSize.min,
                                children: [
                                  FaIcon(
                                    FontAwesomeIcons.at,
                                    color: Colors
                                        .grey
                                        .shade900,
                                  ),
                                  Gaps.h10,
                                  FaIcon(
                                    FontAwesomeIcons.gift,
                                    color: Colors
                                        .grey
                                        .shade900,
                                  ),
                                  Gaps.h10,
                                  FaIcon(
                                    FontAwesomeIcons
                                        .faceLaugh,
                                    color: Colors
                                        .grey
                                        .shade900,
                                  ),
                                  Gaps.h10,
                                  if (_isWriting)
                                    GestureDetector(
                                      onTap: () =>
                                          _onDismissKeyboard(
                                            context,
                                          ),
                                      child: FaIcon(
                                        FontAwesomeIcons
                                            .circleArrowUp,
                                        color: Theme.of(
                                          context,
                                        ).primaryColor,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
