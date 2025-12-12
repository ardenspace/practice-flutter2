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

    ref.read(messagesProvider.notifier).sendMessage(text);
    _editingController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(messagesProvider).isLoading;
    final isDark = isDarkMode(context);
    return Scaffold(
      appBar: AppBar(
        title: ListTile(
          contentPadding: EdgeInsets.zero,
          horizontalTitleGap: Sizes.size8,
          leading: Stack(
            clipBehavior: Clip.none,
            children: [
              const CircleAvatar(
                radius: Sizes.size20,
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
          title: Text(
            "Yeon Koung ${widget.chatId}",
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
        ),
      ),
      body: Stack(
        children: [
          ref
              .watch(chatProvider)
              .when(
                data: (data) {
                  return ListView.separated(
                    padding: const EdgeInsets.symmetric(
                      vertical: Sizes.size10,
                      horizontal: Sizes.size14,
                    ),
                    itemBuilder: (context, index) {
                      final message = data[index];
                      final isMine =
                          message.userId ==
                          ref.watch(authRepo).user!.uid;
                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: isMine
                            ? MainAxisAlignment.end
                            : MainAxisAlignment.start,
                        children: [
                          Container(
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
                                bottomLeft: Radius.circular(
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
                        borderRadius: BorderRadius.circular(
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
        ],
      ),
    );
  }
}
