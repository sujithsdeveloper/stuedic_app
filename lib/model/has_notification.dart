// To parse this JSON data, do
//
//     final hasNotification = hasNotificationFromJson(jsonString);

import 'dart:convert';

HasNotification hasNotificationFromJson(String str) => HasNotification.fromJson(json.decode(str));

String hasNotificationToJson(HasNotification data) => json.encode(data.toJson());

class HasNotification {
    bool? hasNotifications;

    HasNotification({
        this.hasNotifications,
    });

    factory HasNotification.fromJson(Map<String, dynamic> json) => HasNotification(
        hasNotifications: json["hasNotifications"],
    );

    Map<String, dynamic> toJson() => {
        "hasNotifications": hasNotifications,
    };
}
