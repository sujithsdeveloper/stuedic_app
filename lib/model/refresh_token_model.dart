// To parse this JSON data, do
//
//     final refreshTokenModel = refreshTokenModelFromJson(jsonString);

import 'dart:convert';

RefreshTokenModel refreshTokenModelFromJson(String str) => RefreshTokenModel.fromJson(json.decode(str));

String refreshTokenModelToJson(RefreshTokenModel data) => json.encode(data.toJson());

class RefreshTokenModel {
    String? respCode;
    String? message;
    String? token;
    String? refreshToken;

    RefreshTokenModel({
        this.respCode,
        this.message,
        this.token,
        this.refreshToken,
    });

    factory RefreshTokenModel.fromJson(Map<String, dynamic> json) => RefreshTokenModel(
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
