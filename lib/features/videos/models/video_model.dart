class VideoModel {
  final String title;
  final String? description;
  final String fileUrl;
  final String? thumbnailUrl;
  final String creatorUid;
  final String creator;
  final int? likes;
  final int? comments;
  final int? createdAt;

  VideoModel({
    required this.title,
    required this.fileUrl,
    required this.creatorUid,
    required this.description,
    required this.thumbnailUrl,
    required this.likes,
    required this.comments,
    required this.createdAt,
    required this.creator,
  });

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "description": description,
      "fileUrl": fileUrl,
      "thumbnailUrl": thumbnailUrl,
      "creatorUid": creatorUid,
      "creator": creator,
      "likes": likes,
      "comments": comments,
      "createdAt": createdAt,
    };
  }
}
