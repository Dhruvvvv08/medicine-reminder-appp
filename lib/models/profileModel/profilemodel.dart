// To parse this JSON data, do
//
//     final profileModelData = profileModelDataFromJson(jsonString);

import 'dart:convert';

ProfileModelData profileModelDataFromJson(String str) => ProfileModelData.fromJson(json.decode(str));

String profileModelDataToJson(ProfileModelData data) => json.encode(data.toJson());

class ProfileModelData {
    bool success;
    Data data;

    ProfileModelData({
        required this.success,
        required this.data,
    });

    factory ProfileModelData.fromJson(Map<String, dynamic> json) => ProfileModelData(
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
    String phone;
    String role;
    Parent parent;
    List<dynamic> dependents;
    NotificationPreferences notificationPreferences;
    String createdAt;

    Data({
        required this.id,
        required this.name,
        required this.email,
        required this.phone,
        required this.role,
        required this.parent,
        required this.dependents,
        required this.notificationPreferences,
        required this.createdAt,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["_id"],
        name: json["name"],
        email: json["email"],
        phone: json["phone"],
        role: json["role"],
        parent: Parent.fromJson(json["parent"]),
        dependents: List<dynamic>.from(json["dependents"].map((x) => x)),
        notificationPreferences: NotificationPreferences.fromJson(json["notificationPreferences"]),
        createdAt: json["createdAt"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "email": email,
        "phone": phone,
        "role": role,
        "parent": parent.toJson(),
        "dependents": List<dynamic>.from(dependents.map((x) => x)),
        "notificationPreferences": notificationPreferences.toJson(),
        "createdAt": createdAt,
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

class Parent {
    String id;
    String name;
    String email;
    String phone;
    String parentId;

    Parent({
        required this.id,
        required this.name,
        required this.email,
        required this.phone,
        required this.parentId,
    });

    factory Parent.fromJson(Map<String, dynamic> json) => Parent(
        id: json["_id"],
        name: json["name"],
        email: json["email"],
        phone: json["phone"],
        parentId: json["id"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "email": email,
        "phone": phone,
        "id": parentId,
    };
}
