// To parse this JSON data, do
//
//     final userGridModel = userGridModelFromJson(jsonString);

import 'dart:convert';

UserGridModel userGridModelFromJson(String str) => UserGridModel.fromJson(json.decode(str));

String userGridModelToJson(UserGridModel data) => json.encode(data.toJson());

class UserGridModel {
    int? respCode;
    String? message;
    Response? response;

    UserGridModel({
        this.respCode,
        this.message,
        this.response,
    });

    factory UserGridModel.fromJson(Map<String, dynamic> json) => UserGridModel(
        respCode: json["respCode"],
        message: json["message"],
        response: json["response"] == null ? null : Response.fromJson(json["response"]),
    );

    Map<String, dynamic> toJson() => {
        "respCode": respCode,
        "message": message,
        "response": response?.toJson(),
    };
}

class Response {
    List<Post>? posts;

    Response({
        this.posts,
    });

    factory Response.fromJson(Map<String, dynamic> json) => Response(
        posts: json["posts"] == null ? [] : List<Post>.from(json["posts"]!.map((x) => Post.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "posts": posts == null ? [] : List<dynamic>.from(posts!.map((x) => x.toJson())),
    };
}

class Post {
    String? postId;
    String? postContentUrl;

    Post({
        this.postId,
        this.postContentUrl,
    });

    factory Post.fromJson(Map<String, dynamic> json) => Post(
        postId: json["postID"],
        postContentUrl: json["postContentURL"],
    );

    Map<String, dynamic> toJson() => {
        "postID": postId,
        "postContentURL": postContentUrl,
    };
}
