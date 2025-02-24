// To parse this JSON data, do
//
//     final searchUserModel = searchUserModelFromJson(jsonString);

import 'dart:convert';

SearchUserModel searchUserModelFromJson(String str) => SearchUserModel.fromJson(json.decode(str));

String searchUserModelToJson(SearchUserModel data) => json.encode(data.toJson());

class SearchUserModel {
    int? respCode;
    String? message;
    Response? response;

    SearchUserModel({
        this.respCode,
        this.message,
        this.response,
    });

    factory SearchUserModel.fromJson(Map<String, dynamic> json) => SearchUserModel(
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
    List<User>? users;

    Response({
        this.users,
    });

    factory Response.fromJson(Map<String, dynamic> json) => Response(
        users: json["users"] == null ? [] : List<User>.from(json["users"]!.map((x) => User.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "users": users == null ? [] : List<dynamic>.from(users!.map((x) => x.toJson())),
    };
}

class User {
    String? username;
    String? userId;
    String? profilePicUrl;

    User({
        this.username,
        this.userId,
        this.profilePicUrl,
    });

    factory User.fromJson(Map<String, dynamic> json) => User(
        username: json["Username"],
        userId: json["UserID"],
        profilePicUrl: json["ProfilePicURL"],
    );

    Map<String, dynamic> toJson() => {
        "Username": username,
        "UserID": userId,
        "ProfilePicURL": profilePicUrl,
    };
}
