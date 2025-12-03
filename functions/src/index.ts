import * as admin from "firebase-admin";
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
    await snapshot.ref.update({ thumbnailUrl: file.publicUrl() });

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
