// To parse this JSON data, do
//
//     final getNotification = getNotificationFromJson(jsonString);

import 'dart:convert';

GetNotification getNotificationFromJson(String str) => GetNotification.fromJson(json.decode(str));

String getNotificationToJson(GetNotification data) => json.encode(data.toJson());

class GetNotification {
    int? respCode;
    String? message;
    List<Response>? response;

    GetNotification({
        this.respCode,
        this.message,
        this.response,
    });

    factory GetNotification.fromJson(Map<String, dynamic> json) => GetNotification(
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
    String? notificationId;
    String? postId;
    int? userId;
    int? fromUserId;
    String? type;
    bool? read;
    DateTime? created;
    String? fromUserName;
    String? fromUserPicUrl;
    String? postContentUrl;

    Response({
        this.notificationId,
        this.postId,
        this.userId,
        this.fromUserId,
        this.type,
        this.read,
        this.created,
        this.fromUserName,
        this.fromUserPicUrl,
        this.postContentUrl,
    });

    factory Response.fromJson(Map<String, dynamic> json) => Response(
        notificationId: json["notificationID"],
        postId: json["postID"],
        userId: json["userID"],
        fromUserId: json["fromUserID"],
        type: json["type"],
        read: json["read"],
        created: json["created"] == null ? null : DateTime.parse(json["created"]),
        fromUserName: json["fromUserName"],
        fromUserPicUrl: json["fromUserPicURL"],
        postContentUrl: json["postContentUrl"],
    );

    Map<String, dynamic> toJson() => {
        "notificationID": notificationId,
        "postID": postId,
        "userID": userId,
        "fromUserID": fromUserId,
        "type": type,
        "read": read,
        "created": created?.toIso8601String(),
        "fromUserName": fromUserName,
        "fromUserPicURL": fromUserPicUrl,
        "postContentUrl": postContentUrl,
    };
}
