// To parse this JSON data, do
//
//     final chatHistoryModel = chatHistoryModelFromJson(jsonString);

import 'dart:convert';

List<ChatHistoryModel> chatHistoryModelFromJson(String str) =>
    List<ChatHistoryModel>.from(json.decode(str).map((x) => ChatHistoryModel.fromJson(x)));

String chatHistoryModelToJson(List<ChatHistoryModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ChatHistoryModel {
  String? id;
  int? fromUserId;
  int? toUserId;
  String? content;
  DateTime? timestamp;
  bool? read;
  int? currentUser;

  ChatHistoryModel({
    this.id,
    this.fromUserId,
    this.toUserId,
    this.content,
    this.timestamp,
    this.read,
    this.currentUser,
  });

  factory ChatHistoryModel.fromJson(Map<String, dynamic> json) => ChatHistoryModel(
        id: json["id"],
        fromUserId: json["fromUserID"],
        toUserId: json["toUserID"],
        content: json["content"].toString(),
        timestamp: json["timestamp"] == null ? null : DateTime.parse(json["timestamp"]),
        read: json["read"],
        currentUser: json["currentUser"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "fromUserID": fromUserId,
        "toUserID": toUserId,
        "content": content,
        "timestamp": timestamp?.toIso8601String(),
        "read": read,
        "currentUser": currentUser,
      };
}
