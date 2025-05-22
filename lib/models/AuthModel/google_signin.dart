// To parse this JSON data, do
//
//     final googleloginModelApi = googleloginModelApiFromJson(jsonString);

import 'dart:convert';

GoogleloginModelApi googleloginModelApiFromJson(String str) => GoogleloginModelApi.fromJson(json.decode(str));

String googleloginModelApiToJson(GoogleloginModelApi data) => json.encode(data.toJson());

class GoogleloginModelApi {
    bool success;
    Data data;

    GoogleloginModelApi({
        required this.success,
        required this.data,
    });

    factory GoogleloginModelApi.fromJson(Map<String, dynamic> json) => GoogleloginModelApi(
        success: json["success"],
        data: Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "data": data.toJson(),
    };
}

class Data {
    String id;
    String name;
    String email;
    String role;
    List<dynamic> dependents;
    NotificationPreferences notificationPreferences;
    String token;

    Data({
        required this.id,
        required this.name,
        required this.email,
        required this.role,
        required this.dependents,
        required this.notificationPreferences,
        required this.token,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["_id"],
        name: json["name"],
        email: json["email"],
        role: json["role"],
        dependents: List<dynamic>.from(json["dependents"].map((x) => x)),
        notificationPreferences: NotificationPreferences.fromJson(json["notificationPreferences"]),
        token: json["token"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "email": email,
        "role": role,
        "dependents": List<dynamic>.from(dependents.map((x) => x)),
        "notificationPreferences": notificationPreferences.toJson(),
        "token": token,
    };
}

class NotificationPreferences {
    bool email;
    bool push;
    bool sms;

    NotificationPreferences({
        required this.email,
        required this.push,
        required this.sms,
    });

    factory NotificationPreferences.fromJson(Map<String, dynamic> json) => NotificationPreferences(
        email: json["email"],
        push: json["push"],
        sms: json["sms"],
    );

    Map<String, dynamic> toJson() => {
        "email": email,
        "push": push,
        "sms": sms,
    };
}
