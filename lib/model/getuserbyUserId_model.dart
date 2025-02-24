// To parse this JSON data, do
//
//     final getUserByUserIdModel = getUserByUserIdModelFromJson(jsonString);

import 'dart:convert';

GetUserByUserIdModel getUserByUserIdModelFromJson(String str) => GetUserByUserIdModel.fromJson(json.decode(str));

String getUserByUserIdModelToJson(GetUserByUserIdModel data) => json.encode(data.toJson());

class GetUserByUserIdModel {
    int? respCode;
    String? message;
    Response? response;

    GetUserByUserIdModel({
        this.respCode,
        this.message,
        this.response,
    });

    factory GetUserByUserIdModel.fromJson(Map<String, dynamic> json) => GetUserByUserIdModel(
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
    String? userId;
    String? userName;
    String? email;
    bool? isVerified;
    String? role;
    String? phone;
    String? collageName;
    int? followersCount;
    int? followingCount;
    String? profilePicUrl;
    int? collageStrength;
    String? staffDesignation;
    bool? isPublic;
    bool? isCurrentUser;
    bool? isStudent;
    bool? isFollowed;

    Response({
        this.userId,
        this.userName,
        this.email,
        this.isVerified,
        this.role,
        this.phone,
        this.collageName,
        this.followersCount,
        this.followingCount,
        this.profilePicUrl,
        this.collageStrength,
        this.staffDesignation,
        this.isPublic,
        this.isCurrentUser,
        this.isStudent,
        this.isFollowed,
    });

    factory Response.fromJson(Map<String, dynamic> json) => Response(
        userId: json["userID"],
        userName: json["userName"],
        email: json["email"],
        isVerified: json["isVerified"],
        role: json["role"],
        phone: json["phone"],
        collageName: json["collageName"],
        followersCount: json["followersCount"],
        followingCount: json["followingCount"],
        profilePicUrl: json["profilePicURL"],
        collageStrength: json["collageStrength"],
        staffDesignation: json["staffDesignation"],
        isPublic: json["isPublic"],
        isCurrentUser: json["isCurrentUser"],
        isStudent: json["isStudent"],
        isFollowed: json["isFollowed"],
    );

    Map<String, dynamic> toJson() => {
        "userID": userId,
        "userName": userName,
        "email": email,
        "isVerified": isVerified,
        "role": role,
        "phone": phone,
        "collageName": collageName,
        "followersCount": followersCount,
        "followingCount": followingCount,
        "profilePicURL": profilePicUrl,
        "collageStrength": collageStrength,
        "staffDesignation": staffDesignation,
        "isPublic": isPublic,
        "isCurrentUser": isCurrentUser,
        "isStudent": isStudent,
        "isFollowed": isFollowed,
    };
}
