// To parse this JSON data, do
//
//     final chatListUsersModel = chatListUsersModelFromJson(jsonString);

import 'dart:convert';

List<ChatListUsersModel> chatListUsersModelFromJson(String str) =>
    List<ChatListUsersModel>.from(json.decode(str).map((x) => ChatListUsersModel.fromJson(x)));

String chatListUsersModelToJson(List<ChatListUsersModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ChatListUsersModel {
  int? userId;
  String? lastMessage;
  DateTime? timestamp;
  String? username;
  String? profilePicUrl;

  ChatListUsersModel({
    this.userId,
    this.lastMessage,
    this.timestamp,
    this.username,
    this.profilePicUrl,
  });

  factory ChatListUsersModel.fromJson(Map<String, dynamic> json) => ChatListUsersModel(
        userId: json["userID"],
        lastMessage: json["lastMessage"],
        timestamp: json["timestamp"] == null ? null : DateTime.parse(json["timestamp"]),
        username: json["username"],
        profilePicUrl: json["profilePicURL"],
      );

  Map<String, dynamic> toJson() => {
        "userID": userId,
        "lastMessage": lastMessage,
        "timestamp": timestamp?.toIso8601String(),
        "username": username,
        "profilePicURL": profilePicUrl,
      };
}
