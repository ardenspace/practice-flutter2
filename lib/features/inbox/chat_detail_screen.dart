import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/inbox/view_models/messages_view_model.dart';
import 'package:tiktok_clone/features/repos/authentication_repos.dart';
import 'package:tiktok_clone/utils.dart';

class ChatDetailScreen extends ConsumerStatefulWidget {
  static const String routeName = "chatDetail";
  static const String routeURL = ":chatId";
  final String chatId;
  const ChatDetailScreen({super.key, required this.chatId});

  @override
  ConsumerState<ChatDetailScreen> createState() =>
      _ChatDetailScreenState();
}

class _ChatDetailScreenState
    extends ConsumerState<ChatDetailScreen> {
  final TextEditingController _editingController =
      TextEditingController();

  void _onSendPressed() {
    final text = _editingController.text;

    if (text == "") return;

    ref
        .read(messagesProvider.notifier)
        .sendMessage(text, widget.chatId);
    _editingController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(messagesProvider).isLoading;
    final isDark = isDarkMode(context);
    final chatRoomInfoAsync = ref.watch(
      chatRoomInfoProvider(widget.chatId),
    );

    return Scaffold(
      appBar: AppBar(
        title: chatRoomInfoAsync.when(
          data: (chatRoomInfo) {
            if (chatRoomInfo == null) {
              return ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  widget.chatId,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              );
            }

            final otherUser =
                chatRoomInfo["otherUser"]
                    as Map<String, dynamic>;
            final otherUserName =
                otherUser["name"] as String? ?? "Unknown";
            final hasAvatar =
                otherUser["hasAvatar"] == true;
            final otherUserId = otherUser["uid"] as String;

            return ListTile(
              contentPadding: EdgeInsets.zero,
              horizontalTitleGap: Sizes.size8,
              leading: Stack(
                clipBehavior: Clip.none,
                children: [
                  CircleAvatar(
                    radius: Sizes.size20,
                    foregroundImage: hasAvatar
                        ? NetworkImage(
                            "https://firebasestorage.googleapis.com/v0/b/tiktok-clone-4e0c0.appspot.com/o/avatars%2F$otherUserId?alt=media",
                          )
                        : null,
                    child: !hasAvatar
                        ? Text(
                            otherUserName[0].toUpperCase(),
                          )
                        : null,
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
              title: Text(
                otherUserName,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                ),
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
            );
          },
          error: (error, stack) => ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(
              widget.chatId,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          loading: () => ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(
              widget.chatId,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          ref
              .watch(chatProvider(widget.chatId))
              .when(
                data: (data) {
                  return ListView.separated(
                    reverse: true,
                    padding: EdgeInsets.only(
                      top: Sizes.size10,
                      bottom:
                          MediaQuery.of(
                            context,
                          ).padding.bottom +
                          Sizes.size20 *
                              2 + // Container vertical padding
                          Sizes
                              .size56 + // TextField approximate height
                          Sizes.size10, // Extra spacing
                      left: Sizes.size14,
                      right: Sizes.size14,
                    ),
                    itemBuilder: (context, index) {
                      final message = data[index];
                      final isMine =
                          message.userId ==
                          ref.watch(authRepo).user!.uid;

                      // 5분 이내인지 확인
                      final messageTime =
                          DateTime.fromMillisecondsSinceEpoch(
                            message.createdAt,
                          );
                      final now = DateTime.now();
                      final canDelete =
                          isMine &&
                          message.id != null &&
                          now
                                  .difference(messageTime)
                                  .inMinutes <
                              5;

                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: isMine
                            ? MainAxisAlignment.end
                            : MainAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onLongPress: canDelete
                                ? () {
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: const Text(
                                          "Delete message",
                                        ),
                                        content: const Text(
                                          "Are you sure you want to delete this message?",
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.of(
                                                  context,
                                                ).pop(),
                                            child:
                                                const Text(
                                                  "Cancel",
                                                ),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(
                                                context,
                                              ).pop();
                                              ref
                                                  .read(
                                                    messagesProvider
                                                        .notifier,
                                                  )
                                                  .deleteMessage(
                                                    widget
                                                        .chatId,
                                                    message
                                                        .id!,
                                                  );
                                            },
                                            style: TextButton.styleFrom(
                                              foregroundColor:
                                                  Colors
                                                      .red,
                                            ),
                                            child:
                                                const Text(
                                                  "Delete",
                                                ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }
                                : null,
                            child: Container(
                              padding: const EdgeInsets.all(
                                Sizes.size10,
                              ),
                              decoration: BoxDecoration(
                                color: isMine
                                    ? Colors.blue
                                    : Theme.of(
                                        context,
                                      ).primaryColor,
                                borderRadius: BorderRadius.only(
                                  topLeft:
                                      const Radius.circular(
                                        Sizes.size20,
                                      ),
                                  topRight:
                                      const Radius.circular(
                                        Sizes.size20,
                                      ),
                                  bottomLeft:
                                      Radius.circular(
                                        isMine
                                            ? Sizes.size20
                                            : Sizes.size5,
                                      ),
                                  bottomRight:
                                      Radius.circular(
                                        isMine
                                            ? Sizes.size5
                                            : Sizes.size20,
                                      ),
                                ),
                              ),
                              child: Text(
                                message.text,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: Sizes.size16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                    separatorBuilder: (context, index) =>
                        Gaps.v10,
                    itemCount: data.length,
                  );
                },
                error: (error, stackTrace) =>
                    Center(child: Text(error.toString())),
                loading: () => const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
          Positioned(
            bottom: 0,
            width: MediaQuery.of(context).size.width,
            child: SafeArea(
              child: Container(
                color: isDark
                    ? Colors.black
                    : Colors.grey.shade50,
                padding: const EdgeInsets.symmetric(
                  horizontal: Sizes.size14,
                  vertical: Sizes.size20,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _editingController,
                        decoration: InputDecoration(
                          contentPadding:
                              const EdgeInsets.only(
                                left: Sizes.size16,
                              ),
                          hintText: "Send a message...",
                          hintStyle: TextStyle(
                            color: Colors.grey.shade500,
                          ),
                          suffixIcon: const Padding(
                            padding: EdgeInsets.all(
                              Sizes.size16,
                            ),
                            child: FaIcon(
                              FontAwesomeIcons.faceSmile,
                              color: Colors.black,
                              size: Sizes.size24,
                            ),
                          ),
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(Sizes.size20),
                            ),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: isDark
                              ? Colors.grey.shade800
                              : Colors.white,
                        ),
                      ),
                    ),
                    Gaps.h10,
                    ElevatedButton(
                      onPressed: isLoading
                          ? null
                          : _onSendPressed,
                      child: Container(
                        padding: const EdgeInsets.all(
                          Sizes.size12,
                        ),
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(
                                Sizes.size48,
                              ),
                          color: isDark
                              ? Colors.grey.shade500
                              : Colors.grey.shade300,
                        ),
                        child: FaIcon(
                          isLoading
                              ? FontAwesomeIcons.hourglass
                              : FontAwesomeIcons
                                    .solidPaperPlane,
                          color: isDark
                              ? Colors.black
                              : Colors.white,
                          size: Sizes.size20,
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
    );
  }
}
