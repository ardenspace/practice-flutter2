class MessageModel {
  final String? id;
  final String text;
  final String userId;
  final int createdAt;

  MessageModel({
    this.id,
    required this.text,
    required this.userId,
    required this.createdAt,
  });
  MessageModel.fromJson(
    Map<String, dynamic> json,
    String? docId,
  ) : id = docId,
      text = json["text"],
      userId = json["userId"],
      createdAt = json["createdAt"];

  Map<String, dynamic> toJson() {
    return {
      "text": text,
      "userId": userId,
      "createdAt": createdAt,
    };
  }
}
