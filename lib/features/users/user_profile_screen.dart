import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/breakpoints.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/settings/settings_screen.dart';
import 'package:tiktok_clone/features/users/view_models/users_view_model.dart';
import 'package:tiktok_clone/features/users/widgets/avatar.dart';
import 'package:tiktok_clone/features/users/widgets/persistent_tab_bar.dart';

class UserProfileScreen extends ConsumerStatefulWidget {
  final String username;
  final String tab;

  const UserProfileScreen({
    super.key,
    required this.username,
    required this.tab,
  });

  @override
  ConsumerState<UserProfileScreen> createState() =>
      _UserProfileScreenState();
}

class _UserProfileScreenState
    extends ConsumerState<UserProfileScreen> {
  void _onGearPressed(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const SettingsScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return ref
        .watch(usersProvider)
        .when(
          error: (error, StackTrace) =>
              Center(child: Text(error.toString())),
          loading: () => const Center(
            child: CircularProgressIndicator.adaptive(),
          ),
          data: (data) => Scaffold(
            backgroundColor: Theme.of(
              context,
            ).appBarTheme.backgroundColor,
            body: SafeArea(
              child: DefaultTabController(
                initialIndex: widget.tab == "likes" ? 1 : 0,
                length: 2,
                child: NestedScrollView(
                  headerSliverBuilder: (context, innerBoxIsScrolled) {
                    return [
                      SliverAppBar(
                        title: Text(data.name),
                        centerTitle: true,
                        actions: [
                          IconButton(
                            onPressed: () =>
                                _onGearPressed(context),
                            icon: const FaIcon(
                              FontAwesomeIcons.gear,
                              size: Sizes.size20,
                            ),
                          ),
                        ],
                      ),
                      SliverToBoxAdapter(
                        child: LayoutBuilder(
                          builder: (context, constraints) =>
                              constraints.maxWidth >
                                  Breakpoints.md
                              ? Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment
                                              .center,
                                      children: [
                                        Avatar(
                                          name: data.name,
                                        ),
                                        Gaps.h32,
                                        Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .center,
                                              children: [
                                                Text(
                                                  "@${data.name}",
                                                  style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.w600,
                                                    fontSize:
                                                        Sizes.size18,
                                                  ),
                                                ),
                                                Gaps.h5,
                                                FaIcon(
                                                  FontAwesomeIcons
                                                      .solidCircleCheck,
                                                  size: Sizes
                                                      .size16,
                                                  color: Colors
                                                      .blue
                                                      .shade500,
                                                ),
                                              ],
                                            ),
                                            Gaps.v10,
                                            SizedBox(
                                              height: Sizes
                                                  .size48,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .center,
                                                children: [
                                                  Column(
                                                    children: [
                                                      const Text(
                                                        "97",
                                                        style: TextStyle(
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: Sizes.size18,
                                                        ),
                                                      ),
                                                      Gaps.v1,
                                                      Text(
                                                        "Following",
                                                        style: TextStyle(
                                                          color: Colors.grey.shade500,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  VerticalDivider(
                                                    width: Sizes
                                                        .size32,
                                                    thickness:
                                                        Sizes.size1,
                                                    color: Colors
                                                        .grey
                                                        .shade400,
                                                    indent:
                                                        Sizes.size14,
                                                    endIndent:
                                                        Sizes.size14,
                                                  ),
                                                  Column(
                                                    children: [
                                                      const Text(
                                                        "10M",
                                                        style: TextStyle(
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: Sizes.size18,
                                                        ),
                                                      ),
                                                      Gaps.v1,
                                                      Text(
                                                        "Followers",
                                                        style: TextStyle(
                                                          color: Colors.grey.shade500,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  VerticalDivider(
                                                    width: Sizes
                                                        .size32,
                                                    thickness:
                                                        Sizes.size1,
                                                    color: Colors
                                                        .grey
                                                        .shade400,
                                                    indent:
                                                        Sizes.size14,
                                                    endIndent:
                                                        Sizes.size14,
                                                  ),
                                                  Column(
                                                    children: [
                                                      const Text(
                                                        "194.3M",
                                                        style: TextStyle(
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: Sizes.size18,
                                                        ),
                                                      ),
                                                      Gaps.v1,
                                                      Text(
                                                        "Likes",
                                                        style: TextStyle(
                                                          color: Colors.grey.shade500,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Gaps.v10,
                                            Container(
                                              padding: const EdgeInsets.symmetric(
                                                vertical: Sizes
                                                    .size5,
                                                horizontal:
                                                    Sizes
                                                        .size48,
                                              ),
                                              decoration: BoxDecoration(
                                                color: Theme.of(
                                                  context,
                                                ).primaryColor,
                                                borderRadius:
                                                    const BorderRadius.all(
                                                      Radius.circular(
                                                        Sizes.size4,
                                                      ),
                                                    ),
                                              ),
                                              child: const Text(
                                                'Follow',
                                                style: TextStyle(
                                                  color: Colors
                                                      .white,
                                                  fontWeight:
                                                      FontWeight
                                                          .w600,
                                                ),
                                                textAlign:
                                                    TextAlign
                                                        .center,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const Column(
                                      children: [
                                        Gaps.v20,
                                        Padding(
                                          padding:
                                              EdgeInsets.symmetric(
                                                horizontal:
                                                    Sizes
                                                        .size32,
                                              ),
                                          child: Text(
                                            "All highlights and where to watch live matches on FIFA+ I wonder how it would loook",
                                            textAlign:
                                                TextAlign
                                                    .center,
                                          ),
                                        ),
                                        Gaps.v5,
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment
                                                  .center,
                                          children: [
                                            FaIcon(
                                              FontAwesomeIcons
                                                  .link,
                                              size: Sizes
                                                  .size12,
                                            ),
                                            Gaps.h4,
                                            Text(
                                              "https://nomadcoders.co",
                                              style: TextStyle(
                                                fontWeight:
                                                    FontWeight
                                                        .w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Gaps.v20,
                                      ],
                                    ),
                                  ],
                                )
                              : Column(
                                  children: [
                                    Gaps.v20,
                                    CircleAvatar(
                                      radius: 50,
                                      foregroundImage:
                                          const AssetImage(
                                            "assets/images/test-image4.jpg",
                                          ),
                                      child: Text(
                                        data.name,
                                      ),
                                    ),
                                    Gaps.v20,
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment
                                              .center,
                                      children: [
                                        const Text(
                                          "@솜다리",
                                          style: TextStyle(
                                            fontWeight:
                                                FontWeight
                                                    .w600,
                                            fontSize: Sizes
                                                .size18,
                                          ),
                                        ),
                                        Gaps.h5,
                                        FaIcon(
                                          FontAwesomeIcons
                                              .solidCircleCheck,
                                          size:
                                              Sizes.size16,
                                          color: Colors
                                              .blue
                                              .shade500,
                                        ),
                                      ],
                                    ),
                                    Gaps.v24,
                                    SizedBox(
                                      height: Sizes.size48,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment
                                                .center,
                                        children: [
                                          Column(
                                            children: [
                                              const Text(
                                                "97",
                                                style: TextStyle(
                                                  fontWeight:
                                                      FontWeight
                                                          .bold,
                                                  fontSize:
                                                      Sizes
                                                          .size18,
                                                ),
                                              ),
                                              Gaps.v1,
                                              Text(
                                                "Following",
                                                style: TextStyle(
                                                  color: Colors
                                                      .grey
                                                      .shade500,
                                                ),
                                              ),
                                            ],
                                          ),
                                          VerticalDivider(
                                            width: Sizes
                                                .size32,
                                            thickness:
                                                Sizes.size1,
                                            color: Colors
                                                .grey
                                                .shade400,
                                            indent: Sizes
                                                .size14,
                                            endIndent: Sizes
                                                .size14,
                                          ),
                                          Column(
                                            children: [
                                              const Text(
                                                "10M",
                                                style: TextStyle(
                                                  fontWeight:
                                                      FontWeight
                                                          .bold,
                                                  fontSize:
                                                      Sizes
                                                          .size18,
                                                ),
                                              ),
                                              Gaps.v1,
                                              Text(
                                                "Followers",
                                                style: TextStyle(
                                                  color: Colors
                                                      .grey
                                                      .shade500,
                                                ),
                                              ),
                                            ],
                                          ),
                                          VerticalDivider(
                                            width: Sizes
                                                .size32,
                                            thickness:
                                                Sizes.size1,
                                            color: Colors
                                                .grey
                                                .shade400,
                                            indent: Sizes
                                                .size14,
                                            endIndent: Sizes
                                                .size14,
                                          ),
                                          Column(
                                            children: [
                                              const Text(
                                                "194.3M",
                                                style: TextStyle(
                                                  fontWeight:
                                                      FontWeight
                                                          .bold,
                                                  fontSize:
                                                      Sizes
                                                          .size18,
                                                ),
                                              ),
                                              Gaps.v1,
                                              Text(
                                                "Likes",
                                                style: TextStyle(
                                                  color: Colors
                                                      .grey
                                                      .shade500,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Gaps.v14,
                                    FractionallySizedBox(
                                      widthFactor: 0.33,
                                      child: Container(
                                        padding:
                                            const EdgeInsets.symmetric(
                                              vertical: Sizes
                                                  .size12,
                                            ),
                                        decoration: BoxDecoration(
                                          color: Theme.of(
                                            context,
                                          ).primaryColor,
                                          borderRadius:
                                              const BorderRadius.all(
                                                Radius.circular(
                                                  Sizes
                                                      .size4,
                                                ),
                                              ),
                                        ),
                                        child: const Text(
                                          'Follow',
                                          style: TextStyle(
                                            color: Colors
                                                .white,
                                            fontWeight:
                                                FontWeight
                                                    .w600,
                                          ),
                                          textAlign:
                                              TextAlign
                                                  .center,
                                        ),
                                      ),
                                    ),
                                    Gaps.v14,
                                    const Padding(
                                      padding:
                                          EdgeInsets.symmetric(
                                            horizontal:
                                                Sizes
                                                    .size32,
                                          ),
                                      child: Text(
                                        "All highlights and where to watch live matches on FIFA+ I wonder how it would loook",
                                        textAlign: TextAlign
                                            .center,
                                      ),
                                    ),
                                    Gaps.v14,
                                    const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment
                                              .center,
                                      children: [
                                        FaIcon(
                                          FontAwesomeIcons
                                              .link,
                                          size:
                                              Sizes.size12,
                                        ),
                                        Gaps.h4,
                                        Text(
                                          "https://nomadcoders.co",
                                          style: TextStyle(
                                            fontWeight:
                                                FontWeight
                                                    .w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Gaps.v20,
                                  ],
                                ),
                        ),
                      ),
                      SliverPersistentHeader(
                        delegate: PersistentTabBar(),
                        pinned: true,
                      ),
                    ];
                  },
                  body: TabBarView(
                    children: [
                      GridView.builder(
                        itemCount: 20,
                        padding: EdgeInsets.zero,
                        gridDelegate:
                            SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount:
                                  width > Breakpoints.lg
                                  ? 5
                                  : width > Breakpoints.md
                                  ? 4
                                  : 3,
                              crossAxisSpacing: Sizes.size2,
                              mainAxisSpacing: Sizes.size2,
                              childAspectRatio: 9 / 14,
                            ),
                        itemBuilder: (context, index) => Column(
                          children: [
                            Stack(
                              children: [
                                AspectRatio(
                                  aspectRatio: 9 / 14,
                                  child: FadeInImage.assetNetwork(
                                    fit: BoxFit.cover,
                                    placeholder:
                                        "assets/images/test-image4.jpg",
                                    image:
                                        "https://images.unsplash.com/photo-1758723208958-c18fa48aaff3?q=80&w=687&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                                  ),
                                ),
                                const Positioned(
                                  bottom: 0,
                                  left: Sizes.size5,
                                  right: 0,
                                  child: Row(
                                    children: [
                                      FaIcon(
                                        FontAwesomeIcons
                                            .play,
                                        color: Colors.white,
                                        size: Sizes.size16,
                                      ),
                                      Gaps.h4,
                                      Text(
                                        "1:00",
                                        style: TextStyle(
                                          color:
                                              Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const Center(child: Text('Page two')),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
  }
}
