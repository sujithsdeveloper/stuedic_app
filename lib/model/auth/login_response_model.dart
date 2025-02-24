// To parse this JSON data, do
//
//     final loginModel = loginModelFromJson(jsonString);

import 'dart:convert';

LoginModel loginModelFromJson(String str) => LoginModel.fromJson(json.decode(str));

String loginModelToJson(LoginModel data) => json.encode(data.toJson());

class LoginModel {
    int? respCode;
    String? message;
    String? token;
    String? refreshToken;

    LoginModel({
        this.respCode,
        this.message,
        this.token,
        this.refreshToken,
    });

    factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
        respCode: json["respCode"],
        message: json["message"],
        token: json["token"],
        refreshToken: json["refresh_token"],
    );

    Map<String, dynamic> toJson() => {
        "respCode": respCode,
        "message": message,
        "token": token,
        "refresh_token": refreshToken,
    };
}
