// To parse this JSON data, do
//
//     final discoverModel = discoverModelFromJson(jsonString);

import 'dart:convert';

DiscoverModel discoverModelFromJson(String str) => DiscoverModel.fromJson(json.decode(str));

String discoverModelToJson(DiscoverModel data) => json.encode(data.toJson());

class DiscoverModel {
    int? respCode;
    String? message;
    List<Response>? response;

    DiscoverModel({
        this.respCode,
        this.message,
        this.response,
    });

    factory DiscoverModel.fromJson(Map<String, dynamic> json) => DiscoverModel(
        respCode: json["respCode"],
        message: json["message"],
        response: json["response"] == null ? [] : List<Response>.from(json["response"]!.map((x) => Response.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "respCode": respCode,
        "message": message,
        "response": response == null ? [] : List<dynamic>.from(response!.map((x) => x.toJson())),
    };
}

class Response {
    String? postId;
    String? postContentUrl;
    String? authorName;
    String? authorPicUrl;
    int? likesCount;
    String? timeAgo;

    Response({
        this.postId,
        this.postContentUrl,
        this.authorName,
        this.authorPicUrl,
        this.likesCount,
        this.timeAgo,
    });

    factory Response.fromJson(Map<String, dynamic> json) => Response(
        postId: json["postID"],
        postContentUrl: json["postContentURL"],
        authorName: json["authorName"],
        authorPicUrl: json["authorPicURL"],
        likesCount: json["likesCount"],
        timeAgo: json["timeAgo"],
    );

    Map<String, dynamic> toJson() => {
        "postID": postId,
        "postContentURL": postContentUrl,
        "authorName": authorName,
        "authorPicURL": authorPicUrl,
        "likesCount": likesCount,
        "timeAgo": timeAgo,
    };
}
