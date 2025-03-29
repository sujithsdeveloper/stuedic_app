// To parse this JSON data, do
//
//     final singlePostModel = singlePostModelFromJson(jsonString);

import 'dart:convert';

SinglePostModel singlePostModelFromJson(String str) => SinglePostModel.fromJson(json.decode(str));

String singlePostModelToJson(SinglePostModel data) => json.encode(data.toJson());

class SinglePostModel {
    int? respCode;
    String? message;
    Response? response;

    SinglePostModel({
        this.respCode,
        this.message,
        this.response,
    });

    factory SinglePostModel.fromJson(Map<String, dynamic> json) => SinglePostModel(
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
    DateTime? createdAt;
    String? userId;
    String? username;
    String? profilePicUrl;
    String? collageName;
    bool? isLiked;
    bool? isFollowed;
    bool? isBookmarked;
    String? shareableLink;
    String? timeAgo;

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
        this.createdAt,
        this.userId,
        this.username,
        this.profilePicUrl,
        this.collageName,
        this.isLiked,
        this.isFollowed,
        this.isBookmarked,
        this.shareableLink,
        this.timeAgo,
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
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        userId: json["userID"],
        username: json["username"],
        profilePicUrl: json["profilePicURL"],
        collageName: json["collageName"],
        isLiked: json["isLiked"],
        isFollowed: json["isFollowed"],
        isBookmarked: json["isBookmarked"],
        shareableLink: json["shareableLink"],
        timeAgo: json["timeAgo"],
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
        "createdAt": createdAt?.toIso8601String(),
        "userID": userId,
        "username": username,
        "profilePicURL": profilePicUrl,
        "collageName": collageName,
        "isLiked": isLiked,
        "isFollowed": isFollowed,
        "isBookmarked": isBookmarked,
        "shareableLink": shareableLink,
        "timeAgo": timeAgo,
    };
}
