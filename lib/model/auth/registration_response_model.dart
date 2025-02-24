
import 'dart:convert';

RegistrationResponse registrationResponseFromJson(String str) => RegistrationResponse.fromJson(json.decode(str));

String registrationResponseToJson(RegistrationResponse data) => json.encode(data.toJson());

class RegistrationResponse {
    int? respCode;
    String? message;
    String? token;
    String? refreshToken;
    Response? response;

    RegistrationResponse({
        this.respCode,
        this.message,
        this.token,
        this.refreshToken,
        this.response,
    });

    factory RegistrationResponse.fromJson(Map<String, dynamic> json) => RegistrationResponse(
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
