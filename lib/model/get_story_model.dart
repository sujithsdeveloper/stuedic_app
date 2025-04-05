// To parse this JSON data, do
//
//     final getStoriesModel = getStoriesModelFromJson(jsonString);

import 'dart:convert';

GetStoriesModel getStoriesModelFromJson(String str) => GetStoriesModel.fromJson(json.decode(str));

String getStoriesModelToJson(GetStoriesModel data) => json.encode(data.toJson());

class GetStoriesModel {
    int? respCode;
    String? message;
    Response? response;

    GetStoriesModel({
        this.respCode,
        this.message,
        this.response,
    });

    factory GetStoriesModel.fromJson(Map<String, dynamic> json) => GetStoriesModel(
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
    List<GroupedStory>? groupedStories;

    Response({
        this.groupedStories,
    });

    factory Response.fromJson(Map<String, dynamic> json) => Response(
        groupedStories: json["groupedStories"] == null ? [] : List<GroupedStory>.from(json["groupedStories"]!.map((x) => GroupedStory.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "groupedStories": groupedStories == null ? [] : List<dynamic>.from(groupedStories!.map((x) => x.toJson())),
    };
}

class GroupedStory {
    int? authorId;
    List<Story>? stories;
    bool? isCurrentUser;

    GroupedStory({
        this.authorId,
        this.stories,
        this.isCurrentUser,
    });

    factory GroupedStory.fromJson(Map<String, dynamic> json) => GroupedStory(
        authorId: json["authorId"],
        stories: json["stories"] == null ? [] : List<Story>.from(json["stories"]!.map((x) => Story.fromJson(x))),
        isCurrentUser: json["isCurrentUser"],
    );

    Map<String, dynamic> toJson() => {
        "authorId": authorId,
        "stories": stories == null ? [] : List<dynamic>.from(stories!.map((x) => x.toJson())),
        "isCurrentUser": isCurrentUser,
    };
}

class Story {
    String? contentUrl;
    String? caption;
    int? authorId;
    dynamic viewers;
    int? expiresAt;

    Story({
        this.contentUrl,
        this.caption,
        this.authorId,
        this.viewers,
        this.expiresAt,
    });

    factory Story.fromJson(Map<String, dynamic> json) => Story(
        contentUrl: json["contentURL"],
        caption: json["caption"],
        authorId: json["authorID"],
        viewers: json["viewers"],
        expiresAt: json["expiresAt"],
    );

    Map<String, dynamic> toJson() => {
        "contentURL": contentUrl,
        "caption": caption,
        "authorID": authorId,
        "viewers": viewers,
        "expiresAt": expiresAt,
    };
}
