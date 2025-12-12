import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/inbox/models/message_model.dart';

class MessagesRepo {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> sendMessage(
    MessageModel message,
    String chatId,
  ) async {
    await _db
        .collection("chat_rooms")
        .doc(chatId)
        .collection("texts")
        .add(message.toJson());
  }

  Future<String> createChatRoom(
    String userId1,
    String userId2,
  ) async {
    // 두 사용자 ID를 정렬하여 일관된 chatId 생성
    final participants = [userId1, userId2]..sort();
    final chatId = "${participants[0]}_${participants[1]}";

    // chat_room이 없으면 생성
    final chatRoomRef = _db
        .collection("chat_rooms")
        .doc(chatId);
    final chatRoomDoc = await chatRoomRef.get();

    if (!chatRoomDoc.exists) {
      await chatRoomRef.set({
        "participants": participants,
        "createdAt": DateTime.now().millisecondsSinceEpoch,
      });
    }

    return chatId;
  }

  Stream<List<String>> getChatRooms(String userId) {
    return _db
        .collection("chat_rooms")
        .where("participants", arrayContains: userId)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => doc.id).toList(),
        );
  }

  Future<void> deleteMessage(
    String chatId,
    String messageId,
  ) async {
    await _db
        .collection("chat_rooms")
        .doc(chatId)
        .collection("texts")
        .doc(messageId)
        .delete();
  }
}

final messagesRepo = Provider((ref) => MessagesRepo());
