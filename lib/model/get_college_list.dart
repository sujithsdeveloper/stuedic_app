// To parse this JSON data, do
//
//     final getCollegeListModel = getCollegeListModelFromJson(jsonString);

import 'dart:convert';

GetCollegeListModel getCollegeListModelFromJson(String str) => GetCollegeListModel.fromJson(json.decode(str));

String getCollegeListModelToJson(GetCollegeListModel data) => json.encode(data.toJson());

class GetCollegeListModel {
    int? respCode;
    String? message;
    List<Response>? response;

    GetCollegeListModel({
        this.respCode,
        this.message,
        this.response,
    });

    factory GetCollegeListModel.fromJson(Map<String, dynamic> json) => GetCollegeListModel(
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
    String? collageId;
    String? collageName;

    Response({
        this.collageId,
        this.collageName,
    });

    factory Response.fromJson(Map<String, dynamic> json) => Response(
        collageId: json["collageID"],
        collageName: json["collageName"],
    );

    Map<String, dynamic> toJson() => {
        "collageID": collageId,
        "collageName": collageName,
    };
}
