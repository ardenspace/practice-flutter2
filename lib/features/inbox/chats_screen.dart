import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/inbox/chat_detail_screen.dart';
import 'package:tiktok_clone/features/inbox/repos/messages_repo.dart';
import 'package:tiktok_clone/features/inbox/view_models/messages_view_model.dart';
import 'package:tiktok_clone/features/repos/authentication_repos.dart';
import 'package:tiktok_clone/utils.dart';

class ChatsScreen extends ConsumerWidget {
  static const String routeName = "chats";
  static const String routeURL = "/chats";
  const ChatsScreen({super.key});

  void _onPlusPressed(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => const UserSelectionSheet(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatRoomsAsync = ref.watch(chatRoomsProvider);

    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: const Text("Direct messages"),
        actions: [
          IconButton(
            onPressed: () => _onPlusPressed(context),
            icon: const FaIcon(FontAwesomeIcons.plus),
          ),
        ],
      ),
      body: chatRoomsAsync.when(
        data: (chatRoomIds) {
          if (chatRoomIds.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FaIcon(
                    FontAwesomeIcons.message,
                    size: Sizes.size64,
                    color: Colors.grey.shade400,
                  ),
                  Gaps.v20,
                  Text(
                    "No messages yet",
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: Sizes.size16,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.symmetric(
              vertical: Sizes.size10,
            ),
            itemCount: chatRoomIds.length,
            separatorBuilder: (context, index) =>
                const Divider(height: 1),
            itemBuilder: (context, index) {
              final chatId = chatRoomIds[index];
              return ref
                  .watch(chatRoomInfoProvider(chatId))
                  .when(
                    data: (chatRoomInfo) {
                      if (chatRoomInfo == null) {
                        return const SizedBox.shrink();
                      }

                      final otherUser =
                          chatRoomInfo["otherUser"]
                              as Map<String, dynamic>;
                      final lastMessage =
                          chatRoomInfo["lastMessage"]
                              as String?;
                      final lastMessageTime =
                          chatRoomInfo["lastMessageTime"]
                              as int?;

                      String timeText = "";
                      if (lastMessageTime != null) {
                        final dateTime =
                            DateTime.fromMillisecondsSinceEpoch(
                              lastMessageTime,
                            );
                        final now = DateTime.now();
                        if (now
                                .difference(dateTime)
                                .inDays ==
                            0) {
                          timeText = DateFormat(
                            "h:mm a",
                          ).format(dateTime);
                        } else if (now
                                .difference(dateTime)
                                .inDays <
                            7) {
                          timeText = DateFormat(
                            "EEE",
                          ).format(dateTime);
                        } else {
                          timeText = DateFormat(
                            "MM/dd",
                          ).format(dateTime);
                        }
                      }

                      return ListTile(
                        onTap: () {
                          context.pushNamed(
                            ChatDetailScreen.routeName,
                            pathParameters: {
                              "chatId": chatId,
                            },
                          );
                        },
                        leading: CircleAvatar(
                          radius: Sizes.size28,
                          foregroundImage:
                              otherUser["hasAvatar"] == true
                              ? NetworkImage(
                                  "https://firebasestorage.googleapis.com/v0/b/tiktok-clone-4e0c0.appspot.com/o/avatars%2F${otherUser["uid"]}?alt=media",
                                )
                              : null,
                          child:
                              otherUser["hasAvatar"] != true
                              ? Text(
                                  (otherUser["name"]
                                              as String? ??
                                          "U")[0]
                                      .toUpperCase(),
                                )
                              : null,
                        ),
                        title: Row(
                          mainAxisAlignment:
                              MainAxisAlignment
                                  .spaceBetween,
                          crossAxisAlignment:
                              CrossAxisAlignment.end,
                          children: [
                            Expanded(
                              child: Text(
                                otherUser["name"] ??
                                    "Unknown",
                                style: const TextStyle(
                                  fontWeight:
                                      FontWeight.w600,
                                ),
                                overflow:
                                    TextOverflow.ellipsis,
                              ),
                            ),
                            if (timeText.isNotEmpty)
                              Text(
                                timeText,
                                style: TextStyle(
                                  color:
                                      Colors.grey.shade500,
                                  fontSize: Sizes.size12,
                                ),
                              ),
                          ],
                        ),
                        subtitle: lastMessage != null
                            ? Text(
                                lastMessage,
                                overflow:
                                    TextOverflow.ellipsis,
                                maxLines: 1,
                              )
                            : const Text("No messages yet"),
                      );
                    },
                    error: (error, stack) => ListTile(
                      title: Text("Error: $error"),
                    ),
                    loading: () => const ListTile(
                      leading: CircularProgressIndicator(),
                    ),
                  );
            },
          );
        },
        error: (error, stack) =>
            Center(child: Text("Error: $error")),
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}

class UserSelectionSheet extends ConsumerWidget {
  const UserSelectionSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersAsync = ref.watch(usersProvider);
    final currentUser = ref.watch(authRepo).user;
    final isDark = isDarkMode(context);

    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: BoxDecoration(
        color: isDark ? Colors.black : Colors.white,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(Sizes.size20),
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(Sizes.size16),
            child: Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Select a user",
                  style: TextStyle(
                    fontSize: Sizes.size20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                IconButton(
                  onPressed: () => context.pop(),
                  icon: const FaIcon(
                    FontAwesomeIcons.xmark,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: usersAsync.when(
              data: (users) {
                if (users.isEmpty) {
                  return const Center(
                    child: Text("No users found"),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.symmetric(
                    vertical: Sizes.size10,
                  ),
                  itemCount: users.length,
                  separatorBuilder: (context, index) =>
                      const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final user = users[index];
                    final hasAvatar =
                        user["hasAvatar"] == true;
                    final uid = user["uid"] as String;
                    final name =
                        user["name"] as String? ??
                        "Unknown";

                    return ListTile(
                      onTap: () async {
                        if (currentUser == null) return;

                        final repo = ref.read(messagesRepo);
                        final chatId = await repo
                            .createChatRoom(
                              currentUser.uid,
                              uid,
                            );

                        if (context.mounted) {
                          context.pop();
                          context.pushNamed(
                            ChatDetailScreen.routeName,
                            pathParameters: {
                              "chatId": chatId,
                            },
                          );
                        }
                      },
                      leading: CircleAvatar(
                        radius: Sizes.size28,
                        foregroundImage: hasAvatar
                            ? NetworkImage(
                                "https://firebasestorage.googleapis.com/v0/b/tiktok-clone-4e0c0.appspot.com/o/avatars%2F$uid?alt=media",
                              )
                            : null,
                        child: !hasAvatar
                            ? Text(name[0].toUpperCase())
                            : null,
                      ),
                      title: Text(
                        name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    );
                  },
                );
              },
              error: (error, stack) =>
                  Center(child: Text("Error: $error")),
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
