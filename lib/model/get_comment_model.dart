// To parse this JSON data, do
//
//     final getCommentsModel = getCommentsModelFromJson(jsonString);

import 'dart:convert';

GetCommentsModel getCommentsModelFromJson(String str) => GetCommentsModel.fromJson(json.decode(str));

String getCommentsModelToJson(GetCommentsModel data) => json.encode(data.toJson());

class GetCommentsModel {
    List<Comment>? comments;
    String? message;
    int? respCode;

    GetCommentsModel({
        this.comments,
        this.message,
        this.respCode,
    });

    factory GetCommentsModel.fromJson(Map<String, dynamic> json) => GetCommentsModel(
        comments: json["comments"] == null ? [] : List<Comment>.from(json["comments"]!.map((x) => Comment.fromJson(x))),
        message: json["message"],
        respCode: json["respCode"],
    );

    Map<String, dynamic> toJson() => {
        "comments": comments == null ? [] : List<dynamic>.from(comments!.map((x) => x.toJson())),
        "message": message,
        "respCode": respCode,
    };
}

class Comment {
    String? userId;
    String? username;
    String? profilePicUrl;
    String? content;
    String? createdAt;

    Comment({
        this.userId,
        this.username,
        this.profilePicUrl,
        this.content,
        this.createdAt,
    });

    factory Comment.fromJson(Map<String, dynamic> json) => Comment(
        userId: json["userID"],
        username: json["username"],
        profilePicUrl: json["profilePicURL"],
        content: json["content"],
        createdAt: json["createdAt"],
    );

    Map<String, dynamic> toJson() => {
        "userID": userId,
        "username": username,
        "profilePicURL": profilePicUrl,
        "content": content,
        "createdAt": createdAt,
    };
}
