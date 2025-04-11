// To parse this JSON data, do
//
//     final homeStoriesModel = homeStoriesModelFromJson(jsonString);

import 'dart:convert';

HomeStoriesModel homeStoriesModelFromJson(String str) => HomeStoriesModel.fromJson(json.decode(str));

String homeStoriesModelToJson(HomeStoriesModel data) => json.encode(data.toJson());

class HomeStoriesModel {
    int? respCode;
    String? message;
    Response? response;

    HomeStoriesModel({
        this.respCode,
        this.message,
        this.response,
    });

    factory HomeStoriesModel.fromJson(Map<String, dynamic> json) => HomeStoriesModel(
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
    String? authorName;
    String? profilePicUrl;
    List<Story>? stories;
    bool? isCurrentUser;

    GroupedStory({
        this.authorId,
        this.authorName,
        this.profilePicUrl,
        this.stories,
        this.isCurrentUser,
    });

    factory GroupedStory.fromJson(Map<String, dynamic> json) => GroupedStory(
        authorId: json["authorId"],
        authorName: json["authorName"],
        profilePicUrl: json["profilePicURL"],
        stories: json["stories"] == null ? [] : List<Story>.from(json["stories"]!.map((x) => Story.fromJson(x))),
        isCurrentUser: json["isCurrentUser"],
    );

    Map<String, dynamic> toJson() => {
        "authorId": authorId,
        "authorName": authorName,
        "profilePicURL": profilePicUrl,
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
