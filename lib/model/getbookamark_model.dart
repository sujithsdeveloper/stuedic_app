// To parse this JSON data, do
//
//     final getBookamark = getBookamarkFromJson(jsonString);

import 'dart:convert';

GetBookamark getBookamarkFromJson(String str) => GetBookamark.fromJson(json.decode(str));

String getBookamarkToJson(GetBookamark data) => json.encode(data.toJson());

class GetBookamark {
    int? respCode;
    String? message;
    Response? response;

    GetBookamark({
        this.respCode,
        this.message,
        this.response,
    });

    factory GetBookamark.fromJson(Map<String, dynamic> json) => GetBookamark(
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
    List<Bookmark>? bookmarks;

    Response({
        this.bookmarks,
    });

    factory Response.fromJson(Map<String, dynamic> json) => Response(
        bookmarks: json["bookmarks"] == null ? [] : List<Bookmark>.from(json["bookmarks"]!.map((x) => Bookmark.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "bookmarks": bookmarks == null ? [] : List<dynamic>.from(bookmarks!.map((x) => x.toJson())),
    };
}

class Bookmark {
    String? postId;
    String? postContentUrl;

    Bookmark({
        this.postId,
        this.postContentUrl,
    });

    factory Bookmark.fromJson(Map<String, dynamic> json) => Bookmark(
        postId: json["postID"],
        postContentUrl: json["postContentURL"],
    );

    Map<String, dynamic> toJson() => {
        "postID": postId,
        "postContentURL": postContentUrl,
    };
}
