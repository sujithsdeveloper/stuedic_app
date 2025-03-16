// To parse this JSON data, do
//
//     final getShortsModel = getShortsModelFromJson(jsonString);

import 'dart:convert';

GetShortsModel getShortsModelFromJson(String str) => GetShortsModel.fromJson(json.decode(str));

String getShortsModelToJson(GetShortsModel data) => json.encode(data.toJson());

class GetShortsModel {
    int? respCode;
    String? message;
    List<Response>? response;

    GetShortsModel({
        this.respCode,
        this.message,
        this.response,
    });

    factory GetShortsModel.fromJson(Map<String, dynamic> json) => GetShortsModel(
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
    String? postContentUrl;
    String? postDescription;
    String? postType;
    String? postVisibility;
    String? postStatus;
    int? likescount;
    int? authorid;
    String? postId;
    String? collagename;
    int? commentsCount;
    String? postColor;
    String? userId;
    String? username;
    String? profilePicUrl;
    String? collageName;
    bool? isLiked;
    bool? isFollowed;
    String? shareableLink;

    Response({
        this.postContentUrl,
        this.postDescription,
        this.postType,
        this.postVisibility,
        this.postStatus,
        this.likescount,
        this.authorid,
        this.postId,
        this.collagename,
        this.commentsCount,
        this.postColor,
        this.userId,
        this.username,
        this.profilePicUrl,
        this.collageName,
        this.isLiked,
        this.isFollowed,
        this.shareableLink,
    });

    factory Response.fromJson(Map<String, dynamic> json) => Response(
        postContentUrl: json["postContentURL"],
        postDescription: json["postDescription"],
        postType: json["postType"],
        postVisibility: json["postVisibility"],
        postStatus: json["postStatus"],
        likescount: json["likescount"],
        authorid: json["authorid"],
        postId: json["postID"],
        collagename: json["collagename"],
        commentsCount: json["commentsCount"],
        postColor: json["postColor"],
        userId: json["userID"],
        username: json["username"],
        profilePicUrl: json["profilePicURL"],
        collageName: json["collageName"],
        isLiked: json["isLiked"],
        isFollowed: json["isFollowed"],
        shareableLink: json["shareableLink"],
    );

    Map<String, dynamic> toJson() => {
        "postContentURL": postContentUrl,
        "postDescription": postDescription,
        "postType": postType,
        "postVisibility": postVisibility,
        "postStatus": postStatus,
        "likescount": likescount,
        "authorid": authorid,
        "postID": postId,
        "collagename": collagename,
        "commentsCount": commentsCount,
        "postColor": postColor,
        "userID": userId,
        "username": username,
        "profilePicURL": profilePicUrl,
        "collageName": collageName,
        "isLiked": isLiked,
        "isFollowed": isFollowed,
        "shareableLink": shareableLink,
    };
}
