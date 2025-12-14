import * as admin from "firebase-admin";
import * as functions from "firebase-functions/v1";
import { onDocumentCreated } from "firebase-functions/v2/firestore";

admin.initializeApp();

export const onVideoCreated = onDocumentCreated(
  {
    document: "videos/{videoId}",
    region: "us-central1",
  },
  async (event) => {
    const snapshot = event.data;
    if (!snapshot) {
      return;
    }
    const spawn = require("child-process-promise").spawn;
    const video = snapshot.data();
    await spawn("ffmpeg", [
      "-i",
      video.fileUrl,
      "-ss",
      "00:00:01.000", // 1초대의 프레임
      "-vframes",
      "1",
      "-vf",
      "scale=150:-1", // 너비 150에 맞춰 낮추기
      `/tmp/${snapshot.id}.jpg`, // 임시 tmp 폴더에 저장
    ]);
    const storage = admin.storage();
    const [file, _] = await storage.bucket().upload(`/tmp/${snapshot.id}.jpg`, {
      destination: `thumbnails/${snapshot.id}.jpg`,
    });
    await file.makePublic();
    await snapshot.ref.update({
      thumbnailUrl: file.publicUrl(),
      likes: admin.firestore.FieldValue.increment(0), // likes 필드를 0으로 초기화
    });

    const db = admin.firestore();
    await db
      .collection("users")
      .doc(video.creatorUid)
      .collection("videos")
      .doc(snapshot.id)
      .set({
        thumbnailUrl: file.publicUrl(),
        videoId: snapshot.id,
      });
  }
);

export const onLikedCreated = functions.firestore
  .document("likes/{likeId}")
  .onCreate(async (snapshot, context) => {
    const db = admin.firestore();
    const [videoId, userId] = snapshot.id.split("000");

    // videoId가 유효한지 확인
    if (!videoId) {
      console.error("Invalid likeId format:", snapshot.id);
      return;
    }

    // 좋아요 수 증가
    await db
      .collection("videos")
      .doc(videoId)
      .update({
        likes: admin.firestore.FieldValue.increment(1),
      });

    const videoDoc = await db.collection("videos").doc(videoId).get();
    const video = videoDoc.data();

    if (!video) {
      console.error("Video not found:", videoId);
      return;
    }

    const creatorUid = video.creatorUid;

    // 자기 자신의 비디오에 좋아요를 누른 경우 알림을 보내지 않음
    if (userId === creatorUid) {
      return;
    }

    const userDoc = await db.collection("users").doc(creatorUid).get();
    const user = userDoc.data();

    if (!user) {
      console.error("User not found:", creatorUid);
      return;
    }

    const token = user.token;

    // token이 없거나 유효하지 않은 경우
    if (!token || typeof token !== "string") {
      console.warn("Invalid or missing token for user:", creatorUid);
      return;
    }

    try {
      // sendToDevice는 deprecated, send를 사용
      await admin.messaging().send({
        token: token,
        data: {
          screen: "video", // 또는 실제 비디오 화면으로 이동하는 route name
          videoId: videoId,
        },
        notification: {
          title: "Someone liked your video",
          body: "Likes + 1 ! Congrats ! 💓💓",
        },
      });
    } catch (error) {
      console.error("Error sending notification:", error);
    }
  });

export const onLikedRemoved = functions.firestore
  .document("likes/{likeId}")
  .onDelete(async (snapshot, context) => {
    const db = admin.firestore();
    const [videoId, _] = snapshot.id.split("000");
    const videoDoc = await db.collection("videos").doc(videoId).get();
    const currentLikes = videoDoc.data()?.likes ?? 0;

    // likes가 0보다 크면 -1, 아니면 0으로 유지
    if (currentLikes > 0) {
      await db
        .collection("videos")
        .doc(videoId)
        .update({
          likes: admin.firestore.FieldValue.increment(-1),
        });
    } else {
      // likes가 0이거나 없으면 0으로 설정
      await db.collection("videos").doc(videoId).update({
        likes: 0,
      });
    }
  });
