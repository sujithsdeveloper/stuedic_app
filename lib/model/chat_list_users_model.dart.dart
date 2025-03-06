// To parse this JSON data, do
//
//     final chatListModel = chatListModelFromJson(jsonString);

import 'dart:convert';

List<ChatListModel> chatListModelFromJson(String str) => List<ChatListModel>.from(json.decode(str).map((x) => ChatListModel.fromJson(x)));

String chatListModelToJson(List<ChatListModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ChatListModel {
    int? userId;
    String? lastMessage;
    DateTime? timestamp;
    String? username;
    String? profilePicUrl;

    ChatListModel({
        this.userId,
        this.lastMessage,
        this.timestamp,
        this.username,
        this.profilePicUrl,
    });

    factory ChatListModel.fromJson(Map<String, dynamic> json) => ChatListModel(
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
