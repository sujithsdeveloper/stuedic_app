// To parse this JSON data, do
//
//     final registrationModel = registrationModelFromJson(jsonString);

import 'dart:convert';

RegistrationModel registrationModelFromJson(String str) => RegistrationModel.fromJson(json.decode(str));

String registrationModelToJson(RegistrationModel data) => json.encode(data.toJson());

class RegistrationModel {
    int? respCode;
    String? message;
    String? token;
    String? refreshToken;
    Response? response;

    RegistrationModel({
        this.respCode,
        this.message,
        this.token,
        this.refreshToken,
        this.response,
    });

    factory RegistrationModel.fromJson(Map<String, dynamic> json) => RegistrationModel(
        respCode: json["respCode"],
        message: json["message"],
        token: json["token"],
        refreshToken: json["refresh_token"],
        response: json["response"] == null ? null : Response.fromJson(json["response"]),
    );

    Map<String, dynamic> toJson() => {
        "respCode": respCode,
        "message": message,
        "token": token,
        "refresh_token": refreshToken,
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

    Response({
        this.userId,
        this.userName,
        this.email,
        this.isVerified,
        this.role,
        this.phone,
        this.collageName,
    });

    factory Response.fromJson(Map<String, dynamic> json) => Response(
        userId: json["userID"],
        userName: json["userName"],
        email: json["email"],
        isVerified: json["isVerified"],
        role: json["role"],
        phone: json["phone"],
        collageName: json["collageName"],
    );

    Map<String, dynamic> toJson() => {
        "userID": userId,
        "userName": userName,
        "email": email,
        "isVerified": isVerified,
        "role": role,
        "phone": phone,
        "collageName": collageName,
    };
}
