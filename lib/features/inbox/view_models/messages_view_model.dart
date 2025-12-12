import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/inbox/models/message_model.dart';
import 'package:tiktok_clone/features/inbox/repos/messages_repo.dart';
import 'package:tiktok_clone/features/repos/authentication_repos.dart';

class MessagesViewModel extends AsyncNotifier<void> {
  late final MessagesRepo _repo;

  @override
  FutureOr<void> build() {
    _repo = ref.read(messagesRepo);
  }

  Future<void> sendMessage(
    String text,
    String chatId,
  ) async {
    final user = ref.read(authRepo).user;
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final message = MessageModel(
        text: text,
        userId: user!.uid,
        createdAt: DateTime.now().millisecondsSinceEpoch,
      );
      await _repo.sendMessage(message, chatId);
    });
  }

  Future<void> deleteMessage(
    String chatId,
    String messageId,
  ) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _repo.deleteMessage(chatId, messageId);
    });
  }
}

final messagesProvider =
    AsyncNotifierProvider<MessagesViewModel, void>(
      () => MessagesViewModel(),
    );

final chatProvider = StreamProvider.autoDispose
    .family<List<MessageModel>, String>((ref, chatRoomId) {
      final db = FirebaseFirestore.instance;
      return db
          .collection("chat_rooms")
          .doc(chatRoomId)
          .collection("texts")
          .orderBy("createdAt")
          .snapshots()
          .map(
            (event) => event.docs
                .map(
                  (doc) => MessageModel.fromJson(
                    doc.data(),
                    doc.id,
                  ),
                )
                .toList()
                .reversed
                .toList(),
          );
    });

final chatRoomsProvider =
    StreamProvider.autoDispose<List<String>>((ref) {
      final user = ref.watch(authRepo).user;
      if (user == null) return Stream.value([]);

      final repo = ref.read(messagesRepo);
      return repo.getChatRooms(user.uid);
    });

final usersProvider =
    StreamProvider.autoDispose<List<Map<String, dynamic>>>((
      ref,
    ) {
      final db = FirebaseFirestore.instance;
      final currentUserId = ref.watch(authRepo).user?.uid;
      if (currentUserId == null) return Stream.value([]);

      return db
          .collection("users")
          .snapshots()
          .map(
            (snapshot) => snapshot.docs
                .where((doc) => doc.id != currentUserId)
                .map((doc) {
                  final data = doc.data();
                  data["uid"] = doc.id;
                  return data;
                })
                .toList(),
          );
    });

final chatRoomInfoProvider = StreamProvider.autoDispose
    .family<Map<String, dynamic>?, String>((ref, chatId) {
      final db = FirebaseFirestore.instance;
      final currentUserId = ref.watch(authRepo).user?.uid;
      if (currentUserId == null) return Stream.value(null);

      return db
          .collection("chat_rooms")
          .doc(chatId)
          .snapshots()
          .asyncMap((chatRoomDoc) async {
            if (!chatRoomDoc.exists) return null;

            final chatRoomData = chatRoomDoc.data()!;
            final participants = List<String>.from(
              chatRoomData["participants"] ?? [],
            );
            final otherUserId = participants.firstWhere(
              (id) => id != currentUserId,
            );

            // 상대방 정보 가져오기
            final userDoc = await db
                .collection("users")
                .doc(otherUserId)
                .get();
            final otherUserData = userDoc.data();
            if (otherUserData == null) return null;

            // 마지막 메시지 가져오기
            final lastMessageQuery = await db
                .collection("chat_rooms")
                .doc(chatId)
                .collection("texts")
                .orderBy("createdAt", descending: true)
                .limit(1)
                .get();

            String? lastMessage;
            int? lastMessageTime;
            if (lastMessageQuery.docs.isNotEmpty) {
              final lastMessageData = lastMessageQuery
                  .docs
                  .first
                  .data();
              lastMessage = lastMessageData["text"];
              lastMessageTime =
                  lastMessageData["createdAt"];
            }

            return {
              "chatId": chatId,
              "otherUser": {
                "uid": otherUserId,
                "name": otherUserData["name"],
                "hasAvatar":
                    otherUserData["hasAvatar"] ?? false,
              },
              "lastMessage": lastMessage,
              "lastMessageTime": lastMessageTime,
            };
          });
    });
