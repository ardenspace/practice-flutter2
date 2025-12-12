import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/inbox/models/message_model.dart';

class MessagesRepo {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> sendMessage(MessageModel message) async {
    await _db
        .collection("chat_rooms")
        .doc("BDdp3viVw2fFeIp73Z1Vfs9dr8o1")
        .collection("texts")
        .add(message.toJson());
  }
}

final messagesRepo = Provider((ref) => MessagesRepo());
