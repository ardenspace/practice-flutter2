import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/videos/models/video_model.dart';

class VideoRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  UploadTask uploadVideoFile(File video, String uid) {
    final fileRef = _storage.ref().child(
      "/videos/$uid/${DateTime.now().millisecondsSinceEpoch.toString()}",
    );

    return fileRef.putFile(video);
  }

  Future<void> saveVideo(VideoModel data) async {
    await _db.collection("videos").add(data.toJson());
  }

  Future<bool> likeVideo(
    String videoId,
    String userId,
  ) async {
    final query = _db
        .collection("likes")
        .doc("${videoId}000$userId");
    final like = await query.get();

    if (!like.exists) {
      await query.set({
        "createdAt": DateTime.now().millisecondsSinceEpoch,
      });
      return true; // 좋아요 추가됨
    } else {
      await query.delete();
      return false; // 좋아요 취소됨
    }
  }

  Future<bool> isLiked(
    String videoId,
    String userId,
  ) async {
    final like = await _db
        .collection("likes")
        .doc("${videoId}000$userId")
        .get();
    return like.exists;
  }

  Stream<int> watchVideoLikes(String videoId) {
    return _db
        .collection("videos")
        .doc(videoId)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.data()?["likes"] as int? ?? 0,
        );
  }

  Future<QuerySnapshot<Map<String, dynamic>>> fetchVideos({
    int? lastItemCreatedAt,
  }) {
    final query = _db
        .collection("videos")
        .orderBy("createdAt", descending: true)
        .limit(2);
    if (lastItemCreatedAt == null) {
      return query.get();
    } else {
      return query.startAfter([lastItemCreatedAt]).get();
    }
  }
}

final videoRepo = Provider((ref) => VideoRepository());
